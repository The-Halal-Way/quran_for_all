import '../theme/my_images.dart';
import 'pdf_book_document.dart';

abstract final class ScienceInQuranDocument {
  static const english = PdfBookDocument(
    bookId: 'science_in_quran',
    language: PdfBookLanguage.english,
    downloadUrl:
        'https://drive.google.com/file/d/1-HqyttfneYEHpFkGVPs1H0FSpZ-pJGFV/view?usp=sharing',
    sizeMegabytes: 2.7,
  );

  static const bangla = PdfBookDocument(
    bookId: 'science_in_quran',
    language: PdfBookLanguage.bangla,
    downloadUrl:
        'https://drive.google.com/file/d/1TlDOyWo-qSJjqYe-1Ms7uG4Wc3jgZQXe/view?usp=sharing',
    sizeMegabytes: 3,
  );

  static const book = PdfBookDefinition(
    id: 'science_in_quran',
    coverImage: MyImages.bookScienceCover,
    documents: [english, bangla],
  );
}
