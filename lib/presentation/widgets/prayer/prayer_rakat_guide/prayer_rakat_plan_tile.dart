import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import '../prayer_visuals.dart';

import 'prayer_total_rakat_badge.dart';
import 'prayer_rakat_segment_chip.dart';

class PrayerRakatPlanTile extends StatelessWidget {
  const PrayerRakatPlanTile({
    super.key,
    required this.item,
    required this.isFocus,
  });

  final PrayerRakatPlan item;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = PrayerVisuals.accentFor(item.prayer);
    final text = AppTheme.text(context);
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isFocus
            ? accent.withValues(alpha: isDark ? 0.15 : 0.08)
            : hintColor.withValues(alpha: isDark ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isFocus
              ? accent.withValues(alpha: 0.36)
              : hintColor.withValues(alpha: isDark ? 0.14 : 0.1),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.22 : 0.13),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    PrayerVisuals.iconFor(item.prayer),
                    color: accent,
                    size: 19,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.prayerTimelineNameActive.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                PrayerTotalRakatBadge(count: item.totalRakats, accent: accent),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final segment in item.segments)
                  PrayerRakatSegmentChip(segment: segment, accent: accent),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.note,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall.copyWith(color: hintColor, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
