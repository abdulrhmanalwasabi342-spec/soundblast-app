import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../api/models.dart';
import '../api/trpc_client.dart';
import '../services/device_library.dart';
import '../services/downloads.dart';
import '../services/local_playlists.dart';

/// Central app state: auth session, library (likes/favorites/playlists),
/// home cache for offline, and the single audio player used by the mini
/// player and the full player screen.
class AppState extends ChangeNotifier {
  final TrpcClient trpc = TrpcClient();
  late final SoundBlastApi api = SoundBlastApi(trpc);

  /// App language: null = follow the device language (Arabic on an Arabic
  /// phone, English otherwise). 'ar' / 'en' force that language. Persisted
  /// in SharedPreferences as 'sb_locale'; the MaterialApp locale in main.dart
  /// reads this, so changing it rebuilds the whole UI in the new language.
  Locale? appLocale;

  Future<void> setAppLocale(Locale? locale) async {
    appLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove('sb_locale');
    } else {
      await prefs.setString('sb_locale', locale.languageCode);
    }
    notifyListeners();
  }

  /// Called by screens that obtain a fresh user (e.g. OAuth) so listeners
  /// update. (Direct `state.user = ...; state.notifyListeners()` from a
  /// screen is an invalid use of the protected member.)
  /// Path of a profile photo picked on this phone, saved locally because
  /// the server upload needs storage that is not configured yet (the
  /// upload fails with "Storage config missing"). The local photo is what
  /// the Profile screen shows until the server copy lands.
  String? localProfilePhotoPath;

  /// The avatar to show for [user]: a photo picked on this phone wins over
  /// the server URL, then the server photo, then nothing.
  ImageProvider? profilePhotoImage(User? user) {
    final local = localProfilePhotoPath;
    if (local != null && File(local).existsSync()) {
      return FileImage(File(local));
    }
    final url = user?.imageUrl;
    if (url != null && url.isNotEmpty) return NetworkImage(url);
    return null;
  }

  Future<void> saveLocalProfilePhoto(Uint8List bytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/profile-photo.jpg');
      await file.writeAsBytes(bytes);
      localProfilePhotoPath = file.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sb_local_profile_photo', file.path);
      notifyListeners();
    } catch (_) {
      // Local save is best-effort; the in-memory pick still shows.
    }
  }

  Future<void> clearLocalProfilePhoto() async {
    final path = localProfilePhotoPath;
    localProfilePhotoPath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sb_local_profile_photo');
    if (path != null) {
      try {
        await File(path).delete();
      } catch (_) {}
    }
    notifyListeners();
  }

  void setUser(User? u) {
    user = u;
    notifyListeners();
  }

  User? user;
  bool authChecked = false;
  bool onboarded = false;

  // Library state (server-backed when logged in).
  Set<int> favoriteIds = {};
  Set<int> likedIds = {};
  List<Song> likedSongs = [];
  List<Playlist> playlists = [];
  List<Song> myFavorites = [];

  // Home cache (offline fallback): last good home payload.
  HomeSummary? cachedHome;
  List<Song>? cachedSongs;
  String? lastError;

  // Offline: downloaded songs + on-device library.
  final DownloadManager downloads = DownloadManager();
  final DeviceLibrary deviceLibrary = DeviceLibrary();
  List<DeviceSong> deviceSongs = [];
  bool deviceSongsLoaded = false;

  /// Playlists stored only on this phone (on-device songs, no account).
  final LocalPlaylistStore localPlaylists = LocalPlaylistStore();

  /// Set by the UI shell (which owns a BuildContext): asked once, at first
  /// play, before playback starts — see PermissionFlow.
  Future<bool> Function()? requestNotificationPermission;

  final AudioPlayer player = AudioPlayer();
  List<Song> queue = [];
  int queueIndex = -1;

  /// Last playback failure code ('noAudio' | 'failed'), or null. The shell
  /// shows it once as a localized snackbar and clears it — a tap that does
  /// nothing must never be silent again.
  String? playbackError;

  void clearPlaybackError() {
    playbackError = null;
  }
  Song? get currentSong =>
      queueIndex >= 0 && queueIndex < queue.length ? queue[queueIndex] : null;
  bool get isPlaying => player.playing;
  bool shuffle = false;
  LoopMode loopMode = LoopMode.off;

  StreamSubscription<PlayerState>? _playerSub;
  StreamSubscription<int?>? _indexSub;
  bool _playerReady = false;
  // Index of the first playable song in `queue` (songs without any audio
  // are skipped when building the audio source list).
  int _playableOffset = 0;

  AppState() {
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _playerSub = player.playerStateStream.listen((_) => notifyListeners());
    _indexSub = player.currentIndexStream.listen((i) {
      if (i != null) {
        queueIndex = i + _playableOffset;
        notifyListeners();
      }
    });
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _onTrackCompleted();
      }
    });
    _playerReady = true;
  }

  Future<void> init() async {
    await trpc.init();
    final prefs = await SharedPreferences.getInstance();
    onboarded = prefs.getBool('soundblast-onboarded') ?? false;
    final localeRaw = prefs.getString('sb_locale');
    appLocale = localeRaw == 'ar'
        ? const Locale('ar')
        : localeRaw == 'en'
            ? const Locale('en')
            : null;
    final localPhoto = prefs.getString('sb_local_profile_photo');
    if (localPhoto != null && File(localPhoto).existsSync()) {
      localProfilePhotoPath = localPhoto;
    }
    final homeRaw = prefs.getString('sb_cached_home');
    if (homeRaw != null) {
      try {
        cachedHome = HomeSummary.fromJson(jsonDecode(homeRaw));
      } catch (_) {}
    }
    final songsRaw = prefs.getString('sb_cached_songs');
    if (songsRaw != null) {
      try {
        final list = jsonDecode(songsRaw) as List;
        cachedSongs = list.map(Song.fromJson).toList();
      } catch (_) {}
    }
    // The UI must never wait on the network to appear: on a cold start the
    // Render backend can sleep for up to a minute, and gating the first
    // screen on api.me() left the user staring at a bare spinner for that
    // long (1.0.4). Mark auth as checked from local state alone; the server
    // check runs in the background and updates the user when it answers.
    authChecked = true;
    notifyListeners();
    downloads.addListener(notifyListeners);
    unawaited(downloads.load());
    localPlaylists.addListener(notifyListeners);
    unawaited(localPlaylists.load());
    unawaited(_refreshAuth());
  }

  /// Background server auth check: updates the signed-in user when the
  /// server answers; a sleeping server just leaves the guest state until
  /// then instead of blocking the whole app.
  Future<void> _refreshAuth() async {
    try {
      user = await api.me();
    } catch (e) {
      lastError = e.toString();
      user = null;
    }
    notifyListeners();
    if (user != null) {
      unawaited(refreshLibrary());
    }
  }

  /// Load the on-device library (after the permission flow granted access).
  /// Callers with a BuildContext pass the localized "unknown" fallbacks so
  /// the on-device list reads right in Arabic too; without them the plain
  /// English fallbacks apply.
  Future<void> refreshDeviceSongs({
    String? unknownTitle,
    String? unknownArtist,
  }) async {
    try {
      deviceSongs = await deviceLibrary.querySongs(
        unknownTitle: unknownTitle ?? 'Unknown title',
        unknownArtist: unknownArtist ?? 'Unknown artist',
      );
      deviceSongsLoaded = true;
    } catch (_) {
      deviceSongs = [];
      deviceSongsLoaded = true;
    }
    notifyListeners();
    unawaited(_prefetchDeviceArt());
  }

  /// Cached cover-art file path per on-device song id (negative ids from
  /// DeviceSong.toSong). The art bytes come from MediaStore per album and
  /// are saved once under the app documents dir, so list tiles, the mini
  /// player and the full player all show the real cover instead of the
  /// generic note icon.
  final Map<int, String> deviceArtBySongId = {};
  final Set<int> _artFetchedAlbumIds = {};

  /// Cover-art file path for an on-device song (negative id), or null when
  /// its album has no art (yet). The prefetch below fills this in the
  /// background after the library loads.
  String? deviceArtForSong(int songId) {
    final deviceId = -1000000 - songId;
    return deviceArtBySongId[deviceId];
  }

  Future<void> _prefetchDeviceArt() async {
    final albumIds = deviceSongs
        .map((d) => d.albumId)
        .whereType<int>()
        .where((id) => id > 0 && !_artFetchedAlbumIds.contains(id))
        .toSet();
    if (albumIds.isEmpty) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      var changed = false;
      for (final albumId in albumIds) {
        _artFetchedAlbumIds.add(albumId);
        final bytes = await deviceLibrary.albumArt(albumId);
        if (bytes == null || bytes.isEmpty) continue;
        final file = File('${dir.path}/art-$albumId.jpg');
        await file.writeAsBytes(bytes);
        for (final d in deviceSongs) {
          if (d.albumId == albumId) {
            deviceArtBySongId[d.id] = file.path;
          }
        }
        changed = true;
      }
      if (changed) notifyListeners();
    } catch (_) {
      // Cover art is decorative: a failed fetch never breaks the library.
    }
  }

  Future<void> setOnboarded() async {
    onboarded = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundblast-onboarded', true);
    notifyListeners();
  }

  Future<void> cacheHome(HomeSummary home, List<Song> songs) async {
    cachedHome = home;
    cachedSongs = songs;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sb_cached_home', jsonEncode({
      'trendingSongs': home.trendingSongs.map((s) => s.toJson()).toList(),
      'albums': [],
      'artists': [],
      'recentPublicPosts': [],
      'totalSongs': home.totalSongs,
      'totalPlays': home.totalPlays,
    }));
    await prefs.setString(
        'sb_cached_songs', jsonEncode(songs.map((s) => s.toJson()).toList()));
  }

  // ---- auth ---------------------------------------------------------------
  Future<String?> login(String email, String password) async {
    final res = await api.login(email, password);
    if (res['success'] == true) {
      user = User.fromJson(res['user']);
      notifyListeners();
      await refreshLibrary();
      return null;
    }
    final err = res['error']?.toString();
    if (err == 'suspended') {
      return 'This account is suspended. Contact SoundBlast support.';
    }
    if (err == 'exists') return 'An account with this email already exists.';
    return 'Invalid email or password.';
  }

  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String? stageName,
    String? imageUrl,
  }) async {
    final res = await api.signup(
      name: name,
      email: email,
      password: password,
      role: role,
      stageName: stageName,
      imageUrl: imageUrl,
    );
    if (res['success'] == true) {
      user = User.fromJson(res['user']);
      notifyListeners();
      await refreshLibrary();
      return null;
    }
    final err = res['error']?.toString();
    if (err == 'exists') {
      return 'An account with this email already exists.';
    }
    if (err == 'stageName') {
      return 'Artists need a stage name.';
    }
    return 'Could not create the account. Please try again.';
  }

  Future<void> logout() async {
    try {
      await api.logout();
    } catch (_) {}
    user = null;
    favoriteIds = {};
    likedIds = {};
    likedSongs = [];
    playlists = [];
    myFavorites = [];
    notifyListeners();
  }

  // ---- library --------------------------------------------------------------
  Future<void> refreshLibrary() async {
    if (user == null) return;
    try {
      final results = await Future.wait([
        api.myFavoriteIds(),
        api.myLikedSongs(),
        api.myPlaylists(),
        api.myFavorites(),
      ]);
      favoriteIds = results[0] as Set<int>;
      likedSongs = results[1] as List<Song>;
      likedIds = likedSongs.map((s) => s.id).toSet();
      playlists = results[2] as List<Playlist>;
      myFavorites = results[3] as List<Song>;
      notifyListeners();
    } catch (e) {
      lastError = e.toString();
    }
  }

  bool isFavorite(int songId) => favoriteIds.contains(songId);
  bool isLiked(int songId) => likedIds.contains(songId);

  Future<void> toggleFavorite(Song song) async {
    if (user == null) throw const ApiException('Please log in first.');
    final wasFav = favoriteIds.contains(song.id);
    if (wasFav) {
      favoriteIds.remove(song.id);
      myFavorites.removeWhere((s) => s.id == song.id);
    } else {
      favoriteIds.add(song.id);
      myFavorites.insert(0, song);
    }
    notifyListeners();
    try {
      if (wasFav) {
        await api.removeFavorite(song.id);
      } else {
        await api.addFavorite(song.id);
      }
    } catch (e) {
      // Roll back optimistic update.
      if (wasFav) {
        favoriteIds.add(song.id);
      } else {
        favoriteIds.remove(song.id);
      }
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleLike(Song song) async {
    if (user == null) throw const ApiException('Please log in first.');
    final wasLiked = likedIds.contains(song.id);
    if (wasLiked) {
      likedIds.remove(song.id);
      likedSongs.removeWhere((s) => s.id == song.id);
    } else {
      likedIds.add(song.id);
      likedSongs.insert(0, song);
    }
    notifyListeners();
    try {
      await api.toggleLike(song.id, !wasLiked);
    } catch (e) {
      if (wasLiked) {
        likedIds.add(song.id);
      } else {
        likedIds.remove(song.id);
      }
      notifyListeners();
      rethrow;
    }
  }

  // ---- player ---------------------------------------------------------------
  // Background playback: the player runs in just_audio_background's
  // foreground service (see main(): JustAudioBackground.init), so audio
  // keeps playing when the app is closed, with a media notification
  // (title/artist/cover, play/pause/next/previous) and lock-screen
  // controls. Audio focus / interruptions (calls, other apps) are handled
  // by the audio session: playback pauses on a call and resumes after.
  Future<void> playSong(Song song, {List<Song>? fromQueue}) async {
    if (!_playerReady) return;
    await _ensureNotificationPermissionOnce();
    final q = fromQueue ?? [song];
    var idx = q.indexWhere((s) => s.id == song.id);
    if (idx < 0) {
      q.insert(0, song);
      idx = 0;
    }
    queue = q;
    queueIndex = idx;
    notifyListeners();
    final ok = await _loadQueueAndPlay(idx);
    if (ok && queueIndex >= 0 && queueIndex < queue.length) {
      final played = queue[queueIndex];
      if (played.id > 0) unawaited(_recordPlay(played));
    }
  }

  /// Play a downloaded or on-device song (local file) through the same
  /// player/queue. [localPath] is the file on disk.
  Future<void> playLocalSong(Song song,
      {required String localPath, List<Song>? fromQueue}) async {
    if (!_playerReady) return;
    await _ensureNotificationPermissionOnce();
    final withPath = song.copyWithLocalPath(localPath);
    final q = (fromQueue ?? [song])
        .map((s) => s.id == song.id ? withPath : s)
        .toList();
    var idx = q.indexWhere((s) => s.id == song.id);
    if (idx < 0) {
      q.insert(0, withPath);
      idx = 0;
    }
    queue = q;
    queueIndex = idx;
    notifyListeners();
    await _loadQueueAndPlay(idx);
  }

  bool _notifFlowDone = false;

  Future<void> _ensureNotificationPermissionOnce() async {
    if (_notifFlowDone) return;
    _notifFlowDone = true;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('sb_notif_perm_flow_done') == true) return;
    await prefs.setBool('sb_notif_perm_flow_done', true);
    try {
      await requestNotificationPermission?.call();
    } catch (_) {
      // Notification permission is optional: audio plays regardless.
    }
  }

  /// The audio URI for one queue song, or null when it has no audio at all.
  Uri? _audioUriFor(Song s) {
    final local = s.localPath ?? '';
    if (local.isNotEmpty) {
      // On-device songs pass a content:// URI (scoped storage on
      // Android 10+); downloaded songs pass an app-private file path.
      return local.startsWith('content://') ? Uri.parse(local) : Uri.file(local);
    }
    if (s.audioUrl.isNotEmpty) return Uri.parse(s.audioUrl);
    return null;
  }

  /// MediaItem tag = what the background notification + lock screen show.
  MediaItem _mediaItemFor(Song s) => MediaItem(
        id: '${s.id}',
        album: s.albumName.isNotEmpty ? s.albumName : s.genre,
        title: s.title,
        artist: s.artist,
        duration:
            s.duration > 0 ? Duration(seconds: s.duration) : null,
        artUri: (s.imageUrl ?? '').isNotEmpty
            ? Uri.tryParse(s.imageUrl!)
            : null,
      );

  /// True while the player's source is a single song (after the fallback
  /// below skipped unplayable files). Next/Previous then load the next
  /// queue song explicitly instead of seeking inside a concatenating
  /// source that does not exist.
  bool _queueSourceIsSingle = false;

  /// Returns false when nothing could be played, setting [playbackError]
  /// so the shell can tell the user instead of leaving a fake "playing"
  /// state on screen. [queueIndex] ends on the song that is actually
  /// playing (which may be the next playable one when the tapped file
  /// cannot be opened).
  Future<bool> _loadQueueAndPlay(int startIndex) async {
    final playable = queue
        .where((s) => s.audioUrl.isNotEmpty || (s.localPath ?? '').isNotEmpty)
        .toList();
    if (playable.isEmpty) {
      playbackError = 'noAudio';
      notifyListeners();
      return false;
    }
    final sources = playable
        .map((s) => AudioSource.uri(_audioUriFor(s)!, tag: _mediaItemFor(s)))
        .toList();
    final offset = queue.indexWhere(
        (s) => s.audioUrl.isNotEmpty || (s.localPath ?? '').isNotEmpty);
    _playableOffset = offset < 0 ? 0 : offset;
    final start = startIndex - offset;
    try {
      await player.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        initialIndex: start < 0 ? 0 : start,
        initialPosition: Duration.zero,
      );
      await player.play();
      _queueSourceIsSingle = false;
    } catch (e) {
      // One bad file (unsupported codec, corrupt or moved since the scan)
      // must not kill the whole tap: try the following songs one by one.
      debugPrint('SoundBlast playback failed, trying next files: $e');
      return _playNextPlayable(startIndex);
    }
    notifyListeners();
    return true;
  }

  /// Try the songs after [fromIndex] (then wrap to the start) as single
  /// sources until one loads. The first that plays becomes the current
  /// song; the shell is told the tap was skipped, not failed.
  Future<bool> _playNextPlayable(int fromIndex) async {
    final order = <int>[];
    for (var i = fromIndex + 1; i < queue.length && order.length < 8; i++) {
      order.add(i);
    }
    for (var i = 0; i < fromIndex && order.length < 8; i++) {
      order.add(i);
    }
    for (final idx in order) {
      final song = queue[idx];
      final uri = _audioUriFor(song);
      if (uri == null) continue;
      try {
        await player.setAudioSource(
          AudioSource.uri(uri, tag: _mediaItemFor(song)),
          initialPosition: Duration.zero,
        );
        await player.play();
        queueIndex = idx;
        _playableOffset = idx;
        _queueSourceIsSingle = true;
        playbackError = 'skipped';
        notifyListeners();
        return true;
      } catch (_) {
        continue;
      }
    }
    playbackError = 'failed';
    notifyListeners();
    return false;
  }

  Future<void> _recordPlay(Song song) async {
    try {
      await api.recordPlay(song.id);
    } catch (_) {
      // Play counting is best-effort; playback must not fail for it.
    }
  }

  Future<void> playNext() async {
    if (queueIndex + 1 >= queue.length) return;
    if (_queueSourceIsSingle) {
      // No concatenating source to seek inside: load the next song, which
      // re-tries the full queue and falls back to single again if needed.
      await _loadQueueAndPlay(queueIndex + 1);
    } else {
      await player.seekToNext();
    }
  }

  Future<void> playPrevious() async {
    if ((player.position.inSeconds) > 3) {
      await player.seek(Duration.zero);
    } else if (_queueSourceIsSingle) {
      if (queueIndex > 0) await _loadQueueAndPlay(queueIndex - 1);
    } else {
      await player.seekToPrevious();
    }
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
      await _savePosition();
    } else {
      await player.play();
    }
    notifyListeners();
  }

  /// Fully stop playback: pauses, releases the audio source and stops the
  /// background service, which removes the media notification. Use this
  /// when the user wants the player gone — pause alone keeps the
  /// notification so playback can resume.
  Future<void> stopPlayback() async {
    await player.stop();
    queueIndex = -1;
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async {
    await player.seek(position);
    notifyListeners();
  }

  Future<void> setVolume(double v) async {
    await player.setVolume(v);
    notifyListeners();
  }

  Future<void> toggleShuffle() async {
    shuffle = !shuffle;
    await player.setShuffleModeEnabled(shuffle);
    notifyListeners();
  }

  Future<void> cycleRepeat() async {
    loopMode = loopMode == LoopMode.off
        ? LoopMode.all
        : loopMode == LoopMode.all
            ? LoopMode.one
            : LoopMode.off;
    await player.setLoopMode(loopMode);
    notifyListeners();
  }

  Future<void> _onTrackCompleted() async {
    await _savePosition();
    if (loopMode == LoopMode.one) return;
    if (queueIndex + 1 < queue.length) {
      await player.seekToNext();
    }
  }

  Future<void> _savePosition() async {
    final song = currentSong;
    if (user == null || song == null) return;
    try {
      await api.savePosition(
        song.id,
        player.position.inMilliseconds,
        player.duration?.inMilliseconds ?? song.duration * 1000,
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _indexSub?.cancel();
    player.dispose();
    trpc.dispose();
    super.dispose();
  }
}
