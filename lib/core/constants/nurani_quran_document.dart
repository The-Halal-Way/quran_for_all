import '../theme/my_images.dart';

enum NuraniQuranEdition { green, blue }

class NuraniQuranDocument {
  const NuraniQuranDocument._({
    required this.edition,
    required this.downloadUrl,
    required this.sizeMegabytes,
    required this.previewImage,
  });

  static const green = NuraniQuranDocument._(
    edition: NuraniQuranEdition.green,
    downloadUrl:
        'https://drive.google.com/file/d/1nNZU6ixs8NWKXH8cmTfGtL3-PK3grfGF/view?usp=sharing',
    sizeMegabytes: 158.3,
    previewImage: MyImages.nuraniQuranGreenReview,
  );
  static const blue = NuraniQuranDocument._(
    edition: NuraniQuranEdition.blue,
    downloadUrl:
        'https://drive.google.com/file/d/1dtSZ_SmzQ_wLM89jwZrawubRzX-AqLgQ/view?usp=sharing',
    sizeMegabytes: 157,
    previewImage: MyImages.nuraniQuranBlueReview,
  );
  static const editions = [green, blue];
  static const legacyMaximumBytes = 50 * 1024 * 1024;
  static const editionPreferencesKey = 'nurani_quran_selected_edition';

  // Existing installations can still open their original offline PDF and state.
  static const legacyFileName = 'nurani_quran.pdf';
  static const legacyPreferencesKey =
      'nurani_quran_reading_1dCZFwhF-VoXmVcfEzJzWx-dfhEx2Bs-2';

  final NuraniQuranEdition edition;
  final String downloadUrl;
  final double sizeMegabytes;
  final String previewImage;

  String get fileName => 'nurani_quran_${edition.name}.pdf';
  String get preferencesKey => 'nurani_quran_reading_${edition.name}_v2';
  int get expectedBytes => (sizeMegabytes * 1024 * 1024).round();

  /// Allow for rounded sizes while keeping downloads bounded per document.
  int get maximumBytes {
    final limit = (expectedBytes * 1.25).ceil();
    return limit > legacyMaximumBytes ? limit : legacyMaximumBytes;
  }

  /// Accepts a shared Drive link or a direct PDF URL when the source is changed.
  Uri get downloadUri {
    final uri = Uri.parse(downloadUrl);
    if (uri.host != 'drive.google.com') return uri;
    final segments = uri.pathSegments;
    final marker = segments.indexOf('d');
    final id = marker >= 0 && marker + 1 < segments.length
        ? segments[marker + 1]
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

  static NuraniQuranDocument? fromEditionName(String? name) {
    for (final document in editions) {
      if (document.edition.name == name) return document;
    }
    return null;
  }
}
