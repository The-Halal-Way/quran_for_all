import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';

/// Colors shared by the counter and its immersive focus screen.
class TasbeehVisuals {
  const TasbeehVisuals._();

  static List<Color> heroColors(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const [MyColors.primaryDark, MyColors.primary, Color(0xFF30416F)];
    }
    return [
      AppThemeColors.light.heroStart,
      AppThemeColors.light.heroMiddle,
      AppThemeColors.light.heroEnd,
    ];
  }

  static const Color gold = Color(0xFFF0CE87);
  static const Color mint = Color(0xFF79E6DB);
  static const Color rose = Color(0xFFFFA6C7);
}
