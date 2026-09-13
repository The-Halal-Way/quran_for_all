import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DashboardPrayerSummary extends StatelessWidget {
  const DashboardPrayerSummary({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.expanded,
    required this.onToggle,
  });
  final String title, time;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Ink(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [MyColors.secondaryDark, MyColors.primaryLight],
      ),
    ),
    child: InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 14, 4, 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.dashboardCurrentPrayer,
                    style: AppTheme.text(
                      context,
                    ).labelSmall.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
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
                        style: AppTheme.text(
                          context,
                        ).titleMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onToggle,
              tooltip: expanded
                  ? MaterialLocalizations.of(context).expandedIconTapHint
                  : MaterialLocalizations.of(context).collapsedIconTapHint,
              icon: Icon(
                expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
