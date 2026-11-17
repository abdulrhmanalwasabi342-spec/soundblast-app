import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../api/trpc_client.dart';
import '../state/app_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common.dart';

/// Home / Discover / Trending — mirror the website's Home, Discover and
/// Trending screens. Data comes only from the live backend; when the
/// homeSummary endpoint fails (it 500s on the live server today because its
/// artist-posts join fails) the screen falls back to songs.list +
/// songs.trending and says so, instead of showing nothing.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeSummary? _summary;
  List<Song> _songs = [];
  List<String> _genres = [];
  bool _loading = true;
  String? _error;
  bool _usedFallback = false;
  bool _showingCache = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    // Cache first: repeat opens render instantly even while the server is
    // still waking up; the network refresh below replaces the cache.
    final cached = state.cachedHome;
    setState(() {
      _error = null;
      _usedFallback = false;
      if (cached != null) {
        _summary = cached;
        _songs = state.cachedSongs ?? [];
        _loading = false;
        _showingCache = true;
      } else {
        _loading = true;
        _showingCache = false;
      }
    });
    try {
      HomeSummary summary;
      List<Song> freshSongs;
      try {
        summary = await state.api.homeSummary();
        freshSongs = await state.api.allSongs();
      } on ApiException {
        // Live backend defect (2026-11-17): songs.homeSummary returns 500
        // because its artist-posts query fails server-side. Fall back to the
        // individual public endpoints, which do work.
        _usedFallback = true;
        freshSongs = await state.api.allSongs();
        final trending = await state.api.trending();
        summary = HomeSummary(
          trendingSongs:
              trending.isNotEmpty ? trending : freshSongs.take(8).toList(),
          albums: [],
          artists: [],
          recentPublicPosts: [],
          totalSongs: freshSongs.length,
          totalPlays: freshSongs.fold(0, (a, s) => a + s.playCount),
        );
      }
      final genres = await state.api.genres();
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _songs = freshSongs;
        _genres = genres;
        _loading = false;
        _showingCache = false;
      });
      await state.cacheHome(summary, freshSongs);
    } catch (e) {
      if (!mounted) return;
      if (_summary != null) {
        // The cache is already on screen; the refresh just failed quietly.
        setState(() => _showingCache = true);
      } else {
        final state2 = context.read<AppState>();
        if (state2.cachedHome != null) {
          setState(() {
            _summary = state2.cachedHome;
            _songs = state2.cachedSongs ?? [];
            _loading = false;
            _showingCache = true;
          });
        } else {
          setState(() {
            _error = e.toString();
            _loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/soundblast-logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text('SoundBlast',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.upload_outlined),
            tooltip: 'Upload a song',
            onPressed: () => Navigator.of(context).pushNamed('/upload'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    children: [
                      if (_showingCache)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: SbColors.surface2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'You are offline — showing the last saved library.',
                            style: TextStyle(color: SbColors.muted),
                          ),
                        ),
                      if (_usedFallback)
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: SbColors.surface2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Home summary is unavailable on the server right now — showing songs directly.',
                            style: TextStyle(color: SbColors.muted, fontSize: 13),
                          ),
                        ),
                      _hero(context, state),
                      if ((_summary?.trendingSongs ?? []).isNotEmpty)
                        _releaseRadar(
                            context, state, _summary!.trendingSongs),
                      if (_songs.isNotEmpty)
                        _songShelf(
                          context,
                          state,
                          title: 'Weekly top',
                          subtitle: 'Most played this week',
                          songs: _songs,
                          onSeeAll: () =>
                              Navigator.of(context).pushNamed('/trending'),
                        ),
                      if (_genres.isNotEmpty) ...[
                        const SectionHeader(title: 'Moods & genres'),
                        SizedBox(
                          height: 96,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemCount: _genres.length,
                            itemBuilder: (ctx, i) {
                              final g = _genres[i];
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    '/genres/${Uri.encodeComponent(g)}'),
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: SbColors.surface2,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.music_note,
                                          color: SbColors.accentPink),
                                      const SizedBox(height: 8),
                                      Text(g,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      if ((_summary?.artists ?? []).isNotEmpty) ...[
                        const SectionHeader(
                            title: 'Popular artists',
                            subtitle: 'Most followed on SoundBlast'),
                        SizedBox(
                          height: 168,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemCount: _summary!.artists.length,
                            itemBuilder: (ctx, i) {
                              final a = _summary!.artists[i];
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
                      if (_songs.isEmpty && _genres.isEmpty)
                        EmptyState(
                          icon: Icons.library_music_outlined,
                          title: 'No songs yet',
                          message:
                              'The SoundBlast library is empty right now. Artists can publish the first songs from Upload.',
                          action: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/upload'),
                            child: const Text('Upload a song'),
                          ),
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _hero(BuildContext context, AppState state) {
    // ClassicHomeHero (website): bg #050508, pink glow top-left, purple
    // glow bottom-right, gold eyebrow "The SoundBlast room", Playfair
    // Display headline "Find the sound that stays with you." (gradient on
    // "you."), white pill CTA, outline pill, pink analytics pill.
    final top = (_summary?.trendingSongs ?? []).isNotEmpty
        ? _summary!.trendingSongs.first
        : (_songs.isNotEmpty ? _songs.first : null);
    final totalLikes =
        _songs.fold(0, (a, s) => a + s.likeCount);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SbColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -60,
            top: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SbColors.accent.withOpacity(0.20),
              ),
            ),
          ),
          Positioned(
            right: -50,
            bottom: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SbColors.purpleDeep.withOpacity(0.20),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.10)),
                      color: Colors.white.withOpacity(0.045),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.radio,
                            size: 12, color: SbColors.accentPink),
                        SizedBox(width: 6),
                        Text('LISTEN WITH INTENT',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_songs.length} signals live',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Eyebrow('The SoundBlast room'),
              const SizedBox(height: 12),
              const DisplayTitle('Find the sound', fontSize: 40),
              const DisplayTitle('that stays with', fontSize: 40),
              ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(
                  colors: [
                    SbColors.accentPinkPale,
                    SbColors.accent,
                    SbColors.purpleLight,
                  ],
                ).createShader(bounds),
                child: const DisplayTitle('you.', fontSize: 40),
              ),
              const SizedBox(height: 14),
              const Text(
                'A focused home for releases, artist stories, and the tracks worth replaying. Built around the people making the music.',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroPrimaryButton(
                    label: top == null
                        ? 'Explore music'
                        : "Play today's signal",
                    onPressed: top == null
                        ? () => Navigator.of(context).pushNamed('/trending')
                        : () => state.playSong(top, fromQueue: _songs),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/artists'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Meet the artists'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/dashboard'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFFD0ED),
                      backgroundColor: SbColors.accent.withOpacity(0.10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                        side: BorderSide(
                            color: SbColors.accent.withOpacity(0.35)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      'View live analytics · ${formatCount(_summary?.totalPlays ?? 0)} plays / 7d',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.favorite,
                      size: 14, color: SbColors.accentPink),
                  const SizedBox(width: 6),
                  Text(
                    '${formatCount(totalLikes)} marks of love from the community',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              if (top != null) ...[
                const SizedBox(height: 20),
                _SignalCard(song: top, onPlay: () =>
                    state.playSong(top, fromQueue: _songs)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _songShelf(BuildContext context, AppState state,
      {required String title,
      String? subtitle,
      required List<Song> songs,
      VoidCallback? onSeeAll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, subtitle: subtitle, onSeeAll: onSeeAll),
        ...songs.map((s) => SongTile(
              song: s,
              onTap: () => Navigator.of(context).pushNamed('/player'),
              onPlay: () => state.playSong(s, fromQueue: songs),
              trailing: SongActions(song: s),
            )),
      ],
    );
  }

  /// Release radar — the website's featured grid: 2-column cards,
  /// rounded-[1.45rem], square cover with black gradient, white circular
  /// play button, pink heart top-left when liked.
  Widget _releaseRadar(BuildContext context, AppState state, List<Song> songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('New in the room'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DisplayTitle('Release radar', fontSize: 30),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed('/albums'),
                    child: const Text('Browse releases ↗',
                        style: TextStyle(
                            color: Colors.white60, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 24,
            childAspectRatio: 0.72,
          ),
          itemCount: songs.length,
          itemBuilder: (ctx, i) {
            final s = songs[i];
            final liked = state.isLiked(s.id);
            final isCurrent = state.currentSong?.id == s.id;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.07)),
                          color: Colors.white.withOpacity(0.03),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CoverImage(
                                url: s.imageUrl,
                                size: 1000,
                                radius: 23,
                                fallbackIcon: Icons.music_note),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black54,
                                    Colors.black87,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: GestureDetector(
                          onTap: () async {
                            if (state.user == null) {
                              showSnack(context,
                                  'Log in to like songs.');
                              return;
                            }
                            try {
                              await state.toggleLike(s);
                            } catch (e) {
                              if (context.mounted) {
                                showSnack(context, e.toString());
                              }
                            }
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: liked
                                  ? SbColors.accent
                                  : Colors.black.withOpacity(0.45),
                              boxShadow: liked
                                  ? [
                                      BoxShadow(
                                        color: SbColors.accent
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SbColors.accent.withOpacity(0.9),
                            ),
                            child: const Icon(Icons.album,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () =>
                              state.playSong(s, fromQueue: songs),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 12,
                                )
                              ],
                            ),
                            child: Icon(
                              isCurrent && state.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: const Color(0xFF130D19),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            '/artist/${Uri.encodeComponent(s.artist)}'),
                        child: Text(s.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 13)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatCount(s.playCount)} plays'
                        '${s.likeCount > 0 ? ' • ${formatCount(s.likeCount)} likes' : ''}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// White pill hero CTA (website): white bg, dark text, dark circle with a
/// play icon inside.
class _HeroPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _HeroPrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0B0910),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.only(left: 12, right: 20, top: 6, bottom: 6),
        elevation: 8,
        shadowColor: Colors.white.withOpacity(0.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF120F19),
            ),
            child: const Icon(Icons.play_arrow,
                size: 14, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}

/// Featured "Signal" card from the hero (website ClassicHomeHero):
/// rounded-[2rem], border white/12, bg #151020, pink glow, cover art with
/// "SoundBlast original" + "Signal" and a glass "now playing" chip.
class _SignalCard extends StatelessWidget {
  final Song song;
  final VoidCallback onPlay;
  const _SignalCard({required this.song, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        color: SbColors.surface2,
        boxShadow: [
          BoxShadow(
            color: SbColors.accent.withOpacity(0.25),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CoverImage(url: song.imageUrl, size: 1000, radius: 0),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.transparent, Colors.black87],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SOUNDBLAST ORIGINAL',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                        color: Colors.white60)),
                const SizedBox(height: 8),
                const DisplayTitle('Signal', fontSize: 32),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.10)),
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: SbColors.accentPink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('NOW PLAYING',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                              color: Colors.white70)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ),
                      GestureDetector(
                        onTap: onPlay,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.play_arrow,
                              size: 16, color: Color(0xFF130D19)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SongActions extends StatelessWidget {
  final Song song;
  const SongActions({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final liked = state.isLiked(song.id);
    final fav = state.isFavorite(song.id);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? SbColors.accent : SbColors.muted, size: 20),
          tooltip: liked ? 'Unlike' : 'Like',
          onPressed: () async {
            if (state.user == null) {
              showSnack(context, 'Log in to like songs.');
              return;
            }
            try {
              await state.toggleLike(song);
            } catch (e) {
              if (context.mounted) showSnack(context, e.toString());
            }
          },
        ),
        IconButton(
          icon: Icon(fav ? Icons.bookmark : Icons.bookmark_border,
              color: fav ? SbColors.accent : SbColors.muted, size: 20),
          tooltip: fav ? 'Remove from favorites' : 'Save to favorites',
          onPressed: () async {
            if (state.user == null) {
              showSnack(context, 'Log in to save favorites.');
              return;
            }
            try {
              await state.toggleFavorite(song);
            } catch (e) {
              if (context.mounted) showSnack(context, e.toString());
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: SbColors.muted, size: 20),
          onPressed: () => _showSongMenu(context, state, song),
        ),
      ],
    );
  }

  void _showSongMenu(BuildContext context, AppState state, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SbColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CoverImage(url: song.imageUrl, size: 48),
              title: Text(song.title),
              subtitle: Text(song.artist),
            ),
            const Divider(color: SbColors.border),
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play next'),
              onTap: () {
                Navigator.of(ctx).pop();
                state.playSong(song,
                    fromQueue: [song, ...state.queue]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to playlist'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showAddToPlaylist(context, state, song);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(state.downloads.isDownloaded(song.id)
                  ? 'Downloaded — play offline'
                  : 'Download for offline'),
              subtitle: state.downloads.isDownloaded(song.id)
                  ? Text(state.downloads.find(song.id)!.sizeLabel)
                  : null,
              onTap: () async {
                Navigator.of(ctx).pop();
                if (state.downloads.isDownloaded(song.id)) {
                  final d = state.downloads.find(song.id)!;
                  await state.playLocalSong(d.toSong(),
                      localPath: d.path);
                  return;
                }
                try {
                  showSnack(context, 'Downloading ${song.title}…');
                  await state.downloads.download(song);
                  if (context.mounted) {
                    showSnack(context,
                        'Downloaded — available offline in Library → Downloaded.');
                  }
                } catch (e) {
                  if (context.mounted) showSnack(context, e.toString());
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Go to artist: ${song.artist}'),
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(
                    '/artist/${Uri.encodeComponent(song.artist)}');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToPlaylist(
      BuildContext context, AppState state, Song song) {
    if (state.user == null) {
      showSnack(context, 'Log in to use playlists.');
      return;
    }
    if (state.playlists.isEmpty) {
      showSnack(context, 'No playlists yet — create one first.');
      Navigator.of(context).pushNamed('/playlists/create');
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: SbColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Add to playlist',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            ...state.playlists.map((p) => ListTile(
                  leading: const Icon(Icons.playlist_play),
                  title: Text(p.name),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    try {
                      await state.api.addSongToPlaylist(p.id, song.id);
                      if (context.mounted) {
                        showSnack(context, 'Added to ${p.name}.');
                      }
                    } catch (e) {
                      if (context.mounted) showSnack(context, e.toString());
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}

/// Discover — all songs + genres, same content as the website's Discover.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<Song> _songs = [];
  List<String> _genres = [];
  List<ArtistProfile> _artists = [];
  bool _loading = true;
  String? _error;
  String _genreFilter = 'All';

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
      final results = await Future.wait([
        state.api.allSongs(),
        state.api.genres(),
        state.api.allArtists(),
      ]);
      if (!mounted) return;
      setState(() {
        _songs = results[0] as List<Song>;
        _genres = results[1] as List<String>;
        _artists = results[2] as List<ArtistProfile>;
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

  List<Song> get _visible => _genreFilter == 'All'
      ? _songs
      : _songs.where((s) => s.genre == _genreFilter).toList();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
          leading: const DrawerMenuButton(),
          title: const Text('Discover')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    children: [
                      if (_genres.isNotEmpty)
                        SizedBox(
                          height: 48,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            children: [
                              _chip('All'),
                              ..._genres.map(_chip),
                            ],
                          ),
                        ),
                      const SectionHeader(title: 'All songs'),
                      if (_visible.isEmpty)
                        const EmptyState(
                          icon: Icons.music_off_outlined,
                          title: 'Nothing here yet',
                          message:
                              'No songs match this filter. Try another genre.',
                        )
                      else
                        ..._visible.map((s) => SongTile(
                              song: s,
                              onTap: () => state.playSong(s, fromQueue: _visible),
                              onPlay: () =>
                                  state.playSong(s, fromQueue: _visible),
                              trailing: SongActions(song: s),
                            )),
                      if (_artists.isNotEmpty) ...[
                        const SectionHeader(title: 'Artists to explore'),
                        SizedBox(
                          height: 168,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
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
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _chip(String label) {
    final selected = _genreFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: SbColors.accent,
        backgroundColor: SbColors.surface2,
        labelStyle: TextStyle(
            color: selected ? Colors.white : SbColors.text),
        onSelected: (_) => setState(() => _genreFilter = label),
      ),
    );
  }
}

/// Trending — true 7-day trending from play events (songs.trending).
class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
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
      final trending = await state.api.trending();
      final all = trending.isEmpty ? await state.api.allSongs() : trending;
      if (!mounted) return;
      setState(() {
        _songs = all;
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
      appBar: AppBar(title: const Text('Trending')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _songs.isEmpty
                  ? const EmptyState(
                      icon: Icons.trending_up,
                      title: 'No trending songs yet',
                      message:
                          'Trending is computed from plays in the last 7 days. Once people start listening, the chart fills up here.',
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: Text(
                              'Most played in the last 7 days',
                              style: TextStyle(color: SbColors.muted),
                            ),
                          ),
                          ..._songs.asMap().entries.map((e) => SongTile(
                                song: e.value,
                                rank: e.key + 1,
                                onTap: () => state.playSong(e.value,
                                    fromQueue: _songs),
                                onPlay: () => state.playSong(e.value,
                                    fromQueue: _songs),
                                trailing: SongActions(song: e.value),
                              )),
                        ],
                      ),
                    ),
    );
  }
}
