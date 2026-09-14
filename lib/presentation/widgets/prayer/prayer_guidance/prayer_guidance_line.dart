import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class PrayerGuidanceLine extends StatelessWidget {
  const PrayerGuidanceLine({
    super.key,
    required this.icon,
    required this.body,
    required this.accent,
    this.marker,
  });

  final IconData icon;
  final String? marker;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final text = AppTheme.text(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: marker == null
              ? Icon(icon, size: 17, color: accent)
              : Center(
                  child: Text(
                    marker!,
                    style: text.prayerStepIndex.copyWith(color: accent),
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            body,
            style: text.prayerCardBodyEmphasis.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
