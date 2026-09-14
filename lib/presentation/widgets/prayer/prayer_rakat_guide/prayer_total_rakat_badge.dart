import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class PrayerTotalRakatBadge extends StatelessWidget {
  const PrayerTotalRakatBadge({
    super.key,
    required this.count,
    required this.accent,
  });

  final int count;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 66),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.28), width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: text.prayerHeroTime.copyWith(
              color: accent,
              fontSize: 26,
              height: 0.9,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.prayerRakatUnitLabel,
            style: text.prayerStatusChip.copyWith(color: accent, height: 1),
          ),
        ],
      ),
    );
  }
}
