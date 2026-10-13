import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
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
    required this.selectedPhraseLabel,
    required this.selectedRounds,
    required this.selectedTarget,
    required this.selectedProgress,
    required this.isDark,
  });

  final int totalCount;
  final int completedRounds;
  final int currentCount;
  final String selectedPhraseLabel;
  final int selectedRounds;
  final int selectedTarget;
  final double selectedProgress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Column(
        children: [
          _SelectedRoundHighlight(
            phraseLabel: selectedPhraseLabel,
            rounds: selectedRounds,
            target: selectedTarget,
            progress: selectedProgress,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
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
        ],
      ),
    );
  }
}

class _SelectedRoundHighlight extends StatelessWidget {
  const _SelectedRoundHighlight({
    required this.phraseLabel,
    required this.rounds,
    required this.target,
    required this.progress,
    required this.isDark,
  });

  final String phraseLabel;
  final int rounds;
  final int target;
  final double progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = isDark
        ? MyColors.secondaryLight
        : AppThemeColors.light.brand;
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: isDark ? 0.22 : 0.1),
            scheme.surface.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes_rounded, size: 17, color: accent),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  phraseLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelLarge.copyWith(
                    color: scheme.onSurface,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              Text(
                '$rounds ${context.l10n.tasbeehRounds}',
                style: text.labelMedium.copyWith(
                  color: accent,
                  fontWeight: AppTheme.weightExtraBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: accent.withValues(alpha: 0.12),
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${(progress * target).round()} / $target',
                style: text.labelSmall.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
