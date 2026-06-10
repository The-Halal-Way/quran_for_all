import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

/// Golden banner shown at the top of the Daily Tracker on Fridays,
/// highlighting the special Jumu'ah tasks added to the routine.
class FridayBannerWidget extends StatelessWidget {
  const FridayBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC9A227), Color(0xFFE9D27C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(Icons.mosque_rounded, color: MyColors.primary, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dailyTrackerFridayBannerTitle,
                  style: text.dashboardCardTitle.copyWith(
                    color: MyColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.dailyTrackerFridayBannerSubtitle,
                  style: text.bodySmall.copyWith(
                    color: MyColors.primary.withValues(alpha: 0.85),
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
