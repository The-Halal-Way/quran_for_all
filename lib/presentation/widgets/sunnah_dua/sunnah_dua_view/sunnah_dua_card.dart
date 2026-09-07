import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../models/sunnah_dua_item.dart';

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
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final featured = item.isFeatured;
    final accent = dark
        ? Color.lerp(item.accent, Colors.white, 0.45)!
        : item.accent;
    final foreground = featured ? Colors.white : colors.onSurface;
    return Semantics(
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      label: '$kindLabel. ${item.title}. ${item.subtitle}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: LinearGradient(
                colors: featured
                    ? [
                        MyColors.primary,
                        Color.lerp(MyColors.primary, item.accent, 0.5)!,
                      ]
                    : [
                        colors.surface,
                        Color.lerp(
                          colors.surface,
                          item.accent,
                          dark ? 0.15 : 0.06,
                        )!,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: item.accent.withValues(alpha: featured ? 0.6 : 0.22),
              ),
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  top: -12,
                  end: -18,
                  child: ExcludeSemantics(
                    child: Icon(
                      item.icon,
                      size: 108,
                      color: (featured ? Colors.white : item.accent).withValues(
                        alpha: 0.055,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (featured ? Colors.white : item.accent)
                              .withValues(alpha: 0.12),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                            bottom: Radius.circular(12),
                          ),
                          border: Border.all(
                            color: (featured ? Colors.white : item.accent)
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          item.icon,
                          color: featured ? MyColors.tertiaryLight : accent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall.copyWith(
                          color: foreground,
                          fontWeight: AppTheme.weightExtraBold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall.copyWith(
                          color: foreground.withValues(alpha: 0.72),
                          height: 1.35,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              kindLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.labelSmall.copyWith(
                                color: featured
                                    ? MyColors.tertiaryLight
                                    : accent,
                                fontWeight: AppTheme.weightBold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            textDirection: Directionality.of(context),
                            color: featured ? Colors.white : accent,
                          ),
                        ],
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
