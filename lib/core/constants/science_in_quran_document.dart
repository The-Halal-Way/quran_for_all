import 'dart:ui';

import '../theme/my_images.dart';

enum ScienceInQuranLanguage { english, bangla }

/// A downloadable language edition of the Science in Quran booklet.
///
/// Add future book editions to [documents] and keep their source details here
/// so the UI and storage flow stay independent from the download URLs.
class ScienceInQuranDocument {
  const ScienceInQuranDocument._({
    required this.language,
    required this.downloadUrl,
    required this.sizeMegabytes,
    required this.previewImage,
  });

  static const english = ScienceInQuranDocument._(
    language: ScienceInQuranLanguage.english,
    downloadUrl:
        'https://drive.google.com/file/d/1-HqyttfneYEHpFkGVPs1H0FSpZ-pJGFV/view?usp=sharing',
    sizeMegabytes: 2.7,
    previewImage: MyImages.bookScienceEng,
  );

  static const bangla = ScienceInQuranDocument._(
    language: ScienceInQuranLanguage.bangla,
    downloadUrl:
        'https://drive.google.com/file/d/1TlDOyWo-qSJjqYe-1Ms7uG4Wc3jgZQXe/view?usp=sharing',
    sizeMegabytes: 3,
    previewImage: MyImages.bookScienceBn,
  );

  static const documents = [english, bangla];
  static const selectedLanguageKey = 'science_in_quran_selected_language';

  final ScienceInQuranLanguage language;
  final String downloadUrl;
  final double sizeMegabytes;
  final String previewImage;

  String get fileName => 'science_in_quran_${language.name}.pdf';
  String get preferencesKey => 'science_in_quran_reading_${language.name}_v1';
  int get expectedBytes => (sizeMegabytes * 1024 * 1024).round();
  int get maximumBytes => (expectedBytes * 1.5).ceil();

  Uri get downloadUri {
    final uri = Uri.parse(downloadUrl);
    if (uri.host != 'drive.google.com') return uri;
    final marker = uri.pathSegments.indexOf('d');
    final id = marker >= 0 && marker + 1 < uri.pathSegments.length
        ? uri.pathSegments[marker + 1]
        : uri.queryParameters['id'];
    if (id == null || id.isEmpty) {
      throw const FormatException('The Google Drive link has no file ID');
    }
    return Uri.https('drive.usercontent.google.com', '/download', {
      'id': id,
      'export': 'download',
      'confirm': 't',
    });
  }

  static ScienceInQuranDocument? fromLanguageName(String? name) {
    for (final document in documents) {
      if (document.language.name == name) return document;
    }
    return null;
  }

  static ScienceInQuranDocument forLocale(Locale locale) =>
      locale.languageCode.toLowerCase() == 'bn' ? bangla : english;
}
