import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/my_images.dart';
import '../../../../data/models/prayer/prayer_guide_variant.dart';
import '../../../models/prayer_movement_assets.dart';
import 'prayer_movement_frame_painter.dart';
import 'prayer_movement_illustration.dart';

class PrayerMovementHeroStage extends StatelessWidget {
  const PrayerMovementHeroStage({super.key, required this.variant});

  final PrayerGuideVariant variant;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 228,
    height: 256,
    child: Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: PrayerMovementFramePainter(
              accent: MyColors.secondaryLight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.sm,
          ),
          child: PrayerMovementIllustration(
            asset: PrayerMovementAssets.forVariant(MyImages.takbeerh, variant),
            semanticLabel: variant == PrayerGuideVariant.female
                ? context.l10n.prayerMovementsFemaleGuideLabel
                : context.l10n.prayerMovementsMaleGuideLabel,
          ),
        ),
      ],
    ),
  );
}
