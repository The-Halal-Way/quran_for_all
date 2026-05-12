import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Layered shadow presets for premium depth.
///
/// Each preset uses a two-layer approach: a near shadow for crisp
/// definition and an ambient shadow for soft depth, both tinted with
/// the primary color to feel cohesive with the brand palette.
class AppShadows {
  const AppShadows._();

  /// Subtle resting shadow for cards and list items.
  static List<BoxShadow> card({Color? tint}) => [
        BoxShadow(
          color: (tint ?? AppColors.primary).withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: (tint ?? AppColors.primary).withValues(alpha: 0.03),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];

  /// Medium elevation for floating panels and dialogs.
  static List<BoxShadow> elevated({Color? tint}) => [
        BoxShadow(
          color: (tint ?? AppColors.primary).withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: (tint ?? AppColors.primary).withValues(alpha: 0.04),
          blurRadius: 48,
          offset: const Offset(0, 20),
        ),
      ];

  /// Deep shadow for hero banners and prominent cards.
  static List<BoxShadow> hero({Color? tint}) => [
        BoxShadow(
          color: (tint ?? AppColors.primary).withValues(alpha: 0.16),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: (tint ?? AppColors.primary).withValues(alpha: 0.06),
          blurRadius: 56,
          offset: const Offset(0, 28),
        ),
      ];

  /// Soft colored glow for premium accent elements.
  static List<BoxShadow> glow(Color color, {double intensity = 0.25}) => [
        BoxShadow(
          color: color.withValues(alpha: intensity),
          blurRadius: 20,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: color.withValues(alpha: intensity * 0.4),
          blurRadius: 44,
          offset: const Offset(0, 12),
        ),
      ];

  /// Upward shadow for bottom navigation bars.
  static List<BoxShadow> get navigation => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, -6),
        ),
      ];
}
