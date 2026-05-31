import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

// MARK: Prayer - Sehri Window Card
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      gradient: LinearGradient(
        colors: [
          MyColors.secondary.withValues(alpha: isDark ? 0.13 : 0.07),
          MyColors.primaryLight.withValues(alpha: isDark ? 0.1 : 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: MyColors.secondary.withValues(alpha: 0.22),
      shadowColor: MyColors.secondary,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MyColors.secondary.withValues(alpha: isDark ? 0.2 : 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: MyColors.secondary,
              size: 21,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashboardPrayerSehri,
                  style: text.prayerTimelineNameActive.copyWith(
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeRange,
                  style: text.prayerTimelineTime.copyWith(color: hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${context.l10n.prayerViewSehriLast}: $lastTime',
            style: text.prayerStatusChip.copyWith(color: MyColors.secondary),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Daily Timeline Card
class PrayerTimelineCard extends StatelessWidget {
  const PrayerTimelineCard({super.key, required this.items});

  final List<PrayerTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900
              ? 6
              : constraints.maxWidth >= 620
              ? 3
              : 2;
          const gap = AppSpacing.sm;
          final itemWidth =
              (constraints.maxWidth - (columns - 1) * gap) / columns;
          final itemHeight = columns == 6 ? 82.0 : 88.0;

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final item in items)
                SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: _PrayerTimelineTile(item: item),
                ),
            ],
          );
        },
      ),
    );
  }
}

// MARK: Prayer - Timeline Tile
class _PrayerTimelineTile extends StatelessWidget {
  const _PrayerTimelineTile({required this.item});

  final PrayerTimelineItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = PrayerVisuals.accentFor(item.prayer);
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final active = item.isFocus || item.isNext;
    final text = AppTheme.text(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: active
            ? accent.withValues(alpha: isDark ? 0.16 : 0.09)
            : hintColor.withValues(alpha: isDark ? 0.08 : 0.045),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: active
              ? accent.withValues(alpha: 0.38)
              : hintColor.withValues(alpha: isDark ? 0.14 : 0.1),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: active
                        ? accent.withValues(alpha: isDark ? 0.2 : 0.13)
                        : hintColor.withValues(alpha: isDark ? 0.11 : 0.07),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Icon(
                    PrayerVisuals.iconFor(item.prayer),
                    color: active ? accent : hintColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (active
                                ? text.prayerTimelineNameActive
                                : text.prayerTimelineName)
                            .copyWith(color: active ? textColor : hintColor),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: _StatusChip(item: item, accent: accent),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.time,
                      style:
                          (active
                                  ? text.prayerTimelineTimeActive
                                  : text.prayerTimelineTime)
                              .copyWith(color: active ? accent : hintColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: Prayer - Timeline Status Chip
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.item, required this.accent});

  final PrayerTimelineItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final label = item.isFocus
        ? context.l10n.prayerViewFocus
        : item.isNext
        ? context.l10n.prayerViewNext
        : item.isPassed
        ? context.l10n.prayerViewPassed
        : context.l10n.prayerViewSoon;
    final chipColor = item.isFocus || item.isNext
        ? accent
        : (isDark ? MyColors.darkTextTertiary : MyColors.textTertiary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: chipColor.withValues(
          alpha: item.isFocus || item.isNext ? 0.13 : 0.08,
        ),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: text.prayerStatusChip.copyWith(color: chipColor),
      ),
    );
  }
}
