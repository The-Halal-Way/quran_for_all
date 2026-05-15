import 'package:flutter/material.dart';

import '../../core/theme/my_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/app_responsive.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final maxCardWidth = responsive.pick(
      mobile: 420,
      tablet: 500,
      desktop: 560,
    );
    final outerPadding = responsive.pick(mobile: 20, tablet: 22, desktop: 24);
    final innerPadding = responsive.pick(mobile: 22, tablet: 24, desktop: 26);
    final iconBoxSize = responsive.pick(mobile: 54, tablet: 52, desktop: 56);
    final iconSize = responsive.pick(mobile: 28, tablet: 26, desktop: 29);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(outerPadding),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxCardWidth),
          padding: EdgeInsets.all(innerPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl + 2),
            color: MyColors.surface.withValues(alpha: 0.92),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.36),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(icon, size: iconSize, color: colorScheme.primary),
              ),
              const SizedBox(height: AppSpacing.lg - 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
