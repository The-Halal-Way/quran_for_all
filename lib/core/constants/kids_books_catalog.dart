import '../theme/my_images.dart';
import 'pdf_book_document.dart';

/// Publication details and sources live here; no PDFs are fetched at startup.
abstract final class KidsBooksCatalog {
  static const sahabah = PdfBookDefinition(
    id: 'kids_sahabah_stories',
    documents: [
      PdfBookDocument(
        bookId: 'kids_sahabah_stories',
        language: PdfBookLanguage.english,
        title: 'Stories of the Sahabah for Little Muslims',
        downloadUrl:
            'https://drive.google.com/file/d/1DjcMxY4zixo_bw_iidGfDh-bQr-CIoj9/view?usp=sharing',
        sizeMegabytes: 11.8,
        previewImage: MyImages.sahabaStoriesCover,
      ),
      PdfBookDocument(
        bookId: 'kids_sahabah_stories',
        language: PdfBookLanguage.bangla,
        title: 'ছোট্ট মুসলিমদের জন্য সাহাবিদের গল্প',
        downloadUrl:
            'https://drive.google.com/file/d/1tTkj57z2mqrdpbD2zOKtdO4MRkjMwD7x/view?usp=sharing',
        sizeMegabytes: 8.8,
        previewImage: MyImages.sahabaStoriesCover,
      ),
    ],
  );

  static const prophets = PdfBookDefinition(
    id: 'kids_prophets_stories',
    documents: [
      PdfBookDocument(
        bookId: 'kids_prophets_stories',
        language: PdfBookLanguage.english,
        title: 'Stories of the Prophets for Little Hearts',
        downloadUrl:
            'https://drive.google.com/file/d/1sMWibEBuz01rgl_hrw_1wsd1THbr2C7J/view?usp=sharing',
        sizeMegabytes: 5.4,
        previewImage: MyImages.prophetsStoriesCover,
      ),
      PdfBookDocument(
        bookId: 'kids_prophets_stories',
        language: PdfBookLanguage.bangla,
        title: 'ছোট হৃদয়ের জন্য নবীদের গল্প',
        downloadUrl:
            'https://drive.google.com/file/d/1JaPH9Vv-oKMHA1VAvxiQyjtOS_Z9SjvL/view?usp=sharing',
        sizeMegabytes: 4.3,
        previewImage: MyImages.prophetsStoriesCover,
      ),
    ],
  );

  static const prophetLife = PdfBookDefinition(
    id: 'kids_prophet_muhammad_life',
    documents: [
      PdfBookDocument(
        bookId: 'kids_prophet_muhammad_life',
        language: PdfBookLanguage.english,
        title: 'The Life of Prophet Muhammad (SAW)',
        downloadUrl:
            'https://drive.google.com/file/d/1WWLjVlL03FoE-d8gyX3p4iDuW9Lkeqcx/view?usp=sharing',
        sizeMegabytes: 10.6,
        previewImage: MyImages.lifeOfProphetCover,
      ),
      PdfBookDocument(
        bookId: 'kids_prophet_muhammad_life',
        language: PdfBookLanguage.bangla,
        title: 'মহানবী মুহাম্মদ (সা.)-এর জীবন',
        downloadUrl:
            'https://drive.google.com/file/d/1NCouafP91COy8uLp09PNo0n64jIjX52f/view?usp=sharing',
        sizeMegabytes: 30.2,
        previewImage: MyImages.lifeOfProphetCover,
      ),
    ],
  );

  static const fortyHadith = PdfBookDefinition(
    id: 'kids_forty_hadith_stories',
    documents: [
      PdfBookDocument(
        bookId: 'kids_forty_hadith_stories',
        language: PdfBookLanguage.english,
        title: '40 Hadiths for Children with Stories',
        downloadUrl:
            'https://drive.google.com/file/d/1Smw2EetTXDjDp-obY2JNrQ4uIIt_ZP_J/view?usp=sharing',
        sizeMegabytes: 2.4,
        previewImage: MyImages.fortyHadithStoriesCover,
      ),
      PdfBookDocument(
        bookId: 'kids_forty_hadith_stories',
        language: PdfBookLanguage.bangla,
        title: '৪০টি শিশুদের জন্য হাদিস গল্পে গল্প',
        downloadUrl:
            'https://drive.google.com/file/d/1WpSc-6X3KWG5d9kGITqTMpWZt6z7kNZp/view?usp=sharing',
        sizeMegabytes: 2.3,
        previewImage: MyImages.fortyHadithStoriesCover,
      ),
    ],
  );

  static const books = [sahabah, prophets, prophetLife, fortyHadith];
}
