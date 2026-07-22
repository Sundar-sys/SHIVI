import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/audio_player_service.dart';
import '../data/models/track.dart';

class MusicState {
  final Track? currentTrack;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final TrackCategory selectedCategory;

  MusicState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.selectedCategory = TrackCategory.calmingBeats,
  });

  MusicState copyWith({
    Track? currentTrack,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    TrackCategory? selectedCategory,
  }) {
    return MusicState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class MusicNotifier extends StateNotifier<MusicState> {
  final AudioPlayerService _service;

  MusicNotifier(this._service) : super(MusicState()) {
    _service.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });
    _service.durationStream.listen((dur) {
      if (dur != null) state = state.copyWith(duration: dur);
    });
    _service.playerStateStream.listen((playerState) {
      state = state.copyWith(isPlaying: playerState.playing);
    });
  }

  Future<void> playTrack(Track track) async {
    state = state.copyWith(currentTrack: track);
    await _service.loadAndPlay(track);
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _service.pause();
    } else {
      await _service.resume();
    }
  }

  Future<void> seek(Duration position) => _service.seek(position);
  void selectCategory(TrackCategory category) {
    state = state.copyWith(selectedCategory: category);
  }
}

final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier(AudioPlayerService());
});
