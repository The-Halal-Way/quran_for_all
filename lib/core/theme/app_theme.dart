import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: MyColors.primary,
          brightness: Brightness.light,
          primary: MyColors.primary,
          secondary: MyColors.secondary,
          surface: MyColors.surface,
        ).copyWith(
          tertiary: MyColors.tertiary,
          onPrimary: MyColors.textOnPrimary,
          onSecondary: const Color(0xFF342500),
          onTertiary: MyColors.textOnPrimary,
          onSurface: MyColors.textPrimary,
          outline: MyColors.divider,
          surfaceContainerHighest: MyColors.surfaceContainer,
        );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData get darkTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: MyColors.primary,
          brightness: Brightness.dark,
          primary: MyColors.primaryLight,
          secondary: MyColors.secondaryLight,
          surface: MyColors.darkSurface,
        ).copyWith(
          tertiary: MyColors.tertiaryLight,
          onPrimary: MyColors.darkTextPrimary,
          onSecondary: MyColors.darkTextPrimary,
          onTertiary: MyColors.darkTextPrimary,
          onSurface: MyColors.darkTextPrimary,
          outline: MyColors.darkDivider,
          surfaceContainerHighest: MyColors.darkSurfaceContainer,
        );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final metrics = _ThemeMetrics.fromWidth(_effectiveScreenWidth);
    final isDark = brightness == Brightness.dark;
    final scaffoldBg = isDark ? MyColors.darkScaffold : MyColors.scaffold;
    final cardColor = isDark ? MyColors.darkCardFill : MyColors.cardFill;
    final textSecondary = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final textTertiary = isDark
        ? MyColors.darkTextTertiary
        : MyColors.textTertiary;

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      brightness: brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final textTheme = _buildTextTheme(
      base.textTheme,
      colorScheme.onSurface,
      metrics,
    );

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
        toolbarHeight: metrics.size(56),
        titleSpacing: metrics.space(AppSpacing.lg),
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        color: cardColor,
        shadowColor: colorScheme.primary.withValues(
          alpha: isDark ? 0.20 : 0.10,
        ),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(metrics.radius(AppRadius.lg)),
          ),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: isDark ? 0.15 : 0.18),
            width: metrics.stroke(1),
          ),
        ),
      ),

      // ── Bottom Navigation Bar ───────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: metrics.size(72),
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.primary,
              size: metrics.icon(24),
            );
          }
          return IconThemeData(color: textTertiary, size: metrics.icon(24));
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
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: metrics.icon(22),
      ),

      // ── List tiles ──────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        minLeadingWidth: metrics.size(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.md)),
        ),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
      ),

      // ── Inputs ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surface.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.92),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textTertiary),
        contentPadding: EdgeInsets.symmetric(
          horizontal: metrics.space(AppSpacing.lg),
          vertical: metrics.space(14),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.md)),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.25),
            width: metrics.stroke(1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.md)),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.25),
            width: metrics.stroke(1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.md)),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.7),
            width: metrics.stroke(1.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.md)),
          borderSide: BorderSide(
            color: MyColors.error.withValues(alpha: 0.6),
            width: metrics.stroke(1),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.md)),
          borderSide: BorderSide(
            color: MyColors.error,
            width: metrics.stroke(1.5),
          ),
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
          padding: EdgeInsets.symmetric(
            horizontal: metrics.space(AppSpacing.xl),
            vertical: metrics.space(AppSpacing.md + 2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
          ),
          minimumSize: Size(metrics.size(100), metrics.size(44)),
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
          padding: EdgeInsets.symmetric(
            horizontal: metrics.space(AppSpacing.xl),
            vertical: metrics.space(AppSpacing.md + 2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
          ),
          minimumSize: Size(metrics.size(100), metrics.size(44)),
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
          padding: EdgeInsets.symmetric(
            horizontal: metrics.space(18),
            vertical: metrics.space(12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
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
          padding: EdgeInsets.symmetric(
            horizontal: metrics.space(AppSpacing.lg),
            vertical: metrics.space(AppSpacing.sm),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
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
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
        ),
        elevation: 0,
        pressElevation: 1,
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.18),
        thickness: metrics.stroke(1),
        space: metrics.space(1),
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
        radius: Radius.circular(metrics.radius(AppRadius.sm)),
        thickness: WidgetStatePropertyAll(metrics.size(5)),
        minThumbLength: metrics.size(44),
      ),

      // ── SnackBar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.sm)),
        ),
        backgroundColor: isDark ? MyColors.darkCardFill : MyColors.textPrimary,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: colorScheme.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.xl)),
        ),
      ),

      // ── Bottom Sheet ────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: colorScheme.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(metrics.radius(AppRadius.xl)),
          ),
        ),
        dragHandleColor: colorScheme.outline.withValues(alpha: 0.4),
        dragHandleSize: Size(metrics.size(36), metrics.size(4)),
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? MyColors.darkSurfaceContainer : MyColors.textPrimary,
          borderRadius: BorderRadius.circular(metrics.radius(AppRadius.xs)),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: isDark ? MyColors.darkTextPrimary : Colors.white,
        ),
      ),
    );
  }

  // ── Typography ──────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(
    TextTheme base,
    Color onSurface,
    _ThemeMetrics metrics,
  ) {
    final body = GoogleFonts.manropeTextTheme(
      base,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return body.copyWith(
      displaySmall: GoogleFonts.sora(
        fontSize: metrics.text(36),
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: metrics.text(28),
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: metrics.text(21),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: metrics.text(17),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.15,
        color: onSurface,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: metrics.text(16),
        height: 1.55,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: metrics.text(14),
        height: 1.5,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: metrics.text(12),
        height: 1.45,
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontSize: metrics.text(13),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: metrics.text(15),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: onSurface,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: metrics.text(11),
        color: onSurface.withValues(alpha: 0.78),
      ),
    );
  }

  static double get _effectiveScreenWidth {
    try {
      final width = ScreenUtil().screenWidth;
      if (width > 0) return width;
    } catch (_) {
      // ScreenUtil may be unavailable in early initialization or tests.
    }

    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isNotEmpty) {
      final view = views.first;
      if (view.devicePixelRatio > 0) {
        return view.physicalSize.width / view.devicePixelRatio;
      }
    }
    return 375;
  }
}

enum _DeviceClass { mobile, tablet, desktop }

class _ThemeMetrics {
  const _ThemeMetrics({
    required this.deviceClass,
    required this.textScale,
    required this.spacingScale,
    required this.sizeScale,
  });

  final _DeviceClass deviceClass;
  final double textScale;
  final double spacingScale;
  final double sizeScale;

  factory _ThemeMetrics.fromWidth(double width) {
    if (width < 430) {
      return const _ThemeMetrics(
        deviceClass: _DeviceClass.mobile,
        textScale: 0.95,
        spacingScale: 0.95,
        sizeScale: 0.95,
      );
    }

    if (width < 600) {
      return const _ThemeMetrics(
        deviceClass: _DeviceClass.mobile,
        textScale: 1.0,
        spacingScale: 1.0,
        sizeScale: 1.0,
      );
    }

    if (width < 1200) {
      return const _ThemeMetrics(
        deviceClass: _DeviceClass.tablet,
        textScale: 0.92,
        spacingScale: 0.94,
        sizeScale: 0.94,
      );
    }

    return const _ThemeMetrics(
      deviceClass: _DeviceClass.desktop,
      textScale: 1.03,
      spacingScale: 1.08,
      sizeScale: 1.04,
    );
  }

  double text(double value) => value * textScale;

  double space(double value) => value * spacingScale;

  double size(double value) => value * sizeScale;

  double radius(double value) => value * sizeScale;

  double icon(double value) => value * sizeScale;

  double stroke(double value) => value * sizeScale;
}

