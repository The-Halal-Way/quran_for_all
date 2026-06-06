import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

// MARK: Prayer - Rakat Guide Entry Card
class PrayerRakatGuideCard extends StatelessWidget {
  const PrayerRakatGuideCard({
    super.key,
    required this.items,
    required this.focusPrayer,
  });

  final List<PrayerRakatPlan> items;
  final PrayerKey focusPrayer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => _showRakatGuideSheet(context),
        child: PrayerCardShell(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: MyColors.secondary.withValues(
                        alpha: isDark ? 0.2 : 0.12,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.format_list_numbered_rounded,
                      color: MyColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.prayerRakatGuideTitle,
                          style: text.hadithTitle.copyWith(
                            color: textColor,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.prayerRakatGuideSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall.copyWith(
                            color: hintColor,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: hintColor,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Keep the home tab light: counts stay visible at first glance,
              // while partition details move into the on-demand bottom sheet.
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final item in items)
                    _RakatCountChip(
                      item: item,
                      isFocus: item.prayer == focusPrayer,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.open_in_full_rounded,
                    size: 16,
                    color: MyColors.secondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.prayerRakatViewDetails,
                    style: TextStyle(color: MyColors.secondary, height: 1.2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: Prayer - Rakat Guide Bottom Sheet Launcher
  Future<void> _showRakatGuideSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _PrayerRakatGuideSheet(items: items, focusPrayer: focusPrayer),
    );
  }
}

// MARK: Prayer - Rakat Guide Bottom Sheet
class _PrayerRakatGuideSheet extends StatelessWidget {
  const _PrayerRakatGuideSheet({
    required this.items,
    required this.focusPrayer,
  });

  final List<PrayerRakatPlan> items;
  final PrayerKey focusPrayer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, controller) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: hintColor.withValues(alpha: 0.26),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.prayerRakatGuideTitle,
                            style: text.hadithTitle.copyWith(
                              color: textColor,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.l10n.prayerRakatGuideSubtitle,
                            style: text.bodySmall.copyWith(
                              color: hintColor,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: hintColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                // MARK: Prayer - Rakat Detail List
                child: ListView.separated(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _PrayerRakatPlanTile(
                      item: item,
                      isFocus: item.prayer == focusPrayer,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// MARK: Prayer - Compact Rakat Count Chip
class _RakatCountChip extends StatelessWidget {
  const _RakatCountChip({required this.item, required this.isFocus});

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

    return Container(
      constraints: const BoxConstraints(minWidth: 88, minHeight: 52),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isFocus
            ? accent.withValues(alpha: isDark ? 0.2 : 0.12)
            : hintColor.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isFocus
              ? accent.withValues(alpha: 0.42)
              : hintColor.withValues(alpha: isDark ? 0.14 : 0.1),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PrayerVisuals.iconFor(item.prayer), color: accent, size: 17),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${item.totalRakats}',
            style: text.prayerStepIndex.copyWith(color: accent, height: 1),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            item.name,
            style: text.prayerStatusChip.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Rakat Prayer Detail Tile
class _PrayerRakatPlanTile extends StatelessWidget {
  const _PrayerRakatPlanTile({required this.item, required this.isFocus});

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
                _TotalRakatBadge(count: item.totalRakats, accent: accent),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final segment in item.segments)
                  _RakatSegmentChip(segment: segment, accent: accent),
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

// MARK: Prayer - Highlighted Rakat Total Badge
class _TotalRakatBadge extends StatelessWidget {
  const _TotalRakatBadge({required this.count, required this.accent});

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

// MARK: Prayer - Rakat Partition Chip
class _RakatSegmentChip extends StatelessWidget {
  const _RakatSegmentChip({required this.segment, required this.accent});

  final PrayerRakatSegment segment;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final labelColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: accent.withValues(alpha: 0.16), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${segment.count}',
            style: text.prayerStepIndex.copyWith(color: accent, height: 1),
          ),
          const SizedBox(width: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.prayerStatusChip.copyWith(
                    color: labelColor,
                    height: 1.1,
                  ),
                ),
                Text(
                  segment.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall.copyWith(color: subColor, height: 1.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
