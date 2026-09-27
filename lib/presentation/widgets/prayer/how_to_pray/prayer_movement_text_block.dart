import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'prayer_movement_block_label.dart';

class PrayerMovementTextBlock extends StatelessWidget {
  const PrayerMovementTextBlock({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final color = isDark ? MyColors.darkTextSecondary : MyColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrayerMovementBlockLabel(icon: icon, label: label, accent: accent),
        const SizedBox(height: AppSpacing.xs),
        SelectableText(
          value,
          style: text.prayerCardBodyEmphasis.copyWith(
            color: color,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
