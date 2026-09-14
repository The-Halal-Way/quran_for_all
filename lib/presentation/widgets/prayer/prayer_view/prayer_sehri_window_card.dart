import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

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
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.secondary.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.nightlight_round, color: colors.secondary, size: 23),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      context.l10n.dashboardPrayerSehri,
                      style: text.labelMedium.copyWith(
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                    Text(
                      '${context.l10n.prayerViewSehriLast} $lastTime',
                      style: text.labelSmall.copyWith(
                        color: colors.secondary,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  timeRange,
                  style: text.bodySmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
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
