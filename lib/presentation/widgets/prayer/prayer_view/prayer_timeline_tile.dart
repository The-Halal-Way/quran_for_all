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
    final colors = Theme.of(context).colorScheme;
    final active = item.isFocus || item.isCurrent;
    final foreground = active ? Colors.white : colors.onSurface;
    final accent = active ? MyColors.tertiaryLight : colors.secondary;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [MyColors.primary, MyColors.primaryLight],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : null,
          color: active ? null : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: active
                ? MyColors.primaryLight
                : colors.outline.withValues(alpha: 0.55),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  PrayerVisuals.iconFor(item.prayer),
                  color: accent,
                  size: 21,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _status(context),
                    textAlign: TextAlign.end,
                    style: text.labelSmall.copyWith(
                      color: active
                          ? accent
                          : foreground.withValues(alpha: 0.6),
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              item.name,
              style: text.titleMedium.copyWith(color: foreground),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.time,
              style: text.bodySmall.copyWith(
                color: foreground.withValues(alpha: active ? 0.86 : 0.72),
                fontWeight: AppTheme.weightSemiBold,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _status(BuildContext context) {
    if (item.isCurrent) return context.l10n.prayerViewNow;
    if (item.isFocus) return context.l10n.prayerViewFocus;
    if (item.isPassed) return context.l10n.prayerViewPassed;
    return context.l10n.prayerViewSoon;
  }
}
