import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import '../prayer_visuals.dart';
import '../shared/prayer_card_shell.dart';

class PrayerNowCard extends StatelessWidget {
  const PrayerNowCard({super.key, required this.content});

  final PrayerFocusContent content;

  @override
  Widget build(BuildContext context) {
    final accent = PrayerVisuals.accentFor(content.prayer);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final text = AppTheme.text(context);

    return PrayerCardShell(
      gradient: LinearGradient(
        colors: [
          accent.withValues(alpha: isDark ? 0.16 : 0.08),
          MyColors.secondary.withValues(alpha: isDark ? 0.11 : 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: accent.withValues(alpha: 0.22),
      shadowColor: accent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.18 : 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: accent.withValues(alpha: 0.32)),
            ),
            child: Icon(Icons.route_rounded, color: accent, size: 23),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.now.title,
                  style: text.prayerCardTitle.copyWith(
                    color: textColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  content.now.body,
                  style: text.prayerCardBody.copyWith(
                    color: subColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
