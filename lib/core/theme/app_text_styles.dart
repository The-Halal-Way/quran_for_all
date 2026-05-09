import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized text styles for Arabic / Quranic text.
///
/// Usage: `Text(ayah.arabicText, style: AppTextStyles.quranArabic(context))`
class AppTextStyles {
  const AppTextStyles._();

  /// Large Quranic Arabic text (ayah display).
  static TextStyle quranArabic(BuildContext context, {double fontSize = 32}) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      height: 1.8,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Surah name in Arabic (banner / card headers).
  static TextStyle surahArabicName(BuildContext context, {double fontSize = 34}) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  /// Smaller Arabic inline text (pills, labels).
  static TextStyle arabicLabel(BuildContext context, {double fontSize = 16}) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
