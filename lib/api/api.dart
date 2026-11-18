import 'trpc_client.dart';
import 'models.dart';

/// One thin wrapper per tRPC procedure used by the app, mirroring
/// server/routers.ts. Procedure names are the exact `router.procedure`
/// strings; inputs match the zod schemas in that file.
class SoundBlastApi {
  final TrpcClient client;
  SoundBlastApi(this.client);

  // ---- auth -------------------------------------------------------------
  Future<User?> me() async {
    final json = await client.query('localAuth.me');
    if (json == null) return null;
    return User.fromJson(json);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final json = await client.mutation('localAuth.login', {
      'email': email,
      'password': password,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  /// Exchange a one-time OAuth app code (soundblast://oauth?code=…) for a
  /// session. Used by the Google system-browser flow (and the GitHub app
  /// flow before it). Returns false when the code is invalid or expired.
  Future<bool> exchangeAppCode(String code) async {
    try {
      final json =
          await client.mutation('localAuth.exchangeAppCode', {'code': code});
      return (json as Map)['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String? stageName,
    String? imageUrl,
  }) async {
    final json = await client.mutation('localAuth.signup', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      if (stageName != null && stageName.isNotEmpty) 'stageName': stageName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'policyAccepted': true,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<void> logout() async {
    try {
      await client.mutation('auth.logout');
    } finally {
      await client.clearSession();
    }
  }

  Future<String?> signupAvatarUpload({
    required String base64Data,
    required String fileName,
    required String fileType,
  }) async {
    final json = await client.mutation('localAuth.signupAvatarUpload', {
      'data': base64Data,
      'fileName': fileName,
      'fileType': fileType,
    });
    final m = Map<String, dynamic>.from(json as Map);
    return m['url']?.toString();
  }

  // ---- songs ------------------------------------------------------------
  Future<List<Song>> allSongs() async {
    final json = await client.query('songs.list');
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<HomeSummary> homeSummary() async {
    final json = await client.query('songs.homeSummary');
    return HomeSummary.fromJson(json);
  }

  Future<List<Song>> trending() async {
    final json = await client.query('songs.trending');
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<List<String>> genres() async {
    final json = await client.query('songs.genres');
    if (json is List) return json.map((e) => e.toString()).toList();
    return [];
  }

  Future<List<Song>> songsByGenre(String genre) async {
    final json = await client.query('songs.byGenre', {'genre': genre});
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<List<Song>> songsByArtist(String artist) async {
    final json = await client.query('songs.byArtist', {'artist': artist});
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<List<Song>> songsByUser(String userId) async {
    final json = await client.query('songs.byUser', {'userId': userId});
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<Song?> songDetail(int id) async {
    final json = await client.query('songs.detail', {'id': id});
    if (json == null) return null;
    return Song.fromJson(json);
  }

  Future<SearchResult> search(String query) async {
    final json = await client.query('songs.search', {'query': query});
    return SearchResult.fromJson(json);
  }

  Future<List<ArtistProfile>> allArtists() async {
    final json = await client.query('songs.allArtists');
    if (json is List) return json.map(ArtistProfile.fromJson).toList();
    return [];
  }

  Future<List<Album>> albums() async {
    final json = await client.query('songs.albums');
    if (json is List) return json.map(Album.fromJson).toList();
    return [];
  }

  Future<Map<String, dynamic>> artistProfile(int localUserId) async {
    final json =
        await client.query('songs.artistProfile', {'localUserId': localUserId});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<List<ArtistPost>> artistPosts(int artistLocalUserId) async {
    final json = await client
        .query('songs.artistPosts', {'artistLocalUserId': artistLocalUserId});
    if (json is List) return json.map(ArtistPost.fromJson).toList();
    return [];
  }

  Future<List<ArtistPost>> publicPostsFeed() async {
    final json = await client.query('songs.publicPostsFeed');
    if (json is List) return json.map(ArtistPost.fromJson).toList();
    return [];
  }

  Future<List<ArtistPost>> myArtistPosts() async {
    final json = await client.query('songs.studioPosts', {});
    if (json is List) return json.map(ArtistPost.fromJson).toList();
    return [];
  }

  Future<void> recordPlay(int songId, {String visitorId = ''}) async {
    await client.mutation('songs.recordPlay', {
      'songId': songId,
      if (visitorId.isNotEmpty) 'visitorId': visitorId,
    });
  }

  Future<void> deleteMySong(int songId) async {
    await client.mutation('songs.delete', {'songId': songId});
  }

  Future<Map<String, dynamic>> uploadFile({
    required String base64Data,
    required String fileName,
    required String fileType,
  }) async {
    final json = await client.mutation('songs.uploadFile', {
      'data': base64Data,
      'fileName': fileName,
      'fileType': fileType,
      'category': 'songs',
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> uploadSong({
    required String title,
    required String audioUrl,
    required String audioKey,
    String? imageUrl,
    String? imageKey,
    String genre = 'Pop',
    int duration = 0,
    int? sizeBytes,
    String? albumName,
    int? albumId,
  }) async {
    final json = await client.mutation('songs.upload', {
      'title': title,
      'audioUrl': audioUrl,
      'audioKey': audioKey,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (imageKey != null) 'imageKey': imageKey,
      'genre': genre,
      'duration': duration,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (albumName != null) 'albumName': albumName,
      if (albumId != null) 'albumId': albumId,
      'rightsConfirmed': true,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<List<Album>> myArtistAlbums() async {
    final json = await client.query('songs.artistAlbums');
    if (json is List) return json.map(Album.fromJson).toList();
    return [];
  }

  Future<int> createArtistAlbum({
    required String title,
    String? description,
    String? imageUrl,
  }) async {
    final json = await client.mutation('songs.createArtistAlbum', {
      'title': title,
      'releaseType': 'album',
      if (description != null) 'description': description,
      if (imageUrl != null) 'coverUrl': imageUrl,
    });
    return int.tryParse(
            (Map<String, dynamic>.from(json as Map)['id'] ?? 0).toString()) ??
        0;
  }

  // ---- likes / favorites / positions ------------------------------------
  Future<Map<String, dynamic>> toggleLike(int songId, bool like) async {
    final json =
        await client.mutation('likes.toggle', {'songId': songId, 'like': like});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<List<Song>> myLikedSongs() async {
    final json = await client.query('likes.myLikedSongs');
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<void> savePosition(
      int songId, int positionMs, int durationMs) async {
    await client.mutation('likes.savePosition', {
      'songId': songId,
      'positionMs': positionMs,
      'durationMs': durationMs,
    });
  }

  Future<List<Song>> myFavorites() async {
    final json = await client.query('favorites.list');
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<void> addFavorite(int songId) async {
    await client.mutation('favorites.add', {'songId': songId});
  }

  Future<void> removeFavorite(int songId) async {
    await client.mutation('favorites.remove', {'songId': songId});
  }

  Future<Set<int>> myFavoriteIds() async {
    final json = await client.query('favorites.myIds');
    if (json is List) {
      return json.map((e) => int.tryParse(e.toString()) ?? 0).toSet();
    }
    return <int>{};
  }

  // ---- comments ----------------------------------------------------------
  Future<List<SongComment>> commentsForSong(int songId) async {
    final json = await client.query('comments.list', {'songId': songId});
    if (json is List) return json.map(SongComment.fromJson).toList();
    return [];
  }

  Future<void> addComment(int songId, String text) async {
    await client.mutation('comments.add', {'songId': songId, 'text': text});
  }

  Future<Map<String, dynamic>> likeComment(int commentId) async {
    final json =
        await client.mutation('comments.like', {'commentId': commentId});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<void> deleteComment(int commentId) async {
    await client.mutation('comments.delete', {'commentId': commentId});
  }

  // ---- playlists ----------------------------------------------------------
  Future<List<Playlist>> myPlaylists() async {
    final json = await client.query('playlists.list');
    if (json is List) return json.map(Playlist.fromJson).toList();
    return [];
  }

  Future<Map<String, dynamic>> createPlaylist({
    required String name,
    String? description,
    List<int> songIds = const [],
    bool saveAsDraft = false,
  }) async {
    final json = await client.mutation('playlists.create', {
      'name': name,
      if (description != null && description.isNotEmpty)
        'description': description,
      'songIds': songIds,
      'saveAsDraft': saveAsDraft,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<({Playlist? playlist, List<Song> songs})> playlistDetail(
      int id) async {
    final json = await client.query('playlists.detail', {'id': id});
    final m = Map<String, dynamic>.from(json as Map);
    final pl =
        m['playlist'] == null ? null : Playlist.fromJson(m['playlist']);
    final songs = m['songs'] is List
        ? (m['songs'] as List).map(Song.fromJson).toList()
        : <Song>[];
    return (playlist: pl, songs: songs);
  }

  Future<void> updatePlaylist(int id,
      {String? name, String? description}) async {
    await client.mutation('playlists.update', {
      'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  Future<void> deletePlaylist(int id) async {
    await client.mutation('playlists.delete', {'id': id});
  }

  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    await client.mutation(
        'playlists.addSong', {'playlistId': playlistId, 'songId': songId});
  }

  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    await client.mutation(
        'playlists.removeSong', {'playlistId': playlistId, 'songId': songId});
  }

  // ---- notifications / feedback ------------------------------------------
  Future<List<AppNotification>> myNotifications() async {
    final json = await client.query('notifications.list');
    if (json is List) return json.map(AppNotification.fromJson).toList();
    return [];
  }

  Future<int> unreadNotificationCount() async {
    final json = await client.query('notifications.unreadCount');
    if (json is Map) {
      final m = Map<String, dynamic>.from(json);
      return int.tryParse((m['count'] ?? m['unreadCount'] ?? 0).toString()) ??
          0;
    }
    return int.tryParse(json.toString()) ?? 0;
  }

  Future<void> markNotificationRead(int id) async {
    await client.mutation('notifications.markRead', {'id': id});
  }

  Future<void> markAllNotificationsRead() async {
    await client.mutation('notifications.markAllRead');
  }

  Future<int> submitFeedback(String message, {String category = 'feedback'}) async {
    final json = await client.mutation('feedback.submit', {
      'category': category,
      'message': message,
    });
    final m = Map<String, dynamic>.from(json as Map);
    return int.tryParse((m['id'] ?? 0).toString()) ?? 0;
  }

  // ---- artist studio ------------------------------------------------------
  Future<List<Song>> studioSongs() async {
    final json = await client.query('songs.studioSongs', {});
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<Map<String, dynamic>> studioStats() async {
    final json = await client.query('songs.studioStats', {});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> artistPerformance(int days) async {
    final json =
        await client.query('songs.studioPerformance', {'days': days});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> artistActivationStatus() async {
    final json = await client.query('songs.artistActivation', {});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> followers(int artistLocalUserId) async {
    final json =
        await client.query('songs.followers', {'artistLocalUserId': artistLocalUserId});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> createArtistPost({
    required String body,
    String kind = 'post',
    String visibility = 'public',
  }) async {
    final json = await client.mutation('songs.createStudioPost', {
      'body': body,
      'kind': kind,
      'visibility': visibility,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> updateArtistProfile({
    required String stageName,
    String? bio,
    String? imageUrl,
    String? slug,
  }) async {
    final json = await client.mutation('songs.updateProfile', {
      'stageName': stageName,
      if (bio != null) 'bio': bio,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (slug != null) 'slug': slug,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<void> deleteArtistPost(int postId) async {
    await client.mutation('songs.deleteArtistPost', {'postId': postId});
  }

  Future<void> followArtist(int artistLocalUserId) async {
    await client.mutation(
        'songs.follow', {'artistLocalUserId': artistLocalUserId});
  }

  Future<void> unfollowArtist(int artistLocalUserId) async {
    await client.mutation(
        'songs.unfollow', {'artistLocalUserId': artistLocalUserId});
  }

  // ---- stats / visitors ----------------------------------------------------
  Future<Map<String, dynamic>> platformStats({int days = 7}) async {
    final json = await client.query('stats.platform', {'days': days});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<int> visitorCount() async {
    final json = await client.query('visitors.count');
    if (json is Map) {
      return int.tryParse(
              (Map<String, dynamic>.from(json)['count'] ?? 0).toString()) ??
          0;
    }
    return int.tryParse(json.toString()) ?? 0;
  }

  // ---- admin ---------------------------------------------------------------
  Future<Map<String, dynamic>> adminOverview() async {
    final json = await client.query('songs.admin.overview');
    return Map<String, dynamic>.from(json as Map);
  }

  Future<List<dynamic>> adminUsers() async {
    final json = await client.query('songs.admin.users');
    if (json is List) return json;
    return [];
  }

  Future<List<dynamic>> adminComments({int limit = 100}) async {
    final json =
        await client.query('songs.admin.comments', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<List<dynamic>> adminFeedback({int limit = 100}) async {
    final json =
        await client.query('songs.admin.feedback', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<void> adminDeleteSong(int songId) async {
    await client.mutation('songs.admin.deleteSong', {'songId': songId});
  }

  Future<void> adminSetVerified(int localUserId, bool verified) async {
    await client.mutation('songs.admin.setVerified',
        {'localUserId': localUserId, 'verified': verified});
  }

  Future<void> adminSetFeedbackStatus(int feedbackId, String status) async {
    await client.mutation('songs.admin.setFeedbackStatus',
        {'feedbackId': feedbackId, 'status': status});
  }

  Future<void> adminDeleteFeedback(int feedbackId) async {
    await client.mutation(
        'songs.admin.deleteFeedback', {'feedbackId': feedbackId});
  }

  Future<void> adminDeleteComment(int commentId) async {
    await client.mutation(
        'songs.admin.deleteComment', {'commentId': commentId});
  }

  Future<void> adminDeletePlaylist(int playlistId) async {
    await client.mutation(
        'songs.admin.deletePlaylist', {'playlistId': playlistId});
  }

  Future<void> adminSendNotification(int localUserId, String title) async {
    await client.mutation('songs.admin.sendNotification',
        {'localUserId': localUserId, 'title': title});
  }

  Future<void> adminSetUserAdmin(int localUserId, bool isAdmin) async {
    await client.mutation('songs.admin.setUserAdmin',
        {'localUserId': localUserId, 'isAdmin': isAdmin});
  }

  Future<void> adminSetHeroActionOrder(int preset) async {
    await client.mutation(
        'songs.admin.setHeroActionOrder', {'preset': preset});
  }

  // ---- admin: full procedure surface (server/routers.ts admin router) ----
  Future<List<dynamic>> adminArtistActivationCases({int limit = 100}) async {
    final json = await client
        .query('songs.admin.artistActivationCases', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<Map<String, dynamic>> adminLibraryIntegrity() async {
    final json = await client.query('songs.admin.libraryIntegrity');
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminCleanupLibraryIntegrity() async {
    final json = await client.mutation(
        'songs.admin.cleanupLibraryIntegrity',
        {'confirmation': 'CLEAN_LIBRARY'});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminReconcileSongSizes(
      {int limit = 5}) async {
    final json = await client
        .mutation('songs.admin.reconcileSongSizes', {'limit': limit});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminRollupPlayEvents(
      {int retentionDays = 45}) async {
    final json = await client.mutation('songs.admin.rollupPlayEvents', {
      'confirmation': 'ROLLUP_EVENTS',
      'retentionDays': retentionDays,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminBulkDeleteComments() async {
    final json = await client.mutation('songs.admin.bulkDeleteComments',
        {'confirmation': 'DELETE_ALL_COMMENTS'});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminBulkDeletePlaylists() async {
    final json = await client.mutation('songs.admin.bulkDeletePlaylists',
        {'confirmation': 'DELETE_ALL_PLAYLISTS'});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminBulkDeleteAccounts() async {
    final json = await client.mutation('songs.admin.bulkDeleteAccounts',
        {'confirmation': 'DELETE_ALL_ACCOUNTS'});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<Map<String, dynamic>> adminBulkWipePlatformContent() async {
    final json = await client.mutation(
        'songs.admin.bulkWipePlatformContent',
        {'confirmation': 'WIPE_PLATFORM_CONTENT'});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<List<dynamic>> adminOAuthUsers() async {
    final json = await client.query('songs.admin.oauthUsers');
    if (json is List) return json;
    return [];
  }

  Future<void> adminSetOAuthUserRole(String openId, String role) async {
    await client.mutation(
        'songs.admin.setOAuthUserRole', {'openId': openId, 'role': role});
  }

  Future<void> adminDeleteOAuthUser(String openId) async {
    await client.mutation(
        'songs.admin.deleteOAuthUser', {'openId': openId});
  }

  Future<void> adminSetUserStatus(int localUserId, String status,
      {String? reason}) async {
    await client.mutation('songs.admin.setUserStatus', {
      'localUserId': localUserId,
      'status': status,
      if (reason != null) 'reason': reason,
    });
  }

  Future<void> adminUpdateLocalUser(
      int localUserId, Map<String, dynamic> patch) async {
    await client.mutation(
        'songs.admin.updateLocalUser', {'localUserId': localUserId, ...patch});
  }

  Future<Map<String, dynamic>> adminCreateLocalUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? stageName,
    bool isAdmin = false,
    String status = 'active',
  }) async {
    final json = await client.mutation('songs.admin.createLocalUser', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      if (stageName != null) 'stageName': stageName,
      'isAdmin': isAdmin,
      'status': status,
    });
    return Map<String, dynamic>.from(json as Map);
  }

  Future<void> adminResetPassword(int localUserId, String newPassword) async {
    await client.mutation('songs.admin.resetPassword',
        {'localUserId': localUserId, 'newPassword': newPassword});
  }

  Future<void> adminDeleteLocalUser(int localUserId) async {
    await client.mutation(
        'songs.admin.deleteLocalUser', {'localUserId': localUserId});
  }

  Future<void> adminUpdateSong(
      int songId, Map<String, dynamic> patch) async {
    await client.mutation(
        'songs.admin.updateSong', {'songId': songId, ...patch});
  }

  Future<void> adminSetSongPublic(int songId, bool isPublic) async {
    await client.mutation('songs.admin.setSongPublic',
        {'songId': songId, 'isPublic': isPublic ? 'true' : 'false'});
  }

  Future<Map<String, dynamic>> adminRecompressLegacyBatch(
      {int limit = 3}) async {
    final json = await client
        .mutation('songs.admin.recompressLegacyBatch', {'limit': limit});
    return Map<String, dynamic>.from(json as Map);
  }

  Future<List<Song>> adminSongsByUser(int localUserId) async {
    final json = await client
        .query('songs.admin.songsByUser', {'localUserId': localUserId});
    if (json is List) return json.map(Song.fromJson).toList();
    return [];
  }

  Future<List<dynamic>> adminArtists() async {
    final json = await client.query('songs.admin.artists');
    if (json is List) return json;
    return [];
  }

  Future<List<dynamic>> adminArtistPosts({int limit = 100}) async {
    final json =
        await client.query('songs.admin.artistPosts', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<void> adminCreateArtistPost({
    required int artistLocalUserId,
    required String body,
    String kind = 'post',
    String visibility = 'public',
  }) async {
    await client.mutation('songs.admin.createArtistPost', {
      'artistLocalUserId': artistLocalUserId,
      'body': body,
      'kind': kind,
      'visibility': visibility,
    });
  }

  Future<void> adminUpdateArtistPost(
      int postId, Map<String, dynamic> patch) async {
    await client.mutation(
        'songs.admin.updateArtistPost', {'postId': postId, ...patch});
  }

  Future<void> adminArchiveArtistPost(int postId) async {
    await client.mutation(
        'songs.admin.archiveArtistPost', {'postId': postId});
  }

  Future<void> adminRestoreArtistPost(int postId) async {
    await client.mutation(
        'songs.admin.restoreArtistPost', {'postId': postId});
  }

  Future<void> adminDeleteArtistPost(int postId) async {
    await client.mutation(
        'songs.admin.deleteArtistPost', {'postId': postId});
  }

  Future<List<dynamic>> adminMediaReferences() async {
    final json = await client.query('songs.admin.mediaReferences');
    if (json is List) return json;
    return [];
  }

  Future<void> adminDeleteMediaReference(String referenceId) async {
    await client.mutation('songs.admin.deleteMediaReference', {
      'referenceId': referenceId,
      'confirmation': 'REMOVE_MEDIA_REFERENCE',
    });
  }

  Future<List<dynamic>> adminArtistPostComments({int limit = 100}) async {
    final json = await client
        .query('songs.admin.artistPostComments', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<void> adminUpdateArtistPostComment(int commentId, String text) async {
    await client.mutation('songs.admin.updateArtistPostComment',
        {'commentId': commentId, 'text': text});
  }

  Future<void> adminDeleteArtistPostComment(int commentId) async {
    await client.mutation(
        'songs.admin.deleteArtistPostComment', {'commentId': commentId});
  }

  Future<void> adminClearArtistPostEngagement(int postId) async {
    await client.mutation('songs.admin.clearArtistPostEngagement', {
      'postId': postId,
      'confirmation': 'CLEAR_POST_ENGAGEMENT',
    });
  }

  Future<void> adminDeleteCommentsBySong(int songId) async {
    await client.mutation(
        'songs.admin.deleteCommentsBySong', {'songId': songId});
  }

  Future<List<dynamic>> adminPlaylists() async {
    final json = await client.query('songs.admin.playlists');
    if (json is List) return json;
    return [];
  }

  Future<List<dynamic>> adminReleases({int limit = 100}) async {
    final json =
        await client.query('songs.admin.releases', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<void> adminUpdateRelease(
      int albumId, Map<String, dynamic> patch) async {
    await client.mutation(
        'songs.admin.updateRelease', {'albumId': albumId, ...patch});
  }

  Future<void> adminDeleteRelease(int albumId) async {
    await client.mutation(
        'songs.admin.deleteRelease', {'albumId': albumId});
  }

  Future<int> adminCountFavorites(int localUserId) async {
    final json = await client
        .query('songs.admin.countFavorites', {'localUserId': localUserId});
    if (json is Map) {
      return int.tryParse(
              (Map<String, dynamic>.from(json)['count'] ?? 0).toString()) ??
          0;
    }
    return int.tryParse(json.toString()) ?? 0;
  }

  Future<void> adminClearFavorites(int localUserId) async {
    await client.mutation(
        'songs.admin.clearFavorites', {'localUserId': localUserId});
  }

  Future<List<dynamic>> adminVisitorHistory({int limit = 100}) async {
    final json = await client
        .query('songs.admin.visitorHistory', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<void> adminResetVisitorCounter() async {
    await client.mutation('songs.admin.resetVisitorCounter');
  }

  Future<void> adminClearVisitorHistory() async {
    await client.mutation('songs.admin.clearVisitorHistory');
  }

  Future<List<dynamic>> adminNotifications({int limit = 100}) async {
    final json =
        await client.query('songs.admin.notifications', {'limit': limit});
    if (json is List) return json;
    return [];
  }

  Future<void> adminDeleteNotification(int notificationId) async {
    await client.mutation(
        'songs.admin.deleteNotification', {'notificationId': notificationId});
  }

  Future<List<dynamic>> adminAuditEvents({int limit = 100}) async {
    final json =
        await client.query('songs.admin.auditEvents', {'limit': limit});
    if (json is List) return json;
    return [];
  }
}
