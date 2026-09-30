import 'package:flutter/material.dart';

/// Color tokens for the new light appearance.
///
/// Dark mode continues to use the existing MyColors palette.
class AppThemeColors {
  const AppThemeColors({
    required this.canvas,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.stroke,
    required this.strokeStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.brand,
    required this.violet,
    required this.cyan,
    required this.coral,
    required this.success,
    required this.warning,
    required this.danger,
    required this.heroStart,
    required this.heroMiddle,
    required this.heroEnd,
    required this.heroForeground,
    required this.shadow,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceMuted;
  final Color stroke;
  final Color strokeStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color brand;
  final Color violet;
  final Color cyan;
  final Color coral;
  final Color success;
  final Color warning;
  final Color danger;
  final Color heroStart;
  final Color heroMiddle;
  final Color heroEnd;
  final Color heroForeground;
  final Color shadow;

  static const light = AppThemeColors(
    canvas: Color(0xFFF6F7FC),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFCFCFF),
    surfaceMuted: Color(0xFFF0F2FA),
    stroke: Color(0xFFE2E5F0),
    strokeStrong: Color(0xFFCCD1E0),
    textPrimary: Color(0xFF15182B),
    textSecondary: Color(0xFF59627A),
    textMuted: Color(0xFF8A93AA),
    brand: Color(0xFF625BF6),
    violet: Color(0xFF8B5CF6),
    cyan: Color(0xFF08AFCB),
    coral: Color(0xFFE94D8C),
    success: Color(0xFF168F68),
    warning: Color(0xFFC67A05),
    danger: Color(0xFFD43D55),
    heroStart: Color(0xFF11163F),
    heroMiddle: Color(0xFF352777),
    heroEnd: Color(0xFF6848E8),
    heroForeground: Color(0xFFFFFFFF),
    shadow: Color(0xFF202650),
  );
}
