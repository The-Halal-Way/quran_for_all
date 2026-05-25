import 'package:flutter/material.dart';

/// Premium multi-stop gradient presets – Deviant Royal Edition.
///
/// Three-stop gradients with bridging mid-tones create smoother,
/// richer transitions than simple two-color ramps.
class AppGradients {
  const AppGradients._();

  // ── Page Backgrounds ─────────────────────────────────────────────────────

  /// Icy violet-mist page background – light mode.
  static const LinearGradient pageBg = LinearGradient(
    colors: [Color(0xFFFDF8FF), Color(0xFFF5F0FF), Color(0xFFEEE4FA)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Deep indigo velvet page background – dark mode.
  static const LinearGradient darkPageBg = LinearGradient(
    colors: [Color(0xFF0D001A), Color(0xFF1A0A2E), Color(0xFF250F3D)],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Splash / Hero ────────────────────────────────────────────────────────

  /// Full-screen splash gradient – cosmic indigo → electric violet → shocking fuchsia.
  static const LinearGradient splash = LinearGradient(
    colors: [Color(0xFF1E0A3C), Color(0xFF4B30A1), Color(0xFFFF4081)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero banner gradient – violet → fuchsia → icy teal.
  static const LinearGradient heroBanner = LinearGradient(
    colors: [Color(0xFF4B30A1), Color(0xFFD50057), Color(0xFF00BFA5)],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Accent Gradients ─────────────────────────────────────────────────────

  /// Royal shimmer – fuchsia 🔁 neon rose (replaces old gold shimmer).
  static const LinearGradient royalShimmer = LinearGradient(
    colors: [Color(0xFFD50057), Color(0xFFFF4081), Color(0xFFC2185B)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary soft gradient – deep indigo → electric purple.
  static const LinearGradient primarySoft = LinearGradient(
    colors: [Color(0xFF1E0A3C), Color(0xFF4B30A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Branding circle gradient – neon fuchsia → mint‑teal (iconic clash).
  static const LinearGradient brandingCircle = LinearGradient(
    colors: [Color(0xFFFF4081), Color(0xFF64FFDA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
