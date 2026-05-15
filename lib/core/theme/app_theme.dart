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
        textScale: 0.85,
        spacingScale: 0.85,
        sizeScale: 0.85,
      );
    }

    return const _ThemeMetrics(
      deviceClass: _DeviceClass.desktop,
      textScale: 1.2,
      spacingScale: 1.5,
      sizeScale: 1.2,
    );
  }

  double text(double value) => value * textScale;

  double space(double value) => value * spacingScale;

  double size(double value) => value * sizeScale;

  double radius(double value) => value * sizeScale;

  double icon(double value) => value * sizeScale;

  double stroke(double value) => value * sizeScale;
}

/*
// appTheme.dart

abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double responsiveTextScale(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 0.85;
    return 1.2;
  }

  static double responsiveSpacing(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 0.85;
    return 1.5;
  }

  static double tabletSizeMultiplier(BuildContext context) {
    if (isTablet(context)) return 0.85;
    return 1.0;
  }

  static double getResponsiveSize(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) {
      return tabletSize * tabletSizeMultiplier(context);
    }
    return desktopSize;
  }

  static double getResponsiveTextSize(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    return desktopSize;
  }

  static ThemeData light(BuildContext context) => ThemeData(
    useMaterial3: true,
    visualDensity: visualDensity,
    primaryColor: MyColor.primary,
    scaffoldBackgroundColor: MyColor.surface,
    cardColor: MyColor.surfaceContainer,
    iconTheme: IconThemeData(
      color: MyColor.onSurfaceVariant,
      size: getResponsiveSize(context, 20.w, 16.w, 24.w),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleSpacing: getResponsiveSize(context, 16.w, 12.w, 24.w),
      centerTitle: isTablet(context) ? true : false,
      iconTheme: IconThemeData(
        color: MyColor.onSurfaceVariant,
        size: getResponsiveSize(context, 20.w, 16.w, 24.w),
      ),
      backgroundColor: MyColor.primary,
      titleTextStyle: TextStyle(
        color: MyColor.onSurface,
        fontSize: getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp),
        fontFamily: MyString.poppinsMedium,
        fontWeight: FontWeight.w600,
      ),
      toolbarHeight: getResponsiveSize(context, 56.h, 75.h, 64.h),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: MyColor.primary,
      onPrimary: MyColor.onPrimary,
      primaryContainer: MyColor.primaryContainer,
      onPrimaryContainer: MyColor.onPrimaryContainer,
      secondary: MyColor.secondary,
      onSecondary: MyColor.onSecondary,
      secondaryContainer: MyColor.secondaryContainer,
      onSecondaryContainer: MyColor.onSecondaryContainer,
      tertiary: MyColor.secondary,
      onTertiary: MyColor.onSecondary,
      tertiaryContainer: MyColor.secondaryContainer,
      onTertiaryContainer: MyColor.onSecondaryContainer,
      error: MyColor.error,
      onError: MyColor.onPrimary,
      errorContainer: MyColor.errorContainer,
      onErrorContainer: MyColor.onErrorContainer,
      surface: MyColor.surface,
      onSurface: MyColor.onSurface,
      surfaceContainerHighest: MyColor.surfaceContainerHigh,
      onSurfaceVariant: MyColor.onSurfaceVariant,
      outline: MyColor.outline,
      outlineVariant: MyColor.outlineVariant,
      shadow: MyColor.black,
      scrim: MyColor.black,
      inverseSurface: MyColor.darkSurface,
      onInverseSurface: MyColor.darkOnSurface,
      inversePrimary: MyColor.primaryFixedDim,
      surfaceTint: MyColor.primary,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: MyColor.onSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 32.sp, 30.sp, 40.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        color: MyColor.onSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 28.sp, 26.sp, 36.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: MyColor.onSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 24.sp, 22.sp, 32.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: MyColor.onSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 20.sp, 19.sp, 24.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: MyColor.onSurface,
        fontSize:
            getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp) *
            responsiveTextScale(context),
        fontFamily: MyString.poppinsMedium,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurfaceVariant,
        fontFamily: MyString.poppinsRegular,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurface,
        fontFamily: MyString.rubikRegular,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurface,
        fontFamily: MyString.rubikRegular,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 10.sp, 9.5.sp, 12.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurfaceVariant,
        fontFamily: MyString.rubikRegular,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurfaceVariant,
        fontFamily: MyString.poppinsMedium,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 12.sp, 11.sp, 14.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurfaceVariant,
        fontFamily: MyString.poppinsRegular,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 10.sp, 9.5.sp, 12.sp) *
            responsiveTextScale(context),
        color: MyColor.outline,
        fontFamily: MyString.poppinsRegular,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.onSurfaceVariant,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.outline,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w400,
      ),
      isDense: true,
      filled: true,
      prefixIconColor: MyColor.outline,
      fillColor: MyColor.surfaceContainerLowest,
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.h * responsiveSpacing(context),
        horizontal: 18.w * responsiveSpacing(context),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.primary,
          width: 1.5.w * tabletSizeMultiplier(context),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.outlineVariant,
          width: 1.0.w * tabletSizeMultiplier(context),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.error,
          width: 1.5.w * tabletSizeMultiplier(context),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.error,
          width: 1.5.w * tabletSizeMultiplier(context),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              7.r * tabletSizeMultiplier(context),
            ),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 16.h * responsiveSpacing(context),
            horizontal: 24.w * responsiveSpacing(context),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(MyColor.primary),
        foregroundColor: WidgetStateProperty.all(MyColor.onPrimary),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize:
                getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp) *
                responsiveTextScale(context),
            fontFamily: MyString.poppinsMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        minimumSize: WidgetStateProperty.all(
          Size(
            getResponsiveSize(context, 100.w, 85.w, 120.w),
            getResponsiveSize(context, 44.h, 40.h, 52.h),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(MyColor.primary),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize:
                getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
                responsiveTextScale(context),
            fontFamily: MyString.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 8.h * responsiveSpacing(context),
            horizontal: 16.w * responsiveSpacing(context),
          ),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: MyColor.outlineVariant,
      thickness: 1.0.w * tabletSizeMultiplier(context),
      space: 1.0.h * responsiveSpacing(context),
    ),
  );
  static ThemeData dark(BuildContext context) => ThemeData.dark().copyWith(
    visualDensity: visualDensity,
    primaryColor: MyColor.primary,
    scaffoldBackgroundColor: MyColor.darkSurface,
    cardColor: MyColor.darkSurfaceContainer,
    iconTheme: IconThemeData(
      color: MyColor.darkOnSurfaceVariant,
      size: getResponsiveSize(context, 20.w, 16.w, 24.w),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(
        color: MyColor.darkOnSurfaceVariant,
        size: getResponsiveSize(context, 20.w, 16.w, 24.w),
      ),
      backgroundColor: MyColor.darkSurface,
      titleTextStyle: TextStyle(
        color: MyColor.darkOnSurface,
        fontSize: getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp),
        fontFamily: MyString.poppinsMedium,
        fontWeight: FontWeight.w600,
      ),
      toolbarHeight: getResponsiveSize(context, 56.h, 75.h, 64.h),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: MyColor.primary,
      onPrimary: MyColor.onPrimary,
      primaryContainer: MyColor.primaryContainer,
      onPrimaryContainer: MyColor.onPrimaryContainer,
      secondary: MyColor.darkSurfaceContainerHigh,
      onSecondary: MyColor.darkOnSurface,
      secondaryContainer: MyColor.darkSurfaceContainerHigh,
      onSecondaryContainer: MyColor.darkOnSurface,
      tertiary: MyColor.darkSurfaceContainerHigh,
      onTertiary: MyColor.darkOnSurface,
      tertiaryContainer: MyColor.darkSurfaceContainerHigh,
      onTertiaryContainer: MyColor.darkOnSurface,
      error: MyColor.darkError,
      onError: MyColor.onPrimary,
      errorContainer: MyColor.darkErrorContainer,
      onErrorContainer: MyColor.darkOnErrorContainer,
      surface: MyColor.darkSurface,
      onSurface: MyColor.darkOnSurface,
      surfaceContainerHighest: MyColor.darkSurfaceContainerHigh,
      onSurfaceVariant: MyColor.darkOnSurfaceVariant,
      outline: MyColor.darkOutline,
      outlineVariant: MyColor.darkOutlineVariant,
      shadow: MyColor.black,
      scrim: MyColor.black,
      inverseSurface: MyColor.surface,
      onInverseSurface: MyColor.onSurface,
      inversePrimary: MyColor.primaryFixedDim,
      surfaceTint: MyColor.primary,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: MyColor.darkOnSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 32.sp, 30.sp, 40.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        color: MyColor.darkOnSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 28.sp, 26.sp, 36.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: MyColor.darkOnSurface,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 24.sp, 22.sp, 32.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: MyColor.darkSurfaceBright,
        fontFamily: MyString.poppinsMedium,
        fontSize:
            getResponsiveTextSize(context, 20.sp, 19.sp, 24.sp) *
            responsiveTextScale(context),
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: MyColor.darkSurfaceBright,
        fontSize:
            getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp) *
            responsiveTextScale(context),
        fontFamily: MyString.poppinsMedium,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOnSurfaceVariant,
        fontFamily: MyString.poppinsRegular,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOnSurface,
        fontFamily: MyString.rubikRegular,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.darkSurfaceBright,
        fontFamily: MyString.rubikRegular,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 12.sp, 11.5.sp, 14.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOnSurfaceVariant,
        fontFamily: MyString.rubikRegular,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOnSurfaceVariant,
        fontFamily: MyString.poppinsMedium,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 12.sp, 11.sp, 14.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOnSurfaceVariant,
        fontFamily: MyString.poppinsRegular,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 10.sp, 9.5.sp, 12.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOutline,
        fontFamily: MyString.poppinsRegular,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOnSurfaceVariant,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: TextStyle(
        fontSize:
            getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
            responsiveTextScale(context),
        color: MyColor.darkOutline,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w400,
      ),
      isDense: true,
      filled: true,
      prefixIconColor: MyColor.darkOutline,
      fillColor: MyColor.darkSurfaceContainer,
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.h * responsiveSpacing(context),
        horizontal: 18.w * responsiveSpacing(context),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.primary,
          width: 1.5.w * tabletSizeMultiplier(context),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.darkOutlineVariant,
          width: 1.0.w * tabletSizeMultiplier(context),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.darkError,
          width: 1.5.w * tabletSizeMultiplier(context),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r * tabletSizeMultiplier(context)),
        ),
        borderSide: BorderSide(
          color: MyColor.darkError,
          width: 1.5.w * tabletSizeMultiplier(context),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              7.r * tabletSizeMultiplier(context),
            ),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 16.h * responsiveSpacing(context),
            horizontal: 24.w * responsiveSpacing(context),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(MyColor.primary),
        foregroundColor: WidgetStateProperty.all(MyColor.onPrimary),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize:
                getResponsiveTextSize(context, 16.sp, 15.sp, 18.sp) *
                responsiveTextScale(context),
            fontFamily: MyString.poppinsMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        minimumSize: WidgetStateProperty.all(
          Size(
            getResponsiveSize(context, 100.w, 85.w, 120.w),
            getResponsiveSize(context, 44.h, 40.h, 52.h),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(MyColor.primary),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize:
                getResponsiveTextSize(context, 14.sp, 13.sp, 16.sp) *
                responsiveTextScale(context),
            fontFamily: MyString.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 8.h * responsiveSpacing(context),
            horizontal: 16.w * responsiveSpacing(context),
          ),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: MyColor.darkOutlineVariant,
      thickness: 1.0.w * tabletSizeMultiplier(context),
      space: 1.0.h * responsiveSpacing(context),
    ),
  );
}

*/
