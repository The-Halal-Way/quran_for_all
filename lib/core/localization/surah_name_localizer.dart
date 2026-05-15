import 'package:flutter/widgets.dart';
import 'package:avro_phonetic_textfield/avro_phonetic_textfield.dart' as avro;

import '../enums/app_language.dart';
import '../../data/models/surah_model.dart';

extension SurahNameLocalizer on SurahModel {
  String localizedTitle(BuildContext context, AppLanguage language) {
    final _ = context;
    final english = nameEnglish.trim();
    final translated = nameTranslated.trim();
    final arabic = nameArabic.trim();

    if (language == AppLanguage.bangla) {
      if (english.isNotEmpty) {
        final banglaPronunciation = _toBanglaPronunciation(english);
        if (banglaPronunciation.isNotEmpty) {
          return banglaPronunciation;
        }
      }

      if (english.isNotEmpty) {
        return english;
      }
      if (translated.isNotEmpty) {
        return translated;
      }
      return arabic;
    }

    if (english.isNotEmpty) {
      return english;
    }

    if (translated.isNotEmpty) {
      return translated;
    }

    return arabic;
  }

  String _toBanglaPronunciation(String value) {
    final normalized = value
        .toLowerCase()
        .replaceAll(RegExp(r"[`'’]"), '')
        .replaceAll(RegExp(r'[^a-z\s-]'), ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.isEmpty) {
      return '';
    }

    return avro.parse(normalized).trim();
  }
}
