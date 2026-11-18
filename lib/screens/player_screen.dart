import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'home_screens.dart' show SongActions;

/// Full music player (website /music-player and /player/:songId):
/// cover art, title/artist, seek bar, play/pause, next/previous, shuffle,
/// repeat, volume, queue, lyrics, and the song comments thread.
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<SongComment> _comments = [];
  bool _loadingComments = false;
  String? _commentsError;
  int? _commentsSongId;
  final _commentController = TextEditingController();
  bool _showLyrics = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments(int songId) async {
    final state = context.read<AppState>();
    _commentsSongId = songId;
    setState(() {
      _loadingComments = true;
      _comments = [];
      _commentsError = null;
    });
    try {
      final comments = await state.api.commentsForSong(songId);
      if (!mounted || _commentsSongId != songId) return;
      setState(() {
        _comments = comments;
        _loadingComments = false;
      });
    } catch (e) {
      if (!mounted || _commentsSongId != songId) return;
      setState(() {
        _commentsError = friendlyError(e, context.l10n);
        _loadingComments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final song = state.currentSong;
        // Comments load with the song — the section below always renders,
        // so waiting for the comments button left it showing "no comments".
        if (song != null &&
            song.id != _commentsSongId &&
            !_loadingComments) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _loadComments(song.id);
          });
        }
        if (song == null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.nowPlayingTitle)),
            body: EmptyState(
              icon: Icons.music_note,
              title: context.l10n.nothingPlaying,
              message: context.l10n.pickSongHint,
              action: ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (_) => false),
                child: Text(context.l10n.browseMusic),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.nowPlayingTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.stop),
                tooltip: context.l10n.stopPlayback,
                onPressed: () async {
                  await context.read<AppState>().stopPlayback();
                  if (context.mounted) {
                    showSnack(context,
                        context.l10n.playbackStopped);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.queue_music),
                tooltip: context.l10n.queue,
                onPressed: () => _showQueue(context, state),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CoverImage(
                    url: song.id < 0
                        ? (state.deviceArtForSong(song.id) ?? song.imageUrl)
                        : song.imageUrl,
                    size: 280,
                    radius: 20,
                    fallbackIcon: Icons.music_note),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              '/artist/${Uri.encodeComponent(song.artist)}'),
                          child: Text(song.artist,
                              style: const TextStyle(
                                  color: SbColors.accent, fontSize: 16)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [
                            song.genre,
                            if (song.playCount > 0)
                              context.l10n.playsCount(formatCount(song.playCount)),
                            if (song.likeCount > 0)
                              context.l10n.likesCount(formatCount(song.likeCount)),
                          ].join(' • '),
                          style: const TextStyle(color: SbColors.muted),
                        ),
                      ],
                    ),
                  ),
                  SongActions(song: song),
                ],
              ),
              const SizedBox(height: 8),
              _SeekBar(state: state),
              _Controls(state: state),
              _VolumeRow(state: state),
              if (state.batteryExemptionGranted == false)
                _BackgroundBatteryBanner(state: state),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: (song.lyrics ?? '').isEmpty
                        ? null
                        : () =>
                            setState(() => _showLyrics = !_showLyrics),
                    icon: const Icon(Icons.lyrics_outlined, size: 18),
                    label: Text((song.lyrics ?? '').isEmpty
                        ? context.l10n.noLyrics
                        : _showLyrics
                            ? context.l10n.hideLyrics
                            : context.l10n.showLyrics),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _loadComments(song.id),
                    icon: const Icon(Icons.comment_outlined, size: 18),
                    label: Text(context.l10n.comments),
                  ),
                ],
              ),
              if (_showLyrics && (song.lyrics ?? '').isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SbColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(song.lyrics!),
                ),
              const SizedBox(height: 8),
              Text(context.l10n.comments,
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _commentsSection(context, state, song),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _commentsSection(BuildContext context, AppState state, Song song) {
    return Column(
      children: [
        if (_loadingComments)
          const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator())
        else if (_commentsError != null)
          ErrorView(
              message: _commentsError!,
              onRetry: () => _loadComments(song.id))
        else if (_comments.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(context.l10n.noComments,
                style: TextStyle(color: SbColors.muted)),
          )
        else
          ..._comments.map((c) => Card(
                color: SbColors.card,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: SbColors.surface2,
                    child: Icon(Icons.person, color: SbColors.muted),
                  ),
                  title: Text(c.userName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (c.likeCount > 0)
                        Text('${c.likeCount}',
                            style: const TextStyle(color: SbColors.muted)),
                      IconButton(
                        icon: const Icon(Icons.thumb_up_outlined, size: 18),
                        onPressed: () async {
                          try {
                            await state.api.likeComment(c.id);
                            await _loadComments(song.id);
                          } catch (e) {
                            if (mounted) showSnack(context, friendlyError(e, context.l10n));
                          }
                        },
                      ),
                      if (state.user != null &&
                          (state.user!.id == c.userId ||
                              state.user!.isAdmin))
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () async {
                            final ok = await confirmDialog(context,
                                title: context.l10n.deleteComment,
                                message: context.l10n.deleteCommentConfirm);
                            if (ok) {
                              try {
                                await state.api.deleteComment(c.id);
                                await _loadComments(song.id);
                              } catch (e) {
                                if (mounted) {
                                  showSnack(context, friendlyError(e, context.l10n));
                                }
                              }
                            }
                          },
                        ),
                    ],
                  ),
                ),
              )),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                    hintText: context.l10n.writeComment),
                maxLength: 500,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: SbColors.accent,
              onPressed: () async {
                final text = _commentController.text.trim();
                if (text.isEmpty) return;
                if (state.user == null) {
                  showSnack(context, context.l10n.loginToComment);
                  return;
                }
                try {
                  await state.api.addComment(song.id, text);
                  _commentController.clear();
                  await _loadComments(song.id);
                } catch (e) {
                  if (mounted) showSnack(context, friendlyError(e, context.l10n));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showQueue(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SbColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(context.l10n.upNext,
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: state.queue
                    .asMap()
                    .entries
                    .map((e) => ListTile(
                          leading: CoverImage(
                              url: e.value.imageUrl, size: 44, radius: 8),
                          title: Text(e.value.title,
                              style: TextStyle(
                                  fontWeight: e.key == state.queueIndex
                                      ? FontWeight.w800
                                      : FontWeight.normal,
                                  color: e.key == state.queueIndex
                                      ? SbColors.accent
                                      : SbColors.text)),
                          subtitle: Text(e.value.artist),
                          trailing: e.key == state.queueIndex
                              ? const Icon(Icons.equalizer,
                                  color: SbColors.accent)
                              : null,
                          onTap: () {
                            Navigator.of(ctx).pop();
                            state.playSong(e.value,
                                fromQueue: state.queue);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundBatteryBanner extends StatelessWidget {
  final AppState state;
  const _BackgroundBatteryBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SbColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SbColors.accent.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.backgroundBatteryTitle,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(context.l10n.backgroundBatteryBody,
              style: const TextStyle(color: SbColors.muted, fontSize: 13)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => state.requestBatteryExemption(),
            child: Text(context.l10n.backgroundBatteryButton),
          ),
        ],
      ),
    );
  }
}

class _SeekBar extends StatelessWidget {
  final AppState state;
  const _SeekBar({required this.state});

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: state.player.positionStream,
      builder: (context, posSnap) {
        return StreamBuilder<Duration?>(
          stream: state.player.durationStream,
          builder: (context, durSnap) {
            final position = posSnap.data ?? Duration.zero;
            final duration = durSnap.data ??
                Duration(seconds: state.currentSong?.duration ?? 0);
            final max = duration.inMilliseconds > 0
                ? duration.inMilliseconds.toDouble()
                : 1.0;
            final value = position.inMilliseconds
                .toDouble()
                .clamp(0.0, max);
            return Column(
              children: [
                Slider(
                  value: value,
                  max: max,
                  activeColor: SbColors.accent,
                  inactiveColor: SbColors.border,
                  onChanged: (v) =>
                      state.seekTo(Duration(milliseconds: v.toInt())),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_fmt(position),
                        style: const TextStyle(color: SbColors.muted)),
                    Text(_fmt(duration),
                        style: const TextStyle(color: SbColors.muted)),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  final AppState state;
  const _Controls({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle,
              color: state.shuffle ? SbColors.accent : SbColors.muted),
          onPressed: () => state.toggleShuffle(),
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 44,
          onPressed: () => state.playPrevious(),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 40,
            color: Colors.black,
            onPressed: () => state.togglePlayPause(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 44,
          onPressed: () => state.playNext(),
        ),
        IconButton(
          icon: Icon(
            state.loopMode == LoopMode.one
                ? Icons.repeat_one
                : Icons.repeat,
            color: state.loopMode == LoopMode.off
                ? SbColors.muted
                : SbColors.accent,
          ),
          onPressed: () => state.cycleRepeat(),
        ),
      ],
    );
  }
}

class _VolumeRow extends StatelessWidget {
  final AppState state;
  const _VolumeRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: state.player.volumeStream,
      builder: (context, snap) {
        final v = snap.data ?? 1.0;
        return Row(
          children: [
            const Icon(Icons.volume_down, color: SbColors.muted),
            Expanded(
              child: Slider(
                value: v,
                activeColor: SbColors.accent,
                inactiveColor: SbColors.border,
                onChanged: (nv) => state.setVolume(nv),
              ),
            ),
            const Icon(Icons.volume_up, color: SbColors.muted),
          ],
        );
      },
    );
  }
}
