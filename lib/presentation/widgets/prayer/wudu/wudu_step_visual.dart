import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/my_images.dart';
import 'wudu_step_type.dart';

class WuduStepVisual extends StatelessWidget {
  const WuduStepVisual({
    super.key,
    required this.type,
    required this.accent,
    required this.fallbackLabel,
  });

  final WuduStepType type;
  final Color accent;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    final asset = switch (type) {
      WuduStepType.hands => MyImages.wuduStep1Hands,
      WuduStepType.mouth => MyImages.wuduStep2Mouth,
      WuduStepType.nose => MyImages.wuduStep3Nose,
      WuduStepType.face => MyImages.wuduStep4Face,
      WuduStepType.arms => MyImages.wuduStep5Arms,
      WuduStepType.head => MyImages.wuduStep6Head,
      WuduStepType.ears => MyImages.wuduStep7Ears,
      WuduStepType.feet => MyImages.wuduStep8Feet,
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 132),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.16),
            MyColors.primaryLight.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(
            fallbackLabel,
            textAlign: TextAlign.center,
            style: AppTheme.text(context).labelMedium.copyWith(
              color: accent,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ),
      ),
    );
  }
}
