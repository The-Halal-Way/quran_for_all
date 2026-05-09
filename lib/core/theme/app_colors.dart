import 'package:flutter/material.dart';

/// Centralized color palette for the app.
///
/// Use these tokens instead of inline hex values so that every screen
/// shares a single source of truth for colour.
class AppColors {
  const AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0D7A67);
  static const Color primaryLight = Color(0xFF1A9E86);
  static const Color primaryDark = Color(0xFF065647);

  static const Color secondary = Color(0xFFC8922A);
  static const Color secondaryLight = Color(0xFFE8B34D);

  static const Color tertiary = Color(0xFFA7523D);
  static const Color tertiaryLight = Color(0xFFCB7A66);

  // ── Light Surfaces ───────────────────────────────────────────────────────
  static const Color scaffold = Color(0xFFF5EDD8);
  static const Color surface = Color(0xFFFFFDF7);
  static const Color cardFill = Color(0xFFFFFEFC);
  static const Color divider = Color(0xFFD6DCCF);

  // ── Light Text ───────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A2420);
  static const Color textSecondary = Color(0xFF4A5650);
  static const Color textTertiary = Color(0xFF7E8B84);
  static const Color textOnPrimary = Colors.white;

  // ── Dark Surfaces ────────────────────────────────────────────────────────
  static const Color darkScaffold = Color(0xFF111916);
  static const Color darkSurface = Color(0xFF1A2420);
  static const Color darkCardFill = Color(0xFF1F2D28);
  static const Color darkDivider = Color(0xFF2E3D36);

  // ── Dark Text ────────────────────────────────────────────────────────────
  static const Color darkTextPrimary = Color(0xFFE8ECE9);
  static const Color darkTextSecondary = Color(0xFFAAB4AE);
  static const Color darkTextTertiary = Color(0xFF6E7D76);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF1B8A4A);
  static const Color error = Color(0xFFBF3B30);
  static const Color errorSurface = Color(0xFFFFF0EB);
  static const Color info = Color(0xFF3478A5);

  // ── Light Gradients ──────────────────────────────────────────────────────
  static const LinearGradient pageBg = LinearGradient(
    colors: [Color(0xFFFFFDF5), Color(0xFFF2E6CF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashBg = LinearGradient(
    colors: [Color(0xFF0D7A67), Color(0xFFA7523D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBanner = LinearGradient(
    colors: [Color(0xFF0D7A67), Color(0xFFA7523D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Dark Gradients ───────────────────────────────────────────────────────
  static const LinearGradient darkPageBg = LinearGradient(
    colors: [Color(0xFF111916), Color(0xFF1A2420)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
