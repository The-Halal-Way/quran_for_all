// AppColors.dart
import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  // Primary: deep regal indigo
  static const Color primary      = Color(0xFF1E0A3C); // midnight purple‑blue
  static const Color primaryLight = Color(0xFF4B30A1); // electric indigo
  static const Color primaryDark  = Color(0xFF0D0320); // almost black violet

  // Secondary: shocking fuchsia (replaces gold as the royal accent)
  static const Color secondary      = Color(0xFFD50057); // vivid fuchsia
  static const Color secondaryLight = Color(0xFFFF4081); // neon pink‑rose
  static const Color secondaryDark  = Color(0xFF8E0033); // deep berry

  // Tertiary: icy teal (exotic cold metal, never warm)
  static const Color tertiary      = Color(0xFF00BFA5); // teal accent
  static const Color tertiaryLight = Color(0xFF64FFDA); // mint flash
  static const Color tertiaryDark  = Color(0xFF00897B); // deep emerald teal

  // ── Light Surfaces ───────────────────────────────────────────────────────
  static const Color scaffold        = Color(0xFFF5F2FF); // ice‑blue lavender
  static const Color surface         = Color(0xFFFFFFFF); // pure white
  static const Color surfaceContainer = Color(0xFFEEE8FA); // pale violet pearl
  static const Color cardFill        = Color(0xFFFFFFFF); // clean cards
  static const Color divider         = Color(0xFFD9D1E8); // soft violet‑grey

  // ── Light Text ───────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF120B24); // deep navy‑ink
  static const Color textSecondary = Color(0xFF4C425C); // muted plum
  static const Color textTertiary  = Color(0xFF7A7288); // lavender grey
  static const Color textOnPrimary = Colors.white;

  // ── Dark Surfaces ────────────────────────────────────────────────────────
  static const Color darkScaffold        = Color(0xFF060118); // abyss indigo
  static const Color darkSurface         = Color(0xFF120A2B);
  static const Color darkSurfaceContainer = Color(0xFF1D1238);
  static const Color darkCardFill        = Color(0xFF261A45); // deep velvet
  static const Color darkDivider         = Color(0xFF382E54);

  // ── Dark Text ────────────────────────────────────────────────────────────
  static const Color darkTextPrimary   = Color(0xFFEDE7F6); // softest lavender
  static const Color darkTextSecondary = Color(0xFFB39DDB); // lilac grey
  static const Color darkTextTertiary  = Color(0xFF7E57C2); // muted purple

  // ── Semantic (tuned to the palette) ──────────────────────────────────────
  static const Color success     = Color(0xFF00E676); // neon emerald
  static const Color error       = Color(0xFFFF1744); // electric red
  static const Color errorSurface = Color(0xFFFFF0F5); // pink‑tinted bg
  static const Color info        = Color(0xFF448AFF); // bright blue
}