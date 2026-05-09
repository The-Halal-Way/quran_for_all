import 'package:flutter/material.dart';

/// Responsive breakpoints and helper for adapting layout to screen width.
///
/// Usage:
/// ```dart
/// final responsive = AppResponsive.of(context);
/// responsive.isMobile  // < 600
/// responsive.isTablet  // 600..1024
/// responsive.padding   // adaptive horizontal padding
/// ```
class AppResponsive {
  const AppResponsive._(this.width);

  factory AppResponsive.of(BuildContext context) {
    return AppResponsive._(MediaQuery.sizeOf(context).width);
  }

  final double width;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  /// Adaptive horizontal padding: tighter on mobile, wider on larger screens.
  double get padding => isMobile ? 16 : isTablet ? 24 : 32;

  /// Max content width for centering on large screens.
  double get maxContentWidth => isMobile ? double.infinity : 720;

  /// Number of grid columns for module cards.
  int get moduleColumns => isMobile ? 1 : isTablet ? 2 : 3;
}
