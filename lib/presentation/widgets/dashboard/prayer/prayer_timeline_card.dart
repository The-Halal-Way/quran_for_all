import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

class PrayerTimelineCard extends StatelessWidget {
  const PrayerTimelineCard({super.key, required this.items});

  final List<PrayerTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _PrayerTimelineRow(item: items[index]),
            if (index != items.length - 1)
              Divider(
                height: AppSpacing.lg,
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.18),
              ),
          ],
        ],
      ),
    );
  }
}

class _PrayerTimelineRow extends StatelessWidget {
  const _PrayerTimelineRow({required this.item});

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

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: active
                ? accent.withValues(alpha: isDark ? 0.20 : 0.13)
                : hintColor.withValues(alpha: isDark ? 0.10 : 0.08),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: active
                  ? accent.withValues(alpha: 0.42)
                  : hintColor.withValues(alpha: 0.12),
            ),
          ),
          child: Icon(
            PrayerVisuals.iconFor(item.prayer),
            color: active ? accent : hintColor,
            size: 21,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (active
                            ? text.prayerTimelineNameActive
                            : text.prayerTimelineName)
                        .copyWith(color: active ? textColor : hintColor),
              ),
              const SizedBox(height: 4),
              _StatusChip(item: item, accent: accent),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
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
    );
  }
}

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
