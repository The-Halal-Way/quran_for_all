import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/my_colors.dart';

class AppContinueBox extends StatelessWidget {
  const AppContinueBox({
    super.key,
    required this.leading,
    required this.content,
    this.onTap,
    this.trailing,
    this.padding,
  });

  final Widget leading;
  final Widget content;
  final VoidCallback? onTap;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.14),
                MyColors.secondaryLight.withValues(alpha: 0.22),
                colorScheme.tertiary.withValues(alpha: 0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.34),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -24,
                right: -18,
                child: _DecorOrb(
                  size: 72.w.clamp(64.0, 82.0),
                  color: colorScheme.primary.withValues(alpha: 0.10),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -12,
                child: _DecorOrb(
                  size: 52.w.clamp(46.0, 60.0),
                  color: colorScheme.secondary.withValues(alpha: 0.16),
                ),
              ),
              Padding(
                padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    leading,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: content),
                    if (trailing != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorOrb extends StatelessWidget {
  const _DecorOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
