import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'home_screens.dart' show SongActions;

/// Genres list (website /genres).
class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List<String> _genres = [];
  Map<String, int> _counts = {};
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
      final genres = await state.api.genres();
      final songs = await state.api.allSongs();
      final counts = <String, int>{};
      for (final s in songs) {
        counts[s.genre] = (counts[s.genre] ?? 0) + 1;
      }
      if (!mounted) return;
      setState(() {
        _genres = genres;
        _counts = counts;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Genres')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _genres.isEmpty
                  ? const EmptyState(
                      icon: Icons.category_outlined,
                      title: 'No genres yet',
                      message:
                          'Genres appear here once artists publish songs.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        children: _genres
                            .map((g) => ListTile(
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: SbColors.surface2,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.music_note,
                                        color: SbColors.accent),
                                  ),
                                  title: Text(g,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text(
                                      '${_counts[g] ?? 0} song${(_counts[g] ?? 0) == 1 ? '' : 's'}'),
                                  trailing:
                                      const Icon(Icons.chevron_right),
                                  onTap: () => Navigator.of(context).pushNamed(
                                      '/genres/${Uri.encodeComponent(g)}'),
                                ))
                            .toList(),
                      ),
                    ),
    );
  }
}

/// Genre details (website /genres/:slug) — songs in that genre.
class GenreDetailsScreen extends StatefulWidget {
  final String slug;
  const GenreDetailsScreen({super.key, required this.slug});

  @override
  State<GenreDetailsScreen> createState() => _GenreDetailsScreenState();
}

class _GenreDetailsScreenState extends State<GenreDetailsScreen> {
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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final songs = await state.api.songsByGenre(widget.slug);
      if (!mounted) return;
      setState(() {
        _songs = songs;
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
      appBar: AppBar(title: Text(widget.slug)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: SbColors.surface2,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.music_note,
                                size: 36, color: SbColors.accent),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.slug,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800)),
                                Text(
                                    '${_songs.length} song${_songs.length == 1 ? '' : 's'}',
                                    style: const TextStyle(
                                        color: SbColors.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_songs.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => state.playSong(_songs.first,
                                fromQueue: _songs),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play all'),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _songs.isEmpty
                          ? EmptyState(
                              icon: Icons.music_off_outlined,
                              title: 'No $widget.slug songs yet',
                              message:
                                  'No public songs in this genre right now.',
                            )
                          : ListView(
                              children: _songs
                                  .map((s) => SongTile(
                                        song: s,
                                        onTap: () => state.playSong(s,
                                            fromQueue: _songs),
                                        onPlay: () => state.playSong(s,
                                            fromQueue: _songs),
                                        trailing: SongActions(song: s),
                                      ))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
    );
  }
}

/// Albums list (website /albums) — official releases from getAlbums().
class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  List<Album> _albums = [];
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
      final albums = await state.api.albums();
      if (!mounted) return;
      setState(() {
        _albums = albums;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _albums.isEmpty
                  ? const EmptyState(
                      icon: Icons.album_outlined,
                      title: 'No albums yet',
                      message:
                          'Albums appear here once artists publish releases.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: _albums.length,
                        itemBuilder: (ctx, i) {
                          final a = _albums[i];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                '/albums/${a.id}',
                                arguments: a),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CoverImage(
                                        url: a.imageUrl,
                                        size: 1000,
                                        radius: 16,
                                        fallbackIcon: Icons.album),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(a.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                Text(
                                  [
                                    if (a.artistName != null) a.artistName!,
                                    if (a.releaseType != null) a.releaseType!,
                                    if (a.songCount > 0)
                                      '${a.songCount} songs',
                                  ].join(' • '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: SbColors.muted, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

/// Album details (website /albums/:id) — songs of the release.
class AlbumDetailsScreen extends StatefulWidget {
  final int albumId;
  final Album? album;
  const AlbumDetailsScreen({super.key, required this.albumId, this.album});

  @override
  State<AlbumDetailsScreen> createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  Album? _album;
  List<Song> _songs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _album = widget.album;
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final albums = await state.api.albums();
      final all = await state.api.allSongs();
      Album? album = _album;
      try {
        album ??= albums.firstWhere((a) => a.id == widget.albumId);
      } catch (_) {}
      final songs =
          all.where((s) => s.albumId == widget.albumId).toList();
      // Legacy tracks carry the album name but no albumId.
      if (songs.isEmpty && album != null) {
        songs.addAll(
            all.where((s) => s.albumName == album!.title).toList());
      }
      if (!mounted) return;
      setState(() {
        _album = album;
        _songs = songs;
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
      appBar: AppBar(title: Text(_album?.title ?? 'Album')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _album == null
                  ? const EmptyState(
                      icon: Icons.album_outlined,
                      title: 'Album not found',
                      message: 'This release may be private or removed.',
                    )
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CoverImage(
                                  url: _album!.imageUrl,
                                  size: 120,
                                  radius: 16,
                                  fallbackIcon: Icons.album),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(_album!.title,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 4),
                                    Text(
                                      [
                                        if (_album!.artistName != null)
                                          _album!.artistName!,
                                        if (_album!.releaseType != null)
                                          _album!.releaseType!,
                                        '${_songs.length} songs',
                                      ].join(' • '),
                                      style: const TextStyle(
                                          color: SbColors.muted),
                                    ),
                                    if ((_album!.description ?? '')
                                        .isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(_album!.description!,
                                            style: const TextStyle(
                                                color: SbColors.muted,
                                                fontSize: 13)),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _songs.isEmpty
                                  ? null
                                  : () => state.playSong(_songs.first,
                                      fromQueue: _songs),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play album'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._songs.asMap().entries.map((e) => SongTile(
                              song: e.value,
                              rank: e.key + 1,
                              onTap: () => state.playSong(e.value,
                                  fromQueue: _songs),
                              onPlay: () => state.playSong(e.value,
                                  fromQueue: _songs),
                              trailing: SongActions(song: e.value),
                            )),
                        if (_songs.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'No public songs in this release yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: SbColors.muted),
                            ),
                          ),
                      ],
                    ),
    );
  }
}

/// Artists list (website /artists).
class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List<ArtistProfile> _artists = [];
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
      final artists = await state.api.allArtists();
      if (!mounted) return;
      setState(() {
        _artists = artists;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Artists')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _artists.isEmpty
                  ? const EmptyState(
                      icon: Icons.people_outline,
                      title: 'No artists yet',
                      message:
                          'Artists appear here once they sign up and publish.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: _artists.length,
                        itemBuilder: (ctx, i) {
                          final a = _artists[i];
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
    );
  }
}

/// Artist page (website /artist/:artistName): profile, songs, posts, follow.
class ArtistPageScreen extends StatefulWidget {
  final String handle;
  final int? localUserId;
  const ArtistPageScreen({super.key, required this.handle, this.localUserId});

  @override
  State<ArtistPageScreen> createState() => _ArtistPageScreenState();
}

class _ArtistPageScreenState extends State<ArtistPageScreen> {
  ArtistProfile? _profile;
  List<Song> _songs = [];
  List<ArtistPost> _posts = [];
  int _followerCount = 0;
  bool _following = false;
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
      int? id = widget.localUserId;
      if (id == null) {
        // Resolve slug/name to a local user id via the server.
        final res = await state.trpc.query(
            'songs.resolveByHandle', {'handle': widget.handle});
        final m = res is Map ? Map<String, dynamic>.from(res) : {};
        id = m['localUserId'] == null
            ? null
            : int.tryParse(m['localUserId'].toString());
      }
      if (id == null) throw Exception('Artist not found');
      final profile = await state.api.artistProfile(id);
      final posts = await state.api.artistPosts(id);
      final followers = await state.api.followers(id);
      if (!mounted) return;
      final p = profile['profile'];
      setState(() {
        _profile =
            p == null ? null : ArtistProfile.fromJson(p);
        _songs = (profile['songs'] is List)
            ? (profile['songs'] as List).map(Song.fromJson).toList()
            : [];
        _followerCount = (profile['followerCount'] as num?)?.toInt() ?? 0;
        _posts = posts;
        _following = followers['following'] == true;
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

  Future<void> _toggleFollow() async {
    final state = context.read<AppState>();
    if (state.user == null) {
      showSnack(context, 'Log in to follow artists.');
      return;
    }
    final id = _profile?.localUserId;
    if (id == null) return;
    try {
      if (_following) {
        await state.api.unfollowArtist(id);
        setState(() {
          _following = false;
          _followerCount = (_followerCount - 1).clamp(0, 1 << 30);
        });
      } else {
        await state.api.followArtist(id);
        setState(() {
          _following = true;
          _followerCount += 1;
        });
      }
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(_profile?.stageName ?? widget.handle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _profile == null
                  ? const EmptyState(
                      icon: Icons.person_off_outlined,
                      title: 'Artist not found',
                      message: 'This artist page does not exist.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: CoverImage(
                                      url: _profile!.imageUrl,
                                      size: 120,
                                      radius: 60,
                                      fallbackIcon: Icons.person),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_profile!.stageName,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800)),
                                    if (_profile!.verified)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Icon(Icons.verified,
                                            color: SbColors.accent),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_followerCount followers • ${_songs.length} songs • ${_songs.fold(0, (a, s) => a + s.playCount)} plays',
                                  style: const TextStyle(
                                      color: SbColors.muted),
                                ),
                                if ((_profile!.bio ?? '').isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(_profile!.bio!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: SbColors.muted)),
                                  ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _songs.isEmpty
                                            ? null
                                            : () => state.playSong(
                                                _songs.first,
                                                fromQueue: _songs),
                                        icon: const Icon(Icons.play_arrow),
                                        label: const Text('Play'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _toggleFollow,
                                        icon: Icon(_following
                                            ? Icons.check
                                            : Icons.person_add),
                                        label: Text(_following
                                            ? 'Following'
                                            : 'Follow'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: SbColors.text,
                                          side: const BorderSide(
                                              color: SbColors.border),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(999)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SectionHeader(title: 'Songs'),
                          if (_songs.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No public songs from this artist yet.',
                                style:
                                    TextStyle(color: SbColors.muted),
                              ),
                            )
                          else
                            ..._songs.map((s) => SongTile(
                                  song: s,
                                  onTap: () => state.playSong(s,
                                      fromQueue: _songs),
                                  onPlay: () => state.playSong(s,
                                      fromQueue: _songs),
                                  trailing: SongActions(song: s),
                                )),
                          if (_posts.isNotEmpty) ...[
                            const SectionHeader(title: 'Posts'),
                            ..._posts.map((p) => Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  color: SbColors.card,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(p.body),
                                        if (p.createdAt != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Text(
                                              p.createdAt!
                                                  .toString()
                                                  .substring(
                                                      0,
                                                      p.createdAt!.length > 10
                                                          ? 10
                                                          : p.createdAt!.length),
                                              style: const TextStyle(
                                                  color: SbColors.muted,
                                                  fontSize: 12),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
    );
  }
}

/// Artist posts feed (website /artist-posts). NOTE: the live backend's
/// publicPostsFeed endpoint currently returns 500 (same artist-posts DB
/// defect as homeSummary), so the feed shows that honestly with retry.
class ArtistPostsScreen extends StatefulWidget {
  const ArtistPostsScreen({super.key});

  @override
  State<ArtistPostsScreen> createState() => _ArtistPostsScreenState();
}

class _ArtistPostsScreenState extends State<ArtistPostsScreen> {
  List<ArtistPost> _posts = [];
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
      final posts = await state.api.publicPostsFeed();
      if (!mounted) return;
      setState(() {
        _posts = posts;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Artist Posts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(
                  message:
                      'The artist posts feed is unavailable on the server right now ($_error). Artist posts still work on each artist page.',
                  onRetry: _load)
              : _posts.isEmpty
                  ? const EmptyState(
                      icon: Icons.post_add_outlined,
                      title: 'No posts yet',
                      message: 'Artists have not shared any public posts.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        children: _posts
                            .map((p) => Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  color: SbColors.card,
                                  child: ListTile(
                                    leading: CoverImage(
                                        url: p.imageUrl,
                                        size: 48,
                                        fallbackIcon: Icons.person),
                                    title: Text(p.stageName ?? 'Artist'),
                                    subtitle: Text(p.body),
                                    onTap: () {
                                      if (p.artistLocalUserId > 0) {
                                        Navigator.of(context).pushNamed(
                                          '/artist/${Uri.encodeComponent(p.stageName ?? '')}',
                                          arguments: p.artistLocalUserId,
                                        );
                                      }
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
    );
  }
}

/// Gallery (website /gallery) — artwork of the library's songs.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final songs = await state.api.allSongs();
      if (!mounted) return;
      setState(() {
        _songs = songs.where((s) => (s.imageUrl ?? '').isNotEmpty).toList();
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
      appBar: AppBar(title: const Text('Gallery')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _songs.isEmpty
                  ? const EmptyState(
                      icon: Icons.photo_library_outlined,
                      title: 'Gallery is empty',
                      message:
                          'Song artwork appears here once songs with cover art are published.',
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _songs.length,
                      itemBuilder: (ctx, i) {
                        final s = _songs[i];
                        return GestureDetector(
                          onTap: () =>
                              state.playSong(s, fromQueue: _songs),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CoverImage(
                                url: s.imageUrl, size: 1000, radius: 12),
                          ),
                        );
                      },
                    ),
    );
  }
}

/// Sitemap (website /sitemap) — every section of the app in one list.
class SitemapScreen extends StatelessWidget {
  const SitemapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = <(String, String, IconData)>[
      ('Home', '/', Icons.home),
      ('Discover', '/discover', Icons.explore),
      ('Trending', '/trending', Icons.trending_up),
      ('Genres', '/genres', Icons.category),
      ('Albums', '/albums', Icons.album),
      ('Artists', '/artists', Icons.people),
      ('Artist Posts', '/artist-posts', Icons.post_add),
      ('Playlists', '/playlists', Icons.playlist_play),
      ('Your Library', '/favorites', Icons.library_music),
      ('Search', '/search', Icons.search),
      ('Upload a Song', '/upload', Icons.upload),
      ('Dashboard', '/dashboard', Icons.dashboard),
      ('Artist Studio', '/artist-studio', Icons.mic),
      ('Notifications', '/notifications', Icons.notifications),
      ('About', '/about', Icons.info),
      ('Contact', '/contact', Icons.mail),
      ('Terms, Privacy & Permissions', '/policy', Icons.policy),
      ('Feedback', '/feedback', Icons.feedback),
      ('Gallery', '/gallery', Icons.photo_library),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Sitemap')),
      body: ListView(
        children: [
          ...items.map((e) => ListTile(
                leading: Icon(e.$3, color: SbColors.accent),
                title: Text(e.$1),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).pushNamed(e.$2),
              )),
          if (state.user == null)
            ListTile(
              leading: const Icon(Icons.login, color: SbColors.accent),
              title: const Text('Log in'),
              onTap: () => Navigator.of(context).pushNamed('/login'),
            ),
          if (state.user != null && state.user!.isAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings,
                  color: SbColors.accent),
              title: const Text('Admin'),
              onTap: () => Navigator.of(context).pushNamed('/admin'),
            ),
        ],
      ),
    );
  }
}
