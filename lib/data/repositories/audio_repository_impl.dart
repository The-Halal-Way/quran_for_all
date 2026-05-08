import '../../data/models/ayah_model.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../services/audio_service.dart';

class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl(this._audioService);

  final AudioService _audioService;

  @override
  bool get isPlaying => _audioService.isPlaying;

  @override
  bool get isPaused => _audioService.isPaused;

  @override
  Stream<bool> get isPlayingStream => _audioService.isPlayingStream;

  @override
  Stream<bool> get isPausedStream => _audioService.isPausedStream;

  @override
  Stream<Duration> get positionStream => _audioService.positionStream;

  @override
  Stream<Duration> get durationStream => _audioService.durationStream;

  @override
  Future<void> playAyah(AyahModel ayah) => _audioService.playAyah(ayah);

  @override
  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0}) =>
      _audioService.playSurah(ayahs, startIndex: startIndex);

  @override
  Future<void> pause() => _audioService.pause();

  @override
  Future<void> resume() => _audioService.resume();

  @override
  Future<void> stop() => _audioService.stop();
}
