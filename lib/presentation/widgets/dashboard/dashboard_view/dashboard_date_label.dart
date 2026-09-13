import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DashboardDateLabel extends StatelessWidget {
  const DashboardDateLabel({
    super.key,
    required this.label,
    required this.icon,
    this.highlighted = false,
  });
  final String label;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = highlighted
        ? (dark ? MyColors.tertiaryLight : MyColors.tertiaryDark)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            label,
            style: AppTheme.text(context).dashboardDate.copyWith(
              color: color,
              fontWeight: AppTheme.weightSemiBold,
            ),
          ),
        ),
      ],
    );
  }
}
