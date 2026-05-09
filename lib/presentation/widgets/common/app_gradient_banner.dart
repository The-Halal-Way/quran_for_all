import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// A gradient-filled banner / hero card used at the top of list pages.
///
/// Replaces duplicated Container + gradient + boxShadow patterns in
/// [ReadQuranTopBanner], [LearnHeaderCard], surah-detail header, etc.
class AppGradientBanner extends StatelessWidget {
  const AppGradientBanner({
    super.key,
    required this.gradient,
    required this.child,
    this.borderRadius = AppSpacing.xxl,
    this.padding = const EdgeInsets.all(18),
    this.shadowColor,
  });

  final LinearGradient gradient;
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? gradient.colors.first.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
