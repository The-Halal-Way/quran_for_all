import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';

// MARK: Prayer - Special Prayer Note Card
class SpecialPrayerNoteCard extends StatelessWidget {
  const SpecialPrayerNoteCard({
    super.key,
    required this.note,
    required this.type,
  });

  final PrayerGuidanceItem note;
  final SpecialPrayerType type;

  @override
  Widget build(BuildContext context) {
    final accent = type == SpecialPrayerType.janaza
        ? MyColors.primaryLight
        : MyColors.tertiary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      margin: const EdgeInsets.only(top: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: accent.withValues(alpha: 0.22),
      gradient: LinearGradient(
        colors: [
          accent.withValues(alpha: isDark ? 0.13 : 0.07),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: accent, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: text.prayerStepIndex.copyWith(
                    color: titleColor,
                    height: 1.25,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  note.body,
                  style: text.bodySmall.copyWith(
                    color: bodyColor,
                    height: 1.45,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
