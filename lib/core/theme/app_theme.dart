import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ).copyWith(
      tertiary: AppColors.tertiary,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: const Color(0xFF342500),
      onTertiary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      outline: AppColors.divider,
      surfaceContainerHighest: AppColors.surfaceContainer,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.darkSurface,
    ).copyWith(
      tertiary: AppColors.tertiaryLight,
      onPrimary: AppColors.darkTextPrimary,
      onSecondary: AppColors.darkTextPrimary,
      onTertiary: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
      outline: AppColors.darkDivider,
      surfaceContainerHighest: AppColors.darkSurfaceContainer,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scaffoldBg = isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final cardColor = isDark ? AppColors.darkCardFill : AppColors.cardFill;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textTertiary = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      brightness: brightness,
    );

    final textTheme = _buildTextTheme(base.textTheme, colorScheme.onSurface);

    return base.copyWith(
      textTheme: textTheme,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        color: cardColor,
        shadowColor: colorScheme.primary.withValues(alpha: isDark ? 0.20 : 0.10),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: isDark ? 0.15 : 0.18),
          ),
        ),
      ),

      // ── Bottom Navigation Bar ───────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 24);
          }
          return IconThemeData(color: textTertiary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final style = textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          );
          if (states.contains(WidgetState.selected)) {
            return style?.copyWith(color: colorScheme.primary);
          }
          return style?.copyWith(color: textTertiary);
        }),
      ),

      // ── Progress indicators ─────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.secondary,
        linearTrackColor: colorScheme.secondary.withValues(alpha: 0.15),
      ),

      // ── Icons ───────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: colorScheme.primary),

      // ── List tiles ──────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: textSecondary,
        ),
      ),

      // ── Inputs ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surface.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.92),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.7),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.error.withValues(alpha: 0.6),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        prefixIconColor: colorScheme.primary,
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.30),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md + 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardColor,
          foregroundColor: colorScheme.primary,
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.12),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md + 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35)),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),

      // ── Text Button ────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),

      // ── Chips ───────────────────────────────────────────────────────────
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.20)),
        backgroundColor: colorScheme.primary.withValues(alpha: 0.06),
        selectedColor: colorScheme.primary.withValues(alpha: 0.14),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        elevation: 0,
        pressElevation: 1,
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.18),
        thickness: 1,
        space: 1,
      ),

      // ── Scrollbar ───────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return colorScheme.primary.withValues(alpha: 0.88);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.72);
          }
          return colorScheme.primary.withValues(alpha: 0.45);
        }),
        trackColor: WidgetStatePropertyAll(
          colorScheme.primary.withValues(alpha: 0.08),
        ),
        trackBorderColor: WidgetStatePropertyAll(
          colorScheme.outline.withValues(alpha: 0.15),
        ),
        radius: const Radius.circular(AppRadius.sm),
        thickness: const WidgetStatePropertyAll(5),
        minThumbLength: 44,
      ),

      // ── SnackBar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        backgroundColor: isDark ? AppColors.darkCardFill : AppColors.textPrimary,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: colorScheme.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),

      // ── Bottom Sheet ────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: colorScheme.primary.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        dragHandleColor: colorScheme.outline.withValues(alpha: 0.4),
        dragHandleSize: const Size(36, 4),
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.textPrimary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: isDark ? AppColors.darkTextPrimary : Colors.white,
        ),
      ),
    );
  }

  // ── Typography ──────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(TextTheme base, Color onSurface) {
    final body = GoogleFonts.manropeTextTheme(base)
        .apply(bodyColor: onSurface, displayColor: onSurface);

    return body.copyWith(
      displaySmall: GoogleFonts.sora(
        fontSize: 36,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 28,
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.15,
        color: onSurface,
      ),
      bodyLarge: body.bodyLarge?.copyWith(height: 1.55),
      bodyMedium: body.bodyMedium?.copyWith(height: 1.5),
      labelLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: onSurface,
      ),
    );
  }
}
