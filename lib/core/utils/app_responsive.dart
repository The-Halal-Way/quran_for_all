import 'package:flutter/material.dart';

/// Responsive breakpoints and helper for adapting layout to screen width.
///
/// Usage:
/// ```dart
/// final responsive = AppResponsive.of(context);
/// responsive.isMobile  // < 600
/// responsive.isTablet  // 600..1199
/// responsive.padding   // adaptive horizontal padding
/// ```
class AppResponsive {
  const AppResponsive._(this.width);

  factory AppResponsive.of(BuildContext context) {
    return AppResponsive._(MediaQuery.sizeOf(context).width);
  }

  factory AppResponsive.ofWidth(double width) {
    return AppResponsive._(width);
  }

  final double width;

  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1200;

  bool get isMobile => width < mobileBreakpoint;
  bool get isTablet => width >= mobileBreakpoint && width < desktopBreakpoint;
  bool get isDesktop => width >= desktopBreakpoint;
  bool get isLargeTablet => width >= 900 && width < desktopBreakpoint;
  bool get isCompactPhone => width >= 360 && width < 430;
  bool get isSmallPhone => width < 360;

  /// Global downscale for narrow phones (for example 390-420 dp widths).
  double get compactPhoneScale {
    if (isSmallPhone) return 0.90;
    if (isCompactPhone) return 0.95;
    return 1.0;
  }

  /// Adaptive horizontal padding: tighter on mobile, wider on larger screens.
  double get padding {
    if (isSmallPhone) return 14;
    if (isCompactPhone) return 15;
    if (isMobile) return 16;
    if (isLargeTablet) return 26;
    if (isTablet) return 22;
    return 30;
  }

  /// Vertical spacing baseline between major sections.
  double get sectionGap => isMobile
      ? (isCompactPhone ? 13 : 14)
      : isTablet
      ? 16
      : 18;

  /// Max content width for centering on large screens.
  double get maxContentWidth => isMobile
      ? double.infinity
      : isTablet
      ? 860
      : 980;

  /// Slightly wider canvas for content-heavy pages.
  double get maxReadingContentWidth => isMobile
      ? double.infinity
      : isTablet
      ? 920
      : 1040;

  /// Safe width for bottom sheets on larger screens.
  double get maxSheetWidth => isMobile
      ? double.infinity
      : isTablet
      ? 760
      : 860;

  /// Safe width for dialogs on larger screens.
  double get maxDialogWidth => isMobile
      ? double.infinity
      : isTablet
      ? 620
      : 700;

  /// Generic responsive value picker.
  double pick({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isTablet) return tablet;
    if (isDesktop) return desktop;
    return mobile * compactPhoneScale;
  }

  /// Keep iconography and visual blocks from over-scaling on larger devices.
  double moderate(
    double base, {
    double tabletFactor = 0.94,
    double desktopFactor = 1.0,
  }) {
    if (isTablet) {
      return base * tabletFactor;
    }
    if (isDesktop) {
      return base * desktopFactor;
    }
    return base;
  }

  /// Select responsive grid column count.
  int columns({int mobile = 1, int tablet = 2, int desktop = 3}) {
    if (isTablet) return tablet;
    if (isDesktop) return desktop;
    return mobile;
  }

  /// Number of grid columns for module cards.
  int get moduleColumns => columns();
}
