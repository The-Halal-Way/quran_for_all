import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Categories used to group items inside the Daily Tracker checklist.
enum TaskCategory { prayer, nafl, dua, sunnah, quran, tasbeeh, hadith, custom }

extension TaskCategoryX on TaskCategory {
  String get code => switch (this) {
    TaskCategory.prayer => 'prayer',
    TaskCategory.nafl => 'nafl',
    TaskCategory.dua => 'dua',
    TaskCategory.sunnah => 'sunnah',
    TaskCategory.quran => 'quran',
    TaskCategory.tasbeeh => 'tasbeeh',
    TaskCategory.hadith => 'hadith',
    TaskCategory.custom => 'custom',
  };

  /// Icon representing the category in the daily tracker UI.
  IconData get icon => switch (this) {
    TaskCategory.prayer => Icons.mosque_rounded,
    TaskCategory.nafl => CupertinoIcons.moon_stars_fill,
    TaskCategory.dua => CupertinoIcons.sparkles,
    TaskCategory.sunnah => CupertinoIcons.heart_fill,
    TaskCategory.quran => CupertinoIcons.book_fill,
    TaskCategory.tasbeeh => CupertinoIcons.hand_draw_fill,
    TaskCategory.hadith => CupertinoIcons.doc_text_fill,
    TaskCategory.custom => CupertinoIcons.checkmark_alt_circle_fill,
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
      case 'custom':
        return TaskCategory.custom;
      case 'prayer':
      default:
        return TaskCategory.prayer;
    }
  }
}
