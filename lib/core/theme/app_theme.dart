import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  const AppTheme._();

  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  static AppTypography text(BuildContext context) {
    return AppTypography._(Theme.of(context), _themeMetrics);
  }

  static double scaledFontSize(BuildContext context, double size) {
    return _themeMetrics.text(size);
  }

  static TextStyle quranArabic(BuildContext context, {double? fontSize}) {
    return text(context).quranArabic.copyWith(fontSize: fontSize);
  }

  static TextStyle surahArabicName(BuildContext context, {double? fontSize}) {
    return text(context).surahArabicName.copyWith(fontSize: fontSize);
  }

  static TextStyle arabicLabel(BuildContext context, {double? fontSize}) {
    return text(context).arabicLabel.copyWith(fontSize: fontSize);
  }

  static TextStyle learnArabicLetter(BuildContext context, {double? fontSize}) {
    return text(context).learnArabicLetter.copyWith(fontSize: fontSize);
  }

  static TextStyle learnArabicWord(BuildContext context, {double? fontSize}) {
    return text(context).learnArabicWord.copyWith(fontSize: fontSize);
  }

  static TextStyle sora(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.sora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle manrope(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle amiri(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

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
    final metrics = _themeMetrics;
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

  static _ThemeMetrics get _themeMetrics {
    return _ThemeMetrics.fromWidth(_effectiveScreenWidth);
  }
}

class AppTypography {
  const AppTypography._(this._theme, this._metrics);

  final ThemeData _theme;
  final _ThemeMetrics _metrics;

  TextTheme get _textTheme => _theme.textTheme;
  ColorScheme get _colorScheme => _theme.colorScheme;

  TextStyle get displaySmall => _required(_textTheme.displaySmall);
  TextStyle get headlineMedium => _required(_textTheme.headlineMedium);
  TextStyle get titleLarge => _required(_textTheme.titleLarge);
  TextStyle get titleMedium => _required(_textTheme.titleMedium);
  TextStyle get titleSmall => _required(_textTheme.titleSmall);
  TextStyle get bodyLarge => _required(_textTheme.bodyLarge);
  TextStyle get bodyMedium => _required(_textTheme.bodyMedium);
  TextStyle get bodySmall => _required(_textTheme.bodySmall);
  TextStyle get labelLarge => _required(_textTheme.labelLarge);
  TextStyle get labelMedium => _required(_textTheme.labelMedium);
  TextStyle get labelSmall => _required(_textTheme.labelSmall);

  TextStyle get dashboardBismillah => _amiri(
    size: 21,
    weight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0.2,
  );

  TextStyle get dashboardWatermarkArabic =>
      _amiri(size: 36, weight: FontWeight.bold);

  TextStyle get dashboardEyebrow => labelMedium.copyWith(
    fontSize: _metrics.text(13),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  TextStyle get dashboardDate => bodySmall.copyWith(
    fontSize: _metrics.text(12),
    fontWeight: FontWeight.w500,
  );

  TextStyle get dashboardSectionTitle => titleMedium.copyWith(
    fontSize: _metrics.text(16),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  TextStyle get dashboardCardEyebrow => labelSmall.copyWith(
    fontSize: _metrics.text(10),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  TextStyle get dashboardCardTitle => titleSmall.copyWith(
    fontSize: _metrics.text(13),
    fontWeight: FontWeight.w700,
  );

  TextStyle get dashboardCardMeta => bodySmall.copyWith(
    fontSize: _metrics.text(10),
    fontWeight: FontWeight.w500,
  );

  TextStyle get dashboardPrayerName => bodyMedium.copyWith(
    fontSize: _metrics.text(14),
    fontWeight: FontWeight.w500,
  );

  TextStyle get dashboardPrayerNameActive =>
      dashboardPrayerName.copyWith(fontWeight: FontWeight.w700);

  TextStyle get dashboardPrayerTime => titleSmall.copyWith(
    fontSize: _metrics.text(14),
    fontWeight: FontWeight.w500,
  );

  TextStyle get dashboardPrayerTimeActive =>
      dashboardPrayerTime.copyWith(fontWeight: FontWeight.w800);

  TextStyle get dashboardNextPrayerName =>
      titleMedium.copyWith(fontWeight: FontWeight.w800);

  TextStyle get dashboardNextPrayerTime =>
      titleLarge.copyWith(fontWeight: FontWeight.w800);

  TextStyle get dashboardTinyBadge => labelSmall.copyWith(
    fontSize: _metrics.text(9),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  TextStyle get dashboardActionTitle => titleSmall.copyWith(
    fontSize: _metrics.text(12),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
  );

  TextStyle get dashboardActionSubtitle =>
      bodySmall.copyWith(fontSize: _metrics.text(10));

  TextStyle get dashboardHadithNumber => titleLarge.copyWith(
    fontSize: _metrics.text(22),
    fontWeight: FontWeight.w800,
    height: 1,
  );

  TextStyle get dashboardHadithLabel => labelSmall.copyWith(
    fontSize: _metrics.text(9),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  TextStyle get dashboardHadithArabicTitle => _amiri(size: 17, height: 1.3);

  TextStyle get dashboardHadithTitle => titleSmall.copyWith(
    fontSize: _metrics.text(13),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
  );

  TextStyle get dashboardHadithDescription => bodySmall.copyWith(
    fontSize: _metrics.text(11),
    fontWeight: FontWeight.w500,
  );

  TextStyle get compassTitle => titleLarge.copyWith(
    fontSize: _metrics.text(22),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );

  TextStyle get compassSubtitle => labelSmall.copyWith(
    fontSize: _metrics.text(12),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  TextStyle get compassHeading => displaySmall.copyWith(
    fontSize: _metrics.text(64),
    fontWeight: FontWeight.w700,
    letterSpacing: -3,
    height: 1,
  );

  TextStyle get compassDegreeSymbol => titleLarge.copyWith(
    fontSize: _metrics.text(30),
    fontWeight: FontWeight.w400,
  );

  TextStyle get compassDialCardinal => titleMedium.copyWith(
    fontSize: _metrics.text(14),
    fontWeight: FontWeight.w700,
  );

  TextStyle get compassDialNorth =>
      compassDialCardinal.copyWith(fontSize: _metrics.text(17));

  TextStyle get compassDialOrdinal => labelSmall.copyWith(
    fontSize: _metrics.text(9),
    fontWeight: FontWeight.w600,
  );

  TextStyle get compassMeccaLabel => labelSmall.copyWith(
    fontSize: _metrics.text(8),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  TextStyle get compassInfoAction => labelSmall.copyWith(
    fontSize: _metrics.text(9),
    fontWeight: FontWeight.w700,
  );

  TextStyle get compassHeadingMedium => displaySmall.copyWith(
    fontSize: _metrics.text(42),
    fontWeight: FontWeight.w800,
  );

  TextStyle get compassHeadingSmall => titleSmall.copyWith(
    fontSize: _metrics.text(13),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  TextStyle get compassPill => labelSmall.copyWith(
    fontSize: _metrics.text(11),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.7,
  );

  TextStyle get compassInfoValue => titleMedium.copyWith(
    fontSize: _metrics.text(18),
    fontWeight: FontWeight.w800,
  );

  TextStyle get compassInfoLabel => labelSmall.copyWith(
    fontSize: _metrics.text(11),
    fontWeight: FontWeight.w600,
  );

  TextStyle get prayerAppBarTitle => titleMedium.copyWith(
    fontSize: _metrics.text(16),
    fontWeight: FontWeight.w800,
  );

  TextStyle get prayerAppBarSubtitle => labelSmall.copyWith(
    fontSize: _metrics.text(10.5),
    fontWeight: FontWeight.w600,
  );

  TextStyle get prayerHeroTitle => headlineMedium.copyWith(
    fontSize: _metrics.text(27),
    fontWeight: FontWeight.w800,
    height: 1.12,
  );

  TextStyle get prayerHeroSubtitle => bodyMedium.copyWith(
    fontSize: _metrics.text(13.5),
    fontWeight: FontWeight.w600,
    height: 1.48,
  );

  TextStyle get prayerHeroLabel => labelSmall.copyWith(
    fontSize: _metrics.text(11.5),
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  TextStyle get prayerHeroTime => displaySmall.copyWith(
    fontSize: _metrics.text(31),
    fontWeight: FontWeight.w900,
    height: 1,
  );

  TextStyle get prayerHeroChip => labelSmall.copyWith(
    fontSize: _metrics.text(10.5),
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  TextStyle get prayerTimelineName => titleSmall.copyWith(
    fontSize: _metrics.text(14),
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  TextStyle get prayerTimelineNameActive =>
      prayerTimelineName.copyWith(fontWeight: FontWeight.w800);

  TextStyle get prayerTimelineTime => titleSmall.copyWith(
    fontSize: _metrics.text(15),
    fontWeight: FontWeight.w600,
  );

  TextStyle get prayerTimelineTimeActive =>
      prayerTimelineTime.copyWith(fontWeight: FontWeight.w800);

  TextStyle get prayerStatusChip => labelSmall.copyWith(
    fontSize: _metrics.text(10.5),
    fontWeight: FontWeight.w800,
    height: 1.1,
  );

  TextStyle get prayerCardTitle => titleSmall.copyWith(
    fontSize: _metrics.text(15),
    fontWeight: FontWeight.w800,
  );

  TextStyle get prayerCardBody => bodySmall.copyWith(
    fontSize: _metrics.text(13),
    fontWeight: FontWeight.w500,
  );

  TextStyle get prayerCardBodyEmphasis =>
      prayerCardBody.copyWith(fontWeight: FontWeight.w600, height: 1.5);

  TextStyle get prayerStepIndex => titleSmall.copyWith(
    fontSize: _metrics.text(13),
    fontWeight: FontWeight.w900,
  );

  TextStyle get hadithArabicTitle => _amiri(size: 30, weight: FontWeight.bold);

  TextStyle get hadithArabicHeader => _amiri(size: 28, weight: FontWeight.bold);

  TextStyle get hadithArabicBody => _amiri(size: 26, height: 1.9);

  TextStyle get hadithTitle => titleMedium.copyWith(
    fontSize: _metrics.text(17),
    fontWeight: FontWeight.w700,
  );

  TextStyle get hadithSubtitle =>
      bodySmall.copyWith(fontSize: _metrics.text(11));

  TextStyle get hadithBody => bodyMedium.copyWith(fontSize: _metrics.text(14));

  TextStyle get hadithLoadingArabicTitle =>
      _amiri(size: 28, weight: FontWeight.bold);

  TextStyle get hadithHeaderArabicTitle =>
      _amiri(size: 22, weight: FontWeight.bold, letterSpacing: 0.5);

  TextStyle get hadithHeaderTitle =>
      _sora(size: 12, weight: FontWeight.w700, letterSpacing: -0.1);

  TextStyle get hadithHeaderLabel =>
      _manrope(size: 13, weight: FontWeight.w600, letterSpacing: 0.3);

  TextStyle get hadithHeaderSubtitle =>
      _manrope(size: 10, weight: FontWeight.w500);

  TextStyle get hadithHeaderProgress =>
      _manrope(size: 11, weight: FontWeight.w500);

  TextStyle get hadithProgressCount =>
      _manrope(size: 11, weight: FontWeight.w700);

  TextStyle get hadithBottomNavLabel =>
      _manrope(size: 12, weight: FontWeight.w700);

  TextStyle get hadithBottomIntro =>
      _manrope(size: 10, weight: FontWeight.w600);

  TextStyle get hadithIntroArabicTitle =>
      _amiri(size: 30, weight: FontWeight.bold);

  TextStyle get hadithIntroBookTitle =>
      _manrope(size: 13, weight: FontWeight.w500, letterSpacing: 0.5);

  TextStyle get hadithIntroAuthor =>
      _manrope(size: 12, weight: FontWeight.w500);

  TextStyle get hadithSectionTitle => _sora(size: 16, weight: FontWeight.w700);

  TextStyle hadithParagraph({required bool isBangla}) {
    return _manrope(size: isBangla ? 15 : 14, height: isBangla ? 1.9 : 1.7);
  }

  TextStyle get hadithTranslationLabel =>
      _manrope(size: 11, weight: FontWeight.w700, letterSpacing: 0.8);

  TextStyle get hadithArabicBadge => _amiri(size: 12);

  TextStyle get hadithArabicCardBody =>
      _amiri(size: 22, height: 1.9, weight: FontWeight.normal);

  TextStyle get hadithJumpTitle => _sora(size: 17, weight: FontWeight.w700);

  TextStyle get hadithJumpCount => _manrope(size: 11);

  TextStyle get hadithJumpSearch => _manrope(size: 14);

  TextStyle get hadithJumpSearchHint => _manrope(size: 13);

  TextStyle get hadithJumpNumber => _sora(size: 13, weight: FontWeight.w800);

  TextStyle get hadithJumpArabic => _amiri(size: 15, height: 1.4);

  TextStyle get hadithJumpSubtitle =>
      _manrope(size: 11, weight: FontWeight.w500);

  TextStyle get hadithPillOption => _manrope(size: 11, weight: FontWeight.w700);

  TextStyle get hadithStatValue => _sora(size: 16, weight: FontWeight.w800);

  TextStyle get hadithStatLabel => _manrope(size: 10, weight: FontWeight.w500);

  TextStyle get hadithShortMemorizeBadge =>
      _manrope(size: 10, weight: FontWeight.w700, letterSpacing: 1.2);

  TextStyle get hadithShortArabicShowcase =>
      _amiri(size: 30, height: 1.8, weight: FontWeight.bold);

  TextStyle get hadithShortHeadline => _sora(
    size: 16,
    weight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.2,
  );

  TextStyle get hadithShortLessonLabel =>
      _manrope(size: 10, weight: FontWeight.w700, letterSpacing: 0.8);

  TextStyle get hadithShortLessonIndex =>
      _manrope(size: 10, weight: FontWeight.w800);

  TextStyle hadithShortLessonBody({required bool isBangla}) {
    return _manrope(
      size: isBangla ? 14.5 : 13.5,
      height: isBangla ? 1.75 : 1.6,
    );
  }

  TextStyle get duahAppBarTitle =>
      titleMedium.copyWith(fontWeight: FontWeight.w700);

  TextStyle get duahAppBarSubtitle => bodySmall;

  TextStyle get duahLevelCount =>
      labelSmall.copyWith(fontWeight: FontWeight.w700);

  TextStyle get duahLevelDescription => bodySmall.copyWith(height: 1.4);

  TextStyle duahLevelTab({required bool isSelected}) => labelMedium.copyWith(
    fontSize: _metrics.text(11.5),
    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
  );

  TextStyle get duahSectionCount =>
      labelSmall.copyWith(fontWeight: FontWeight.w700);

  TextStyle get duahCardLabel =>
      labelMedium.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2);

  TextStyle get duahCardArabic => duahArabic.copyWith(
    fontSize: _metrics.text(24),
    height: 1.8,
    fontWeight: FontWeight.w400,
  );

  TextStyle get duahCardBodyItalic =>
      bodyMedium.copyWith(fontStyle: FontStyle.italic, height: 1.4);

  TextStyle get duahCardBody => bodyMedium.copyWith(height: 1.4);

  TextStyle get duahVariantToggle =>
      labelMedium.copyWith(fontSize: _metrics.text(12));

  TextStyle get duahSubItemTitle =>
      labelSmall.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3);

  TextStyle get duahSubItemArabic =>
      duahArabic.copyWith(fontSize: _metrics.text(20), height: 1.8);

  TextStyle get powerfulDuahAppBarTitle =>
      titleLarge.copyWith(fontWeight: FontWeight.w700);

  TextStyle get powerfulDuahNoteTitle =>
      labelMedium.copyWith(fontWeight: FontWeight.w700);

  TextStyle get powerfulDuahNoteBody => bodySmall.copyWith(height: 1.5);

  TextStyle get powerfulDuahFilterButton => labelMedium.copyWith(
    fontSize: _metrics.text(12),
    fontWeight: FontWeight.w700,
  );

  TextStyle powerfulDuahFilterChip({required bool isActive}) =>
      labelMedium.copyWith(
        fontSize: _metrics.text(12),
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
      );

  TextStyle get powerfulDuahCount => bodyMedium;

  TextStyle get powerfulDuahCountMeta => bodySmall;

  TextStyle get powerfulDuahNumber => labelMedium.copyWith(
    fontSize: _metrics.text(12),
    fontWeight: FontWeight.w800,
  );

  TextStyle get powerfulDuahSource => labelSmall.copyWith(letterSpacing: 0.2);

  TextStyle get powerfulDuahArabic => duahArabic.copyWith(
    fontSize: _metrics.text(22),
    height: 2.0,
    fontWeight: FontWeight.w400,
  );

  TextStyle get powerfulDuahPronunciation =>
      bodyMedium.copyWith(fontStyle: FontStyle.italic, height: 1.5);

  TextStyle get powerfulDuahPronunciationHidden => bodySmall;

  TextStyle get powerfulDuahTranslation => bodyMedium.copyWith(height: 1.55);

  TextStyle get powerfulDuahTag => labelSmall.copyWith(
    fontSize: _metrics.text(10),
    fontWeight: FontWeight.w700,
  );

  TextStyle get powerfulDuahCopyAction =>
      labelSmall.copyWith(fontWeight: FontWeight.w700);

  TextStyle get quranArabic => _amiri(size: 32, height: 1.8);

  TextStyle get surahArabicName => _amiri(size: 34, weight: FontWeight.w700);

  TextStyle get arabicLabel => _amiri(size: 16);

  TextStyle get learnArabicLetter =>
      _amiri(size: 35, height: 1.2, weight: FontWeight.w700);

  TextStyle get learnArabicWord =>
      _amiri(size: 31, height: 1.35, weight: FontWeight.w700);

  TextStyle get duahArabic => TextStyle(
    fontFamily: 'Scheherazade New',
    fontSize: _metrics.text(22),
    height: 1.9,
    fontWeight: FontWeight.w600,
    color: _colorScheme.onSurface,
  );

  TextStyle _amiri({
    required double size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.amiri(
      fontSize: _metrics.text(size),
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: _colorScheme.onSurface,
    );
  }

  TextStyle _manrope({
    required double size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.manrope(
      fontSize: _metrics.text(size),
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: _colorScheme.onSurface,
    );
  }

  TextStyle _sora({
    required double size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.sora(
      fontSize: _metrics.text(size),
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: _colorScheme.onSurface,
    );
  }

  TextStyle _required(TextStyle? style) {
    return style ?? const TextStyle();
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
