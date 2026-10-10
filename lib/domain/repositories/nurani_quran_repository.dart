import '../../core/constants/nurani_quran_document.dart';
import '../entities/quran/nurani_quran_state.dart';

abstract class NuraniQuranRepository {
  Future<NuraniQuranLibrary> loadLibrary();
  Future<NuraniQuranLibrary> download({
    required NuraniQuranDocument document,
    required void Function(int bytes, int? total) onProgress,
  });
  void cancelDownload();
  Future<void> saveReading(NuraniQuranReadingState reading);
  Future<void> removeDownload();
}
