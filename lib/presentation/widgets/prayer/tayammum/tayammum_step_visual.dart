import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
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
    final text = AppTheme.text(context);
    final (icon, secondary, label) = switch (type) {
      TayammumStepType.intention => (
        Icons.favorite_outline_rounded,
        Icons.self_improvement_rounded,
        '1',
      ),
      TayammumStepType.earth => (
        Icons.back_hand_rounded,
        Icons.grain_rounded,
        '2',
      ),
      TayammumStepType.wipe => (
        Icons.face_retouching_natural_rounded,
        Icons.pan_tool_alt_rounded,
        '3',
      ),
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 108),
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -22,
            right: -12,
            child: Icon(
              secondary,
              size: 74,
              color: accent.withValues(alpha: 0.11),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _VisualIcon(icon: icon, accent: accent),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.arrow_forward_rounded, color: accent, size: 21),
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: text.labelLarge.copyWith(
                      color: accent,
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisualIcon extends StatelessWidget {
  const _VisualIcon({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
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
  );
}
