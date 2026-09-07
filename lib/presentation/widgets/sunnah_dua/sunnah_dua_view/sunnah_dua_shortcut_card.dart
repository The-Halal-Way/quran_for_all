import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../models/sunnah_dua_shortcut.dart';

class SunnahDuaShortcutCard extends StatelessWidget {
  const SunnahDuaShortcutCard({
    super.key,
    required this.item,
    required this.onTap,
  });
  final SunnahDuaShortcut item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Semantics(
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      label: '${item.title}. ${item.subtitle}',
      child: Material(
        color: MyColors.primary,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: LinearGradient(
                colors: [
                  MyColors.primary,
                  Color.lerp(MyColors.primary, item.accent, 0.5)!,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              border: Border.all(color: item.accent.withValues(alpha: 0.5)),
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  top: -24,
                  end: -24,
                  child: ExcludeSemantics(
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item.icon,
                            color: Color.lerp(item.accent, Colors.white, 0.6),
                            size: 25,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.north_east_rounded,
                            color: Colors.white54,
                            size: 17,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.weightBold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall.copyWith(
                          color: Colors.white70,
                          height: 1.3,
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
