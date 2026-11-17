import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/common.dart';

/// The app shell's scaffold key: the tab screens' AppBars are nested inside
/// their own Scaffolds, so the menu button opens the shell drawer through
/// this key instead of `Scaffold.of(context)`.
final appShellScaffoldKey = GlobalKey<ScaffoldState>();

/// Hamburger button for the tab screens' AppBars.
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Menu',
      onPressed: () => appShellScaffoldKey.currentState?.openDrawer(),
    );
  }
}

class _DrawerEntry {
  const _DrawerEntry(this.label, this.icon, this.route, {this.tab});
  final String label;
  final IconData icon;
  final String route;
  /// Tab index for Home/Discover, which switch the shell tab instead of
  /// pushing a duplicate page on top of it.
  final int? tab;
}

/// Sidebar navigation, mirroring the website's navigation groups
/// (SignUpSection: menuItems / libraryItems / playlistItems) in the same
/// order, with the same labels and routes.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  final int currentTab;
  final ValueChanged<int> onSelectTab;

  static const _menu = [
    _DrawerEntry('Home', Icons.home, '/', tab: 0),
    _DrawerEntry('Discover', Icons.explore, '/discover', tab: 1),
    _DrawerEntry('Albums', Icons.album, '/albums'),
    _DrawerEntry('Artists', Icons.person, '/artists'),
    _DrawerEntry('Artist Posts', Icons.message, '/artist-posts'),
  ];

  static const _library = [
    _DrawerEntry('Music Player', Icons.trending_up, '/music-player'),
    _DrawerEntry('Feedback', Icons.message, '/feedback'),
    _DrawerEntry('Trending Songs', Icons.local_fire_department, '/trending'),
    _DrawerEntry('Genres', Icons.music_note, '/genres'),
    _DrawerEntry('Dashboard', Icons.bar_chart, '/dashboard'),
  ];

  static const _playlists = [
    _DrawerEntry('Favorites', Icons.favorite, '/favorites'),
    _DrawerEntry('Liked Songs', Icons.music_note, '/liked'),
    _DrawerEntry('Playlists', Icons.list, '/playlists'),
    _DrawerEntry('Add playlist', Icons.add, '/playlists/create'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Drawer(
      backgroundColor: SbColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            _brandHeader(),
            const Divider(height: 1, color: Colors.white12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _section(context, 'Menu', _menu),
                  _section(context, 'Library', _library),
                  _section(context, 'Playlists', _playlists),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white12),
            _accountFooter(context, state),
          ],
        ),
      ),
    );
  }

  /// BrandMark, like the website header: the main logo + SoundBlast in
  /// the brand pink.
  Widget _brandHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              'assets/images/soundblast-logo.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'SoundBlast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: SbColors.accent,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<_DrawerEntry> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: SbColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items.map((item) => _tile(context, item)),
      ],
    );
  }

  Widget _tile(BuildContext context, _DrawerEntry item) {
    final isActive = item.tab != null && item.tab == currentTab;
    final isSpecial = item.route == '/playlists/create';
    return ListTile(
      leading: Icon(
        item.icon,
        size: 20,
        color: isSpecial
            ? SbColors.accent
            : isActive
                ? SbColors.accent
                : Colors.white70,
      ),
      title: Text(
        item.label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isSpecial
              ? SbColors.accent
              : isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.85),
        ),
      ),
      selected: isActive,
      selectedTileColor: SbColors.accent.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: () => _go(context, item),
    );
  }

  void _go(BuildContext context, _DrawerEntry item) {
    final navigator = Navigator.of(context);
    navigator.pop(); // Close the drawer first.
    if (item.tab != null) {
      onSelectTab(item.tab!);
    } else {
      navigator.pushNamed(item.route);
    }
  }

  Widget _accountFooter(BuildContext context, AppState state) {
    final user = state.user;
    if (user == null) {
      return ListTile(
        leading: const Icon(Icons.login, size: 20, color: Colors.white70),
        title: const Text('Log in'),
        onTap: () {
          final navigator = Navigator.of(context);
          navigator.pop();
          navigator.pushNamed('/login');
        },
      );
    }
    return ListTile(
      leading: const CircleAvatar(
        radius: 16,
        child: Icon(Icons.person, size: 18),
      ),
      title: Text(
        user.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.logout, size: 20, color: Colors.redAccent),
        tooltip: 'Log out',
        onPressed: () async {
          final navigator = Navigator.of(context);
          navigator.pop();
          await state.logout();
        },
      ),
      onTap: () {
        final navigator = Navigator.of(context);
        navigator.pop();
        navigator.pushNamed('/profile');
      },
    );
  }
}
