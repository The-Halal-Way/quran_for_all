import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class PrayerCardShell extends StatelessWidget {
  const PrayerCardShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.gradient,
    this.color,
    this.borderColor,
    this.shadowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = color ?? (isDark ? MyColors.darkCardFill : Colors.white);
    final border =
        borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.07)
            : MyColors.divider.withValues(alpha: 0.85));

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border, width: 0.8),
        boxShadow: AppShadows.card(tint: shadowColor ?? MyColors.primary),
      ),
      child: child,
    );
  }
}
