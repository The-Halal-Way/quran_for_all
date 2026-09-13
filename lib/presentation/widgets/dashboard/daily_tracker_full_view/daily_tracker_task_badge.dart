import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DailyTrackerTaskBadge extends StatelessWidget {
  const DailyTrackerTaskBadge({
    super.key,
    required this.label,
    required this.accent,
  });
  final String label;
  final Color accent;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Text(
      label,
      style: AppTheme.text(
        context,
      ).labelSmall.copyWith(color: accent, fontWeight: AppTheme.weightSemiBold),
    ),
  );
}
