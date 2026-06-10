import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

/// Returns the localized display name for a [TaskCategory].
String categoryLabel(BuildContext context, TaskCategory category) {
  final l10n = context.l10n;
  return switch (category) {
    TaskCategory.prayer => l10n.dailyTrackerCategoryPrayer,
    TaskCategory.nafl => l10n.dailyTrackerCategoryNafl,
    TaskCategory.dua => l10n.dailyTrackerCategoryDua,
    TaskCategory.sunnah => l10n.dailyTrackerCategorySunnah,
    TaskCategory.quran => l10n.dailyTrackerCategoryQuran,
    TaskCategory.tasbeeh => l10n.dailyTrackerCategoryTasbeeh,
    TaskCategory.hadith => l10n.dailyTrackerCategoryHadith,
  };
}

/// Returns the accent color used to represent a [TaskCategory].
Color categoryColor(TaskCategory category) {
  return switch (category) {
    TaskCategory.prayer => MyColors.secondary,
    TaskCategory.nafl => MyColors.primaryLight,
    TaskCategory.dua => MyColors.tertiary,
    TaskCategory.sunnah => MyColors.tertiaryDark,
    TaskCategory.quran => MyColors.primary,
    TaskCategory.tasbeeh => MyColors.secondaryLight,
    TaskCategory.hadith => MyColors.primaryLight,
  };
}

/// Section header shown above each category's tasks in the full Daily
/// Tracker view.
class CategoryHeaderWidget extends StatelessWidget {
  const CategoryHeaderWidget({
    super.key,
    required this.category,
    required this.textMain,
  });

  final TaskCategory category;
  final Color textMain;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final color = categoryColor(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Icon(category.icon, size: 16, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            categoryLabel(context, category),
            style: text.dashboardSectionTitle.copyWith(color: textMain),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.25), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
