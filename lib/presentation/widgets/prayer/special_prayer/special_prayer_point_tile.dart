import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'special_prayer_phrase_panel.dart';

class SpecialPrayerPointTile extends StatelessWidget {
  const SpecialPrayerPointTile({
    super.key,
    required this.point,
    required this.index,
    required this.accent,
  });

  final SpecialPrayerPoint point;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final hasPhrase =
        point.arabic != null ||
        point.pronunciation != null ||
        point.translation != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.055)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PointMarker(
                label: point.badge ?? '${index + 1}',
                accent: accent,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.title,
                      style: text.prayerTimelineNameActive.copyWith(
                        color: titleColor,
                        height: 1.22,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      point.body,
                      style: text.bodySmall.copyWith(
                        color: bodyColor,
                        height: 1.48,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPhrase) ...[
            const SizedBox(height: AppSpacing.md),
            SpecialPrayerPhrasePanel(point: point, accent: accent),
          ],
        ],
      ),
    );
  }
}

class _PointMarker extends StatelessWidget {
  const _PointMarker({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);

    return Container(
      width: 42,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: text.prayerStatusChip.copyWith(
              color: accent,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
