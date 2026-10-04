import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class SpecialPrayerPhrasePanel extends StatelessWidget {
  const SpecialPrayerPhrasePanel({
    super.key,
    required this.point,
    required this.accent,
  });

  final SpecialPrayerPoint point;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (point.arabic != null)
            Text(
              point.arabic!,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTheme.amiri(
                context,
                fontSize: 25,
                fontWeight: AppTheme.weightBold,
                color: isDark ? Colors.white : MyColors.textPrimary,
                height: 1.7,
                letterSpacing: 0,
              ),
            ),
          if (point.pronunciation != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              point.pronunciation!,
              style: text.prayerCardBodyEmphasis.copyWith(
                color: accent,
                letterSpacing: 0,
              ),
            ),
          ],
          if (point.translation != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              point.translation!,
              style: text.bodySmall.copyWith(
                color: bodyColor,
                height: 1.45,
                letterSpacing: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
