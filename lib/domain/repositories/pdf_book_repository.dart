import '../../core/constants/pdf_book_document.dart';
import '../entities/pdf_book_state.dart';

abstract class PdfBookRepository {
  Future<PdfBookLibrary> loadLibrary();

  Future<PdfBookLibrary> download({
    required PdfBookDocument document,
    required void Function(int bytes, int? total) onProgress,
  });

  void cancelDownload();

  Future<void> saveReading(PdfBookReadingState reading);

  Future<void> removeDownload();
}
