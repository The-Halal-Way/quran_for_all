import 'package:flutter/material.dart';

/// Premium multi-stop gradient presets.
///
/// Three-stop gradients with bridging mid-tones create smoother,
/// richer transitions than simple two-color ramps.
class AppGradients {
  const AppGradients._();

  // ── Page Backgrounds ─────────────────────────────────────────────────────

  /// Warm pearl page background – light mode.
  static const LinearGradient pageBg = LinearGradient(
    colors: [Color(0xFFFFFEFA), Color(0xFFF7F3EA), Color(0xFFEDE8DD)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Deep midnight page background – dark mode.
  static const LinearGradient darkPageBg = LinearGradient(
    colors: [Color(0xFF070C18), Color(0xFF101A2D), Color(0xFF17243A)],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Splash / Hero ────────────────────────────────────────────────────────

  /// Full-screen splash gradient – midnight → indigo → emerald.
  static const LinearGradient splash = LinearGradient(
    colors: [Color(0xFF090F20), Color(0xFF26365E), Color(0xFF177A6B)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero banner gradient – midnight → royal indigo → emerald.
  static const LinearGradient heroBanner = LinearGradient(
    colors: [Color(0xFF18223D), Color(0xFF5263A7), Color(0xFF177A6B)],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Accent Gradients ─────────────────────────────────────────────────────

  /// Antique-gold shimmer for small highlights and progress accents.
  static const LinearGradient royalShimmer = LinearGradient(
    colors: [Color(0xFF8A6220), Color(0xFFE5C46F), Color(0xFFB98732)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary soft gradient – midnight → royal indigo.
  static const LinearGradient primarySoft = LinearGradient(
    colors: [Color(0xFF18223D), Color(0xFF5263A7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Branding circle gradient – antique gold → emerald.
  static const LinearGradient brandingCircle = LinearGradient(
    colors: [Color(0xFFE5C46F), Color(0xFF177A6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
