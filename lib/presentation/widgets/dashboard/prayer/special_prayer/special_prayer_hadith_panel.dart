import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';

class SpecialPrayerHadithPanel extends StatelessWidget {
  const SpecialPrayerHadithPanel({
    super.key,
    required this.references,
    required this.type,
  });

  final List<PrayerHadithReference> references;
  final SpecialPrayerType type;

  @override
  Widget build(BuildContext context) {
    final accent = type == SpecialPrayerType.janaza
        ? MyColors.tertiary
        : MyColors.secondary;

    return PrayerCardShell(
      borderColor: accent.withValues(alpha: 0.24),
      shadowColor: accent,
      child: Column(
        children: [
          for (var index = 0; index < references.length; index++) ...[
            _HadithReferenceTile(
              reference: references[index],
              index: index,
              accent: accent,
            ),
            if (index != references.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _HadithReferenceTile extends StatelessWidget {
  const _HadithReferenceTile({
    required this.reference,
    required this.index,
    required this.accent,
  });

  final PrayerHadithReference reference;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.055)
            : accent.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              index.isEven
                  ? Icons.menu_book_rounded
                  : Icons.manage_search_rounded,
              color: accent,
              size: 19,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reference.source,
                  style: text.prayerTimelineNameActive.copyWith(
                    color: titleColor,
                    height: 1.25,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  reference.body,
                  style: text.bodySmall.copyWith(
                    color: bodyColor,
                    height: 1.48,
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
