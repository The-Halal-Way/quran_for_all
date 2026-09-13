import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DailyTrackerFridayBanner extends StatelessWidget {
  const DailyTrackerFridayBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? MyColors.tertiaryLight : MyColors.tertiaryDark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.mosque_rounded, color: accent, size: 26),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dailyTrackerFridayBannerTitle,
                  style: AppTheme.text(context).titleSmall.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.dailyTrackerFridayBannerSubtitle,
                  style: AppTheme.text(context).bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
