import '../../data/models/ayah_model.dart';

abstract class AudioRepository {
  bool get isPlaying;
  bool get isPaused;
  Stream<bool> get isPlayingStream;
  Stream<bool> get isPausedStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;

  /// Verse number within the current surah; zero denotes its unnumbered opening.
  Stream<int> get currentAyahNumberStream;

  Future<void> playAyah(AyahModel ayah);
  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0});
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
}
