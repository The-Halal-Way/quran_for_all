import '../../core/enums/app_language.dart';
import 'package:avro_phonetic_textfield/avro_phonetic_textfield.dart' as avro;

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
    return language == AppLanguage.bangla
        ? transliterationBn
        : transliterationEn;
  }

  static String normalizeBanglaPronunciation({
    required String transliterationEn,
    required String transliterationBn,
  }) {
    final bn = transliterationBn.trim();
    if (bn.isNotEmpty && _isBanglaScript(bn)) {
      return bn;
    }

    final en = transliterationEn.trim();
    if (en.isEmpty) {
      return '';
    }

    return avro.parse(_sanitizeForAvro(en));
  }

  static String _sanitizeForAvro(String input) {
    return input
        .toLowerCase()
        // API occasionally uses "lyya" where "iyya" is intended.
        .replaceAll(RegExp(r'\blyy'), 'iyy')
        // Apostrophes for ayin/hamza break Avro parsing and render literally.
        .replaceAll(RegExp(r"[`'’]"), '')
        // Avro tends to over-elongate when fed repeated "a" in this dataset.
        .replaceAll(RegExp(r'a{2,}'), 'a')
        .replaceAll(RegExp(r'[^a-z\s-]'), ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static bool _isBanglaScript(String text) {
    return RegExp(r'[\u0980-\u09FF]').hasMatch(text);
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
      transliterationBn: normalizeBanglaPronunciation(
        transliterationEn: (transliterationEnAyah?['text'] as String?) ?? '',
        transliterationBn: (transliterationBnAyah?['text'] as String?) ?? '',
      ),
      translationEn: (englishTranslationAyah?['text'] as String?) ?? '',
      translationBn: (banglaTranslationAyah?['text'] as String?) ?? '',
      audioUrl: '$audioBaseUrl/$globalNumber.mp3',
    );
  }

  factory AyahModel.fromMap(Map<String, Object?> map) {
    final transliterationEn = (map['transliteration_en'] as String?) ?? '';
    final transliterationBn = (map['transliteration_bn'] as String?) ?? '';

    return AyahModel(
      id: _toInt(map['id']),
      surahId: _toInt(map['surah_id']),
      ayahNumber: _toInt(map['ayah_number']),
      juzNumber: _toInt(map['juz_number']),
      hizbQuarter: _toInt(map['hizb_quarter']),
      pageNumber: _toInt(map['page_number']),
      arabicText: (map['arabic_text'] as String?) ?? '',
      transliterationEn: transliterationEn,
      transliterationBn: normalizeBanglaPronunciation(
        transliterationEn: transliterationEn,
        transliterationBn: transliterationBn,
      ),
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
