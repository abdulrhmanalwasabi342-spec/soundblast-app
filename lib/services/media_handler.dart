import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// SoundBlast's own media-session handler (the bridge between the
/// app's single [AudioPlayer] and Android's MediaSession / media
/// notification card).
///
/// It replaces just_audio_background's handler for one reason: the
/// card must ALWAYS show the four Samsung-style controls — previous,
/// play/pause, next — in that order, even when the queue holds a
/// single song. just_audio_background only shows the skip buttons
/// when the queue has a previous/next song, so a one-song queue
/// rendered just play + stop. The close button is NOT a control here:
/// with `androidNotificationOngoing` the system adds its own X
/// (cancel → stop), exactly like Samsung Music's card.
///
/// The skip buttons wrap around the queue (next on the last song
/// restarts the first, previous on the first restarts the last), so
/// they always do something real — never a dead button.
class SoundBlastAudioHandler extends BaseAudioHandler {
  SoundBlastAudioHandler(this._player) {
    _repeatMode = _toRepeatMode(_player.loopMode);
    _shuffleMode = _player.shuffleModeEnabled
        ? AudioServiceShuffleMode.all
        : AudioServiceShuffleMode.none;
    // Seed from the player's current state, then keep the session in
    // sync with the player.
    _broadcastQueue();
    _broadcastMediaItem();
    _broadcastState();
    _subs.addAll([
      _player.playbackEventStream.listen((_) => _broadcastState()),
      _player.positionStream.listen((_) => _broadcastState()),
      _player.currentIndexStream.listen((_) {
        _broadcastMediaItem();
        _broadcastState();
      }),
      _player.sequenceStream.listen((_) {
        _broadcastQueue();
        _broadcastMediaItem();
        _broadcastState();
      }),
      _player.loopModeStream.listen((mode) {
        _repeatMode = _toRepeatMode(mode);
        _broadcastState();
      }),
      _player.shuffleModeEnabledStream.listen((enabled) {
        _shuffleMode = enabled
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none;
        _broadcastState();
      }),
    ]);
  }

  final AudioPlayer _player;
  final List<StreamSubscription> _subs = [];
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;
  AudioServiceShuffleMode _shuffleMode = AudioServiceShuffleMode.none;

  /// The four Samsung-style controls, always present, in Samsung's
  /// order. The compact (collapsed) card shows only play/pause
  /// (index 1), matching the collapsed card's single button.
  List<MediaControl> get _controls => [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ];

  void _broadcastState() {
    playbackState.add(PlaybackState(
      controls: _controls,
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [1],
      processingState: _toProcessingState(_player.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: _player.currentIndex,
      repeatMode: _repeatMode,
      shuffleMode: _shuffleMode,
    ));
  }

  void _broadcastMediaItem() {
    final sequence = _player.sequence;
    final index = _player.currentIndex;
    if (sequence == null ||
        index == null ||
        index < 0 ||
        index >= sequence.length) {
      mediaItem.add(null);
      return;
    }
    final tag = sequence[index].tag;
    if (tag is MediaItem) mediaItem.add(tag);
  }

  void _broadcastQueue() {
    final sequence = _player.sequence ?? const <IndexedAudioSource>[];
    queue.add(
      sequence
          .map((source) => source.tag)
          .whereType<MediaItem>()
          .toList(),
    );
  }

  static AudioProcessingState _toProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  static AudioServiceRepeatMode _toRepeatMode(LoopMode mode) {
    switch (mode) {
      case LoopMode.off:
        return AudioServiceRepeatMode.none;
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
      case LoopMode.all:
        return AudioServiceRepeatMode.all;
    }
  }

  static LoopMode _toLoopMode(AudioServiceRepeatMode mode) {
    switch (mode) {
      case AudioServiceRepeatMode.none:
        return LoopMode.off;
      case AudioServiceRepeatMode.one:
        return LoopMode.one;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        // Group repeat has no just_audio equivalent; queue repeat is
        // the closest behaviour.
        return LoopMode.all;
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> fastForward() =>
      _player.seek(_player.position + const Duration(seconds: 10));

  @override
  Future<void> rewind() {
    final target = _player.position - const Duration(seconds: 10);
    return _player.seek(
      target < Duration.zero ? Duration.zero : target,
    );
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    // The service removes the notification once the broadcast state
    // goes idle (follows from the player's own streams).
  }

  @override
  Future<void> skipToNext() async {
    final sequence = _player.sequence ?? const <IndexedAudioSource>[];
    if (sequence.isEmpty) return;
    final index = _player.currentIndex ?? 0;
    final next = index + 1 < sequence.length ? index + 1 : 0;
    await _player.seek(Duration.zero, index: next);
  }

  @override
  Future<void> skipToPrevious() async {
    final sequence = _player.sequence ?? const <IndexedAudioSource>[];
    if (sequence.isEmpty) return;
    final index = _player.currentIndex ?? 0;
    final prev = index - 1 >= 0 ? index - 1 : sequence.length - 1;
    await _player.seek(Duration.zero, index: prev);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) =>
      _player.setLoopMode(_toLoopMode(repeatMode));

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) =>
      _player.setShuffleModeEnabled(
        shuffleMode != AudioServiceShuffleMode.none,
      );
}
