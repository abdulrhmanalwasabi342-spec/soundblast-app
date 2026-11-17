import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../api/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

/// Admin (website /admin) — admin-only. Exposes EVERY procedure of the
/// server admin router (server/routers.ts `songs.admin`), grouped the way
/// the task requires:
///
///  Users — view/create/edit/suspend/activate/delete, reset password,
///    grant/revoke admin (owner-only: only the ADMIN_EMAIL owner account
///    can grant admin; the owner can never be demoted/suspended/deleted).
///  Content — all songs (edit/hide/publish/delete), albums/releases,
///    playlists, comments moderation incl. bulk delete, artist posts.
///  Artists — approve/activate artist accounts, verified badges,
///    manage profiles/stage names, suspend offending artists.
///  Home & platform — hero action order, feedback inbox, contact messages.
///  Analytics — overview, play history, visitors, library integrity,
///    rollup play events.
///  System & safety — library cleanup, reconcile sizes, audit log,
///    push notification management, bulk delete, full platform wipe
///    (behind a typed confirmation).
///
/// NEW capabilities labelled as such in the UI (from SoundCloud / Spotify
/// for Artists / YouTube Studio / Anghami + judgement) are backed by the
/// closest existing procedure where one exists; anything with no server
/// procedure is listed in README.md as a named gap — never a fake button.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  Map<String, dynamic>? _overview;
  List<dynamic> _users = [];
  List<dynamic> _comments = [];
  List<dynamic> _feedback = [];
  List<dynamic> _artists = [];
  List<dynamic> _activationCases = [];
  List<dynamic> _songs = [];
  List<dynamic> _playlists = [];
  List<dynamic> _releases = [];
  List<dynamic> _artistPosts = [];
  List<dynamic> _audit = [];
  List<dynamic> _visitors = [];
  List<dynamic> _notifications = [];
  List<dynamic> _oauthUsers = [];
  Map<String, dynamic>? _integrity;
  bool _loading = true;
  bool _loadedTab = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 7, vsync: this);
    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      _loadTab(_tab.index);
    });
    _load();
  }

  SoundBlastApi get _api => context.read<AppState>().api;

  Future<void> _load() async {
    final state = context.read<AppState>();
    if (state.user == null || !state.user!.isAdmin) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<dynamic> results = await Future.wait([
        _api.adminOverview(),
        _api.adminUsers(),
        _api.adminComments(limit: 100),
        _api.adminFeedback(limit: 100),
      ]);
      if (!mounted) return;
      setState(() {
        _overview = results[0] as Map<String, dynamic>;
        _users = results[1] as List<dynamic>;
        _comments = results[2] as List<dynamic>;
        _feedback = results[3] as List<dynamic>;
        _loading = false;
      });
      await _loadTab(0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadTab(int index) async {
    if (_loadedTab && index != 5) return;
    try {
      switch (index) {
        case 2: // Content
          final List<dynamic> results = await Future.wait([
            _api.allSongs(),
            _api.adminPlaylists(),
            _api.adminReleases(limit: 100),
            _api.adminArtistPosts(limit: 100),
          ]);
          if (!mounted) return;
          setState(() {
            _songs = (results[0] as List<Song>)
                .map((s) => s.toJson())
                .toList();
            _playlists = results[1] as List<dynamic>;
            _releases = results[2] as List<dynamic>;
            _artistPosts = results[3] as List<dynamic>;
          });
        case 3: // Artists
          final List<dynamic> results = await Future.wait([
            _api.adminArtists(),
            _api.adminArtistActivationCases(limit: 100),
          ]);
          if (!mounted) return;
          setState(() {
            _artists = results[0] as List<dynamic>;
            _activationCases = results[1] as List<dynamic>;
          });
        case 5: // Analytics
          final List<dynamic> results = await Future.wait([
            _api.adminLibraryIntegrity(),
            _api.adminVisitorHistory(limit: 100),
            _api.adminNotifications(limit: 100),
          ]);
          if (!mounted) return;
          setState(() {
            _integrity = results[0] as Map<String, dynamic>;
            _visitors = results[1] as List<dynamic>;
            _notifications = results[2] as List<dynamic>;
          });
        case 6: // System & safety
          final List<dynamic> results = await Future.wait([
            _api.adminAuditEvents(limit: 100),
            _api.adminOAuthUsers(),
          ]);
          if (!mounted) return;
          setState(() {
            _audit = results[0] as List<dynamic>;
            _oauthUsers = results[1] as List<dynamic>;
          });
      }
      _loadedTab = true;
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        bottom: user?.isAdmin == true
            ? TabBar(
                controller: _tab,
                indicatorColor: SbColors.accent,
                labelColor: SbColors.text,
                unselectedLabelColor: SbColors.muted,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Users'),
                  Tab(text: 'Content'),
                  Tab(text: 'Artists'),
                  Tab(text: 'Home & platform'),
                  Tab(text: 'Analytics'),
                  Tab(text: 'System & safety'),
                ],
              )
            : null,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : user == null || !user.isAdmin
              ? const EmptyState(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admins only',
                  message:
                      'This area is restricted to SoundBlast administrators.',
                )
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : TabBarView(
                      controller: _tab,
                      children: [
                        _overviewTab(context),
                        _usersTab(context),
                        _contentTab(context),
                        _artistsTab(context),
                        _homeTab(context),
                        _analyticsTab(context),
                        _systemTab(context),
                      ],
                    ),
    );
  }

  Map<String, dynamic> _m(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  int _id(Map<String, dynamic> m) =>
      int.tryParse((m['id'] ?? m['localUserId'] ?? 0).toString()) ?? 0;

  Future<void> _run(Future<void> Function() fn) async {
    try {
      await fn();
      await _load();
      await _loadTab(_tab.index);
    } catch (e) {
      if (mounted) showSnack(context, e.toString());
    }
  }

  /// Typed confirmation for destructive admin actions (the server itself
  /// requires the confirmation literal for bulk operations).
  Future<bool> _typedConfirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmWord,
  }) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SbColors.surface,
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 12),
            Text(
              'Type "$confirmWord" to confirm.',
              style: const TextStyle(
                  color: SbColors.danger, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(controller: controller),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: SbColors.danger),
            onPressed: () => Navigator.of(ctx)
                .pop(controller.text.trim() == confirmWord),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  // ---- Overview -------------------------------------------------------------
  Widget _overviewTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_overview != null)
            ..._overview!.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text('${e.value}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                )),
          const SizedBox(height: 8),
          const Text('Owner',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const Text(
            'The owner account (ADMIN_EMAIL) can never be demoted, suspended or deleted by another admin, and only the owner can grant admin to others.',
            style: TextStyle(color: SbColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ---- Users ------------------------------------------------------------------
  Widget _usersTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showCreateUser(context),
                icon: const Icon(Icons.person_add),
                label: const Text('Create user'),
              ),
            ),
          ),
          if (_users.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No users yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._users.map((u) {
              final m = _m(u);
              final id = _id(m);
              final isAdmin = m['isAdmin'] == true || m['isAdmin'] == 1;
              final suspended = '${m['status'] ?? 'active'}' == 'suspended';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: SbColors.surface2,
                  child: Icon(
                      m['role'] == 'artist' ? Icons.mic : Icons.person,
                      color: SbColors.muted),
                ),
                title: Text(
                    '${m['name'] ?? m['stageName'] ?? 'User'}${isAdmin ? ' · admin' : ''}'),
                subtitle: Text(
                    '${m['email'] ?? ''} • ${m['role'] ?? 'user'} • ${m['status'] ?? 'active'}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'grant_admin' || v == 'revoke_admin') {
                      // Owner-only: the server refuses non-owner grants.
                      await _run(() => _api.adminSetUserAdmin(
                          id, v == 'grant_admin'));
                    } else if (v == 'suspend' || v == 'activate') {
                      await _run(() => _api.adminSetUserStatus(
                          id, v == 'suspend' ? 'suspended' : 'active'));
                    } else if (v == 'reset_password') {
                      _showResetPassword(context, id,
                          '${m['name'] ?? 'user'}');
                    } else if (v == 'edit') {
                      _showEditUser(context, id, m);
                    } else if (v == 'delete') {
                      final ok = await confirmDialog(context,
                          title: 'Delete user',
                          message:
                              'Delete this account permanently? The owner account can never be deleted.');
                      if (ok) {
                        await _run(
                            () => _api.adminDeleteLocalUser(id));
                      }
                    } else if (v == 'notify') {
                      await _run(() => _api.adminSendNotification(
                          id, 'A message from SoundBlast'));
                      if (mounted) {
                        showSnack(context, 'Notification sent.');
                      }
                    } else if (v == 'clear_favs') {
                      await _run(
                          () => _api.adminClearFavorites(id));
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: isAdmin ? 'revoke_admin' : 'grant_admin',
                        child: Text(isAdmin
                            ? 'Revoke admin (owner only)'
                            : 'Grant admin (owner only)')),
                    PopupMenuItem(
                        value: suspended ? 'activate' : 'suspend',
                        child: Text(
                            suspended ? 'Activate account' : 'Suspend account')),
                    const PopupMenuItem(
                        value: 'reset_password',
                        child: Text('Reset password')),
                    const PopupMenuItem(
                        value: 'edit', child: Text('Edit profile')),
                    const PopupMenuItem(
                        value: 'notify', child: Text('Send notification')),
                    const PopupMenuItem(
                        value: 'clear_favs',
                        child: Text('Clear favorites [NEW]')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('Delete account')),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _showCreateUser(BuildContext context) async {
    final name = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    final stage = TextEditingController();
    String role = 'user';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: SbColors.surface,
          title: const Text('Create user'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: name,
                    decoration:
                        const InputDecoration(labelText: 'Name')),
                TextField(
                    controller: email,
                    decoration:
                        const InputDecoration(labelText: 'Email')),
                TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password (min 8)')),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: role,
                  items: const [
                    DropdownMenuItem(
                        value: 'user', child: Text('Listener')),
                    DropdownMenuItem(
                        value: 'artist', child: Text('Artist')),
                  ],
                  onChanged: (v) => setState(() => role = v ?? 'user'),
                ),
                TextField(
                    controller: stage,
                    decoration: const InputDecoration(
                        labelText: 'Stage name (artists)')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Create')),
          ],
        ),
      ),
    );
    if (ok == true) {
      await _run(() => _api.adminCreateLocalUser(
            name: name.text.trim(),
            email: email.text.trim(),
            password: password.text,
            role: role,
            stageName: stage.text.trim().isEmpty
                ? null
                : stage.text.trim(),
          ));
    }
  }

  Future<void> _showResetPassword(
      BuildContext context, int id, String name) async {
    final password = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SbColors.surface,
        title: Text('Reset password — $name'),
        content: TextField(
          controller: password,
          obscureText: true,
          decoration:
              const InputDecoration(labelText: 'New password (min 8)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Reset')),
        ],
      ),
    );
    if (ok == true && password.text.length >= 8) {
      await _run(() => _api.adminResetPassword(id, password.text));
    }
  }

  Future<void> _showEditUser(
      BuildContext context, int id, Map<String, dynamic> m) async {
    final name = TextEditingController(text: '${m['name'] ?? ''}');
    final stage = TextEditingController(text: '${m['stageName'] ?? ''}');
    final bio = TextEditingController(text: '${m['bio'] ?? ''}');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SbColors.surface,
        title: const Text('Edit user'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: stage,
                  decoration:
                      const InputDecoration(labelText: 'Stage name')),
              TextField(
                  controller: bio,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Save')),
        ],
      ),
    );
    if (ok == true) {
      await _run(() => _api.adminUpdateLocalUser(id, {
            'name': name.text.trim(),
            'stageName': stage.text.trim(),
            'bio': bio.text.trim(),
          }));
    }
  }

  // ---- Content ----------------------------------------------------------------
  Widget _contentTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadTab(2),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Songs',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_songs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No songs yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._songs.take(50).map((s) {
              final m = _m(s);
              final id = _id(m);
              final isPublic = '${m['isPublic'] ?? 'true'}' == 'true';
              return ListTile(
                leading: CoverImage(url: m['imageUrl']?.toString(), size: 44),
                title: Text('${m['title'] ?? ''}'),
                subtitle: Text(
                    '${m['artist'] ?? ''} • ${m['genre'] ?? ''} • ${isPublic ? 'public' : 'hidden'}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'hide' || v == 'publish') {
                      await _run(() => _api.adminSetSongPublic(
                          id, v == 'publish'));
                    } else if (v == 'delete') {
                      final ok = await confirmDialog(context,
                          title: 'Delete song',
                          message: 'Delete "${m['title']}" permanently?');
                      if (ok) {
                        await _run(() => _api.adminDeleteSong(id));
                      }
                    } else if (v == 'delete_comments') {
                      final ok = await confirmDialog(context,
                          title: 'Delete comments',
                          message:
                              'Delete all comments on "${m['title']}"?');
                      if (ok) {
                        await _run(
                            () => _api.adminDeleteCommentsBySong(id));
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: isPublic ? 'hide' : 'publish',
                        child:
                            Text(isPublic ? 'Hide (unpublish)' : 'Publish')),
                    const PopupMenuItem(
                        value: 'delete_comments',
                        child: Text('Delete all its comments')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('Delete song')),
                  ],
                ),
              );
            }),
          const SizedBox(height: 16),
          const Text('Releases (albums)',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_releases.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No releases yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._releases.map((r) {
              final m = _m(r);
              final id = _id(m);
              return ListTile(
                leading: const Icon(Icons.album),
                title: Text('${m['title'] ?? m['albumName'] ?? ''}'),
                subtitle: Text('${m['artist'] ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: SbColors.danger),
                  onPressed: () async {
                    final ok = await confirmDialog(context,
                        title: 'Delete release',
                        message: 'Delete this release permanently?');
                    if (ok) {
                      await _run(() => _api.adminDeleteRelease(id));
                    }
                  },
                ),
              );
            }),
          const SizedBox(height: 16),
          const Text('Playlists',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_playlists.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No playlists yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._playlists.map((p) {
              final m = _m(p);
              final id = _id(m);
              return ListTile(
                leading: const Icon(Icons.playlist_play),
                title: Text('${m['name'] ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: SbColors.danger),
                  onPressed: () async {
                    final ok = await confirmDialog(context,
                        title: 'Delete playlist',
                        message: 'Delete this playlist permanently?');
                    if (ok) {
                      await _run(
                          () => _api.adminDeletePlaylist(id));
                    }
                  },
                ),
              );
            }),
          const SizedBox(height: 16),
          const Text('Comments moderation',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No comments yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._comments.take(30).map((c) {
              final m = _m(c);
              final id = _id(m);
              return ListTile(
                title: Text('${m['text'] ?? ''}'),
                subtitle: Text('${m['userName'] ?? 'Listener'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: SbColors.danger),
                  onPressed: () async {
                    await _run(
                        () => _api.adminDeleteComment(id));
                  },
                ),
              );
            }),
          const SizedBox(height: 16),
          const Text('Artist posts',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_artistPosts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No artist posts yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._artistPosts.take(20).map((p) {
              final m = _m(p);
              final id = _id(m);
              return ListTile(
                title: Text('${m['body'] ?? ''}',
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('${m['stageName'] ?? ''}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'archive') {
                      await _run(
                          () => _api.adminArchiveArtistPost(id));
                    } else if (v == 'restore') {
                      await _run(
                          () => _api.adminRestoreArtistPost(id));
                    } else if (v == 'delete') {
                      await _run(
                          () => _api.adminDeleteArtistPost(id));
                    } else if (v == 'clear_engagement') {
                      await _run(() =>
                          _api.adminClearArtistPostEngagement(id));
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'archive', child: Text('Archive')),
                    PopupMenuItem(
                        value: 'restore', child: Text('Restore')),
                    PopupMenuItem(
                        value: 'clear_engagement',
                        child: Text('Clear engagement')),
                    PopupMenuItem(
                        value: 'delete', child: Text('Delete post')),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ---- Artists ---------------------------------------------------------------
  Widget _artistsTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadTab(3),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Artist activation cases',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const Text(
            'Artist accounts that have not completed activation.',
            style: TextStyle(color: SbColors.muted, fontSize: 13),
          ),
          if (_activationCases.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No pending activation cases.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._activationCases.map((c) {
              final m = _m(c);
              final id = _id(m);
              return ListTile(
                leading: const Icon(Icons.mic),
                title: Text('${m['stageName'] ?? m['name'] ?? ''}'),
                subtitle: Text('${m['email'] ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.verified,
                      color: SbColors.accent),
                  tooltip: 'Mark verified',
                  onPressed: () async {
                    await _run(
                        () => _api.adminSetVerified(id, true));
                  },
                ),
              );
            }),
          const SizedBox(height: 16),
          const Text('All artists',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_artists.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No artists yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._artists.map((a) {
              final m = _m(a);
              final id = _id(m);
              final verified = m['verified'] == true || m['verified'] == 1;
              return ListTile(
                leading: const Icon(Icons.mic),
                title: Text('${m['stageName'] ?? ''}'),
                subtitle: Text(verified ? 'Verified' : 'Not verified'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'verify' || v == 'unverify') {
                      await _run(() => _api.adminSetVerified(
                          id, v == 'verify'));
                    } else if (v == 'suspend') {
                      await _run(
                          () => _api.adminSetUserStatus(id, 'suspended'));
                    } else if (v == 'activate') {
                      await _run(() =>
                          _api.adminSetUserStatus(id, 'active'));
                    } else if (v == 'songs') {
                      final songs = await _api.adminSongsByUser(id);
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: SbColors.surface,
                            title: Text(
                                'Songs by ${m['stageName'] ?? ''}'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView(
                                shrinkWrap: true,
                                children: songs.isEmpty
                                    ? [
                                        const Text('No songs.',
                                            style: TextStyle(
                                                color: SbColors.muted))
                                      ]
                                    : songs
                                        .map((s) => ListTile(
                                              title: Text(s.title),
                                              subtitle:
                                                  Text(s.genre),
                                            ))
                                        .toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(),
                                  child: const Text('Close')),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: verified ? 'unverify' : 'verify',
                        child: Text(verified
                            ? 'Remove verified badge'
                            : 'Mark verified')),
                    const PopupMenuItem(
                        value: 'suspend',
                        child: Text('Suspend artist [NEW]')),
                    const PopupMenuItem(
                        value: 'activate',
                        child: Text('Activate artist')),
                    const PopupMenuItem(
                        value: 'songs', child: Text('View songs')),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ---- Home & platform ---------------------------------------------------------
  Widget _homeTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Home hero action order',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const Text(
            'Controls which action the Home hero button offers first.',
            style: TextStyle(color: SbColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(
                3,
                (i) => ChoiceChip(
                      label: Text('Preset $i'),
                      selected: false,
                      onSelected: (_) async {
                        await _run(() =>
                            _api.adminSetHeroActionOrder(i));
                        if (mounted) {
                          showSnack(context,
                              'Hero action order set to preset $i.');
                        }
                      },
                    )),
          ),
          const SizedBox(height: 24),
          const Text('Feedback inbox',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_feedback.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No feedback yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._feedback.map((f) {
              final m = _m(f);
              final id = _id(m);
              final status = '${m['status'] ?? 'new'}';
              return ListTile(
                title: Text('${m['message'] ?? ''}'),
                subtitle: Text(
                    '${m['name'] ?? ''} • ${m['category'] ?? 'feedback'} • $status'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'reviewed' || v == 'closed') {
                      await _run(() =>
                          _api.adminSetFeedbackStatus(id, v));
                    } else if (v == 'delete') {
                      await _run(
                          () => _api.adminDeleteFeedback(id));
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'reviewed', child: Text('Mark reviewed')),
                    PopupMenuItem(value: 'closed', child: Text('Close')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            }),
          const SizedBox(height: 24),
          const GatedFeature(
            label: 'Contact messages inbox [NEW]',
            reason:
                'The website has no contact-messages inbox endpoint yet — contact currently goes through Feedback. Listed as a named gap in README.md.',
            icon: Icons.mail_outline,
          ),
        ],
      ),
    );
  }

  // ---- Analytics ----------------------------------------------------------------
  Widget _analyticsTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadTab(5),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Library integrity',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_integrity != null)
            ..._integrity!.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text('${e.value}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                )),
          const SizedBox(height: 16),
          const Text('Play history (visitors)',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_visitors.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No visitor history yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._visitors.take(20).map((v) {
              final m = _m(v);
              return ListTile(
                title: Text('${m['path'] ?? m['event'] ?? ''}'),
                subtitle: Text('${m['createdAt'] ?? ''}'),
              );
            }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await _run(
                        () => _api.adminResetVisitorCounter());
                    if (mounted) {
                      showSnack(context, 'Visitor counter reset.');
                    }
                  },
                  child: const Text('Reset visitor counter'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final ok = await confirmDialog(context,
                        title: 'Clear visitor history',
                        message:
                            'Delete all recorded visitor history?');
                    if (ok) {
                      await _run(
                          () => _api.adminClearVisitorHistory());
                    }
                  },
                  child: const Text('Clear history'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Push notifications sent',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_notifications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No notifications recorded yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._notifications.take(20).map((n) {
              final m = _m(n);
              final id = _id(m);
              return ListTile(
                title: Text('${m['title'] ?? ''}'),
                subtitle: Text('${m['createdAt'] ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: SbColors.danger),
                  onPressed: () async {
                    await _run(
                        () => _api.adminDeleteNotification(id));
                  },
                ),
              );
            }),
        ],
      ),
    );
  }

  // ---- System & safety -----------------------------------------------------------
  Widget _systemTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadTab(6),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Library maintenance',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final res =
                      await _api.adminCleanupLibraryIntegrity();
                  if (mounted) {
                    showSnack(context, 'Library cleanup done: $res');
                  }
                  await _loadTab(5);
                },
                child: const Text('Clean library integrity'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final res =
                      await _api.adminReconcileSongSizes(limit: 5);
                  if (mounted) {
                    showSnack(context, 'Reconciled sizes: $res');
                  }
                },
                child: const Text('Reconcile song sizes'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final res = await _api.adminRollupPlayEvents();
                  if (mounted) {
                    showSnack(context, 'Play events rolled up: $res');
                  }
                },
                child: const Text('Roll up play events (45d)'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final res =
                      await _api.adminRecompressLegacyBatch(limit: 3);
                  if (mounted) {
                    showSnack(context, 'Recompressed batch: $res');
                  }
                },
                child: const Text('Recompress legacy audio [NEW]'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('OAuth users',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_oauthUsers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No OAuth users yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._oauthUsers.map((u) {
              final m = _m(u);
              final openId = '${m['openId'] ?? ''}';
              return ListTile(
                title: Text('${m['name'] ?? m['email'] ?? openId}'),
                subtitle: Text('role: ${m['role'] ?? 'user'}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'make_admin' || v == 'make_user') {
                      await _run(() => _api.adminSetOAuthUserRole(
                          openId,
                          v == 'make_admin' ? 'admin' : 'user'));
                    } else if (v == 'delete') {
                      await _run(
                          () => _api.adminDeleteOAuthUser(openId));
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'make_admin',
                        child: Text('Make admin (owner only)')),
                    PopupMenuItem(
                        value: 'make_user', child: Text('Make user')),
                    PopupMenuItem(
                        value: 'delete', child: Text('Delete OAuth user')),
                  ],
                ),
              );
            }),
          const SizedBox(height: 24),
          const Text('Audit log',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (_audit.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No audit events yet.',
                  style: TextStyle(color: SbColors.muted)),
            )
          else
            ..._audit.take(30).map((a) {
              final m = _m(a);
              return ListTile(
                title: Text('${m['action'] ?? ''}'),
                subtitle: Text(
                    '${m['targetType'] ?? ''} • ${m['createdAt'] ?? ''}'),
              );
            }),
          const SizedBox(height: 24),
          const Text('Danger zone',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: SbColors.danger)),
          const SizedBox(height: 8),
          const Text(
            'Bulk actions delete platform data permanently. Each one needs its confirmation phrase typed in.',
            style: TextStyle(color: SbColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _dangerButton(context, 'Delete ALL comments',
                  'DELETE_ALL_COMMENTS', () async {
                final res = await _api.adminBulkDeleteComments();
                if (mounted) showSnack(context, 'Done: $res');
              }),
              _dangerButton(context, 'Delete ALL playlists',
                  'DELETE_ALL_PLAYLISTS', () async {
                final res = await _api.adminBulkDeletePlaylists();
                if (mounted) showSnack(context, 'Done: $res');
              }),
              _dangerButton(context, 'Delete ALL accounts',
                  'DELETE_ALL_ACCOUNTS', () async {
                final res = await _api.adminBulkDeleteAccounts();
                if (mounted) showSnack(context, 'Done: $res');
              }),
              _dangerButton(context, 'WIPE platform content',
                  'WIPE_PLATFORM_CONTENT', () async {
                final res = await _api.adminBulkWipePlatformContent();
                if (mounted) showSnack(context, 'Done: $res');
              }),
            ],
          ),
          const SizedBox(height: 24),
          const GatedFeature(
            label: 'Scheduled maintenance mode [NEW]',
            reason:
                'The website has no maintenance-mode endpoint — the app lists it as a named gap (see README.md). Use Render to stop the service if maintenance is needed.',
            icon: Icons.build_outlined,
          ),
        ],
      ),
    );
  }

  Widget _dangerButton(BuildContext context, String label, String word,
      Future<void> Function() fn) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: SbColors.danger),
      onPressed: () async {
        final ok = await _typedConfirm(context,
            title: label,
            message: 'This permanently deletes data across SoundBlast.',
            confirmWord: word);
        if (ok) {
          try {
            await fn();
            await _load();
          } catch (e) {
            if (mounted) showSnack(context, e.toString());
          }
        }
      },
      child: Text(label),
    );
  }
}
