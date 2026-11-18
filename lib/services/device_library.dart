import 'package:flutter/services.dart';

import '../api/models.dart';

/// Audio files already on the device, scanned with Android's MediaStore
/// through a first-party MethodChannel in MainActivity.kt
/// (`com.soundblast.app/media_store`). No network is used; files play from
/// their content URI through the same player/queue as streamed songs.
///
/// Why not on_audio_query: its latest stable release (2.9.0) ships an
/// Android plugin without a namespace, which AGP 8 refuses to configure,
/// and its 3.0.0 beta needs Dart <3.0. The channel below does the same
/// MediaStore query (duration > 0, IS_MUSIC) in ~100 lines of Kotlin.
/// Display cleanup for MediaStore text: file names on this phone are often
/// percent-encoded (`%D8%A3...` is Arabic UTF-8) and use `_` as a word
/// separator, so raw titles show as `%D8%A3%D8%B5...` or `#جلسة_خميس...`.
/// Decode them back to readable words; `<unknown>` (MediaStore's own
/// placeholder) and empty text become the fallback.
String _cleanLabel(String? raw, String fallback) {
  var s = (raw ?? '').trim();
  if (s.isEmpty || s == '<unknown>') return fallback;
  if (s.contains('%')) {
    try {
      s = Uri.decodeComponent(s);
    } catch (_) {
      // Not valid percent-encoding (e.g. "100%"): keep the original.
    }
  }
  s = s.replaceAll('_', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  return s.isEmpty ? fallback : s;
}

class DeviceSong {
  final int id;
  final String title;
  final String artist;
  final String path;
  final int durationMs;
  final String? album;
  final String? genre;
  final String? composer;

  /// content:// URI for the file — the reliable way to play it under
  /// scoped storage (Android 10+). Falls back to [path] when absent.
  final String? contentUri;

  const DeviceSong({
    required this.id,
    required this.title,
    required this.artist,
    required this.path,
    required this.durationMs,
    required this.album,
    this.genre,
    this.composer,
    this.contentUri,
  });

  /// The URI the player should open: content URI when available, else the
  /// raw file path.
  String get playableUri => contentUri ?? path;

  /// Parent folder name of the file (Samsung Music's Folder category).
  /// Folder names are percent-decoded and prettified like titles, since
  /// they come from the same mangled file names.
  String folderName({String unknownFolder = 'Unknown folder'}) {
    final parts = path.split('/');
    if (parts.length >= 2) {
      final name = parts[parts.length - 2];
      if (name.isNotEmpty) return _cleanLabel(name, unknownFolder);
    }
    return unknownFolder;
  }

  Song toSong({String onThisDevice = 'On this device'}) => Song(
        id: -1000000 - id, // negative ids: never collide with server ids
        title: title,
        artist: artist,
        userId: '',
        localUserId: 0,
        audioUrl: '',
        audioKey: '',
        imageUrl: null,
        genre: (genre?.isNotEmpty ?? false) ? genre! : (album ?? onThisDevice),
        duration: durationMs ~/ 1000,
        sizeBytes: 0,
        playCount: 0,
        likeCount: 0,
        lyrics: null,
        albumId: null,
        albumName: album ?? '',
        createdAt: null,
      );
}

class DeviceLibrary {
  static const _channel = MethodChannel('com.soundblast.app/media_store');

  /// Query all audio on the device. Returns [] when the permission is not
  /// granted — callers must run the permission flow first.
  Future<List<DeviceSong>> querySongs({
    String unknownTitle = 'Unknown title',
    String unknownArtist = 'Unknown artist',
  }) async {
    final List<dynamic> raw;
    try {
      raw = await _channel.invokeMethod<List<dynamic>>('querySongs') ?? [];
    } on PlatformException catch (e) {
      // Permission denied (or no media): an empty on-device list, not a
      // crash — the UI shows the permission note instead.
      if (e.code == 'PERMISSION_DENIED') return [];
      rethrow;
    }
    final songs = <DeviceSong>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      final m = Map<String, dynamic>.from(entry);
      final durationMs = (m['durationMs'] as num?)?.toInt() ?? 0;
      final path = m['path']?.toString() ?? '';
      if (path.isEmpty || durationMs <= 0) continue;
      songs.add(DeviceSong(
        id: (m['id'] as num?)?.toInt() ?? 0,
        title: _cleanLabel(m['title']?.toString(), unknownTitle),
        artist: _cleanLabel(m['artist']?.toString(), unknownArtist),
        path: path,
        durationMs: durationMs,
        album: _cleanLabel(m['album']?.toString(), ''),
        genre: _cleanLabel(m['genre']?.toString(), ''),
        composer: _cleanLabel(m['composer']?.toString(), ''),
        contentUri: m['contentUri']?.toString(),
      ));
    }
    return songs;
  }
}
