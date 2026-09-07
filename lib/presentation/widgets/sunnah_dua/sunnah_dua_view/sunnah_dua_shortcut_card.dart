import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/dashboard/dashboard_action_item.dart';

class SunnahDuaShortcutCard extends StatelessWidget {
  const SunnahDuaShortcutCard({super.key, required this.item});

  final DashboardActionItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: item.sublabel == null
          ? item.label
          : '${item.label}. ${item.sublabel}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: item.onTap,
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [surface, Color.lerp(surface, item.color, 0.12)!],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              border: Border.all(color: item.color.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item.icon, color: item.color, size: 22),
                    const Spacer(),
                    Icon(Icons.north_east_rounded, color: item.color, size: 16),
                  ],
                ),
                const Spacer(),
                Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelMedium.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                    height: 1.18,
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
