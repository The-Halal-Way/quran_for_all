import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';
import 'powerful_duah_data.dart';

class PowerfulDuahCard extends StatelessWidget {
  const PowerfulDuahCard({super.key, required this.duah, required this.onTap});

  final PowerfulDuah duah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;
    final accent = duah.isFeatured ? MyColors.secondary : MyColors.primaryLight;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label:
          '${duah.localizedTitle(context)}. ${duah.localizedTranslation(context)}',
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
                colors: [surface, Color.lerp(surface, accent, 0.08)!],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: accent.withValues(alpha: 0.20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${duah.number}',
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: accent,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        duah.localizedTitle(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text(context).titleSmall.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                    ),
                    if (duah.isFeatured)
                      const Icon(
                        Icons.star_rounded,
                        color: MyColors.secondary,
                        size: 17,
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  duah.arabic,
                  textAlign: TextAlign.right,
                  textDirection: ui.TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(
                    context,
                  ).titleLarge.copyWith(height: 1.7),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        duah.source ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: accent,
                          fontWeight: AppTheme.weightBold,
                        ),
                      ),
                    ),
                    Icon(Icons.north_east_rounded, color: accent, size: 17),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
