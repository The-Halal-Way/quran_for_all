import 'package:avro_phonetic_textfield/avro_phonetic_textfield.dart' as avro;

import '../../core/enums/app_language.dart';
import '../../core/constants/app_constants.dart';
import '../../core/quran/quran_bismillah.dart';

class AyahTranslation {
  const AyahTranslation({
    required this.text,
    required this.edition,
    required this.translator,
    required this.language,
  });

  final String text;
  final String edition;
  final String translator;
  final AppLanguage language;
}

class AyahModel {
  const AyahModel({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.juzNumber,
    required this.hizbQuarter,
    required this.pageNumber,
    required String arabicText,
    required this.transliterationEn,
    required this.transliterationBn,
    required this.translationEn,
    required this.translationBn,
    required this.tafsirEn,
    required this.tafsirBn,
    required this.audioUrl,
  }) : _arabicText = arabicText;

  final int id;
  final int surahId;
  final int ayahNumber;
  final int juzNumber;
  final int hizbQuarter;
  final int pageNumber;
  final String _arabicText;
  // Normalize on read so previously downloaded data is corrected offline,
  // without changing verse IDs, bookmarks or requiring a database migration.
  String get arabicText => QuranBismillah.verseText(
    surahId: surahId,
    ayahNumber: ayahNumber,
    text: _arabicText,
  );
  final String transliterationEn;
  final String transliterationBn;
  final String translationEn;
  final String translationBn;
  // These legacy database columns contain additional translations, not tafsir.
  final String tafsirEn;
  final String tafsirBn;
  final String audioUrl;

  String transliterationFor(AppLanguage language) {
    return language == AppLanguage.bangla
        ? transliterationBn
        : transliterationEn;
  }

  AyahTranslation? additionalTranslationFor(AppLanguage language) {
    final englishAdditional = _translationIfValid(
      tafsirEn,
      AppConstants.additionalEnglishEdition,
      AppConstants.additionalEnglishTranslator,
      AppLanguage.english,
    );
    final banglaAdditional = _translationIfValid(
      tafsirBn,
      AppConstants.additionalBanglaEdition,
      AppConstants.additionalBanglaTranslator,
      AppLanguage.bangla,
    );
    final englishPrimary = _translationIfValid(
      translationEn,
      AppConstants.englishEdition,
      AppConstants.englishTranslator,
      AppLanguage.english,
    );
    final banglaPrimary = _translationIfValid(
      translationBn,
      AppConstants.banglaEdition,
      AppConstants.banglaTranslator,
      AppLanguage.bangla,
    );

    if (language == AppLanguage.bangla) {
      return banglaAdditional ??
          banglaPrimary ??
          englishAdditional ??
          englishPrimary;
    }
    return englishAdditional ??
        englishPrimary ??
        banglaAdditional ??
        banglaPrimary;
  }

  static AyahTranslation? _translationIfValid(
    String text,
    String edition,
    String translator,
    AppLanguage language,
  ) {
    final clean = text.trim();
    if (clean.isEmpty ||
        (language == AppLanguage.bangla
            ? !_isBanglaScript(clean)
            : !_isLatinScript(clean))) {
      return null;
    }
    return AyahTranslation(
      text: clean,
      edition: edition,
      translator: translator,
      language: language,
    );
  }

  static String normalizeAdditionalTranslation(String text) => text.trim();

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

  static bool _isLatinScript(String text) {
    return RegExp(r'[A-Za-z]').hasMatch(text);
  }

  factory AyahModel.fromMergedApi({
    required int surahId,
    required Map<String, dynamic> arabicAyah,
    Map<String, dynamic>? transliterationEnAyah,
    Map<String, dynamic>? transliterationBnAyah,
    Map<String, dynamic>? englishTranslationAyah,
    Map<String, dynamic>? banglaTranslationAyah,
    Map<String, dynamic>? tafsirEnAyah,
    Map<String, dynamic>? tafsirBnAyah,
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
      tafsirEn: normalizeAdditionalTranslation(
        (tafsirEnAyah?['text'] as String?) ?? '',
      ),
      tafsirBn: normalizeAdditionalTranslation(
        (tafsirBnAyah?['text'] as String?) ?? '',
      ),
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
      tafsirEn: (map['tafsir_en'] as String?) ?? '',
      tafsirBn: (map['tafsir_bn'] as String?) ?? '',
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
      'tafsir_en': tafsirEn,
      'tafsir_bn': tafsirBn,
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
