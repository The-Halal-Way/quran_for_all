import '../shared/prayer_card_shell.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'prayer_movement_hadith_line.dart';

class PrayerMovementHadithPanel extends StatelessWidget {
  const PrayerMovementHadithPanel({super.key, required this.hadiths});

  final List<PrayerHadithReference> hadiths;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      borderColor: MyColors.tertiary.withValues(alpha: 0.22),
      shadowColor: MyColors.tertiary,
      gradient: LinearGradient(
        colors: [
          MyColors.tertiary.withValues(alpha: isDark ? 0.14 : 0.07),
          MyColors.secondary.withValues(alpha: isDark ? 0.10 : 0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: MyColors.tertiary.withValues(
                    alpha: isDark ? 0.20 : 0.13,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: MyColors.tertiary.withValues(alpha: 0.30),
                  ),
                ),
                child: const Icon(
                  Icons.format_quote_rounded,
                  color: MyColors.tertiary,
                  size: 21,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.prayerMovementsHadithTitle,
                      style: text.prayerCardTitle.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.prayerMovementsHadithSubtitle,
                      style: text.prayerCardBody.copyWith(
                        color: bodyColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var index = 0; index < hadiths.length; index++) ...[
            PrayerMovementHadithLine(reference: hadiths[index]),
            if (index != hadiths.length - 1)
              Divider(
                height: AppSpacing.xxl,
                color: (isDark ? MyColors.darkDivider : MyColors.divider)
                    .withValues(alpha: 0.62),
              ),
          ],
        ],
      ),
    );
  }
}
