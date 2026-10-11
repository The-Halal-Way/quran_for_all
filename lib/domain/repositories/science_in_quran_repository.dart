import '../../core/constants/science_in_quran_document.dart';
import '../entities/science_in_quran_state.dart';

abstract class ScienceInQuranRepository {
  Future<ScienceInQuranLibrary> loadLibrary();

  Future<ScienceInQuranLibrary> download({
    required ScienceInQuranDocument document,
    required void Function(int bytes, int? total) onProgress,
  });

  void cancelDownload();

  Future<void> saveReading(ScienceInQuranReadingState reading);

  Future<void> removeDownload();
}
