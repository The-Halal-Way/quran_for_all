import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'prayer_movement_arabic_block.dart';
import 'prayer_movement_badge.dart';
import 'prayer_movement_note.dart';
import 'prayer_movement_number_badge.dart';
import 'prayer_movement_text_block.dart';

class PrayerMovementStepDetails extends StatelessWidget {
  const PrayerMovementStepDetails({
    super.key,
    required this.step,
    required this.accent,
  });

  final PrayerMovementStep step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PrayerMovementNumberBadge(number: step.number, accent: accent),
            PrayerMovementBadge(label: step.badge, accent: accent),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          step.title,
          style: text.prayerHeroTitle.copyWith(
            color: titleColor,
            fontSize: AppTheme.scaledFontSize(context, 23),
            height: 1.13,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          step.body,
          style: text.prayerCardBodyEmphasis.copyWith(
            color: bodyColor,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrayerMovementArabicBlock(arabic: step.arabic, accent: accent),
        const SizedBox(height: AppSpacing.md),
        PrayerMovementTextBlock(
          icon: Icons.record_voice_over_rounded,
          label: context.l10n.prayerMovementsPronunciationLabel,
          value: step.pronunciation,
          accent: accent,
        ),
        const SizedBox(height: AppSpacing.md),
        PrayerMovementTextBlock(
          icon: Icons.translate_rounded,
          label: context.l10n.prayerMovementsTranslationLabel,
          value: step.translation,
          accent: MyColors.tertiary,
        ),
        const SizedBox(height: AppSpacing.md),
        PrayerMovementNote(note: step.note, accent: accent),
      ],
    );
  }
}
