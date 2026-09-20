// MyColors.dart
import 'package:flutter/material.dart';

class MyColors {
  const MyColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  // Primary: tailored midnight ink with a restrained royal-indigo lift.
  static const Color primary = Color(0xFF18223D);
  static const Color primaryLight = Color(0xFF5263A7);
  static const Color primaryDark = Color(0xFF090F20);

  // Secondary: antique gold, used sparingly for focus and celebration.
  static const Color secondary = Color(0xFFB98732);
  static const Color secondaryLight = Color(0xFFE5C46F);
  static const Color secondaryDark = Color(0xFF78551D);

  // Tertiary: deep emerald for spiritual and completion accents.
  static const Color tertiary = Color(0xFF177A6B);
  static const Color tertiaryLight = Color(0xFF68C7B5);
  static const Color tertiaryDark = Color(0xFF0C554B);

  // ── Light Surfaces ───────────────────────────────────────────────────────
  static const Color scaffold = Color(0xFFF6F3EC);
  static const Color surface = Color(0xFFFFFDF8);
  static const Color surfaceContainer = Color(0xFFF1ECE2);
  static const Color cardFill = Color(0xFFFFFEFB);
  static const Color divider = Color(0xFFD9D2C4);

  // ── Light Text ───────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF161C2B);
  static const Color textSecondary = Color(0xFF505564);
  static const Color textTertiary = Color(0xFF777B86);
  static const Color textOnPrimary = Colors.white;

  // ── Dark Surfaces ────────────────────────────────────────────────────────
  static const Color darkScaffold = Color(0xFF070C18);
  static const Color darkSurface = Color(0xFF10182A);
  static const Color darkSurfaceContainer = Color(0xFF182339);
  static const Color darkCardFill = Color(0xFF1D2941);
  static const Color darkDivider = Color(0xFF344057);
  static const darkCard = Color(0xFF1D2941);

  // ── Dark Text ────────────────────────────────────────────────────────────
  static const Color darkTextPrimary = Color(0xFFF5F0E7);
  static const Color darkTextSecondary = Color(0xFFC1BAAD);
  static const Color darkTextTertiary = Color(0xFF8E918F);

  // ── Semantic (tuned to the palette) ──────────────────────────────────────
  static const Color success = Color(0xFF27866F);
  static const Color error = Color(0xFFB83B4A);
  static const Color errorSurface = Color(0xFFFFF1F1);
  static const Color info = Color(0xFF496AA8);
}
