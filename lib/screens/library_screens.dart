import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/models.dart';
import '../services/downloads.dart';
import '../services/permission_flow.dart';
import '../state/app_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common.dart';
import 'device_library_screens.dart';
import 'home_screens.dart' show SongActions;

/// Search — songs.search returns songs + artists + genres (website Search).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  SearchResult? _result;
  List<String> _genres = [];
  bool _searching = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      final g = await context.read<AppState>().api.genres();
      if (mounted) setState(() => _genres = g);
    } catch (_) {}
  }

  Future<void> _search(String q) async {
    final query = q.trim();
    if (query.isEmpty) {
      setState(() => _result = null);
      return;
    }
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final res = await context.read<AppState>().api.search(query);
      if (!mounted) return;
      setState(() {
        _result = res;
        _searching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _searching = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hasQuery = _controller.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
          leading: const DrawerMenuButton(), title: Text(context.l10n.search)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: hasQuery
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _result = null);
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              onChanged: (v) {
                if (v.trim().isEmpty) setState(() => _result = null);
                setState(() {});
              },
            ),
          ),
          if (_searching)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: SbColors.muted)),
            ),
          Expanded(
            child: _result == null
                ? ListView(
                    children: [
                      SectionHeader(title: context.l10n.browseGenres),
                      if (_genres.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(context.l10n.noGenresEmpty,
                              style: TextStyle(color: SbColors.muted)),
                        )
                      else
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _genres
                                .map((g) => ActionChip(
                                      label: Text(g),
                                      backgroundColor: SbColors.surface2,
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(
                                              '/genres/${Uri.encodeComponent(g)}'),
                                    ))
                                .toList(),
                          ),
                        ),
                      SectionHeader(title: context.l10n.quickLinks),
                      ListTile(
                        leading: const Icon(Icons.trending_up),
                        title: Text(context.l10n.trending),
                        onTap: () =>
                            Navigator.of(context).pushNamed('/trending'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.explore),
                        title: Text(context.l10n.navDiscover),
                        onTap: () =>
                            Navigator.of(context).pushNamed('/discover'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: Text(context.l10n.artists),
                        onTap: () =>
                            Navigator.of(context).pushNamed('/artists'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.album),
                        title: Text(context.l10n.navAlbums),
                        onTap: () =>
                            Navigator.of(context).pushNamed('/albums'),
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      if (_result!.songs.isNotEmpty) ...[
                        SectionHeader(title: context.l10n.songs),
                        ..._result!.songs.map((s) => SongTile(
                              song: s,
                              onTap: () => state.playSong(s,
                                  fromQueue: _result!.songs),
                              onPlay: () => state.playSong(s,
                                  fromQueue: _result!.songs),
                              trailing: SongActions(song: s),
                            )),
                      ],
                      if (_result!.artists.isNotEmpty) ...[
                        SectionHeader(title: context.l10n.artists),
                        SizedBox(
                          height: 168,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemCount: _result!.artists.length,
                            itemBuilder: (ctx, i) {
                              final a = _result!.artists[i];
                              return ArtistCard(
                                artist: a,
                                onTap: () =>
                                    Navigator.of(context).pushNamed(
                                  '/artist/${Uri.encodeComponent(a.slug ?? a.stageName)}',
                                  arguments: a.localUserId,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      if (_result!.genres.isNotEmpty) ...[
                        SectionHeader(title: context.l10n.genres),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 8,
                            children: _result!.genres
                                .map((g) => ActionChip(
                                      label: Text(g),
                                      backgroundColor: SbColors.surface2,
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(
                                              '/genres/${Uri.encodeComponent(g)}'),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                      if (_result!.songs.isEmpty &&
                          _result!.artists.isEmpty &&
                          _result!.genres.isEmpty)
                        EmptyState(
                          icon: Icons.search_off,
                          title: context.l10n.noResults,
                          message:
                              'Nothing matches "${_controller.text.trim()}" yet. Try a different song, artist or genre.',
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Library — the website's Favorites screen: tabs Liked Songs, Favorites
/// (saved), Playlists. Requires login for the server lists; guests see the
/// login prompt instead of fake data.
class LibraryScreen extends StatefulWidget {
  final int initialTab;
  const LibraryScreen({super.key, this.initialTab = 0});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this, initialIndex: widget.initialTab);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();
      if (state.user != null) state.refreshLibrary();
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: Text(context.l10n.yourLibrary),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: SbColors.accent,
          labelColor: SbColors.text,
          unselectedLabelColor: SbColors.muted,
          tabs: const [
            Tab(text: 'Liked'),
            Tab(text: 'Favorites'),
            Tab(text: 'Playlists'),
            Tab(text: 'Downloaded'),
          ],
        ),
      ),
      body: state.user == null
          ? _loginPrompt(context)
          : TabBarView(
              controller: _tab,
              children: [
                _songList(state, state.likedSongs, Icons.favorite_border,
                    'No liked songs yet',
                    'Tap the heart on any song to keep it here.'),
                _songList(state, state.myFavorites, Icons.bookmark_border,
                    'No favorites yet',
                    'Tap the bookmark on any song to save it here.'),
                _playlistsTab(context, state),
                _downloadedTab(context, state),
              ],
            ),
      floatingActionButton: state.user != null
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/playlists/create'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: Text(context.l10n.newPlaylist),
            )
          : null,
    );
  }

  Widget _loginPrompt(BuildContext context) {
    return EmptyState(
      icon: Icons.lock_outline,
      title: context.l10n.libraryLoginTitle,
      message: context.l10n.libraryLoginMessage,
      action: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed('/login'),
        child: Text(context.l10n.login),
      ),
    );
  }

  Widget _songList(AppState state, List<Song> songs, IconData icon,
      String title, String message) {
    if (songs.isEmpty) {
      return EmptyState(icon: icon, title: title, message: message);
    }
    return RefreshIndicator(
      onRefresh: () => state.refreshLibrary(),
      child: ListView(
        children: songs
            .map((s) => SongTile(
                  song: s,
                  onTap: () => state.playSong(s, fromQueue: songs),
                  onPlay: () => state.playSong(s, fromQueue: songs),
                  trailing: SongActions(song: s),
                ))
            .toList(),
      ),
    );
  }

  /// Downloaded / On-device tab: songs downloaded inside the app (playable
  /// with no internet) and audio files already on the device.
  Widget _downloadedTab(BuildContext context, AppState state) {
    return ListView(
      children: [
        SectionHeader(
            title: context.l10n.downloadedTitle,
            subtitle: context.l10n.downloadedSubtitle),
        if (state.downloads.items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'No downloads yet. Use ⋮ → Download for offline on any song.',
              style: TextStyle(color: SbColors.muted),
            ),
          )
        else
          ...state.downloads.items.map((d) {
            final song = d.toSong();
            final prog = state.downloads.progress[d.songId];
            return SongTile(
              song: song,
              onTap: () => state.playLocalSong(song, localPath: d.path,
                  fromQueue: state.downloads.items
                      .map((x) => x.toSong().copyWithLocalPath(x.path))
                      .toList()),
              onPlay: () => state.playLocalSong(song, localPath: d.path,
                  fromQueue: state.downloads.items
                      .map((x) => x.toSong().copyWithLocalPath(x.path))
                      .toList()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prog != null &&
                      prog.status == DownloadStatus.downloading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: prog.progress < 0 ? null : prog.progress,
                        strokeWidth: 2,
                      ),
                    ),
                  Text(d.sizeLabel,
                      style: const TextStyle(
                          color: SbColors.muted, fontSize: 12)),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: SbColors.muted, size: 20),
                    tooltip: 'Delete download',
                    onPressed: () async {
                      final ok = await confirmDialog(context,
                          title: context.l10n.deleteDownload,
                          message:
                              'Delete the offline copy of "${d.title}"? The song stays on SoundBlast.');
                      if (ok) {
                        await state.downloads.remove(d.songId);
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        SectionHeader(
            title: context.l10n.onDeviceTitle,
            subtitle: context.l10n.onDeviceSubtitle),
        _onDeviceSection(context, state),
        const SizedBox(height: 32),
      ],
    );
  }

  /// Offline playlists (on-device songs only, no account): list + create.
  Widget _localPlaylistsHub(BuildContext context, AppState state) {
    final store = state.localPlaylists;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(context.l10n.myPlaylistsOffline,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              TextButton.icon(
                onPressed: () async {
                  final name = await askTextInput(context,
                      title: context.l10n.newPlaylist, hint: context.l10n.playlistNameHint);
                  if (name != null && name.isNotEmpty) {
                    await store.create(name);
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.l10n.newLabel),
              ),
            ],
          ),
        ),
        if (store.items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'No offline playlists yet. Create one, then add songs with ⋮ on any on-device song.',
              style: TextStyle(color: SbColors.muted),
            ),
          )
        else
          ...store.items.map((p) => ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SbColors.surface2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.playlist_play,
                      color: SbColors.accent),
                ),
                title: Text(p.name),
                subtitle: Text(
                    '${p.songIds.length} song${p.songIds.length == 1 ? '' : 's'}'),
                trailing: const Icon(Icons.chevron_right,
                    color: SbColors.muted),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        LocalPlaylistDetailScreen(playlist: p),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _onDeviceSection(BuildContext context, AppState state) {
    return FutureBuilder<bool>(
      future: PermissionFlow.isMediaGranted(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }
        if (snap.data == true) {
          if (!state.deviceSongsLoaded) {
            final l10n = context.l10n;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              state.refreshDeviceSongs(
                unknownTitle: l10n.unknownTitle,
                unknownArtist: l10n.unknownArtist,
              );
            });
            return const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            );
          }
          if (state.deviceSongs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'No audio files found on this device.',
                style: TextStyle(color: SbColors.muted),
              ),
            );
          }
          // Samsung Music-style hub: the same on-device songs, browsable
          // by category, plus playlists that live only on this phone —
          // everything here works with no internet at all.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _localPlaylistsHub(context, state),
              ...DeviceCategory.values.map((c) {
                final count = c == DeviceCategory.tracks
                    ? state.deviceSongs.length
                    : groupDeviceSongs(context, c, state.deviceSongs).length;
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: SbColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(deviceCategoryIcon(c),
                        color: SbColors.accent),
                  ),
                  title: Text(deviceCategoryLabel(context, c)),
                  subtitle: Text(switch (c) {
                    DeviceCategory.tracks => context.l10n.songsCount(count),
                    DeviceCategory.albums => context.l10n.albumsCount(count),
                    DeviceCategory.artists => context.l10n.artistsCount(count),
                    DeviceCategory.genres => context.l10n.genresCount(count),
                    DeviceCategory.folders => context.l10n.foldersCount(count),
                    DeviceCategory.composers =>
                      context.l10n.composersCount(count),
                  }),
                  trailing: const Icon(Icons.chevron_right,
                      color: SbColors.muted),
                  onTap: () {
                    if (c == DeviceCategory.tracks) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DeviceSongsScreen(
                              title: context.l10n.allTracks,
                              songs: state.deviceSongs),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              DeviceCategoryScreen(category: c),
                        ),
                      );
                    }
                  },
                );
              }),
            ],
          );
        }
        // Not granted: offer the one-time ask (with explanation first).
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SoundBlast can play the songs already on this phone — even without internet.',
                style: TextStyle(color: SbColors.muted),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final l10n = context.l10n;
                  final granted =
                      await PermissionFlow.requestMedia(context);
                  if (granted) {
                    await state.refreshDeviceSongs(
                      unknownTitle: l10n.unknownTitle,
                      unknownArtist: l10n.unknownArtist,
                    );
                  } else {
                    if (context.mounted) setState(() {});
                  }
                },
                icon: const Icon(Icons.folder_open),
                label: Text(context.l10n.browseDeviceSongs),
              ),
              const SizedBox(height: 12),
              FutureBuilder<int>(
                future: SharedPreferences.getInstance().then(
                    (p) => p.getInt('sb_perm_media_asked') ?? 0),
                builder: (context, askedSnap) {
                  if ((askedSnap.data ?? 0) >= 2) {
                    return PermissionFlow.permissionBlockedNote(
                      context,
                      title: context.l10n.accessOffTitle,
                      body: context.l10n.permissionDeclinedTwice,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _playlistsTab(BuildContext context, AppState state) {
    if (state.playlists.isEmpty) {
      return EmptyState(
        icon: Icons.playlist_play,
        title: context.l10n.noPlaylists,
        message: context.l10n.createPlaylistHint,
        action: ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pushNamed('/playlists/create'),
          child: Text(context.l10n.createPlaylist),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => state.refreshLibrary(),
      child: ListView(
        children: state.playlists
            .map((p) => ListTile(
                  leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: SbColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.playlist_play,
                        color: SbColors.accent),
                  ),
                  title: Text(p.name),
                  subtitle: Text(p.description ?? 'Playlist'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/playlists/${p.id}'),
                ))
            .toList(),
      ),
    );
  }
}

/// Playlists list (website /playlists) — same data as the Library tab.
class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
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
      await state.refreshLibrary();
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navPlaylists)),
      body: state.user == null
          ? EmptyState(
              icon: Icons.lock_outline,
              title: context.l10n.loginPlaylistsTitle,
              message: context.l10n.loginPlaylistMessage,
              action: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/login'),
                child: Text(context.l10n.login),
              ),
            )
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : state.playlists.isEmpty
                      ? EmptyState(
                          icon: Icons.playlist_play,
                          title: context.l10n.noPlaylists,
                          message:
                              'Create your first playlist and add songs to it.',
                          action: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/playlists/create'),
                            child: Text(context.l10n.createPlaylist),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            children: state.playlists
                                .map((p) => ListTile(
                                      leading: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: SbColors.surface2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.playlist_play,
                                            color: SbColors.accent),
                                      ),
                                      title: Text(p.name),
                                      subtitle:
                                          Text(p.description ?? 'Playlist'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () => Navigator.of(context)
                                          .pushNamed('/playlists/${p.id}'),
                                    ))
                                .toList(),
                          ),
                        ),
      floatingActionButton: state.user != null
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/playlists/create'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: Text(context.l10n.newPlaylist),
            )
          : null,
    );
  }
}

/// Create playlist (website /playlists/create).
class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  List<Song> _all = [];
  final Set<int> _picked = {};
  bool _loadingSongs = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      final songs = await context.read<AppState>().api.allSongs();
      if (mounted) {
        setState(() {
          _all = songs;
          _loadingSongs = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingSongs = false);
    }
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      showSnack(context, 'Log in to create a playlist.');
      return;
    }
    if (_name.text.trim().isEmpty) {
      showSnack(context, 'Give your playlist a name.');
      return;
    }
    setState(() => _saving = true);
    try {
      final res = await state.api.createPlaylist(
        name: _name.text.trim(),
        description: _desc.text.trim(),
        songIds: _picked.toList(),
        saveAsDraft: _picked.isEmpty,
      );
      await state.refreshLibrary();
      if (!mounted) return;
      final id = res['id'];
      showSnack(context, 'Playlist created.');
      if (id != null) {
        Navigator.of(context).pushReplacementNamed('/playlists/$id');
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.createPlaylist)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: context.l10n.playlistNameHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _desc,
            decoration:
                InputDecoration(labelText: context.l10n.descriptionOptional),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          const Text(
            'Pick songs (optional — you can save an empty playlist as a draft and add songs later).',
            style: TextStyle(color: SbColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (_loadingSongs)
            const Center(child: CircularProgressIndicator())
          else if (_all.isEmpty)
            Text(context.l10n.noSongsInLibrary,
                style: TextStyle(color: SbColors.muted))
          else
            ..._all.map((s) => CheckboxListTile(
                  value: _picked.contains(s.id),
                  onChanged: (v) => setState(() {
                    if (v == true) {
                      _picked.add(s.id);
                    } else {
                      _picked.remove(s.id);
                    }
                  }),
                  title: Text(s.title),
                  subtitle: Text(s.artist),
                  secondary: CoverImage(url: s.imageUrl, size: 44),
                )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_picked.isEmpty ? context.l10n.createPlaylistDraft : context.l10n.createPlaylist),
            ),
          ),
        ],
      ),
    );
  }
}

/// Playlist details (website /playlists/:id): songs, play-all, rename,
/// delete, remove songs.
class PlaylistDetailsScreen extends StatefulWidget {
  final int playlistId;
  const PlaylistDetailsScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  Playlist? _playlist;
  List<Song> _songs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    // Playlists belong to an account: a guest sees the login prompt, never
    // a raw server error (the old "Please login (10001)" screen).
    if (state.user == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await state.api.playlistDetail(widget.playlistId);
      if (!mounted) return;
      setState(() {
        _playlist = res.playlist;
        _songs = res.songs;
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
    // A guest, or a session that died mid-use (the server answers
    // "Please log in to continue."), gets the login prompt — never the raw
    // error screen.
    final needsLogin =
        state.user == null || _error == 'Please log in to continue.';
    return Scaffold(
      appBar: AppBar(
        title: Text(_playlist?.name ?? 'Playlist'),
        actions: [
          if (_playlist != null)
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'rename') {
                  _rename();
                } else if (v == 'delete') {
                  final ok = await confirmDialog(context,
                      title: context.l10n.deletePlaylist,
                      message:
                          'Delete "${_playlist!.name}"? The songs stay in the library.');
                  if (ok) {
                    try {
                      await state.api.deletePlaylist(widget.playlistId);
                      await state.refreshLibrary();
                      if (mounted) Navigator.of(context).pop();
                    } catch (e) {
                      if (mounted) showSnack(context, e.toString());
                    }
                  }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'rename', child: Text(context.l10n.rename)),
                PopupMenuItem(value: 'delete', child: Text(context.l10n.delete)),
              ],
            ),
        ],
      ),
      body: needsLogin
          ? EmptyState(
              icon: Icons.lock_outline,
              title: context.l10n.loginPlaylistTitle,
              message: context.l10n.loginPlaylistMessage,
              action: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/login'),
                child: Text(context.l10n.login),
              ),
            )
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : _playlist == null
                      ? EmptyState(
                          icon: Icons.playlist_remove,
                      title: context.l10n.playlistNotFound,
                      message:
                          'This playlist is private or no longer exists.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_playlist!.name,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text(
                                  '${_songs.length} song${_songs.length == 1 ? '' : 's'}'
                                  '${(_playlist!.description ?? '').isNotEmpty ? ' • ${_playlist!.description}' : ''}',
                                  style: const TextStyle(
                                      color: SbColors.muted),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _songs.isEmpty
                                        ? null
                                        : () => state.playSong(_songs.first,
                                            fromQueue: _songs),
                                    icon: const Icon(Icons.play_arrow),
                                    label: Text(context.l10n.playAll),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_songs.isEmpty)
                            EmptyState(
                              icon: Icons.music_off_outlined,
                              title: context.l10n.noSongsYet,
                              message:
                                  'Add songs from any song menu (⋮ → Add to playlist).',
                            )
                          else
                            ..._songs.map((s) => SongTile(
                                  song: s,
                                  onTap: () => state.playSong(s,
                                      fromQueue: _songs),
                                  onPlay: () => state.playSong(s,
                                      fromQueue: _songs),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline,
                                        color: SbColors.muted, size: 20),
                                    tooltip: 'Remove from playlist',
                                    onPressed: () async {
                                      try {
                                        await state.api
                                            .removeSongFromPlaylist(
                                                widget.playlistId, s.id);
                                        await _load();
                                      } catch (e) {
                                        if (mounted) {
                                          showSnack(context, e.toString());
                                        }
                                      }
                                    },
                                  ),
                                )),
                        ],
                      ),
                    ),
    );
  }

  Future<void> _rename() async {
    final controller =
        TextEditingController(text: _playlist?.name ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SbColors.surface,
        title: Text(context.l10n.renamePlaylist),
        content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: context.l10n.fieldName)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(context.l10n.cancel)),
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(ctx).pop(controller.text.trim()),
              child: Text(context.l10n.save)),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      try {
        await context
            .read<AppState>()
            .api
            .updatePlaylist(widget.playlistId, name: name);
        await context.read<AppState>().refreshLibrary();
        await _load();
      } catch (e) {
        if (mounted) showSnack(context, e.toString());
      }
    }
  }
}
