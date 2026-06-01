import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';

class SettingsHijriCalendarCard extends StatelessWidget {
  const SettingsHijriCalendarCard({
    super.key,
    required this.adjustment,
    required this.onAdjustmentChanged,
  });

  final int adjustment;
  final ValueChanged<int> onAdjustmentChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.calendar_month_rounded,
            title: context.l10n.settingsHijriCalendarTitle,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.settingsHijriAdjustmentTitle,
                  style: text.titleMedium.copyWith(
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.settingsHijriAdjustmentSubtitle,
                  style: text.bodySmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.68),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<int>(
                    segments: [
                      ButtonSegment<int>(
                        value: -1,
                        icon: const Icon(Icons.remove_rounded, size: 18),
                        label: Text(context.l10n.hijriAdjustmentMinusLabel),
                      ),
                      ButtonSegment<int>(
                        value: 0,
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: Text(
                          context.l10n.hijriAdjustmentCalculatedLabel,
                        ),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(context.l10n.hijriAdjustmentPlusLabel),
                      ),
                    ],
                    selected: {adjustment},
                    onSelectionChanged: (selected) {
                      onAdjustmentChanged(selected.first);
                    },
                    style: SegmentedButton.styleFrom(
                      selectedForegroundColor: colorScheme.onPrimary,
                      selectedBackgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onSurface,
                    ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final boxSize = responsive.pick(mobile: 34, tablet: 30, desktop: 34);
    final iconSize = responsive.pick(mobile: 18, tablet: 16.5, desktop: 18.5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg - 2,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.compact),
            ),
            child: Icon(icon, color: colorScheme.primary, size: iconSize),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Text(
              title,
              style: AppTheme.text(
                context,
              ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
            ),
          ),
        ],
      ),
    );
  }
}
