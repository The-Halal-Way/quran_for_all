import 'package:flutter/material.dart';

/// Categories used to group items inside the Daily Tracker checklist.
enum TaskCategory { prayer, nafl, dua, sunnah, quran, tasbeeh, hadith }

extension TaskCategoryX on TaskCategory {
  String get code => switch (this) {
    TaskCategory.prayer => 'prayer',
    TaskCategory.nafl => 'nafl',
    TaskCategory.dua => 'dua',
    TaskCategory.sunnah => 'sunnah',
    TaskCategory.quran => 'quran',
    TaskCategory.tasbeeh => 'tasbeeh',
    TaskCategory.hadith => 'hadith',
  };

  /// Icon representing the category in the daily tracker UI.
  IconData get icon => switch (this) {
    TaskCategory.prayer => Icons.mosque_rounded,
    TaskCategory.nafl => Icons.nights_stay_rounded,
    TaskCategory.dua => Icons.auto_awesome_rounded,
    TaskCategory.sunnah => Icons.star_rounded,
    TaskCategory.quran => Icons.auto_stories_rounded,
    TaskCategory.tasbeeh => Icons.touch_app_rounded,
    TaskCategory.hadith => Icons.menu_book_rounded,
  };

  static TaskCategory fromCode(String? code) {
    switch (code) {
      case 'nafl':
        return TaskCategory.nafl;
      case 'dua':
        return TaskCategory.dua;
      case 'sunnah':
        return TaskCategory.sunnah;
      case 'quran':
        return TaskCategory.quran;
      case 'tasbeeh':
        return TaskCategory.tasbeeh;
      case 'hadith':
        return TaskCategory.hadith;
      case 'prayer':
      default:
        return TaskCategory.prayer;
    }
  }
}
