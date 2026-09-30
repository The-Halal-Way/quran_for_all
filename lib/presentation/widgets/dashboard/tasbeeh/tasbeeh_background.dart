import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import 'tasbeeh_ornament.dart';

class TasbeehBackground extends StatelessWidget {
  const TasbeehBackground({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [MyColors.darkScaffold, MyColors.darkSurfaceContainer]
              : [
                  AppThemeColors.light.canvas,
                  AppThemeColors.light.surfaceMuted,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TasbeehOrnament(
        opacity: isDark ? 0.1 : 0.08,
        color: isDark ? Colors.white : AppThemeColors.light.brand,
      ),
    );
  }
}
