import '../../core/enums/app_language.dart';

class AyahModel {
  const AyahModel({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.juzNumber,
    required this.hizbQuarter,
    required this.pageNumber,
    required this.arabicText,
    required this.transliterationEn,
    required this.transliterationBn,
    required this.translationEn,
    required this.translationBn,
    required this.audioUrl,
  });

  final int id;
  final int surahId;
  final int ayahNumber;
  final int juzNumber;
  final int hizbQuarter;
  final int pageNumber;
  final String arabicText;
  final String transliterationEn;
  final String transliterationBn;
  final String translationEn;
  final String translationBn;
  final String audioUrl;

  String transliterationFor(AppLanguage language) {
    if (language == AppLanguage.bangla && transliterationBn.isNotEmpty) {
      return transliterationBn;
    }
    return transliterationEn;
  }

  factory AyahModel.fromMergedApi({
    required int surahId,
    required Map<String, dynamic> arabicAyah,
    Map<String, dynamic>? transliterationEnAyah,
    Map<String, dynamic>? transliterationBnAyah,
    Map<String, dynamic>? englishTranslationAyah,
    Map<String, dynamic>? banglaTranslationAyah,
    required String audioBaseUrl,
  }) {
    final globalNumber = _toInt(arabicAyah['number']);

    return AyahModel(
      id: globalNumber,
      surahId: surahId,
      ayahNumber: _toInt(arabicAyah['numberInSurah']),
      juzNumber: _toInt(arabicAyah['juz']),
      hizbQuarter: _toInt(arabicAyah['hizbQuarter']),
      pageNumber: _toInt(arabicAyah['page']),
      arabicText: (arabicAyah['text'] as String?) ?? '',
      transliterationEn: (transliterationEnAyah?['text'] as String?) ?? '',
      transliterationBn: (transliterationBnAyah?['text'] as String?) ?? '',
      translationEn: (englishTranslationAyah?['text'] as String?) ?? '',
      translationBn: (banglaTranslationAyah?['text'] as String?) ?? '',
      audioUrl: '$audioBaseUrl/$globalNumber.mp3',
    );
  }

  factory AyahModel.fromMap(Map<String, Object?> map) {
    return AyahModel(
      id: _toInt(map['id']),
      surahId: _toInt(map['surah_id']),
      ayahNumber: _toInt(map['ayah_number']),
      juzNumber: _toInt(map['juz_number']),
      hizbQuarter: _toInt(map['hizb_quarter']),
      pageNumber: _toInt(map['page_number']),
      arabicText: (map['arabic_text'] as String?) ?? '',
      transliterationEn: (map['transliteration_en'] as String?) ?? '',
      transliterationBn: (map['transliteration_bn'] as String?) ?? '',
      translationEn: (map['translation_en'] as String?) ?? '',
      translationBn: (map['translation_bn'] as String?) ?? '',
      audioUrl: (map['audio_url'] as String?) ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'juz_number': juzNumber,
      'hizb_quarter': hizbQuarter,
      'page_number': pageNumber,
      'arabic_text': arabicText,
      'transliteration_en': transliterationEn,
      'transliteration_bn': transliterationBn,
      'translation_en': translationEn,
      'translation_bn': translationBn,
      'audio_url': audioUrl,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
