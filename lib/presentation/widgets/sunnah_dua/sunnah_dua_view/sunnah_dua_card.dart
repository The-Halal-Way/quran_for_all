import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/sunnah_dua/sunnah_dua_models.dart';

class SunnahDuaCard extends StatelessWidget {
  const SunnahDuaCard({
    super.key,
    required this.item,
    required this.kindLabel,
    required this.onTap,
  });

  final SunnahDuaItem item;
  final String kindLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '$kindLabel. ${item.title}. ${item.subtitle}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [surface, Color.lerp(surface, item.accent, 0.08)!],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              border: Border.all(
                color: item.accent.withValues(
                  alpha: item.isFeatured ? 0.38 : 0.18,
                ),
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: item.gradientColors),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 18),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.north_east_rounded,
                      color: item.accent,
                      size: 17,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  kindLabel.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall.copyWith(
                    color: item.accent,
                    fontWeight: AppTheme.weightBold,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                    height: 1.15,
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
