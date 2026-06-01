import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/hijri/hijri_calendar_models.dart';

class HijriCalendarMonthGrid extends StatelessWidget {
  const HijriCalendarMonthGrid({
    super.key,
    required this.month,
    required this.weekdayLabels,
    required this.formatNumber,
    required this.formatGregorianDay,
    required this.isToday,
    required this.isSelected,
    required this.onDateSelected,
    required this.isDark,
  });

  final HijriCalendarMonth month;
  final List<String> weekdayLabels;
  final String Function(int value) formatNumber;
  final String Function(DateTime date) formatGregorianDay;
  final bool Function(HijriDateInfo date) isToday;
  final bool Function(HijriDateInfo date) isSelected;
  final ValueChanged<HijriDateInfo> onDateSelected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : MyColors.divider.withValues(alpha: 0.85);
    final cells = <Widget>[
      for (var index = 0; index < month.leadingEmptyDays; index++)
        const SizedBox.shrink(),
      for (final day in month.days)
        _HijriCalendarDayCell(
          date: day,
          hijriDay: formatNumber(day.day),
          gregorianDay: formatGregorianDay(day.gregorianDate),
          isToday: isToday(day),
          isSelected: isSelected(day),
          isDark: isDark,
          onTap: () => onDateSelected(day),
        ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: isDark ? 0.16 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              for (final label in weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall.copyWith(
                        color: subColor,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final aspectRatio = constraints.maxWidth < 390 ? 0.86 : 0.98;
              return GridView.count(
                crossAxisCount: 7,
                childAspectRatio: aspectRatio,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.xs,
                crossAxisSpacing: AppSpacing.xs,
                children: cells,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HijriCalendarDayCell extends StatelessWidget {
  const _HijriCalendarDayCell({
    required this.date,
    required this.hijriDay,
    required this.gregorianDay,
    required this.isToday,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final HijriDateInfo date;
  final String hijriDay;
  final String gregorianDay;
  final bool isToday;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final accent = isSelected
        ? MyColors.secondary
        : isToday
        ? MyColors.tertiary
        : MyColors.primaryLight;
    final background = isSelected
        ? MyColors.secondary.withValues(alpha: isDark ? 0.28 : 0.14)
        : isToday
        ? MyColors.tertiary.withValues(alpha: isDark ? 0.22 : 0.12)
        : Colors.transparent;
    final foreground = isSelected
        ? (isDark ? Colors.white : MyColors.secondaryDark)
        : isDark
        ? MyColors.darkTextPrimary
        : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$hijriDay, $gregorianDay',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Ink(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: (isSelected || isToday)
                    ? accent.withValues(alpha: 0.55)
                    : Colors.transparent,
                width: 0.9,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hijriDay,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall.copyWith(
                    color: foreground,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  gregorianDay,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall.copyWith(
                    color: isSelected
                        ? foreground.withValues(alpha: 0.76)
                        : subColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
