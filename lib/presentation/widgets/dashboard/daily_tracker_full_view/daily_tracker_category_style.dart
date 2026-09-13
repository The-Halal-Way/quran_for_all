import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/daily_task_model.dart';

String trackerCategoryLabel(BuildContext context, TaskCategory category) {
  final l10n = context.l10n;
  return switch (category) {
    TaskCategory.prayer => l10n.dailyTrackerCategoryPrayer,
    TaskCategory.nafl => l10n.dailyTrackerCategoryNafl,
    TaskCategory.dua => l10n.dailyTrackerCategoryDua,
    TaskCategory.sunnah => l10n.dailyTrackerCategorySunnah,
    TaskCategory.quran => l10n.dailyTrackerCategoryQuran,
    TaskCategory.tasbeeh => l10n.dailyTrackerCategoryTasbeeh,
    TaskCategory.hadith => l10n.dailyTrackerCategoryHadith,
    TaskCategory.custom => l10n.dailyTrackerCategoryCustom,
  };
}

Color trackerCategoryColor(BuildContext context, TaskCategory category) {
  final base = switch (category) {
    TaskCategory.prayer || TaskCategory.tasbeeh => MyColors.secondary,
    TaskCategory.nafl ||
    TaskCategory.quran ||
    TaskCategory.hadith => MyColors.primaryLight,
    TaskCategory.dua || TaskCategory.sunnah => MyColors.tertiaryDark,
    TaskCategory.custom => MyColors.info,
  };
  return Theme.of(context).brightness == Brightness.dark
      ? Color.lerp(base, Colors.white, 0.48)!
      : base;
}

String trackerTaskTitle(BuildContext context, DailyTask task) {
  // Custom tasks store user-entered supporting text in titleBn, not a translation.
  if (task.category == TaskCategory.custom) return task.titleEn;
  final localized = task.localizedTitle(context.l10n.localeName);
  return localized.isEmpty ? task.titleEn : localized;
}
