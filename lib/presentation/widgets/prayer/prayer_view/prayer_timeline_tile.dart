import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_visuals.dart';

class PrayerTimelineTile extends StatelessWidget {
  const PrayerTimelineTile({super.key, required this.item});

  final PrayerTimelineItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = PrayerVisuals.accentFor(item.prayer);
    final active = item.isFocus || item.isCurrent;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: active
            ? LinearGradient(
                colors: [surface, Color.lerp(surface, accent, 0.14)!],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )
            : null,
        color: active ? null : surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: active
              ? accent.withValues(alpha: 0.42)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PrayerVisuals.iconFor(item.prayer), color: accent, size: 19),
              const Spacer(),
              if (active)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelMedium.copyWith(
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.time,
            maxLines: 1,
            style: text.titleMedium.copyWith(
              color: active ? accent : Theme.of(context).colorScheme.onSurface,
              fontWeight: AppTheme.weightBold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _status(context),
            style: text.labelSmall.copyWith(
              color: active
                  ? accent
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ],
      ),
    );
  }

  String _status(BuildContext context) {
    if (item.isFocus) return context.l10n.prayerViewFocus;
    if (item.isCurrent) return context.l10n.prayerViewNow;
    if (item.isPassed) return context.l10n.prayerViewPassed;
    return context.l10n.prayerViewSoon;
  }
}
