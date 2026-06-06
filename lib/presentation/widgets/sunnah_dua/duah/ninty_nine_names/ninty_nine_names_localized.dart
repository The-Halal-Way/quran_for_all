import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/data/models/dashboard/ninety_nine_names.dart';

extension NintyNineMetadataText on Metadata {
  String titleFor(AppLanguage language) {
    return language == AppLanguage.bangla ? banglaTitle : title;
  }

  String benefitFor(AppLanguage language) {
    return language == AppLanguage.bangla ? banglaBenefit : benefit;
  }

  String conclusionFor(AppLanguage language) {
    return language == AppLanguage.bangla ? banglaConclusion : conclusion;
  }
}

extension NintyNineVerseText on QuranVerse {
  String surahFor(AppLanguage language) {
    return language == AppLanguage.bangla ? banglaSurah : surah;
  }

  String textFor(AppLanguage language) {
    return language == AppLanguage.bangla ? banglaText : text;
  }
}

extension NintyNineNameText on Name {
  String transliterationFor(AppLanguage language) {
    return language == AppLanguage.bangla
        ? banglaTransliteration
        : transliteration;
  }

  String meaningFor(AppLanguage language) {
    return language == AppLanguage.bangla ? banglaMeaning : meaningEnglish;
  }
}
