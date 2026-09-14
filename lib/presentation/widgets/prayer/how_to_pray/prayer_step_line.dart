import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class PrayerStepLine extends StatelessWidget {
  const PrayerStepLine({super.key, required this.index, required this.step});

  final int index;
  final PrayerGuidanceItem step;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final accent = index.isEven ? MyColors.secondary : MyColors.tertiary;
    final text = AppTheme.text(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.32)),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: text.prayerStepIndex.copyWith(color: accent),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: text.prayerTimelineNameActive.copyWith(
                  color: textColor,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                step.body,
                style: text.bodySmall.copyWith(color: subColor, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
