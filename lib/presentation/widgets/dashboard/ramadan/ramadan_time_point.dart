import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class RamadanTimePoint extends StatelessWidget {
  const RamadanTimePoint({
    required this.icon,
    required this.label,
    required this.time,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String time;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: accent.withValues(alpha: 0.16)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accent, size: 19),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTheme.text(context).labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            time,
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
        ),
      ],
    ),
  );
}
