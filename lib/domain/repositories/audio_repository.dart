import '../../data/models/ayah_model.dart';

abstract class AudioRepository {
  bool get isPlaying;
  Stream<bool> get isPlayingStream;

  Future<void> playAyah(AyahModel ayah);

  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0});

  Future<void> stop();
}
