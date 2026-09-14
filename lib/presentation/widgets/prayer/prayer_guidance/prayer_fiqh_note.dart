import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

import '../shared/prayer_card_shell.dart';

class PrayerFiqhNote extends StatelessWidget {
  const PrayerFiqhNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final text = AppTheme.text(context);

    return PrayerCardShell(
      margin: const EdgeInsets.only(top: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: MyColors.tertiary.withValues(alpha: 0.22),
      gradient: LinearGradient(
        colors: [
          MyColors.tertiary.withValues(alpha: isDark ? 0.12 : 0.06),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: MyColors.tertiary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.prayerViewFiqhNoteTitle,
                  style: text.prayerStepIndex.copyWith(
                    color: textColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.prayerViewFiqhNoteBody,
                  style: text.bodySmall.copyWith(color: subColor, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
