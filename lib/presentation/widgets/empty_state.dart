import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/my_colors.dart';
import '../../core/theme/app_spacing.dart';

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
    final width = MediaQuery.sizeOf(context).width;
    final maxCardWidth = width >= 1024 ? 560.0 : width >= 600 ? 500.0 : 420.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.w.clamp(18.0, 30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxCardWidth),
          padding: EdgeInsets.all((AppSpacing.xl + 2).w.clamp(20.0, 30.0)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl + 2),
            color: MyColors.surface.withValues(alpha: 0.92),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.36)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54.w.clamp(48.0, 58.0),
                height: 54.w.clamp(48.0, 58.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  icon,
                  size: 28.sp.clamp(24.0, 30.0),
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg - 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
