import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class RamadanSectionHeading extends StatelessWidget {
  const RamadanSectionHeading({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: scheme.secondary, size: 21),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: AppTheme.text(
                  context,
                ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppTheme.text(
            context,
          ).bodySmall.copyWith(color: scheme.onSurfaceVariant, height: 1.45),
        ),
      ],
    );
  }
}
