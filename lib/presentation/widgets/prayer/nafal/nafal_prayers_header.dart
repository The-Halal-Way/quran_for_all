import 'package:flutter/material.dart';

import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'nafal_stat_chip.dart';

class NafalPrayersHeader extends StatelessWidget {
  const NafalPrayersHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? Colors.white : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MyColors.tertiary, MyColors.secondaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: MyColors.tertiary.withValues(alpha: isDark ? 0.34 : 0.2),
                blurRadius: 24,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Center(
            child: Text(
              context.l10n.prayerNafalArabicLabel,
              style: AppTheme.amiri(
                context,
                fontSize: 28,
                fontWeight: AppTheme.weightBold,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.prayerNafalTitle,
                style: text.prayerCardTitle.copyWith(
                  color: titleColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.prayerNafalSubtitle,
                style: text.prayerCardBody.copyWith(
                  color: bodyColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  NafalStatChip(
                    icon: Icons.timeline_rounded,
                    label: context.l10n.prayerNafalDailyFlowLabel,
                    accent: MyColors.tertiary,
                    isDark: isDark,
                  ),
                  NafalStatChip(
                    icon: Icons.tune_rounded,
                    label: context.l10n.prayerNafalFlexibleLabel,
                    accent: MyColors.secondary,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
