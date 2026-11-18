import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:just_audio_platform_interface/method_channel_just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/models.dart';
import '../state/app_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common.dart';

/// Profile — the account screen: user info, role, library counts, links to
/// Dashboard / Artist Studio / Admin / notifications, log out.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    return Scaffold(
      appBar: AppBar(
          leading: const DrawerMenuButton(),
          title: Text(context.l10n.profile),
          actions: [
            if (user != null)
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: context.l10n.editProfile,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/profile/edit'),
              ),
          ]),
      body: user == null
          ? EmptyState(
              icon: Icons.person_outline,
              title: context.l10n.guestTitle,
              message:
                  context.l10n.guestMessage,
              action: Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: Text(context.l10n.login),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/signup'),
                    child: Text(context.l10n.createAccount),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: SbColors.surface2,
                        backgroundImage: state.profilePhotoImage(user),
                        child: state.profilePhotoImage(user) == null
                            ? const Icon(Icons.person,
                                size: 36, color: SbColors.muted)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(user.displayName,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800)),
                                ),
                                if (user.isAdmin)
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(Icons.verified,
                                        size: 18, color: SbColors.accent),
                                  ),
                              ],
                            ),
                            Text(user.email,
                                style: const TextStyle(
                                    color: SbColors.muted)),
                            Text(
                              user.isAdmin
                                  ? context.l10n.roleAdmin
                                  : user.isArtist
                                      ? context.l10n.roleArtist
                                      : context.l10n.roleListener,
                              style: const TextStyle(
                                  color: SbColors.accent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: SbColors.border),
                _row(context, Icons.favorite, context.l10n.navLikedSongs,
                    '${state.likedSongs.length}',
                    () => Navigator.of(context).pushNamed('/liked')),
                _row(context, Icons.bookmark, context.l10n.navFavorites,
                    '${state.myFavorites.length}',
                    () => Navigator.of(context).pushNamed('/favorites')),
                _row(context, Icons.playlist_play, context.l10n.navPlaylists,
                    '${state.playlists.length}',
                    () => Navigator.of(context).pushNamed('/playlists')),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: Text(context.l10n.navDashboard),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/dashboard'),
                ),
                if (user.isArtist)
                  ListTile(
                    leading: const Icon(Icons.mic),
                    title: Text(context.l10n.artistStudio),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/artist-studio'),
                  ),
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: Text(context.l10n.uploadSong),
                  subtitle: user.isArtist
                      ? null
                      : Text(context.l10n.artistAccountsOnly),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/upload'),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(context.l10n.notifications),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/notifications'),
                ),
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text(context.l10n.notifPreferences),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/notification-preferences'),
                ),
                if (user.isAdmin)
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: Text(context.l10n.admin),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/admin'),
                  ),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(context.l10n.language),
                  trailing: Text(
                    state.appLocale == null
                        ? context.l10n.languageSystem
                        : state.appLocale!.languageCode == 'ar'
                            ? context.l10n.languageArabic
                            : context.l10n.languageEnglish,
                    style: const TextStyle(
                        color: SbColors.muted, fontWeight: FontWeight.w700),
                  ),
                  onTap: () => _showLanguageDialog(context, state),
                ),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(context.l10n.aboutSoundBlast),
                  onTap: () => Navigator.of(context).pushNamed('/about'),
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: Text(context.l10n.contact),
                  onTap: () => Navigator.of(context).pushNamed('/contact'),
                ),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: Text(context.l10n.termsPrivacyPermissions),
                  onTap: () => Navigator.of(context).pushNamed('/policy'),
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: Text(context.l10n.navFeedback),
                  onTap: () => Navigator.of(context).pushNamed('/feedback'),
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: Text(context.l10n.sitemap),
                  onTap: () => Navigator.of(context).pushNamed('/sitemap'),
                ),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.logout, color: SbColors.danger),
                  title: Text(context.l10n.logout,
                      style: TextStyle(color: SbColors.danger)),
                  onTap: () async {
                    final ok = await confirmDialog(context,
                        title: context.l10n.logout,
                        message: context.l10n.logoutConfirm);
                    if (ok) {
                      await context.read<AppState>().logout();
                    }
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppState state) {
    final l10n = context.l10n;
    final current = state.appLocale?.languageCode;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String?>(
              title: Text(l10n.languageSystem),
              value: null,
              groupValue: current,
              onChanged: (v) async {
                Navigator.of(dialogContext).pop();
                await state.setAppLocale(null);
              },
            ),
            RadioListTile<String?>(
              title: const Text('العربية'),
              value: 'ar',
              groupValue: current,
              onChanged: (v) async {
                Navigator.of(dialogContext).pop();
                await state.setAppLocale(const Locale('ar'));
              },
            ),
            RadioListTile<String?>(
              title: const Text('English'),
              value: 'en',
              groupValue: current,
              onChanged: (v) async {
                Navigator.of(dialogContext).pop();
                await state.setAppLocale(const Locale('en'));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(value,
          style: const TextStyle(
              color: SbColors.muted, fontWeight: FontWeight.w700)),
      onTap: onTap,
    );
  }
}

/// Upload a song (website /upload) — artist accounts only, like the website.
/// Flow mirrors the web exactly: artwork + audio are uploaded as base64 via
/// songs.uploadFile, then published via songs.upload.
class UploadSongScreen extends StatefulWidget {
  const UploadSongScreen({super.key});

  @override
  State<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends State<UploadSongScreen> {
  final _title = TextEditingController();
  final _albumName = TextEditingController();
  String _genre = 'Pop';
  List<String> _genres = ['Pop'];
  List<Album> _myAlbums = [];
  int? _albumId;
  PlatformFile? _audio;
  PlatformFile? _image;
  int _durationSec = 0;
  String _stage = '';
  bool _uploading = false;
  bool _rights = false;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    final state = context.read<AppState>();
    try {
      final genres = await state.api.genres();
      if (genres.isNotEmpty && mounted) {
        setState(() {
          _genres = genres;
          // The dropdown's initial value must be one of its items, or
          // Flutter throws a red screen: 'Pop' is only the fallback when
          // the server's genre list has no 'Pop' at all.
          if (!_genres.contains(_genre)) _genre = _genres.first;
        });
      }
    } catch (_) {}
    if (state.user?.isArtist == true) {
      try {
        final albums = await state.api.myArtistAlbums();
        if (mounted) setState(() => _myAlbums = albums);
      } catch (_) {}
    }
  }

  Future<void> _pickAudio() async {
    // The picker itself can fail (a file the system cannot hand over):
    // without this the pick just silently did nothing and the row kept
    // saying "choose an audio file" even though one was chosen.
    final PlatformFile file;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      file = result.files.first;
    } catch (_) {
      if (!mounted) return;
      showSnack(context, context.l10n.couldNotReadFiles);
      return;
    }
    int duration = 0;
    if (file.path != null) {
      // Probe on the plain platform: the main player owns the single
      // background player instance, so a second AudioPlayer here would
      // throw "supports only a single player instance" and the duration
      // would stay 0. The swap is safe — each player captures its own
      // platform at construction, and the swap is restored in finally.
      final backgroundPlatform = JustAudioPlatform.instance;
      JustAudioPlatform.instance = MethodChannelJustAudio();
      try {
        final probe = AudioPlayer();
        duration = (await probe
                    .setFilePath(file.path!)
                    .timeout(const Duration(seconds: 10)))
                ?.inSeconds ??
            0;
        await probe.dispose();
      } catch (_) {
        // Duration stays unknown; the song still uploads.
      } finally {
        JustAudioPlatform.instance = backgroundPlatform;
      }
    }
    if (!mounted) return;
    setState(() {
      _audio = file;
      _durationSec = duration;
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    setState(() => _image = file);
  }

  Future<void> _publish() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      showSnack(context, context.l10n.loginFirst);
      return;
    }
    if (!state.user!.isArtist) {
      showSnack(context,
          context.l10n.onlyArtistsUpload);
      return;
    }
    final missing = <String>[
      if (_title.text.trim().isEmpty) context.l10n.missingTitle,
      if (_audio == null) context.l10n.missingAudio,
      if (_image == null) context.l10n.missingArtwork,
    ];
    if (missing.isNotEmpty) {
      showSnack(context,
          context.l10n.addMissingToContinue(missing.join('، ')));
      return;
    }
    if (!_rights) {
      showSnack(context,
          context.l10n.confirmRightsFirst);
      return;
    }
    final audioBytes = _audio!.bytes;
    final imageBytes = _image!.bytes;
    if (audioBytes == null || imageBytes == null) {
      showSnack(context, context.l10n.couldNotReadFiles);
      return;
    }
    setState(() => _uploading = true);
    try {
      setState(() => _stage = context.l10n.uploadingArtwork);
      final imageResult = await state.api.uploadFile(
        base64Data: base64Encode(imageBytes),
        fileName: _image!.name,
        fileType: 'image/${_image!.extension ?? 'jpeg'}',
      );
      setState(() => _stage = context.l10n.uploadingAudio);
      final audioResult = await state.api.uploadFile(
        base64Data: base64Encode(audioBytes),
        fileName: '${DateTime.now().millisecondsSinceEpoch}-${_audio!.name}',
        fileType: 'audio/${_audio!.extension ?? 'mpeg'}',
      );
      setState(() => _stage = context.l10n.publishing);
      await state.api.uploadSong(
        title: _title.text.trim(),
        audioUrl: audioResult['url']?.toString() ?? '',
        audioKey: audioResult['key']?.toString() ?? '',
        imageUrl: imageResult['url']?.toString(),
        imageKey: imageResult['key']?.toString(),
        genre: _genre,
        duration: _durationSec,
        sizeBytes: audioBytes.length,
        albumName: _albumName.text.trim().isEmpty
            ? null
            : _albumName.text.trim(),
        albumId: _albumId,
      );
      if (!mounted) return;
      showSnack(context, context.l10n.songPublished);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      if (msg.toLowerCase().contains('storage')) {
        showSnack(context, context.l10n.uploadStorageUnavailable);
      } else {
        showSnack(context, friendlyError(e, context.l10n));
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
          _stage = '';
        });
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _albumName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.uploadSong)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (user == null)
            GatedFeature(
              label: context.l10n.uploadSong,
              reason: context.l10n.loginAsArtistUpload,
              icon: Icons.upload,
            )
          else if (!user.isArtist)
            GatedFeature(
              label: context.l10n.uploadSong,
              reason:
                  context.l10n.onlyArtistsUploadListener,
              icon: Icons.upload,
            )
          else ...[
            TextField(
              controller: _title,
              decoration: InputDecoration(labelText: context.l10n.songTitle),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _genre,
              decoration: InputDecoration(labelText: context.l10n.genre),
              items: _genres
                  .map((g) =>
                      DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _genre = v ?? 'Pop'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _albumName,
              decoration: InputDecoration(
                  labelText: context.l10n.albumNameOptional),
            ),
            if (_myAlbums.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                initialValue: _albumId,
                decoration: InputDecoration(
                    labelText: context.l10n.publishIntoReleaseOptional),
                items: [
                  DropdownMenuItem(value: null, child: Text(context.l10n.noneOption)),
                  ..._myAlbums.map((a) => DropdownMenuItem(
                      value: a.id, child: Text(a.title))),
                ],
                onChanged: (v) => setState(() => _albumId = v),
              ),
            ],
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.audio_file),
              title: Text(_audio == null
                  ? context.l10n.chooseAudioFile
                  : _audio!.name),
              subtitle: _audio == null
                  ? null
                  : Text(_durationSec > 0
                      ? context.l10n.durationLabel('${_durationSec ~/ 60}:${(_durationSec % 60).toString().padLeft(2, '0')}')
                      : context.l10n.audioSelected),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickAudio,
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(_image == null
                  ? context.l10n.chooseArtwork
                  : _image!.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickImage,
            ),
            CheckboxListTile(
              value: _rights,
              onChanged: (v) => setState(() => _rights = v ?? false),
              title: Text(
                  context.l10n.confirmRights,
                  style: TextStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            if (_uploading)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 12),
                    Text(_stage),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _uploading ? null : _publish,
                child: Text(context.l10n.publishSong),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.uploadNote,
              style: TextStyle(color: SbColors.muted, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dashboard (website /dashboard) — platform stats + your library at a
/// glance. Uses the real stats.platform endpoint.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _stats;
  int _visitors = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stats = await state.api.platformStats(days: 7);
      final visitors = await state.api.visitorCount();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _visitors = visitors;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e, context.l10n);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navDashboard)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        state.user == null
                            ? context.l10n.dashboardGlance
                            : context.l10n.welcomeBackName(state.user!.displayName),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _stat(context.l10n.songs,
                              '${_stats?['totalSongs'] ?? 0}'),
                          _stat(context.l10n.statListeners,
                              '${_stats?['totalUsers'] ?? 0}'),
                          _stat(context.l10n.statStreams,
                              '${_stats?['totalStreams'] ?? 0}'),
                          _stat(context.l10n.statVisitors, '$_visitors'),
                          _stat(context.l10n.statLikes, '${_stats?['totalLikes'] ?? 0}'),
                          _stat(context.l10n.comments,
                              '${_stats?['totalComments'] ?? 0}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state.user != null) ...[
                        SectionHeader(title: context.l10n.yourLibrary),
                        ListTile(
                          leading: const Icon(Icons.favorite),
                          title: Text(context.l10n.navLikedSongs),
                          trailing: Text('${state.likedSongs.length}'),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/favorites'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.bookmark),
                          title: Text(context.l10n.navFavorites),
                          trailing: Text('${state.myFavorites.length}'),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/favorites'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.playlist_play),
                          title: Text(context.l10n.navPlaylists),
                          trailing: Text('${state.playlists.length}'),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/playlists'),
                        ),
                      ] else
                        EmptyState(
                          icon: Icons.person_outline,
                          title: context.l10n.loginForDashboard,
                          message:
                              context.l10n.dashboardGuestNote,
                          action: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/login'),
                            child: Text(context.l10n.login),
                          ),
                        ),
                      if (state.user?.isArtist == true)
                        ListTile(
                          leading: const Icon(Icons.mic),
                          title: Text(context.l10n.openArtistStudio),
                          trailing:
                              const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/artist-studio'),
                        ),
                      if (state.user?.isAdmin == true)
                        ListTile(
                          leading:
                              const Icon(Icons.admin_panel_settings),
                          title: Text(context.l10n.openAdmin),
                          trailing:
                              const Icon(Icons.chevron_right),
                          onTap: () =>
                              Navigator.of(context).pushNamed('/admin'),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _stat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SbColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: SbColors.muted)),
        ],
      ),
    );
  }
}

/// Artist Studio (website /artist-studio) — artist-only: stats, performance,
/// my songs (delete), my releases, my posts (create/delete), profile edit.
class ArtistStudioScreen extends StatefulWidget {
  const ArtistStudioScreen({super.key});

  @override
  State<ArtistStudioScreen> createState() => _ArtistStudioScreenState();
}

class _ArtistStudioScreenState extends State<ArtistStudioScreen> {
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _performance;
  Map<String, dynamic>? _activation;
  List<Song> _songs = [];
  List<ArtistPost> _posts = [];
  List<Album> _albums = [];
  bool _loading = true;
  String? _error;
  final _postController = TextEditingController();
  String _postKind = 'post';
  String _postVisibility = 'public';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    if (state.user == null || !state.user!.isArtist) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        state.api.studioStats(),
        state.api.artistPerformance(7),
        state.api.artistActivationStatus(),
        state.api.studioSongs(),
        state.api.myArtistPosts(),
        state.api.myArtistAlbums(),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as Map<String, dynamic>;
        _performance = results[1] as Map<String, dynamic>;
        _activation = results[2] as Map<String, dynamic>;
        _songs = results[3] as List<Song>;
        _posts = results[4] as List<ArtistPost>;
        _albums = results[5] as List<Album>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e, context.l10n);
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.artistStudio)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? EmptyState(
                  icon: Icons.lock_outline,
                  title: context.l10n.loginAsArtist,
                  message: context.l10n.studioNeedsArtist,
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: Text(context.l10n.login),
                  ),
                )
              : !user.isArtist
                  ? EmptyState(
                      icon: Icons.mic_off_outlined,
                      title: context.l10n.artistAccountsOnly,
                      message: context.l10n.listenerCannotOpenStudio,
                    )
                  : _error != null
                      ? ErrorView(message: _error!, onRetry: _load)
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              Row(
                                children: [
                                  _miniStat(context.l10n.songs,
                                      '${_stats?['songCount'] ?? 0}'),
                                  _miniStat(context.l10n.statPlays,
                                      '${_stats?['totalPlays'] ?? 0}'),
                                  _miniStat(context.l10n.statLikes,
                                      '${_stats?['totalLikes'] ?? 0}'),
                                  _miniStat(context.l10n.statFollowers,
                                      '${_stats?['followerCount'] ?? 0}'),
                                ],
                              ),
                              if (_activation != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12),
                                  child: Text(
                                    context.l10n.activationStatus('${_activation!['status'] ?? _activation!['stage'] ?? '—'}'),
                                    style: const TextStyle(
                                        color: SbColors.muted),
                                  ),
                                ),
                              if (_performance != null &&
                                  _performance!.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8),
                                  child: Text(
                                    context.l10n.last7DaysPlays('${_performance!['totalPlays'] ?? _performance!['plays'] ?? '—'}'),
                                    style: const TextStyle(
                                        color: SbColors.muted),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed('/upload'),
                                  icon: const Icon(Icons.upload),
                                  label: Text(context.l10n.uploadNewSong),
                                ),
                              ),
                              SectionHeader(title: context.l10n.mySongs),
                              if (_songs.isEmpty)
                                Text(
                                    context.l10n.noSongsPublished,
                                    style: TextStyle(
                                        color: SbColors.muted))
                              else
                                ..._songs.map((s) => ListTile(
                                      leading: CoverImage(
                                          url: s.imageUrl, size: 48),
                                      title: Text(s.title),
                                      subtitle: Text(
                                          '${s.genre} • ${context.l10n.playsCount(formatCount(s.playCount))}'),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            color: SbColors.danger),
                                        onPressed: () async {
                                          final ok =
                                              await confirmDialog(context,
                                                  title: context.l10n.deleteSong,
                                                  message: context.l10n.deleteSongConfirm(s.title));
                                          if (ok) {
                                            try {
                                              await state.api
                                                  .deleteMySong(s.id);
                                              await _load();
                                            } catch (e) {
                                              if (mounted) {
                                                showSnack(
                                                    context, friendlyError(e, context.l10n));
                                              }
                                            }
                                          }
                                        },
                                      ),
                                      onTap: () => state.playSong(s,
                                          fromQueue: _songs),
                                    )),
                              SectionHeader(title: context.l10n.myReleases),
                              if (_albums.isEmpty)
                                Text(context.l10n.noReleasesYet,
                                    style: TextStyle(
                                        color: SbColors.muted))
                              else
                                ..._albums.map((a) => ListTile(
                                      leading: CoverImage(
                                          url: a.imageUrl,
                                          size: 48,
                                          fallbackIcon: Icons.album),
                                      title: Text(a.title),
                                      subtitle: Text(a.releaseType ?? 'album'),
                                      onTap: () => Navigator.of(context)
                                          .pushNamed('/albums/${a.id}',
                                              arguments: a),
                                    )),
                              SectionHeader(title: context.l10n.sharePost),
                              TextField(
                                controller: _postController,
                                decoration: InputDecoration(
                                    hintText: context.l10n.postHint,
                                    labelText: context.l10n.newPost),
                                maxLines: 3,
                                maxLength: 1000,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _postKind,
                                    items: [
                                      DropdownMenuItem(
                                          value: 'post',
                                          child: Text(context.l10n.postKindPost)),
                                      DropdownMenuItem(
                                          value: 'recommendation',
                                          child:
                                              Text(context.l10n.postKindRecommendation)),
                                    ],
                                    onChanged: (v) => setState(
                                        () => _postKind = v ?? 'post'),
                                  ),
                                  const SizedBox(width: 12),
                                  DropdownButton<String>(
                                    value: _postVisibility,
                                    items: [
                                      DropdownMenuItem(
                                          value: 'public',
                                          child: Text(context.l10n.visibilityPublic)),
                                      DropdownMenuItem(
                                          value: 'followers',
                                          child:
                                              Text(context.l10n.followersOnly)),
                                    ],
                                    onChanged: (v) => setState(() =>
                                        _postVisibility = v ?? 'public'),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final body =
                                          _postController.text.trim();
                                      if (body.isEmpty) return;
                                      try {
                                        await state.api.createArtistPost(
                                          body: body,
                                          kind: _postKind,
                                          visibility: _postVisibility,
                                        );
                                        _postController.clear();
                                        await _load();
                                        if (mounted) {
                                          showSnack(
                                              context, context.l10n.postShared);
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          showSnack(
                                              context, friendlyError(e, context.l10n));
                                        }
                                      }
                                    },
                                    child: Text(context.l10n.share),
                                  ),
                                ],
                              ),
                              SectionHeader(title: context.l10n.myPosts),
                              if (_posts.isEmpty)
                                Text(context.l10n.noPosts,
                                    style: TextStyle(
                                        color: SbColors.muted))
                              else
                                ..._posts.map((p) => Card(
                                      color: SbColors.card,
                                      margin:
                                          const EdgeInsets.symmetric(
                                              vertical: 4),
                                      child: ListTile(
                                        title: Text(p.body),
                                        subtitle: Text(
                                            '${p.kind == 'recommendation' ? context.l10n.postKindRecommendation : p.kind == 'post' ? context.l10n.postKindPost : p.kind} • ${p.createdAt ?? ''}'),
                                        trailing: IconButton(
                                          icon: const Icon(
                                              Icons.delete_outline,
                                              color: SbColors.danger),
                                          onPressed: () async {
                                            final ok = await confirmDialog(
                                                context,
                                                title: context.l10n.deletePost,
                                                message: context.l10n.deletePostConfirm);
                                            if (ok) {
                                              try {
                                                await state.api
                                                    .deleteArtistPost(p.id);
                                                await _load();
                                              } catch (e) {
                                                if (mounted) {
                                                  showSnack(context,
                                                      friendlyError(e, context.l10n));
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    )),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: SbColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            Text(label,
                style:
                    const TextStyle(color: SbColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// Notifications inbox (website notifications list) — in-app notifications.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await state.api.myNotifications();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e, context.l10n);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: [
          if (_items.any((n) => !n.isRead))
            TextButton(
              onPressed: () async {
                try {
                  await state.api.markAllNotificationsRead();
                  await _load();
                } catch (e) {
                  if (mounted) showSnack(context, friendlyError(e, context.l10n));
                }
              },
              child: Text(context.l10n.markAllRead),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : state.user == null
              ? EmptyState(
                  icon: Icons.lock_outline,
                  title: context.l10n.loginToSeeNotifications,
                  message:
                      context.l10n.notificationsEmptyHint,
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: Text(context.l10n.login),
                  ),
                )
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : _items.isEmpty
                      ? EmptyState(
                          icon: Icons.notifications_none,
                          title: context.l10n.noNotifications,
                          message: context.l10n.noNotificationsHint,
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            children: _items
                                .map((n) => ListTile(
                                      leading: Icon(
                                        n.isRead
                                            ? Icons.notifications_none
                                            : Icons.notifications,
                                        color: n.isRead
                                            ? SbColors.muted
                                            : SbColors.accent,
                                      ),
                                      title: Text(n.title,
                                          style: TextStyle(
                                              fontWeight: n.isRead
                                                  ? FontWeight.normal
                                                  : FontWeight.w700)),
                                      subtitle: n.body == null
                                          ? null
                                          : Text(n.body!),
                                      trailing: n.isRead
                                          ? null
                                          : TextButton(
                                              onPressed: () async {
                                                try {
                                                  await state.api
                                                      .markNotificationRead(
                                                          n.id);
                                                  await _load();
                                                } catch (e) {
                                                  if (mounted) {
                                                    showSnack(context,
                                                        friendlyError(e, context.l10n));
                                                  }
                                                }
                                              },
                                              child: Text(context.l10n.markRead),
                                            ),
                                    ))
                                .toList(),
                          ),
                        ),
    );
  }
}

/// Notification preferences (website /notification-preferences).
/// Web Push subscriptions are a browser capability: the server's push
/// endpoints (push.subscribe / VAPID) cannot run inside the Android app,
/// so push itself is gated with the reason, while the followed-artist
/// preference list below is real server data.
class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  List<dynamic> _prefs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await state.trpc
          .query('push.followedArtistPreferences');
      if (!mounted) return;
      setState(() {
        _prefs = prefs is List ? prefs : [];
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e, context.l10n);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notifPreferences)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : state.user == null
              ? EmptyState(
                  icon: Icons.lock_outline,
                  title: context.l10n.loginFirst,
                  message: context.l10n.notifPrefsBelongAccount,
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: Text(context.l10n.login),
                  ),
                )
              : ListView(
                  children: [
                    GatedFeature(
                      label: context.l10n.pushNotificationsDevice,
                      reason:
                          context.l10n.webPushUnavailable,
                      icon: Icons.notifications_active_outlined,
                    ),
                    const Divider(color: SbColors.border),
                    SectionHeader(
                        title: context.l10n.artistsYouFollow,
                        subtitle: context.l10n.followedArtistsNote),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_error!,
                            style:
                                const TextStyle(color: SbColors.muted)),
                      )
                    else if (_prefs.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            context.l10n.notFollowingArtists,
                            style: TextStyle(color: SbColors.muted)),
                      )
                    else
                      ..._prefs.map((p) {
                        final m =
                            p is Map ? Map<String, dynamic>.from(p) : {};
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                              '${m['stageName'] ?? m['artistName'] ?? context.l10n.roleArtist}'),
                          subtitle: Text(
                              context.l10n.notificationsState(m['enabled'] == false ? context.l10n.switchOff : context.l10n.switchOn)),
                        );
                      }),
                  ],
                ),
    );
  }
}

/// About (website /about).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Fetched once: the real version of the installed package, so the
  // About screen can never drift behind the releases again.
  static final Future<PackageInfo> _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.aboutSoundBlast)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('SoundBlast',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          SizedBox(height: 12),
          Text(
            context.l10n.aboutBody1,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 16),
          Text(
            context.l10n.aboutBody2,
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 16),
          FutureBuilder<PackageInfo>(
            future: _info,
            builder: (context, snap) {
              final version = snap.data?.version;
              return Text(
                version == null
                    ? context.l10n.appVersionLabel
                    : context.l10n.appVersion(version),
                style: const TextStyle(color: SbColors.muted, fontSize: 13),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Contact (website /contact).
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _openSite(BuildContext context) async {
    final uri = Uri.parse('https://soundblast.onrender.com/#/contact');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        showSnack(context, context.l10n.couldNotOpenWebsite);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.contact)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(context.l10n.getInTouch,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(
            context.l10n.contactBody,
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: Text(context.l10n.sendFeedback),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/feedback'),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(context.l10n.openWebsite),
            subtitle: const Text('soundblast.onrender.com'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openSite(context),
          ),
        ],
      ),
    );
  }
}

/// Policy (website /policy) — Terms, Privacy & Permissions.
class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.termsPrivacyPermissions)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(context.l10n.termsOfUse,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            context.l10n.termsBody,
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(context.l10n.privacy,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            context.l10n.privacyBody,
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(context.l10n.permissions,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            context.l10n.permissionsBody,
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(context.l10n.copyrightReports,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            context.l10n.copyrightBody,
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

/// Feedback (website /feedback) — real feedback.submit mutation.
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _message = TextEditingController();
  String _category = 'feedback';
  bool _busy = false;

  Future<void> _submit() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      showSnack(context, context.l10n.loginToSendFeedback);
      return;
    }
    if (_message.text.trim().length < 10) {
      showSnack(context, context.l10n.feedbackMinChars);
      return;
    }
    setState(() => _busy = true);
    try {
      await state.api.submitFeedback(_message.text.trim(),
          category: _category);
      if (!mounted) return;
      showSnack(context, context.l10n.feedbackSentThanks);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showSnack(context, friendlyError(e, context.l10n));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navFeedback)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(context.l10n.tellUsWhatYouThink,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            context.l10n.feedbackIntro,
            style: TextStyle(color: SbColors.muted),
          ),
          const SizedBox(height: 20),
          if (state.user == null)
            GatedFeature(
              label: context.l10n.sendFeedback,
              reason: context.l10n.loginToSendFeedbackNote,
              icon: Icons.feedback,
            )
          else ...[
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: InputDecoration(labelText: context.l10n.category),
              items: [
                DropdownMenuItem(
                    value: 'feedback', child: Text(context.l10n.navFeedback)),
                DropdownMenuItem(
                    value: 'privacy_request',
                    child: Text(context.l10n.feedbackPrivacyRequest)),
                DropdownMenuItem(
                    value: 'copyright_report',
                    child: Text(context.l10n.feedbackCopyrightReport)),
              ],
              onChanged: (v) => setState(() => _category = v ?? 'feedback'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _message,
              decoration: InputDecoration(
                  labelText: context.l10n.yourMessage,
                  hintText: context.l10n.messageLengthHint),
              maxLines: 8,
              maxLength: 2000,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(context.l10n.sendFeedback),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Edit your own artist profile (stage name, bio, photo).
/// Uses the server's songs.updateProfile — artists only; the server refuses
/// listeners, so they see an honest note instead of a dead form.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _stage = TextEditingController();
  final _bio = TextEditingController();
  PlatformFile? _image;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    if (user == null) return;
    _stage.text = user.displayName;
    if (user.isArtist) _loadBio(user);
  }

  Future<void> _loadBio(User user) async {
    try {
      final id = int.tryParse(user.id);
      if (id == null) return;
      final profile = await context.read<AppState>().api.artistProfile(id);
      final bio = profile['bio']?.toString() ?? '';
      if (mounted && bio.isNotEmpty) _bio.text = bio;
    } catch (_) {}
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes != null) {
      // Save on this phone at pick time: the server upload may fail
      // (storage is not configured), and the "saved locally" message is
      // only true if the photo is actually stored here.
      await context.read<AppState>().saveLocalProfilePhoto(file.bytes!);
    }
    setState(() => _image = file);
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    final user = state.user;
    if (user == null) return;
    final stageName = _stage.text.trim();
    if (stageName.isEmpty) {
      showSnack(context, context.l10n.stageNameRequired);
      return;
    }
    setState(() => _saving = true);
    try {
      String? imageUrl;
      var photoKeptLocal = false;
      if (_image?.bytes != null) {
        try {
          final upload = await state.api.uploadFile(
            base64Data: base64Encode(_image!.bytes!),
            fileName: _image!.name,
            fileType: 'image/${_image!.extension ?? 'jpeg'}',
          );
          imageUrl = upload['url']?.toString();
          if (imageUrl != null) await state.clearLocalProfilePhoto();
        } catch (_) {
          // Storage is not configured on the server, so the upload fails —
          // the photo is already saved on this phone (see _pickImage), so
          // the name and bio still save and the photo still shows.
          photoKeptLocal = true;
        }
      }
      final result = await state.api.updateArtistProfile(
        stageName: stageName,
        bio: _bio.text.trim(),
        imageUrl: imageUrl,
      );
      if (result['success'] == false) {
        if (mounted) {
          showSnack(
              context, result['error']?.toString() ?? 'Failed to save.');
        }
        return;
      }
      final me = await state.api.me();
      if (me != null) state.setUser(me);
      if (!mounted) return;
      showSnack(
          context,
          photoKeptLocal
              ? context.l10n.photoSavedLocally
              : context.l10n.profileUpdated);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showSnack(context, friendlyError(e, context.l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _stage.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editProfile)),
      body: user == null
          ? EmptyState(
              icon: Icons.person_outline,
              title: context.l10n.guestTitle,
              message: context.l10n.guestMessage,
            )
          : !user.isArtist
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: GatedFeature(
                    label: context.l10n.editProfile,
                    reason: context.l10n.editProfileArtistsOnly,
                    icon: Icons.person,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: SbColors.surface2,
                          backgroundImage: _image?.bytes == null
                              ? state.profilePhotoImage(user)
                              : null,
                          child: _image?.bytes != null
                              ? ClipOval(
                                  child: Image.memory(
                                    _image!.bytes!,
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : state.profilePhotoImage(user) == null
                                  ? const Icon(Icons.person,
                                      size: 48, color: SbColors.muted)
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_camera),
                        label: Text(context.l10n.changePhoto),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _stage,
                      decoration: InputDecoration(
                          labelText: context.l10n.stageName),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bio,
                      decoration:
                          InputDecoration(labelText: context.l10n.bio),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: Text(_saving
                          ? context.l10n.saving
                          : context.l10n.save),
                    ),
                  ],
                ),
    );
  }
}
