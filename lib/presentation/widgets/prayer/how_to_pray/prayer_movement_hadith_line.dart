import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class PrayerMovementHadithLine extends StatelessWidget {
  const PrayerMovementHadithLine({super.key, required this.reference});

  final PrayerHadithReference reference;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: MyColors.secondary.withValues(alpha: isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: MyColors.secondary,
            size: 16,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reference.body,
                style: text.prayerCardBodyEmphasis.copyWith(color: bodyColor),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${context.l10n.prayerMovementsHadithSourceLabel}: '
                '${reference.source}',
                style: text.prayerStatusChip.copyWith(
                  color: MyColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
