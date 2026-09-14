import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class PrayerSectionHeading extends StatelessWidget {
  const PrayerSectionHeading({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      header: true,
      child: Row(
        children: [
          Icon(icon, size: 19, color: colors.secondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(title, style: AppTheme.text(context).titleMedium),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        ],
      ),
    );
  }
}
