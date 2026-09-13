import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DashboardContinueCard extends StatelessWidget {
  const DashboardContinueCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.icon,
    required this.accent,
    required this.onTap,
  });
  final String title, subtitle, detail;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return Semantics(
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      label: '$title. $subtitle. $detail',
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap,
          child: Ink(
            height: 166 + (scale - 1).clamp(0, 3) * 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [MyColors.primary, accent],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  end: -18,
                  bottom: -20,
                  child: Icon(
                    icon,
                    size: 112,
                    color: Colors.white.withValues(alpha: 0.055),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 26, color: Colors.white),
                          const Spacer(),
                          const Icon(
                            Icons.north_east_rounded,
                            size: 17,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.dashboardCardEyebrow.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.dashboardCardTitle.copyWith(
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.dashboardCardMeta.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
