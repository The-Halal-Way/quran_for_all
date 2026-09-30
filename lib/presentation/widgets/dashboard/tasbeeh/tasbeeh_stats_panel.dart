import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme_colors.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

import 'tasbeeh_stats_divider.dart';
import 'tasbeeh_stats_metric.dart';

class TasbeehStatsPanel extends StatelessWidget {
  const TasbeehStatsPanel({
    super.key,
    required this.totalCount,
    required this.completedRounds,
    required this.currentCount,
    required this.isDark,
  });

  final int totalCount;
  final int completedRounds;
  final int currentCount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [scheme.surfaceContainerHigh, scheme.surfaceContainerLow]
              : [
                  AppThemeColors.light.surface,
                  AppThemeColors.light.surfaceElevated,
                ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: TasbeehStatsMetric(
              label: context.l10n.tasbeehCurrent,
              value: '$currentCount',
              color: isDark
                  ? MyColors.secondaryLight
                  : AppThemeColors.light.coral,
              foreground: foreground,
            ),
          ),
          const TasbeehStatsDivider(),
          Expanded(
            child: TasbeehStatsMetric(
              label: context.l10n.tasbeehTotal,
              value: '$totalCount',
              color: isDark
                  ? MyColors.tertiaryLight
                  : AppThemeColors.light.cyan,
              foreground: foreground,
            ),
          ),
          const TasbeehStatsDivider(),
          Expanded(
            child: TasbeehStatsMetric(
              label: context.l10n.tasbeehRounds,
              value: '$completedRounds',
              color: isDark
                  ? MyColors.primaryLight
                  : AppThemeColors.light.brand,
              foreground: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
