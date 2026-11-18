import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Playlists that live only on this phone, for the songs already on it —
/// the Samsung Music half of the app. No account, no server, no internet:
/// a playlist is just a name plus MediaStore audio ids, resolved against
/// the current on-device scan at play time (a deleted file is skipped).
class LocalPlaylist {
  final String id;
  String name;
  final int createdAtMs;
  final List<int> songIds;

  LocalPlaylist({
    required this.id,
    required this.name,
    required this.createdAtMs,
    required this.songIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAtMs': createdAtMs,
        'songIds': songIds,
      };

  static LocalPlaylist fromJson(Map<String, dynamic> j) => LocalPlaylist(
        id: j['id'].toString(),
        name: j['name']?.toString() ?? 'Playlist',
        createdAtMs: (j['createdAtMs'] as num?)?.toInt() ?? 0,
        songIds: ((j['songIds'] as List?) ?? [])
            .map((e) => (e as num).toInt())
            .toList(),
      );
}

class LocalPlaylistStore extends ChangeNotifier {
  static const _key = 'sb_local_playlists';
  final List<LocalPlaylist> items = [];
  bool loaded = false;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    items.clear();
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        items.addAll(list.map(
            (e) => LocalPlaylist.fromJson(Map<String, dynamic>.from(e))));
      } catch (_) {}
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(items.map((p) => p.toJson()).toList()));
  }

  Future<LocalPlaylist> create(String name) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final p = LocalPlaylist(
      id: now.toString(),
      name: name.trim().isEmpty ? 'My playlist' : name.trim(),
      createdAtMs: now,
      songIds: [],
    );
    items.insert(0, p);
    await _save();
    notifyListeners();
    return p;
  }

  Future<void> rename(LocalPlaylist p, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    p.name = trimmed;
    await _save();
    notifyListeners();
  }

  Future<void> delete(LocalPlaylist p) async {
    items.removeWhere((x) => x.id == p.id);
    await _save();
    notifyListeners();
  }

  Future<void> addSong(LocalPlaylist p, int songId) async {
    if (p.songIds.contains(songId)) return;
    p.songIds.add(songId);
    await _save();
    notifyListeners();
  }

  Future<void> removeSong(LocalPlaylist p, int songId) async {
    p.songIds.remove(songId);
    await _save();
    notifyListeners();
  }

  bool contains(LocalPlaylist p, int songId) => p.songIds.contains(songId);
}
