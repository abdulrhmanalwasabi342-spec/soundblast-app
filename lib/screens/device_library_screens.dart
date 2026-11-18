import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../services/device_library.dart';
import '../services/local_playlists.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

/// On-device library the Samsung Music way: the same songs, browsable by
/// Track, Album, Artist, Genre, Folder and Composer — plus playlists that
/// live only on this phone. Everything here is local: no account, no
/// server, no internet at any point.

enum DeviceCategory { tracks, albums, artists, genres, folders, composers }

String deviceCategoryLabel(DeviceCategory c) => switch (c) {
      DeviceCategory.tracks => 'Tracks',
      DeviceCategory.albums => 'Albums',
      DeviceCategory.artists => 'Artists',
      DeviceCategory.genres => 'Genres',
      DeviceCategory.folders => 'Folders',
      DeviceCategory.composers => 'Composers',
    };

IconData deviceCategoryIcon(DeviceCategory c) => switch (c) {
      DeviceCategory.tracks => Icons.music_note,
      DeviceCategory.albums => Icons.album,
      DeviceCategory.artists => Icons.person,
      DeviceCategory.genres => Icons.style,
      DeviceCategory.folders => Icons.folder,
      DeviceCategory.composers => Icons.edit_note,
    };

/// Groups the on-device songs for one category, sorted by group name.
Map<String, List<DeviceSong>> groupDeviceSongs(
    DeviceCategory c, List<DeviceSong> songs) {
  final map = <String, List<DeviceSong>>{};
  for (final d in songs) {
    final key = switch (c) {
      DeviceCategory.tracks => 'All tracks',
      DeviceCategory.albums =>
        (d.album?.isNotEmpty ?? false) ? d.album! : 'Unknown album',
      DeviceCategory.artists => d.artist,
      DeviceCategory.genres =>
        (d.genre?.isNotEmpty ?? false) ? d.genre! : 'Unknown genre',
      DeviceCategory.folders => d.folderName,
      DeviceCategory.composers =>
        (d.composer?.isNotEmpty ?? false) ? d.composer! : 'Unknown composer',
    };
    (map[key] ??= []).add(d);
  }
  final keys = map.keys.toList()..sort();
  return {for (final k in keys) k: map[k]!};
}

List<Song> deviceSongsToQueue(List<DeviceSong> songs) =>
    songs.map((d) => d.toSong().copyWithLocalPath(d.playableUri)).toList();

/// Small text-input dialog, shared by "new playlist" and "rename".
Future<String?> askTextInput(
  BuildContext context, {
  required String title,
  String? hint,
  String? initial,
}) async {
  final controller = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: hint),
        onSubmitted: (_) =>
            Navigator.of(context).pop(controller.text.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// One category's groups (albums, artists, genres, folders, composers).
class DeviceCategoryScreen extends StatelessWidget {
  final DeviceCategory category;
  const DeviceCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final songs = context.watch<AppState>().deviceSongs;
    final groups = groupDeviceSongs(category, songs);
    return Scaffold(
      appBar: AppBar(title: Text(deviceCategoryLabel(category))),
      body: groups.isEmpty
          ? const EmptyState(
              icon: Icons.music_off,
              title: 'Nothing here yet',
              message: 'No on-device songs in this category.',
            )
          : ListView(
              children: groups.entries.map((e) {
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: SbColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(deviceCategoryIcon(category),
                        color: SbColors.accent),
                  ),
                  title: Text(e.key),
                  subtitle: Text(
                      '${e.value.length} song${e.value.length == 1 ? '' : 's'}'),
                  trailing: const Icon(Icons.chevron_right,
                      color: SbColors.muted),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DeviceSongsScreen(
                          title: e.key, songs: e.value),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

/// A list of on-device songs: play-all, shuffle, tap to play, ⋮ to add
/// the song to an offline playlist.
class DeviceSongsScreen extends StatelessWidget {
  final String title;
  final List<DeviceSong> songs;
  const DeviceSongsScreen(
      {super.key, required this.title, required this.songs});

  List<Song> get _queue => deviceSongsToQueue(songs);

  Future<void> _playAll(BuildContext context, {bool shuffled = false}) async {
    if (songs.isEmpty) return;
    final state = context.read<AppState>();
    final queue = _queue;
    if (shuffled) queue.shuffle();
    final first = queue.first;
    final firstDevice = songs.firstWhere(
        (d) => d.toSong().id == first.id,
        orElse: () => songs.first);
    await state.playLocalSong(first,
        localPath: firstDevice.playableUri, fromQueue: queue);
  }

  Future<void> _showAddToPlaylist(
      BuildContext context, DeviceSong song) async {
    final state = context.read<AppState>();
    final store = state.localPlaylists;
    final picked = await showModalBottomSheet<LocalPlaylist>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('Add to playlist')),
            ...store.items.map((p) => ListTile(
                  leading: const Icon(Icons.playlist_play,
                      color: SbColors.accent),
                  title: Text(p.name),
                  subtitle: Text(
                      '${p.songIds.length} song${p.songIds.length == 1 ? '' : 's'}'),
                  trailing: store.contains(p, song.id)
                      ? const Icon(Icons.check, color: SbColors.accent)
                      : null,
                  onTap: () => Navigator.of(context).pop(p),
                )),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New playlist'),
              onTap: () async {
                final name = await askTextInput(context,
                    title: 'New playlist', hint: 'Playlist name');
                if (name == null || name.isEmpty) return;
                final created = await store.create(name);
                if (context.mounted) Navigator.of(context).pop(created);
              },
            ),
          ],
        ),
      ),
    );
    if (picked != null) {
      await store.addSong(picked, song.id);
      if (context.mounted) {
        showSnack(context, 'Added to "${picked.name}"');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final queue = _queue;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: songs.isEmpty
          ? const EmptyState(
              icon: Icons.music_off,
              title: 'No songs here',
              message: 'Nothing on this device matches.',
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _playAll(context),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play all'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _playAll(context, shuffled: true),
                          icon: const Icon(Icons.shuffle),
                          label: const Text('Shuffle'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: songs.asMap().entries.map((e) {
                      final ds = e.value;
                      final song = queue[e.key];
                      return SongTile(
                        song: song,
                        onTap: () => state.playLocalSong(song,
                            localPath: ds.playableUri, fromQueue: queue),
                        onPlay: () => state.playLocalSong(song,
                            localPath: ds.playableUri, fromQueue: queue),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert,
                              color: SbColors.muted, size: 20),
                          tooltip: 'Add to playlist',
                          onPressed: () => _showAddToPlaylist(context, ds),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

/// One offline playlist: its songs, play-all, rename and delete.
class LocalPlaylistDetailScreen extends StatelessWidget {
  final LocalPlaylist playlist;
  const LocalPlaylistDetailScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final songs = state.deviceSongs
        .where((d) => playlist.songIds.contains(d.id))
        .toList();
    final queue = deviceSongsToQueue(songs);
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'rename') {
                final name = await askTextInput(context,
                    title: 'Rename playlist',
                    hint: 'Playlist name',
                    initial: playlist.name);
                if (name != null && name.isNotEmpty) {
                  await state.localPlaylists.rename(playlist, name);
                }
              } else if (v == 'delete') {
                final ok = await confirmDialog(context,
                    title: 'Delete playlist',
                    message:
                        'Delete "${playlist.name}"? The songs stay on this device.');
                if (ok && context.mounted) {
                  await state.localPlaylists.delete(playlist);
                  Navigator.of(context).pop();
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: songs.isEmpty
          ? const EmptyState(
              icon: Icons.playlist_remove,
              title: 'No songs yet',
              message:
                  'Add songs from the on-device library (⋮ on any song).',
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        state.playLocalSong(queue.first,
                            localPath: songs.first.playableUri,
                            fromQueue: queue);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play all'),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: songs.asMap().entries.map((e) {
                      final ds = e.value;
                      final song = queue[e.key];
                      return SongTile(
                        song: song,
                        onTap: () => state.playLocalSong(song,
                            localPath: ds.playableUri, fromQueue: queue),
                        onPlay: () => state.playLocalSong(song,
                            localPath: ds.playableUri, fromQueue: queue),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: SbColors.muted, size: 20),
                          tooltip: 'Remove from playlist',
                          onPressed: () => state.localPlaylists
                              .removeSong(playlist, ds.id),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
