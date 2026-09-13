import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardSectionTitle extends StatelessWidget {
  const DashboardSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
  });
  final String title;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.dark
        ? Color.lerp(accent, Colors.white, 0.45)!
        : accent;
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          flex: 4,
          child: Text(
            title,
            style: AppTheme.text(context).dashboardSectionTitle,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Divider(color: color.withValues(alpha: 0.2))),
      ],
    );
  }
}
