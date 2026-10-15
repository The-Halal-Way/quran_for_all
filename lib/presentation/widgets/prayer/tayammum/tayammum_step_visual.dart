import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/my_images.dart';
import 'tayammum_step_type.dart';

class TayammumStepVisual extends StatelessWidget {
  const TayammumStepVisual({
    super.key,
    required this.type,
    required this.accent,
  });

  final TayammumStepType type;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final asset = switch (type) {
      TayammumStepType.earth => MyImages.tayammumStep1,
      TayammumStepType.face => MyImages.tayammumStep2,
      TayammumStepType.hands => MyImages.tayammumStep3,
    };
    final fallbackIcon = switch (type) {
      TayammumStepType.earth => Icons.back_hand_rounded,
      TayammumStepType.face => Icons.face_retouching_natural_rounded,
      TayammumStepType.hands => Icons.pan_tool_alt_rounded,
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 108),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.16),
            MyColors.primaryLight.withValues(alpha: 0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -22,
            right: -12,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 74,
              color: accent.withValues(alpha: 0.11),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  _FallbackVisual(icon: fallbackIcon, accent: accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackVisual extends StatelessWidget {
  const _FallbackVisual({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, Color.lerp(accent, MyColors.primary, 0.35)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 29),
    ),
  );
}
