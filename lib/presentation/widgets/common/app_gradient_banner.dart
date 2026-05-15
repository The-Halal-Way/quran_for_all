import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';

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
    final responsive = AppResponsive.of(context);
    final resolvedPadding = EdgeInsets.fromLTRB(
      responsive.pick(
        mobile: padding.left,
        tablet: padding.left * 0.95,
        desktop: padding.left,
      ),
      responsive.pick(
        mobile: padding.top,
        tablet: padding.top * 0.95,
        desktop: padding.top,
      ),
      responsive.pick(
        mobile: padding.right,
        tablet: padding.right * 0.95,
        desktop: padding.right,
      ),
      responsive.pick(
        mobile: padding.bottom,
        tablet: padding.bottom * 0.95,
        desktop: padding.bottom,
      ),
    );

    final resolvedBorderRadius = responsive
        .pick(
          mobile: borderRadius,
          tablet: borderRadius * 0.96,
          desktop: borderRadius,
        )
        .clamp(16.0, 30.0);

    return Container(
      width: double.infinity,
      padding: resolvedPadding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(resolvedBorderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? gradient.colors.first.withValues(alpha: 0.20),
            blurRadius: responsive.pick(mobile: 24, tablet: 22, desktop: 24),
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: (shadowColor ?? gradient.colors.first).withValues(
              alpha: 0.07,
            ),
            blurRadius: responsive.pick(mobile: 56, tablet: 48, desktop: 56),
            offset: const Offset(0, 28),
          ),
        ],
      ),
      child: child,
    );
  }
}
