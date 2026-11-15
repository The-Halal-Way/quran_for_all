import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

/// Shows the two fasting milestones in the prayer hero when times are ready.
class PrayerFastingTimesStrip extends StatelessWidget {
  const PrayerFastingTimesStrip({
    super.key,
    this.sehriEnd,
    this.sehriRange,
    this.iftarTime,
  });

  final String? sehriEnd;
  final String? sehriRange;
  final String? iftarTime;

  @override
  Widget build(BuildContext context) {
    final showSehri = sehriEnd != null && sehriEnd!.isNotEmpty;
    final showIftar = iftarTime != null && iftarTime!.isNotEmpty;
    if (!showSehri && !showIftar) return const SizedBox.shrink();

    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .14)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sideBySide =
              showSehri &&
              showIftar &&
              constraints.maxWidth >= 290 &&
              MediaQuery.textScalerOf(context).scale(16) <= 20;
          final sehri = _TimeMoment(
            icon: Icons.nightlight_round,
            label: l10n.dashboardPrayerSehri,
            time: sehriRange ?? sehriEnd ?? '',
          );
          final iftar = _TimeMoment(
            icon: Icons.wb_twilight_rounded,
            label: l10n.prayerWidgetIftar,
            time: iftarTime ?? '',
          );

          if (sideBySide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: sehri),
                Container(
                  width: 1,
                  height: 34,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  color: Colors.white.withValues(alpha: .18),
                ),
                Expanded(child: iftar),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showSehri) sehri,
              if (showSehri && showIftar)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: .18),
                  ),
                ),
              if (showIftar) iftar,
            ],
          );
        },
      ),
    );
  }
}

class _TimeMoment extends StatelessWidget {
  const _TimeMoment({
    required this.icon,
    required this.label,
    required this.time,
  });

  final IconData icon;
  final String label, time;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(icon, color: MyColors.tertiaryLight, size: 19),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: text.labelSmall.copyWith(
                  color: MyColors.tertiaryLight,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  time,
                  maxLines: 1,
                  softWrap: false,
                  style: text.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
