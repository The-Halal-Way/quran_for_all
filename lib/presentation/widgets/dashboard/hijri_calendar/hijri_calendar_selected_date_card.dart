import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class HijriCalendarSelectedDateCard extends StatelessWidget {
  const HijriCalendarSelectedDateCard({
    super.key,
    required this.hijriDate,
    required this.gregorianDate,
    required this.isDark,
  });

  final String hijriDate;
  final String gregorianDate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : MyColors.divider.withValues(alpha: 0.85);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: MyColors.tertiary.withValues(alpha: isDark ? 0.16 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MyColors.tertiary.withValues(alpha: isDark ? 0.18 : 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: MyColors.tertiary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.hijriSelectedDateTitle,
                  style: text.labelMedium.copyWith(
                    color: subColor,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hijriDate,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleMedium.copyWith(
                    color: titleColor,
                    fontWeight: AppTheme.weightBold,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  gregorianDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall.copyWith(color: subColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
