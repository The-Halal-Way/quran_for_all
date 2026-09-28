import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class RamadanHeroTag extends StatelessWidget {
  const RamadanHeroTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.full),
      color: Colors.white.withValues(alpha: 0.11),
      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
    ),
    child: Text(
      label,
      style: AppTheme.text(context).labelSmall.copyWith(
        color: Colors.white,
        fontWeight: AppTheme.weightBold,
      ),
    ),
  );
}
