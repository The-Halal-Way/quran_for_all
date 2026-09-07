import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';
import 'daily_duah_data.dart';

class DailyDuahCard extends StatelessWidget {
  const DailyDuahCard({super.key, required this.item, required this.onTap});

  final DuahItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label:
          '${item.localizedTitle(context)}. ${item.localizedTranslation(context)}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  surface,
                  Color.lerp(surface, MyColors.tertiary, 0.075)!,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: MyColors.tertiary.withValues(alpha: 0.18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.localizedTitle(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(
                      Icons.north_east_rounded,
                      color: MyColors.tertiary,
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  item.arabic,
                  textAlign: TextAlign.right,
                  textDirection: ui.TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge.copyWith(
                    height: 1.7,
                    fontWeight: AppTheme.weightSemiBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.localizedTranslation(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.60),
                    height: 1.35,
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
