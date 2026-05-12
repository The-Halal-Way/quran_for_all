import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final resolvedPadding = EdgeInsets.fromLTRB(
      padding.left.w.clamp(14.0, 24.0),
      padding.top.h.clamp(14.0, 24.0),
      padding.right.w.clamp(14.0, 24.0),
      padding.bottom.h.clamp(14.0, 24.0),
    );

    return Container(
      width: double.infinity,
      padding: resolvedPadding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(
          borderRadius.r.clamp(16.0, 30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? gradient.colors.first.withValues(alpha: 0.20),
            blurRadius: 24.r.clamp(18.0, 26.0),
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: (shadowColor ?? gradient.colors.first).withValues(alpha: 0.07),
            blurRadius: 56.r.clamp(34.0, 58.0),
            offset: const Offset(0, 28),
          ),
        ],
      ),
      child: child,
    );
  }
}
