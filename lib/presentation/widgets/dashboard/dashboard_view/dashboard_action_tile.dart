import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dashboard/dashboard_action_item.dart';

class DashboardActionTile extends StatelessWidget {
  const DashboardActionTile({super.key, required this.item});
  final DashboardActionItem item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark
        ? Color.lerp(item.color, Colors.white, 0.45)!
        : item.color;
    final text = AppTheme.text(context);
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return Semantics(
      button: true,
      onTap: item.onTap,
      excludeSemantics: true,
      label: '${item.label}. ${item.sublabel ?? ''}',
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: item.onTap,
          child: Ink(
            height: 122 + (scale - 1).clamp(0, 3) * 82,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.surface,
                  Color.lerp(colors.surface, item.color, dark ? 0.09 : 0.045)!,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item.icon, size: 24, color: accent),
                    const Spacer(),
                    Icon(Icons.north_east_rounded, size: 15, color: accent),
                  ],
                ),
                const Spacer(),
                Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.dashboardActionTitle.copyWith(height: 1.3),
                ),
                if (item.sublabel != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.sublabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.dashboardActionSubtitle.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
