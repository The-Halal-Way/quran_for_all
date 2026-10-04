import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class NafalInfoPill extends StatelessWidget {
  const NafalInfoPill({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final valueColor = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(
            '$label: ',
            style: text.prayerStatusChip.copyWith(color: accent),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: text.prayerStatusChip.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
