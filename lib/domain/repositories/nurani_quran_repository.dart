import '../entities/quran/nurani_quran_state.dart';

abstract class NuraniQuranRepository {
  Future<NuraniQuranLibrary> loadLibrary();
  Future<String> download({
    required void Function(int bytes, int? total) onProgress,
  });
  void cancelDownload();
  Future<void> saveReading(NuraniQuranReadingState reading);
  Future<void> removeDownload();
}
