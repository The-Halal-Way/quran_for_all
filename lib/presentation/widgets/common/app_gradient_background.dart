import 'package:flutter/material.dart';

import '../../../core/theme/app_gradients.dart';

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

  /// Custom gradient. Falls back to light/dark [AppGradients.pageBg].
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: null),
      child: child,
    );
  }
}
