import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color _primary = Color(0xFF0B6B5A);
  static const Color _secondary = Color(0xFFD79B2D);
  static const Color _tertiary = Color(0xFFBC5B40);
  static const Color _surface = Color(0xFFFFFBF2);
  static const Color _scaffold = Color(0xFFF7F0DF);
  static const Color _onSurface = Color(0xFF1D2522);

  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _primary,
          brightness: Brightness.light,
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
        ).copyWith(
          tertiary: _tertiary,
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF342500),
          onTertiary: Colors.white,
          onSurface: _onSurface,
          outline: const Color(0xFFC7D0C2),
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _scaffold,
    );

    final textTheme = _buildTextTheme(base.textTheme, colorScheme.onSurface);

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.35)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.secondary,
      ),
      iconTheme: IconThemeData(color: colorScheme.primary),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.72),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.52),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        prefixIconColor: colorScheme.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.42)),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        backgroundColor: colorScheme.primary.withValues(alpha: 0.09),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return colorScheme.primary.withValues(alpha: 0.9);
          }

          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.78);
          }

          return colorScheme.primary.withValues(alpha: 0.58);
        }),
        trackColor: WidgetStatePropertyAll(
          colorScheme.primary.withValues(alpha: 0.12),
        ),
        trackBorderColor: WidgetStatePropertyAll(
          colorScheme.outline.withValues(alpha: 0.26),
        ),
        radius: const Radius.circular(12),
        thickness: const WidgetStatePropertyAll(7),
        minThumbLength: 44,
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color onSurface) {
    final body = GoogleFonts.manropeTextTheme(
      base,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return body.copyWith(
      displaySmall: GoogleFonts.sora(
        fontSize: 36,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 28,
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: onSurface,
      ),
      bodyLarge: body.bodyLarge?.copyWith(height: 1.45),
      bodyMedium: body.bodyMedium?.copyWith(height: 1.4),
      labelLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: onSurface,
      ),
    );
  }
}
