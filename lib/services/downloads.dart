import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/models.dart';

/// A SoundBlast song downloaded into the app for offline playback.
/// Mirrors the website's download behaviour (DownloadQueueContext):
/// the audio file is fetched from the song's audio URL and saved as
/// "<Artist> — <Title> · SoundBlast Official.<ext>".
class DownloadedSong {
  final int songId;
  final String title;
  final String artist;
  final String? imageUrl;
  final String genre;
  final int duration;
  final String path;
  final int sizeBytes;
  final String downloadedAt;

  const DownloadedSong({
    required this.songId,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.genre,
    required this.duration,
    required this.path,
    required this.sizeBytes,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
        'songId': songId,
        'title': title,
        'artist': artist,
        'imageUrl': imageUrl,
        'genre': genre,
        'duration': duration,
        'path': path,
        'sizeBytes': sizeBytes,
        'downloadedAt': downloadedAt,
      };

  factory DownloadedSong.fromJson(Map<String, dynamic> m) => DownloadedSong(
        songId: (m['songId'] as num?)?.toInt() ?? 0,
        title: m['title']?.toString() ?? 'Untitled',
        artist: m['artist']?.toString() ?? 'Unknown artist',
        imageUrl: m['imageUrl']?.toString(),
        genre: m['genre']?.toString() ?? 'Pop',
        duration: (m['duration'] as num?)?.toInt() ?? 0,
        path: m['path']?.toString() ?? '',
        sizeBytes: (m['sizeBytes'] as num?)?.toInt() ?? 0,
        downloadedAt: m['downloadedAt']?.toString() ?? '',
      );

  Song toSong() => Song(
        id: songId,
        title: title,
        artist: artist,
        userId: '',
        localUserId: 0,
        audioUrl: '',
        audioKey: '',
        imageUrl: imageUrl,
        genre: genre,
        duration: duration,
        sizeBytes: sizeBytes,
        playCount: 0,
        likeCount: 0,
        lyrics: null,
        albumId: null,
        albumName: '',
        createdAt: null,
      );

  String get sizeLabel {
    if (sizeBytes >= 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (sizeBytes >= 1024) return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    return '$sizeBytes B';
  }
}

enum DownloadStatus { idle, downloading, complete, failed }

class DownloadProgress {
  final int songId;
  final double progress; // 0..1, -1 when total unknown
  final DownloadStatus status;
  const DownloadProgress({
    required this.songId,
    required this.progress,
    required this.status,
  });
}

/// Downloads SoundBlast songs for offline playback, stored in the app's
/// documents directory. The index is persisted in SharedPreferences; a
/// download whose file is gone is pruned on load.
class DownloadManager {
  static const _indexKey = 'sb_downloaded_songs';
  final List<DownloadedSong> items = [];
  final Map<int, DownloadProgress> progress = {};
  final List<void Function()> _listeners = [];

  /// Set by AppState: a fresh client on the app's (Cronet) transport, so
  /// downloads work on the networks where the browser works. When unset,
  /// downloads fall back to the plain client.
  http.Client Function()? clientFactory;

  void addListener(void Function() fn) => _listeners.add(fn);
  void removeListener(void Function() fn) => _listeners.remove(fn);
  void _notify() {
    for (final fn in List.of(_listeners)) {
      fn();
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_indexKey);
    items.clear();
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        for (final e in list) {
          final d = DownloadedSong.fromJson(
              Map<String, dynamic>.from(e as Map));
          if (await File(d.path).exists()) {
            items.add(d);
          }
        }
      } catch (_) {}
    }
    _notify();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _indexKey, jsonEncode(items.map((d) => d.toJson()).toList()));
  }

  bool isDownloaded(int songId) =>
      items.any((d) => d.songId == songId);

  DownloadedSong? find(int songId) {
    for (final d in items) {
      if (d.songId == songId) return d;
    }
    return null;
  }

  String _fileName(Song song) {
    String safe(String s) => s
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
        .trim();
    final ext = song.audioUrl.split('.').last.split('?').first;
    final cleanExt = RegExp(r'^[a-zA-Z0-9]{2,5}$').hasMatch(ext)
        ? ext
        : 'mp3';
    return '${safe(song.artist)} — ${safe(song.title)} · SoundBlast Official.$cleanExt';
  }

  /// Download a song. Throws on failure. Progress is reported via
  /// [progress] + listeners.
  Future<DownloadedSong> download(
    Song song, {
    void Function(double progress)? onProgress,
  }) async {
    if (song.audioUrl.isEmpty) {
      throw Exception('This song has no downloadable audio file yet.');
    }
    final existing = find(song.id);
    if (existing != null) return existing;

    progress[song.id] = const DownloadProgress(
        songId: 0, progress: 0, status: DownloadStatus.downloading);
    _notify();
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dlDir = Directory('${dir.path}/soundblast-downloads');
      if (!await dlDir.exists()) await dlDir.create(recursive: true);
      final file = File('${dlDir.path}/${_fileName(song)}');

      final client = clientFactory?.call() ?? http.Client();
      try {
        final request = http.Request('GET', Uri.parse(song.audioUrl));
        final response =
            await client.send(request).timeout(const Duration(seconds: 180));
        if (response.statusCode != 200) {
          throw Exception(
              'Download failed (server returned ${response.statusCode}).');
        }
        final total = response.contentLength ?? -1;
        final sink = file.openWrite();
        var received = 0;
        await for (final chunk
            in response.stream.timeout(const Duration(seconds: 60))) {
          received += chunk.length;
          sink.add(chunk);
          final p = total > 0 ? received / total : -1.0;
          progress[song.id] = DownloadProgress(
              songId: song.id,
              progress: p,
              status: DownloadStatus.downloading);
          onProgress?.call(p);
          _notify();
        }
        await sink.close();
        final downloaded = DownloadedSong(
          songId: song.id,
          title: song.title,
          artist: song.artist,
          imageUrl: song.imageUrl,
          genre: song.genre,
          duration: song.duration,
          path: file.path,
          sizeBytes: received,
          downloadedAt: DateTime.now().toIso8601String(),
        );
        items.insert(0, downloaded);
        await _save();
        progress[song.id] = DownloadProgress(
            songId: song.id,
            progress: 1,
            status: DownloadStatus.complete);
        _notify();
        return downloaded;
      } finally {
        client.close();
      }
    } catch (e) {
      progress[song.id] = DownloadProgress(
          songId: song.id, progress: 0, status: DownloadStatus.failed);
      _notify();
      rethrow;
    }
  }

  Future<void> remove(int songId) async {
    final d = find(songId);
    if (d != null) {
      try {
        final f = File(d.path);
        if (await f.exists()) await f.delete();
      } catch (_) {}
      items.removeWhere((x) => x.songId == songId);
      progress.remove(songId);
      await _save();
      _notify();
    }
  }
}
