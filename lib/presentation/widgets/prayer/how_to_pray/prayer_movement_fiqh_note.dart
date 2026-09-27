import '../shared/prayer_card_shell.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class PrayerMovementFiqhNote extends StatelessWidget {
  const PrayerMovementFiqhNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: MyColors.secondary.withValues(alpha: 0.20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: MyColors.secondaryLight,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.prayerMovementsFiqhNoteTitle,
                  style: text.prayerStepIndex.copyWith(
                    color: titleColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.prayerMovementsFiqhNoteBody,
                  style: text.bodySmall.copyWith(color: bodyColor, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
