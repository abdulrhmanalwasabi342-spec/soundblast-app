import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/models.dart';
import '../state/app_state.dart';
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
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? EmptyState(
              icon: Icons.person_outline,
              title: 'You are browsing as a guest',
              message:
                  'Log in or sign up to like songs, keep favorites, build playlists, upload music and follow artists.',
              action: Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: const Text('Log in'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/signup'),
                    child: const Text('Create an account'),
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
                        backgroundImage: user.imageUrl != null
                            ? NetworkImage(user.imageUrl!)
                            : null,
                        child: user.imageUrl == null
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
                                  const Padding(
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
                                  ? 'Administrator'
                                  : user.isArtist
                                      ? 'Artist'
                                      : 'Listener',
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
                _row(context, Icons.favorite, 'Liked songs',
                    '${state.likedSongs.length}', () {}),
                _row(context, Icons.bookmark, 'Favorites',
                    '${state.myFavorites.length}', () {}),
                _row(context, Icons.playlist_play, 'Playlists',
                    '${state.playlists.length}',
                    () => Navigator.of(context).pushNamed('/playlists')),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/dashboard'),
                ),
                if (user.isArtist)
                  ListTile(
                    leading: const Icon(Icons.mic),
                    title: const Text('Artist Studio'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/artist-studio'),
                  ),
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: const Text('Upload a song'),
                  subtitle: user.isArtist
                      ? null
                      : const Text('Artist accounts only'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/upload'),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/notifications'),
                ),
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: const Text('Notification preferences'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/notification-preferences'),
                ),
                if (user.isAdmin)
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/admin'),
                  ),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About SoundBlast'),
                  onTap: () => Navigator.of(context).pushNamed('/about'),
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: const Text('Contact'),
                  onTap: () => Navigator.of(context).pushNamed('/contact'),
                ),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: const Text('Terms, Privacy & Permissions'),
                  onTap: () => Navigator.of(context).pushNamed('/policy'),
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Feedback'),
                  onTap: () => Navigator.of(context).pushNamed('/feedback'),
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Sitemap'),
                  onTap: () => Navigator.of(context).pushNamed('/sitemap'),
                ),
                const Divider(color: SbColors.border),
                ListTile(
                  leading: const Icon(Icons.logout, color: SbColors.danger),
                  title: const Text('Log out',
                      style: TextStyle(color: SbColors.danger)),
                  onTap: () async {
                    final ok = await confirmDialog(context,
                        title: 'Log out',
                        message: 'Log out of SoundBlast on this device?');
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
        setState(() => _genres = genres);
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    int duration = 0;
    if (file.path != null) {
      try {
        final probe = AudioPlayer();
        duration = (await probe.setFilePath(file.path!))
                ?.inSeconds ??
            0;
        await probe.dispose();
      } catch (_) {}
    }
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
    setState(() => _image = result.files.first);
  }

  Future<void> _publish() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      showSnack(context, 'Log in first.');
      return;
    }
    if (!state.user!.isArtist) {
      showSnack(context,
          'Only artist accounts can upload songs. Sign up as an artist to publish music.');
      return;
    }
    if (_title.text.trim().isEmpty || _audio == null || _image == null) {
      showSnack(context, 'Add a title, audio file, and release artwork to continue.');
      return;
    }
    if (!_rights) {
      showSnack(context,
          'Please confirm you own the rights to publish this song.');
      return;
    }
    final audioBytes = _audio!.bytes;
    final imageBytes = _image!.bytes;
    if (audioBytes == null || imageBytes == null) {
      showSnack(context, 'Could not read the selected files.');
      return;
    }
    setState(() => _uploading = true);
    try {
      setState(() => _stage = 'Uploading artwork…');
      final imageResult = await state.api.uploadFile(
        base64Data: base64Encode(imageBytes),
        fileName: _image!.name,
        fileType: 'image/${_image!.extension ?? 'jpeg'}',
      );
      setState(() => _stage = 'Uploading audio…');
      final audioResult = await state.api.uploadFile(
        base64Data: base64Encode(audioBytes),
        fileName: '${DateTime.now().millisecondsSinceEpoch}-${_audio!.name}',
        fileType: 'audio/${_audio!.extension ?? 'mpeg'}',
      );
      setState(() => _stage = 'Publishing…');
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
      showSnack(context, 'Song published.');
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
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
      appBar: AppBar(title: const Text('Upload a song')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (user == null)
            const GatedFeature(
              label: 'Upload a song',
              reason: 'Log in as an artist to upload songs.',
              icon: Icons.upload,
            )
          else if (!user.isArtist)
            const GatedFeature(
              label: 'Upload a song',
              reason:
                  'Only artist accounts can upload songs. Your account is a listener account — create an artist account to publish music.',
              icon: Icons.upload,
            )
          else ...[
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Song title'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _genre,
              decoration: const InputDecoration(labelText: 'Genre'),
              items: _genres
                  .map((g) =>
                      DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _genre = v ?? 'Pop'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _albumName,
              decoration: const InputDecoration(
                  labelText: 'Album name (optional)'),
            ),
            if (_myAlbums.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                initialValue: _albumId,
                decoration: const InputDecoration(
                    labelText: 'Publish into one of your releases (optional)'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
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
                  ? 'Choose audio file (MP3, WAV, or M4A)'
                  : _audio!.name),
              subtitle: _audio == null
                  ? null
                  : Text(_durationSec > 0
                      ? 'Duration: ${_durationSec ~/ 60}:${(_durationSec % 60).toString().padLeft(2, '0')}'
                      : 'Audio selected'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickAudio,
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(_image == null
                  ? 'Choose release artwork (PNG, JPG, or WEBP)'
                  : _image!.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickImage,
            ),
            CheckboxListTile(
              value: _rights,
              onChanged: (v) => setState(() => _rights = v ?? false),
              title: const Text(
                  'I confirm I own the rights to publish this song.',
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
                child: const Text('Publish song'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Audio is uploaded to the same storage as the website, then the server validates and optimizes it. Large files may take a while on a slow connection.',
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
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
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
                            ? 'SoundBlast at a glance'
                            : 'Welcome back, ${state.user!.displayName}',
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
                          _stat('Songs',
                              '${_stats?['totalSongs'] ?? 0}'),
                          _stat('Listeners',
                              '${_stats?['totalUsers'] ?? 0}'),
                          _stat('Streams',
                              '${_stats?['totalStreams'] ?? 0}'),
                          _stat('Visitors', '$_visitors'),
                          _stat('Likes', '${_stats?['totalLikes'] ?? 0}'),
                          _stat('Comments',
                              '${_stats?['totalComments'] ?? 0}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state.user != null) ...[
                        const SectionHeader(title: 'Your library'),
                        ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text('Liked songs'),
                          trailing: Text('${state.likedSongs.length}'),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/favorites'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.bookmark),
                          title: const Text('Favorites'),
                          trailing: Text('${state.myFavorites.length}'),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/favorites'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.playlist_play),
                          title: const Text('Playlists'),
                          trailing: Text('${state.playlists.length}'),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/playlists'),
                        ),
                      ] else
                        EmptyState(
                          icon: Icons.person_outline,
                          title: 'Log in for your personal dashboard',
                          message:
                              'Platform totals above are public. Your library, uploads and studio need an account.',
                          action: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/login'),
                            child: const Text('Log in'),
                          ),
                        ),
                      if (state.user?.isArtist == true)
                        ListTile(
                          leading: const Icon(Icons.mic),
                          title: const Text('Open Artist Studio'),
                          trailing:
                              const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/artist-studio'),
                        ),
                      if (state.user?.isAdmin == true)
                        ListTile(
                          leading:
                              const Icon(Icons.admin_panel_settings),
                          title: const Text('Open Admin'),
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
        _error = e.toString();
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
      appBar: AppBar(title: const Text('Artist Studio')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? EmptyState(
                  icon: Icons.lock_outline,
                  title: 'Log in as an artist',
                  message: 'Artist Studio needs an artist account.',
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: const Text('Log in'),
                  ),
                )
              : !user.isArtist
                  ? const EmptyState(
                      icon: Icons.mic_off_outlined,
                      title: 'Artist accounts only',
                      message:
                          'Your account is a listener account. Sign up as an artist to open the studio.',
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
                                  _miniStat('Songs',
                                      '${_stats?['songCount'] ?? 0}'),
                                  _miniStat('Plays',
                                      '${_stats?['totalPlays'] ?? 0}'),
                                  _miniStat('Likes',
                                      '${_stats?['totalLikes'] ?? 0}'),
                                  _miniStat('Followers',
                                      '${_stats?['followerCount'] ?? 0}'),
                                ],
                              ),
                              if (_activation != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Activation: ${_activation!['status'] ?? _activation!['stage'] ?? '—'}',
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
                                    'Last 7 days: ${_performance!['totalPlays'] ?? _performance!['plays'] ?? '—'} plays',
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
                                  label: const Text('Upload a new song'),
                                ),
                              ),
                              const SectionHeader(title: 'My songs'),
                              if (_songs.isEmpty)
                                const Text(
                                    'You have not published any songs yet.',
                                    style: TextStyle(
                                        color: SbColors.muted))
                              else
                                ..._songs.map((s) => ListTile(
                                      leading: CoverImage(
                                          url: s.imageUrl, size: 48),
                                      title: Text(s.title),
                                      subtitle: Text(
                                          '${s.genre} • ${formatPlays(s.playCount)}'),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            color: SbColors.danger),
                                        onPressed: () async {
                                          final ok =
                                              await confirmDialog(context,
                                                  title: 'Delete song',
                                                  message:
                                                      'Delete "${s.title}" permanently?');
                                          if (ok) {
                                            try {
                                              await state.api
                                                  .deleteMySong(s.id);
                                              await _load();
                                            } catch (e) {
                                              if (mounted) {
                                                showSnack(
                                                    context, e.toString());
                                              }
                                            }
                                          }
                                        },
                                      ),
                                      onTap: () => state.playSong(s,
                                          fromQueue: _songs),
                                    )),
                              const SectionHeader(title: 'My releases'),
                              if (_albums.isEmpty)
                                const Text('No releases yet.',
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
                              const SectionHeader(title: 'Share a post'),
                              TextField(
                                controller: _postController,
                                decoration: const InputDecoration(
                                    hintText:
                                        'Tell your followers something… (max 1000 characters)',
                                    labelText: 'New post'),
                                maxLines: 3,
                                maxLength: 1000,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _postKind,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'post',
                                          child: Text('Post')),
                                      DropdownMenuItem(
                                          value: 'recommendation',
                                          child:
                                              Text('Recommendation')),
                                    ],
                                    onChanged: (v) => setState(
                                        () => _postKind = v ?? 'post'),
                                  ),
                                  const SizedBox(width: 12),
                                  DropdownButton<String>(
                                    value: _postVisibility,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'public',
                                          child: Text('Public')),
                                      DropdownMenuItem(
                                          value: 'followers',
                                          child:
                                              Text('Followers only')),
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
                                              context, 'Post shared.');
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          showSnack(
                                              context, e.toString());
                                        }
                                      }
                                    },
                                    child: const Text('Share'),
                                  ),
                                ],
                              ),
                              const SectionHeader(title: 'My posts'),
                              if (_posts.isEmpty)
                                const Text('No posts yet.',
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
                                            '${p.kind} • ${p.createdAt ?? ''}'),
                                        trailing: IconButton(
                                          icon: const Icon(
                                              Icons.delete_outline,
                                              color: SbColors.danger),
                                          onPressed: () async {
                                            final ok = await confirmDialog(
                                                context,
                                                title: 'Delete post',
                                                message:
                                                    'Delete this post?');
                                            if (ok) {
                                              try {
                                                await state.api
                                                    .deleteArtistPost(p.id);
                                                await _load();
                                              } catch (e) {
                                                if (mounted) {
                                                  showSnack(context,
                                                      e.toString());
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
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_items.any((n) => !n.isRead))
            TextButton(
              onPressed: () async {
                try {
                  await state.api.markAllNotificationsRead();
                  await _load();
                } catch (e) {
                  if (mounted) showSnack(context, e.toString());
                }
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : state.user == null
              ? EmptyState(
                  icon: Icons.lock_outline,
                  title: 'Log in to see notifications',
                  message:
                      'New releases from artists you follow arrive here.',
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: const Text('Log in'),
                  ),
                )
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : _items.isEmpty
                      ? const EmptyState(
                          icon: Icons.notifications_none,
                          title: 'No notifications',
                          message:
                              'When artists you follow release new songs or share posts, you will see it here.',
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
                                                        e.toString());
                                                  }
                                                }
                                              },
                                              child: const Text('Mark read'),
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
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Notification preferences')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : state.user == null
              ? EmptyState(
                  icon: Icons.lock_outline,
                  title: 'Log in first',
                  message: 'Notification preferences belong to your account.',
                  action: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/login'),
                    child: const Text('Log in'),
                  ),
                )
              : ListView(
                  children: [
                    const GatedFeature(
                      label: 'Push notifications on this device',
                      reason:
                          'Web Push (browser notifications) is not available in the Android app yet — new releases still arrive in your in-app Notifications inbox.',
                      icon: Icons.notifications_active_outlined,
                    ),
                    const Divider(color: SbColors.border),
                    const SectionHeader(
                        title: 'Artists you follow',
                        subtitle:
                            'New releases from these artists appear in your Notifications inbox.'),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_error!,
                            style:
                                const TextStyle(color: SbColors.muted)),
                      )
                    else if (_prefs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            'You are not following any artists yet.',
                            style: TextStyle(color: SbColors.muted)),
                      )
                    else
                      ..._prefs.map((p) {
                        final m =
                            p is Map ? Map<String, dynamic>.from(p) : {};
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                              '${m['stageName'] ?? m['artistName'] ?? 'Artist'}'),
                          subtitle: Text(
                              'Notifications: ${m['enabled'] == false ? 'off' : 'on'}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About SoundBlast')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text('SoundBlast',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          SizedBox(height: 12),
          Text(
            'SoundBlast is a music platform for independent artists and the listeners who love them. Discover new songs, follow artists, build playlists, and — if you make music — publish your own releases and reach new ears.',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 16),
          Text(
            'Everything you hear here is published by real artists on the platform. Likes, comments, follows and playlists are shared across the website and this app, because both talk to the same SoundBlast backend.',
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 16),
          Text(
            'Version 1.0.0 — Android app',
            style: TextStyle(color: SbColors.muted, fontSize: 13),
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
        showSnack(context, 'Could not open the website.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Get in touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const Text(
            'Questions, problems, or a report about content on SoundBlast? Send feedback from the Feedback page — it goes straight to the SoundBlast team — or visit the website contact page.',
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send feedback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/feedback'),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Open the SoundBlast website'),
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
      appBar: AppBar(title: const Text('Terms, Privacy & Permissions')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text('Terms of use',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            'By using SoundBlast you agree to use the platform respectfully: publish only music you own the rights to, do not upload content that infringes copyright, and do not harass other users. Artists confirm they own the rights to every song they publish.',
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text('Privacy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            'Your account stores your name, email and profile photo, plus your likes, favorites, playlists, follows and listening history so the service can work across devices. Your session is kept in a secure cookie on this device. SoundBlast does not sell your personal data.',
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text('Permissions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            'The app asks for storage access only when you pick an audio file, artwork or profile photo to upload. Playback continues while the app is in the background so your music is not interrupted.',
            style: TextStyle(color: SbColors.muted, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text('Copyright reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            'If content on SoundBlast infringes your rights, send a copyright report from the Feedback page (choose the copyright report category). Reports are reviewed by the SoundBlast administrators.',
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
      showSnack(context, 'Log in to send feedback.');
      return;
    }
    if (_message.text.trim().length < 10) {
      showSnack(context, 'Please write at least 10 characters.');
      return;
    }
    setState(() => _busy = true);
    try {
      await state.api.submitFeedback(_message.text.trim(),
          category: _category);
      if (!mounted) return;
      showSnack(context, 'Thanks — your feedback was sent.');
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
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
      appBar: AppBar(title: const Text('Feedback')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Tell us what you think',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
            'Bug reports, ideas, privacy requests and copyright reports all go to the SoundBlast team.',
            style: TextStyle(color: SbColors.muted),
          ),
          const SizedBox(height: 20),
          if (state.user == null)
            const GatedFeature(
              label: 'Send feedback',
              reason: 'Log in to send feedback — it is filed under your account.',
              icon: Icons.feedback,
            )
          else ...[
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(
                    value: 'feedback', child: Text('Feedback')),
                DropdownMenuItem(
                    value: 'privacy_request',
                    child: Text('Privacy request')),
                DropdownMenuItem(
                    value: 'copyright_report',
                    child: Text('Copyright report')),
              ],
              onChanged: (v) => setState(() => _category = v ?? 'feedback'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _message,
              decoration: const InputDecoration(
                  labelText: 'Your message',
                  hintText: 'At least 10 characters, up to 2000.'),
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
                    : const Text('Send feedback'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
