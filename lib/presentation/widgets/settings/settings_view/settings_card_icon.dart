import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class SettingsCardIcon extends StatelessWidget {
  const SettingsCardIcon({super.key, required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.16 : 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.26)),
      ),
      child: Icon(icon, color: accent, size: 24),
    );
  }
}
