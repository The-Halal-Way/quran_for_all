import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A full-screen gradient background used behind every page's content.
///
/// Automatically adapts to light/dark theme.
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  final Widget child;

  /// Custom gradient. Falls back to light/dark [AppColors.pageBg].
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = gradient ?? (isDark ? AppColors.darkPageBg : AppColors.pageBg);

    return DecoratedBox(
      decoration: BoxDecoration(gradient: bg),
      child: child,
    );
  }
}
