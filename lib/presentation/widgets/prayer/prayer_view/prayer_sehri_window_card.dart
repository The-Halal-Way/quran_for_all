import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class PrayerSehriWindowCard extends StatelessWidget {
  const PrayerSehriWindowCard({
    super.key,
    required this.timeRange,
    required this.lastTime,
  });

  final String timeRange;
  final String lastTime;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: MyColors.secondary.withValues(alpha: isDark ? 0.13 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: MyColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.nightlight_round,
            color: MyColors.secondary,
            size: 21,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '${context.l10n.dashboardPrayerSehri}  $timeRange',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelMedium.copyWith(fontWeight: AppTheme.weightBold),
            ),
          ),
          Text(
            '${context.l10n.prayerViewSehriLast} $lastTime',
            style: text.labelSmall.copyWith(
              color: MyColors.secondary,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ],
      ),
    );
  }
}
