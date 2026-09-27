import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import 'prayer_movement_badge.dart';
import 'prayer_movement_frame_painter.dart';
import 'prayer_movement_illustration.dart';

class PrayerMovementImageFrame extends StatelessWidget {
  const PrayerMovementImageFrame({
    super.key,
    required this.step,
    required this.accent,
  });

  final PrayerMovementStep step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: dark ? 0.28 : 0.14),
            MyColors.primaryLight.withValues(alpha: dark ? 0.24 : 0.07),
            MyColors.secondary.withValues(alpha: dark ? 0.20 : 0.09),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                step.number.toString().padLeft(2, '0'),
                style: AppTheme.text(context).headlineMedium.copyWith(
                  color: dark
                      ? MyColors.secondaryLight
                      : MyColors.secondaryDark,
                  fontWeight: AppTheme.weightExtraBold,
                  height: 1,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: PrayerMovementBadge(label: step.badge, accent: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 248,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: PrayerMovementFramePainter(accent: accent),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: PrayerMovementIllustration(
                    asset: step.imageAsset,
                    semanticLabel: step.title,
                    mirror: step.mirrorImage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
