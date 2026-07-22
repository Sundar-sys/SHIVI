import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import '../models/track.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> loadAndPlay(Track track) async {
    await _player.setAudioSource(
      AudioSource.asset(
        track.assetPath,
        tag: MediaItem(
          id: track.id,
          title: track.title,
          artist: track.artist,
          artUri: Uri.parse(track.artworkPath),
        ),
      ),
    );
    await _player.play();
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> setVolume(double volume) => _player.setVolume(volume);
  Future<void> stop() => _player.stop();
  void dispose() => _player.dispose();
}
