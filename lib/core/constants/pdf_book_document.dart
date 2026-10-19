import 'dart:ui';

enum PdfBookLanguage { english, bangla }

/// Source and publication details for one downloadable book.
class PdfBookDocument {
  const PdfBookDocument({
    required this.bookId,
    required this.language,
    required this.downloadUrl,
    this.title,
    this.author,
    this.sizeMegabytes,
  });

  final String bookId;
  final PdfBookLanguage language;
  final String downloadUrl;
  final String? title;
  final String? author;
  final double? sizeMegabytes;

  String get fileName => '${bookId}_${language.name}.pdf';
  String get preferencesKey => '${bookId}_reading_${language.name}_v1';
  int? get expectedBytes =>
      sizeMegabytes == null ? null : (sizeMegabytes! * 1024 * 1024).round();
  int get maximumBytes =>
      expectedBytes == null ? 512 * 1024 * 1024 : (expectedBytes! * 1.5).ceil();

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
}

/// Stable IDs keep downloads and page bookmarks separate for every book.
class PdfBookDefinition {
  const PdfBookDefinition({
    required this.id,
    required this.coverImage,
    required this.documents,
  });

  final String id;
  final String coverImage;
  final List<PdfBookDocument> documents;

  String get selectedLanguageKey => '${id}_selected_language';

  PdfBookDocument? fromLanguageName(String? name) {
    for (final document in documents) {
      if (document.language.name == name) return document;
    }
    return null;
  }

  PdfBookDocument forLocale(Locale locale) =>
      fromLanguageName(locale.languageCode == 'bn' ? 'bangla' : 'english') ??
      documents.first;
}
