import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'api/models.dart';
import 'screens/auth_screens.dart';
import 'screens/browse_screens.dart';
import 'screens/home_screens.dart';
import 'screens/library_screens.dart';
import 'screens/manage_screens.dart';
import 'screens/admin_screen.dart';
import 'screens/oauth_screen.dart';
import 'screens/player_screen.dart';
import 'services/permission_flow.dart';
import 'state/app_state.dart';
import 'widgets/app_drawer.dart';
import 'widgets/common.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  // Show the UI immediately: the old code awaited the audio service and a
  // network login check (api.me(), up to 60s against the sleeping Render
  // backend) BEFORE runApp, so the app opened on a black screen until the
  // server answered. Now the first frame renders at once (a spinner until
  // authChecked) and the heavy init runs in the background.
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const SoundBlastApp(),
    ),
  );
  Future(() async {
    try {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.soundblast.app.audio',
        androidNotificationChannelName: 'SoundBlast playback',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
      ).timeout(const Duration(seconds: 15));
    } catch (_) {
      // Audio service init must never block the UI; playback retries later.
    }
    await appState.init();
  });
}

class SoundBlastApp extends StatelessWidget {
  const SoundBlastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return MaterialApp(
          title: 'SoundBlast',
          debugShowCheckedModeBanner: false,
          theme: sbTheme(),
          // Arabic + English: the locale follows AppState.appLocale (null =
          // device language). RTL flips automatically for Arabic.
          locale: state.appLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: !state.authChecked
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()))
              : !state.onboarded
                  ? const OnboardingScreen()
                  : const AppShell(),
          onGenerateRoute: (settings) => _route(settings, state),
        );
      },
    );
  }

  Route<dynamic>? _route(RouteSettings settings, AppState state) {
    final uri = Uri.parse(settings.name ?? '/');
    final segments = uri.pathSegments;
    final args = settings.arguments;

    Widget page;
    if (segments.isEmpty) {
      page = const AppShell();
    } else if (segments.length == 1) {
      switch (segments[0]) {
        case 'onboarding':
          page = const OnboardingScreen();
        case 'login':
          page = const LoginScreen();
        case 'signup':
          page = const SignupScreen();
        case 'forgot-password':
          page = const ForgotPasswordScreen();
        case 'discover':
          page = const DiscoverScreen();
        case 'trending':
          page = const TrendingScreen();
        case 'genres':
          page = const GenresScreen();
        case 'albums':
          page = const AlbumsScreen();
        case 'artists':
          page = const ArtistsScreen();
        case 'artist-posts':
          page = const ArtistPostsScreen();
        case 'playlists':
          page = const PlaylistsScreen();
        case 'favorites':
          page = const LibraryScreen();
        case 'liked':
          page = const LibraryScreen(initialTab: 0);
        case 'search':
          page = const SearchScreen();
        case 'player':
          page = const PlayerScreen();
        case 'music-player':
          page = const PlayerScreen();
        case 'upload':
          page = const UploadSongScreen();
        case 'dashboard':
          page = const DashboardScreen();
        case 'artist-studio':
          page = const ArtistStudioScreen();
        case 'admin':
          page = const AdminScreen();
        case 'notifications':
          page = const NotificationsScreen();
        case 'notification-preferences':
          page = const NotificationPreferencesScreen();
        case 'about':
          page = const AboutScreen();
        case 'contact':
          page = const ContactScreen();
        case 'policy':
          page = const PolicyScreen();
        case 'feedback':
          page = const FeedbackScreen();
        case 'gallery':
          page = const GalleryScreen();
        case 'sitemap':
          page = const SitemapScreen();
        case 'profile':
          page = const ProfileScreen();
        default:
          page = const NotFoundScreen();
      }
    } else if (segments.length == 2) {
      switch (segments[0]) {
        case 'oauth':
          page = segments[1] == 'github'
              ? const GitHubOAuthScreen()
              : const NotFoundScreen();
        case 'genres':
          page = GenreDetailsScreen(slug: Uri.decodeComponent(segments[1]));
        case 'albums':
          page = AlbumDetailsScreen(
              albumId: int.tryParse(segments[1]) ?? 0,
              album: args is Album ? args : null);
        case 'playlists':
        case 'playlist':
          page = PlaylistDetailsScreen(
              playlistId: int.tryParse(segments[1]) ?? 0);
        case 'artist':
          page = ArtistPageScreen(
            handle: Uri.decodeComponent(segments[1]),
            localUserId: args is int ? args : null,
          );
        case 'player':
          page = const PlayerScreen();
        case 'profile':
          page = segments[1] == 'edit'
              ? const EditProfileScreen()
              : const NotFoundScreen();
        default:
          page = const NotFoundScreen();
      }
    } else {
      page = const NotFoundScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}

/// Main shell: bottom navigation (Home / Discover / Search / Library /
/// Profile) with the persistent mini player above it, mirroring the
/// website's global MiniPlayer.
class AppShell extends StatefulWidget {
  final int initialTab;
  const AppShell({super.key, this.initialTab = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialTab;
    // Notification permission is asked once, at first play (point of need),
    // never on launch — see PermissionFlow.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().requestNotificationPermission = () async {
        if (!mounted) return false;
        return PermissionFlow.requestNotifications(context);
      };
    });
  }

  List<Widget> get _tabs => const [
        HomeScreen(),
        DiscoverScreen(),
        SearchScreen(),
        LibraryScreen(),
        ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appShellScaffoldKey,
      drawer: AppDrawer(
        currentTab: _index,
        onSelectTab: (i) => setState(() => _index = i),
      ),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayerBar(),
          BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: 'Discover'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_music), label: 'Library'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ],
      ),
    );
  }
}

/// Persistent mini player — mirrors the website's MiniPlayer: a floating
/// glass card (rounded-[1.35rem], border white/10, backdrop blur feel)
/// above the bottom nav, with a thin progress line on top, 40px cover,
/// title/artist, and play/pause + next. Tap opens the full player.
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final song = state.currentSong;
        if (song == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/player'),
            child: Container(
              decoration: BoxDecoration(
                color: SbColors.surface.withOpacity(0.92),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.42),
                    blurRadius: 38,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<Duration>(
                    stream: state.player.positionStream,
                    builder: (context, posSnap) {
                      return StreamBuilder<Duration?>(
                        stream: state.player.durationStream,
                        builder: (context, durSnap) {
                          final position = posSnap.data ?? Duration.zero;
                          final duration = durSnap.data ??
                              Duration(
                                  seconds: state.currentSong?.duration ?? 0);
                          final total = duration.inMilliseconds;
                          final frac = total > 0
                              ? (position.inMilliseconds / total)
                                  .clamp(0.0, 1.0)
                              : 0.0;
                          return LinearProgressIndicator(
                            value: frac,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 2,
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        CoverImage(url: song.imageUrl, size: 40, radius: 11),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(song.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(song.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: SbColors.muted, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(state.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled),
                          iconSize: 36,
                          color: Colors.white,
                          onPressed: () => state.togglePlayPause(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () => state.playNext(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SoundBlast')),
      body: EmptyState(
        icon: Icons.search_off,
        title: context.l10n.pageNotFound,
        message: context.l10n.pageNotFoundBody,
        action: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (_) => false),
          child: Text(context.l10n.goHome),
        ),
      ),
    );
  }
}
