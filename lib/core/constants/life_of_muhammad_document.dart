import '../theme/my_images.dart';
import 'pdf_book_document.dart';

abstract final class LifeOfMuhammadDocument {
  static const english = PdfBookDocument(
    bookId: 'life_of_muhammad',
    language: PdfBookLanguage.english,
    title: 'Life of Muhammad',
    author: 'Hazrat Mirza Bashiruddin Mahmud Ahmad',
    downloadUrl:
        'https://drive.google.com/file/d/14cYsCcgjPtS38cP50s7VvKtTXoyRe9Sd/view?usp=sharing',
    previewImage: MyImages.lifeOfMuhammadEn,
  );

  static const bangla = PdfBookDocument(
    bookId: 'life_of_muhammad',
    language: PdfBookLanguage.bangla,
    title: 'রসূলুল্লাহর (সল্লাল্লাহু আলাইহে ওয়াসাল্লাম) বিপ্লবী জীবন',
    author: 'আবু সালীম মুহাম্মদ আবদুল হাই',
    downloadUrl:
        'https://drive.google.com/file/d/1NqOoiDRbJXAvIQv4kcvw8FALV7tjuqZ2/view?usp=sharing',
    previewImage: MyImages.lifeOfMuhammadBn,
  );

  static const book = PdfBookDefinition(
    id: 'life_of_muhammad',
    documents: [english, bangla],
  );
}
