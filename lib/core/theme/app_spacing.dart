/// Spacing & radius tokens on a 4-px grid.
///
/// Usage: `SizedBox(height: AppSpacing.md)`
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

/// Border-radius tokens.
///
/// Usage: `BorderRadius.circular(AppRadius.md)`
class AppRadius {
  const AppRadius._();

  static const double hairline = 1;
  static const double xxs = 2;
  static const double micro = 3;
  static const double tiny = 6;
  static const double tinyPlus = 7;
  static const double xs = 8;
  static const double xsPlus = 9;
  static const double compact = 10;
  static const double small = 11;
  static const double sm = 12;
  static const double base = 14;
  static const double md = 16;
  static const double relaxed = 18;
  static const double lg = 20;
  static const double xlCompact = 22;
  static const double xl = 24;
  static const double xxl = 28;
  static const double full = 999;
}
