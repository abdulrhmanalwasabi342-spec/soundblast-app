import 'dart:convert';

// Data models mirroring the SoundBlast server schema (drizzle/schema.ts)
// and the tRPC procedure return shapes in server/routers.ts. All parsing
// is defensive: the live backend may return missing/extra fields and dates
// as ISO strings.

int _asInt(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

String _asStr(dynamic v, [String fallback = '']) {
  if (v == null) return fallback;
  return v.toString();
}

List<T> _asList<T>(dynamic v, T Function(dynamic) f) {
  if (v is List) return v.map(f).toList();
  return <T>[];
}

Map<String, dynamic> _asMap(dynamic v) {
  if (v is Map<String, dynamic>) return v;
  if (v is Map) return Map<String, dynamic>.from(v);
  return <String, dynamic>{};
}

class User {
  final String id;
  final String name;
  final String email;
  final String role; // "user" | "artist"
  final bool isAdmin;
  final String stageName;
  final String? imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isAdmin,
    required this.stageName,
    this.imageUrl,
  });

  factory User.fromJson(dynamic json) {
    final m = _asMap(json);
    return User(
      id: _asStr(m['id']),
      name: _asStr(m['name'], 'SoundBlast user'),
      email: _asStr(m['email']),
      role: _asStr(m['role'], 'user'),
      isAdmin: m['isAdmin'] == true || m['isAdmin'] == 1,
      stageName: _asStr(m['stageName']),
      imageUrl: m['imageUrl']?.toString(),
    );
  }

  /// Cached locally (SharedPreferences `sb_cached_user`) so the app
  /// opens signed-in even with no internet: the user must never look
  /// logged out just because the server could not be reached.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'isAdmin': isAdmin,
        'stageName': stageName,
        'imageUrl': imageUrl,
      };

  bool get isArtist => role == 'artist';
  String get displayName =>
      stageName.isNotEmpty ? stageName : name;
}

class Song {
  final int id;
  final String title;
  final String artist;
  final String userId;
  final int localUserId;
  final String audioUrl;
  final String audioKey;
  final String? imageUrl;
  final String genre;
  final int duration; // seconds
  final int sizeBytes;
  final int playCount;
  final int likeCount;
  final String? lyrics;
  final int? albumId;
  final String albumName;
  final String? createdAt;
  /// Local file path when this song is played offline (downloaded inside
  /// the app or scanned from the device). Never comes from the server.
  final String? localPath;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.userId,
    required this.localUserId,
    required this.audioUrl,
    required this.audioKey,
    required this.imageUrl,
    required this.genre,
    required this.duration,
    required this.sizeBytes,
    required this.playCount,
    required this.likeCount,
    required this.lyrics,
    required this.albumId,
    required this.albumName,
    required this.createdAt,
    this.localPath,
  });

  /// Direct B2 links to a private bucket answer 401 — the server hands out
  /// the /manus-storage/ proxy instead. Rows stored before that fix still
  /// carry the direct B2 URL, so rewrite them here at parse time: every
  /// consumer (player, covers, downloads) then gets a working link.
  static const _b2DirectPrefix =
      'https://soundblast.s3.us-east-005.backblazeb2.com/';
  static const _proxyBase =
      'https://soundblast.onrender.com/manus-storage';

  static String _resolveMediaUrl(String url) {
    if (url.startsWith(_b2DirectPrefix)) {
      return '$_proxyBase/${url.substring(_b2DirectPrefix.length)}';
    }
    return url;
  }

  factory Song.fromJson(dynamic json) {
    final m = _asMap(json);
    return Song(
      id: _asInt(m['id']),
      title: _asStr(m['title'], 'Untitled'),
      artist: _asStr(m['artist'], 'Unknown artist'),
      userId: _asStr(m['userId']),
      localUserId: _asInt(m['localUserId']),
      audioUrl: _resolveMediaUrl(_asStr(m['audioUrl'])),
      audioKey: _asStr(m['audioKey']),
      imageUrl: m['imageUrl'] == null
          ? null
          : _resolveMediaUrl(m['imageUrl'].toString()),
      genre: _asStr(m['genre'], 'Pop'),
      duration: _asInt(m['duration']),
      sizeBytes: _asInt(m['sizeBytes']),
      playCount: _asInt(m['playCount']),
      likeCount: _asInt(m['likeCount']),
      lyrics: m['lyrics']?.toString(),
      albumId: m['albumId'] == null ? null : _asInt(m['albumId']),
      albumName: _asStr(m['albumName']),
      createdAt: m['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'userId': userId,
        'localUserId': localUserId,
        'audioUrl': audioUrl,
        'audioKey': audioKey,
        'imageUrl': imageUrl,
        'genre': genre,
        'duration': duration,
        'sizeBytes': sizeBytes,
        'playCount': playCount,
        'likeCount': likeCount,
        'lyrics': lyrics,
        'albumId': albumId,
        'albumName': albumName,
        'createdAt': createdAt,
      };

  static Song fromCache(String raw) => Song.fromJson(jsonDecode(raw));
  String toCache() => jsonEncode(toJson());

  String get durationLabel {
    if (duration <= 0) return '';
    final m = duration ~/ 60;
    final s = duration % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Copy with a local file path attached (offline playback).
  Song copyWithLocalPath(String path) => Song(
        id: id,
        title: title,
        artist: artist,
        userId: userId,
        localUserId: localUserId,
        audioUrl: audioUrl,
        audioKey: audioKey,
        imageUrl: imageUrl,
        genre: genre,
        duration: duration,
        sizeBytes: sizeBytes,
        playCount: playCount,
        likeCount: likeCount,
        lyrics: lyrics,
        albumId: albumId,
        albumName: albumName,
        createdAt: createdAt,
        localPath: path,
      );
}

class Album {
  final int id;
  final int artistLocalUserId;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? createdAt;
  final String? artistName;
  final String? releaseType;
  final int songCount;
  final List<Song> songs;

  const Album({
    required this.id,
    required this.artistLocalUserId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    this.artistName,
    this.releaseType,
    this.songCount = 0,
    this.songs = const [],
  });

  factory Album.fromJson(dynamic json) {
    final m = _asMap(json);
    return Album(
      id: _asInt(m['id']),
      artistLocalUserId: _asInt(m['artistLocalUserId']),
      // getAlbums() returns albumName/coverUrl; artistAlbums returns title/imageUrl.
      title: _asStr(m['title'], _asStr(m['albumName'], 'Untitled album')),
      description: m['description']?.toString(),
      imageUrl: m['imageUrl']?.toString() ??
          m['coverUrl']?.toString() ??
          m['coverImageUrl']?.toString(),
      createdAt: m['createdAt']?.toString() ?? m['releasedAt']?.toString(),
      artistName: m['artist']?.toString() ?? m['artistName']?.toString(),
      releaseType: m['releaseType']?.toString(),
      songCount: _asInt(m['songCount']),
      songs: _asList(m['songs'], Song.fromJson),
    );
  }
}

class ArtistProfile {
  final int localUserId;
  final String stageName;
  final String? bio;
  final String? imageUrl;
  final String? slug;
  final bool verified;
  final int followerCount;
  final int songCount;
  final int totalPlays;

  const ArtistProfile({
    required this.localUserId,
    required this.stageName,
    required this.bio,
    required this.imageUrl,
    required this.slug,
    required this.verified,
    this.followerCount = 0,
    this.songCount = 0,
    this.totalPlays = 0,
  });

  factory ArtistProfile.fromJson(dynamic json) {
    final m = _asMap(json);
    return ArtistProfile(
      localUserId: _asInt(m['localUserId']),
      stageName: _asStr(m['stageName'], 'Artist'),
      bio: m['bio']?.toString(),
      imageUrl: m['imageUrl']?.toString(),
      slug: m['slug']?.toString(),
      verified: m['verified'] == true || m['verified'] == 1,
      followerCount: _asInt(m['followerCount']),
      songCount: _asInt(m['songCount']),
      totalPlays: _asInt(m['totalPlays']),
    );
  }
}

class Playlist {
  final int id;
  final int localUserId;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isPublic;
  final String? createdAt;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.localUserId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isPublic,
    required this.createdAt,
    this.songs = const [],
  });

  factory Playlist.fromJson(dynamic json) {
    final m = _asMap(json);
    return Playlist(
      id: _asInt(m['id']),
      localUserId: _asInt(m['localUserId']),
      name: _asStr(m['name'], 'Playlist'),
      description: m['description']?.toString(),
      imageUrl: m['imageUrl']?.toString(),
      isPublic: m['isPublic'] == true ||
          m['isPublic'] == 1 ||
          m['isPublic'] == 'true',
      createdAt: m['createdAt']?.toString(),
      songs: _asList(m['songs'], Song.fromJson),
    );
  }
}

class ArtistPost {
  final int id;
  final int artistLocalUserId;
  final String body;
  final String kind;
  final String? imageUrl;
  final String? stageName;
  final String? createdAt;

  const ArtistPost({
    required this.id,
    required this.artistLocalUserId,
    required this.body,
    required this.kind,
    required this.imageUrl,
    required this.stageName,
    required this.createdAt,
  });

  factory ArtistPost.fromJson(dynamic json) {
    final m = _asMap(json);
    return ArtistPost(
      id: _asInt(m['id']),
      artistLocalUserId: _asInt(m['artistLocalUserId']),
      body: _asStr(m['body']),
      kind: _asStr(m['kind'], 'update'),
      imageUrl: m['imageUrl']?.toString(),
      stageName: m['stageName']?.toString(),
      createdAt: m['createdAt']?.toString(),
    );
  }
}

class SongComment {
  final int id;
  final int songId;
  final String userId;
  final String userName;
  final String text;
  final int likeCount;
  final String? createdAt;

  const SongComment({
    required this.id,
    required this.songId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.likeCount,
    required this.createdAt,
  });

  factory SongComment.fromJson(dynamic json) {
    final m = _asMap(json);
    return SongComment(
      id: _asInt(m['id']),
      songId: _asInt(m['songId']),
      userId: _asStr(m['userId']),
      userName: _asStr(m['userName'], 'Listener'),
      text: _asStr(m['text']),
      likeCount: _asInt(m['likeCount']),
      createdAt: m['createdAt']?.toString(),
    );
  }
}

class AppNotification {
  final int id;
  final String title;
  final String? body;
  final String type;
  final bool isRead;
  final String? createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(dynamic json) {
    final m = _asMap(json);
    return AppNotification(
      id: _asInt(m['id']),
      title: _asStr(m['title']),
      body: m['body']?.toString() ?? m['message']?.toString(),
      type: _asStr(m['type'], 'general'),
      isRead: m['isRead'] == true || m['isRead'] == 1,
      createdAt: m['createdAt']?.toString(),
    );
  }
}

class HomeSummary {
  final List<Song> trendingSongs;
  final List<Album> albums;
  final List<ArtistProfile> artists;
  final List<ArtistPost> recentPublicPosts;
  final int totalSongs;
  final int totalPlays;

  const HomeSummary({
    required this.trendingSongs,
    required this.albums,
    required this.artists,
    required this.recentPublicPosts,
    required this.totalSongs,
    required this.totalPlays,
  });

  factory HomeSummary.fromJson(dynamic json) {
    final m = _asMap(json);
    return HomeSummary(
      trendingSongs: _asList(m['trendingSongs'], Song.fromJson),
      albums: _asList(m['albums'], Album.fromJson),
      artists: _asList(m['artists'], ArtistProfile.fromJson),
      recentPublicPosts:
          _asList(m['recentPublicPosts'], ArtistPost.fromJson),
      totalSongs: _asInt(m['totalSongs']),
      totalPlays: _asInt(m['totalPlays']),
    );
  }

  factory HomeSummary.empty() => const HomeSummary(
        trendingSongs: [],
        albums: [],
        artists: [],
        recentPublicPosts: [],
        totalSongs: 0,
        totalPlays: 0,
      );
}

class SearchResult {
  final List<Song> songs;
  final List<ArtistProfile> artists;
  final List<String> genres;

  const SearchResult({
    required this.songs,
    required this.artists,
    required this.genres,
  });

  factory SearchResult.fromJson(dynamic json) {
    final m = _asMap(json);
    return SearchResult(
      songs: _asList(m['songs'], Song.fromJson),
      artists: _asList(m['artists'], ArtistProfile.fromJson),
      genres: _asList(m['genres'], (e) => e.toString()),
    );
  }
}
