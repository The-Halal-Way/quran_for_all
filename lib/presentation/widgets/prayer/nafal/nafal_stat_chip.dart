import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class NafalStatChip extends StatelessWidget {
  const NafalStatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.accent,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(label, style: text.prayerStatusChip.copyWith(color: accent)),
        ],
      ),
    );
  }
}
