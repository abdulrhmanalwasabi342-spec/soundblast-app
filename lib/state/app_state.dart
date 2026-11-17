import 'dart:async';
import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../api/models.dart';
import '../api/trpc_client.dart';
import '../services/device_library.dart';
import '../services/downloads.dart';

/// Central app state: auth session, library (likes/favorites/playlists),
/// home cache for offline, and the single audio player used by the mini
/// player and the full player screen.
class AppState extends ChangeNotifier {
  final TrpcClient trpc = TrpcClient();
  late final SoundBlastApi api = SoundBlastApi(trpc);

  /// Called by screens that obtain a fresh user (e.g. OAuth) so listeners
  /// update. (Direct `state.user = ...; state.notifyListeners()` from a
  /// screen is an invalid use of the protected member.)
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

  /// Set by the UI shell (which owns a BuildContext): asked once, at first
  /// play, before playback starts — see PermissionFlow.
  Future<bool> Function()? requestNotificationPermission;

  final AudioPlayer player = AudioPlayer();
  List<Song> queue = [];
  int queueIndex = -1;
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
    try {
      user = await api.me();
    } catch (e) {
      lastError = e.toString();
      user = null;
    }
    authChecked = true;
    notifyListeners();
    downloads.addListener(notifyListeners);
    unawaited(downloads.load());
    if (user != null) {
      unawaited(refreshLibrary());
    }
  }

  /// Load the on-device library (after the permission flow granted access).
  Future<void> refreshDeviceSongs() async {
    try {
      deviceSongs = await deviceLibrary.querySongs();
      deviceSongsLoaded = true;
    } catch (_) {
      deviceSongs = [];
      deviceSongsLoaded = true;
    }
    notifyListeners();
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
    await _loadQueueAndPlay(idx);
    if (song.id > 0) unawaited(_recordPlay(song));
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

  Future<void> _loadQueueAndPlay(int startIndex) async {
    final playable = queue
        .where((s) => s.audioUrl.isNotEmpty || (s.localPath ?? '').isNotEmpty)
        .toList();
    if (playable.isEmpty) {
      throw const ApiException('This song has no audio file.');
    }
    final sources = playable.map((s) {
      final local = s.localPath ?? '';
      final uri = local.isNotEmpty
          // On-device songs pass a content:// URI (scoped storage on
          // Android 10+); downloaded songs pass an app-private file path.
          ? (local.startsWith('content://') ? Uri.parse(local) : Uri.file(local))
          : Uri.parse(s.audioUrl);
      return AudioSource.uri(
        uri,
        // MediaItem tag = what the background notification + lock screen show.
        tag: MediaItem(
          id: '${s.id}',
          album: s.albumName.isNotEmpty ? s.albumName : s.genre,
          title: s.title,
          artist: s.artist,
          duration: s.duration > 0
              ? Duration(seconds: s.duration)
              : null,
          artUri: (s.imageUrl ?? '').isNotEmpty
              ? Uri.tryParse(s.imageUrl!)
              : null,
        ),
      );
    }).toList();
    final offset = queue.indexWhere(
        (s) => s.audioUrl.isNotEmpty || (s.localPath ?? '').isNotEmpty);
    _playableOffset = offset < 0 ? 0 : offset;
    final start = startIndex - offset;
    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: start < 0 ? 0 : start,
      initialPosition: Duration.zero,
    );
    await player.play();
    notifyListeners();
  }

  Future<void> _recordPlay(Song song) async {
    try {
      await api.recordPlay(song.id);
    } catch (_) {
      // Play counting is best-effort; playback must not fail for it.
    }
  }

  Future<void> playNext() async {
    if (queueIndex + 1 < queue.length) {
      await player.seekToNext();
    }
  }

  Future<void> playPrevious() async {
    if ((player.position.inSeconds) > 3) {
      await player.seek(Duration.zero);
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
