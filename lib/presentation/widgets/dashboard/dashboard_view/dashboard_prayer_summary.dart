import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../prayer/prayer_time_countdown.dart';

class DashboardPrayerSummary extends StatelessWidget {
  const DashboardPrayerSummary({
    super.key,
    required this.title,
    required this.time,
    this.endsAtUtc,
    required this.icon,
    required this.expanded,
    required this.onToggle,
  });
  final String title, time;
  final DateTime? endsAtUtc;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: Theme.of(context).brightness == Brightness.dark
            ? [MyColors.secondaryDark, MyColors.primaryLight]
            : [AppThemeColors.light.heroStart, AppThemeColors.light.heroEnd],
      ),
    ),
    child: InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.dashboardCurrentPrayer,
                    style: AppTheme.text(
                      context,
                    ).labelSmall.copyWith(color: Colors.white70),
                  ),
                ),
                if (endsAtUtc != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: PrayerTimeCountdown(
                        endsAtUtc: endsAtUtc!,
                        color: Colors.white,
                        compact: true,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 26),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTheme.text(context).titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      Text(
                        time,
                        style: AppTheme.text(context).bodyMedium.copyWith(
                          color: Colors.white,
                          fontSize: AppTheme.scaledFontSize(context, 15),
                          fontWeight: AppTheme.weightSemiBold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Tooltip(
                  message: expanded
                      ? MaterialLocalizations.of(context).expandedIconTapHint
                      : MaterialLocalizations.of(context).collapsedIconTapHint,
                  child: ExcludeSemantics(
                    child: Icon(
                      expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
