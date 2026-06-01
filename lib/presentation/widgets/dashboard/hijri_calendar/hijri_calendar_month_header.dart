import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class HijriCalendarMonthHeader extends StatelessWidget {
  const HijriCalendarMonthHeader({
    super.key,
    required this.monthTitle,
    required this.gregorianRange,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isDark,
  });

  final String monthTitle;
  final String gregorianRange;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      children: [
        _RoundIconButton(
          icon: Icons.chevron_left_rounded,
          tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
          onPressed: canGoPrevious ? onPrevious : null,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                monthTitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleMedium.copyWith(
                  color: titleColor,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                gregorianRange,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall.copyWith(color: subColor),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _RoundIconButton(
          icon: Icons.today_rounded,
          tooltip: context.l10n.hijriCalendarTodayAction,
          onPressed: onToday,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        _RoundIconButton(
          icon: Icons.chevron_right_rounded,
          tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
          onPressed: canGoNext ? onNext : null,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.isDark,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : MyColors.primary.withValues(alpha: 0.07),
        foregroundColor: isDark ? Colors.white : MyColors.primary,
        disabledForegroundColor: (isDark ? Colors.white : MyColors.primary)
            .withValues(alpha: 0.25),
        minimumSize: const Size(38, 38),
        fixedSize: const Size(38, 38),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: 22),
    );
  }
}
