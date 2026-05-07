import '../../data/models/ayah_model.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../services/audio_service.dart';

class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl(this._audioService);

  final AudioService _audioService;

  @override
  bool get isPlaying => _audioService.isPlaying;

  @override
  Stream<bool> get isPlayingStream => _audioService.isPlayingStream;

  @override
  Future<void> playAyah(AyahModel ayah) {
    return _audioService.playAyah(ayah);
  }

  @override
  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0}) {
    return _audioService.playSurah(ayahs, startIndex: startIndex);
  }

  @override
  Future<void> stop() {
    return _audioService.stop();
  }
}
