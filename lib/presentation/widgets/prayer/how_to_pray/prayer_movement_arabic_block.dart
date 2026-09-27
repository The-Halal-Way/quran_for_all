import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'prayer_movement_block_label.dart';

class PrayerMovementArabicBlock extends StatelessWidget {
  const PrayerMovementArabicBlock({
    super.key,
    required this.arabic,
    required this.accent,
  });

  final String arabic;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final arabicSize = arabic.length > 220 ? 21.0 : 25.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrayerMovementBlockLabel(
            icon: Icons.auto_stories_rounded,
            label: context.l10n.prayerMovementsArabicLabel,
            accent: accent,
          ),
          const SizedBox(height: AppSpacing.md),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SelectableText(
              arabic,
              textAlign: TextAlign.right,
              style: AppTheme.amiri(
                context,
                fontSize: arabicSize,
                fontWeight: AppTheme.weightBold,
                height: 1.85,
                color: isDark ? MyColors.darkTextPrimary : MyColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
