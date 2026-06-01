import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/hijri/hijri_calendar_models.dart';

typedef HijriDateSelected = bool Function(int year, int month, int day);

class HijriCalendarDateFinderCard extends StatelessWidget {
  const HijriCalendarDateFinderCard({
    super.key,
    required this.selectedDate,
    required this.dateAdjustment,
    required this.firstGregorianDate,
    required this.lastGregorianDate,
    required this.minHijriYear,
    required this.maxHijriYear,
    required this.daysInMonth,
    required this.monthName,
    required this.formatNumber,
    required this.onGregorianDateSelected,
    required this.onHijriDateSelected,
    required this.onAdjustmentChanged,
    required this.isDark,
  });

  final HijriDateInfo selectedDate;
  final int dateAdjustment;
  final DateTime firstGregorianDate;
  final DateTime lastGregorianDate;
  final int minHijriYear;
  final int maxHijriYear;
  final int Function(int year, int month) daysInMonth;
  final String Function(int month) monthName;
  final String Function(int value) formatNumber;
  final ValueChanged<DateTime> onGregorianDateSelected;
  final HijriDateSelected onHijriDateSelected;
  final ValueChanged<int> onAdjustmentChanged;
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
            color: MyColors.primary.withValues(alpha: isDark ? 0.16 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: MyColors.secondary.withValues(
                    alpha: isDark ? 0.18 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: MyColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.hijriFinderTitle,
                      style: text.titleMedium.copyWith(
                        color: titleColor,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.hijriFinderSubtitle,
                      style: text.bodySmall.copyWith(
                        color: subColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.icon(
                onPressed: () => _pickGregorianDate(context),
                icon: const Icon(Icons.event_rounded, size: 18),
                label: Text(context.l10n.hijriFindGregorianAction),
              ),
              OutlinedButton.icon(
                onPressed: () => _showHijriDateSheet(context),
                icon: const Icon(Icons.calendar_view_month_rounded, size: 18),
                label: Text(context.l10n.hijriFindHijriAction),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.hijriAdjustmentTitle,
            style: text.labelMedium.copyWith(
              color: titleColor,
              fontWeight: AppTheme.weightBold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment<int>(
                  value: -1,
                  icon: const Icon(Icons.remove_rounded, size: 17),
                  label: Text(context.l10n.hijriAdjustmentMinusLabel),
                ),
                ButtonSegment<int>(
                  value: 0,
                  icon: const Icon(Icons.check_rounded, size: 17),
                  label: Text(context.l10n.hijriAdjustmentCalculatedLabel),
                ),
                ButtonSegment<int>(
                  value: 1,
                  icon: const Icon(Icons.add_rounded, size: 17),
                  label: Text(context.l10n.hijriAdjustmentPlusLabel),
                ),
              ],
              selected: {dateAdjustment},
              onSelectionChanged: (selected) {
                onAdjustmentChanged(selected.first);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickGregorianDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampedInitialGregorianDate(),
      firstDate: firstGregorianDate,
      lastDate: lastGregorianDate,
    );
    if (picked != null) {
      onGregorianDateSelected(picked);
    }
  }

  Future<void> _showHijriDateSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<_HijriDateSelection>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _HijriDatePickerSheet(
        initialDate: selectedDate,
        minYear: minHijriYear,
        maxYear: maxHijriYear,
        daysInMonth: daysInMonth,
        monthName: monthName,
        formatNumber: formatNumber,
      ),
    );
    if (selected == null) {
      return;
    }

    final success = onHijriDateSelected(
      selected.year,
      selected.month,
      selected.day,
    );
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.hijriInvalidDateMessage)),
      );
    }
  }

  DateTime _clampedInitialGregorianDate() {
    final selected = selectedDate.gregorianDate;
    if (selected.isBefore(firstGregorianDate)) {
      return firstGregorianDate;
    }
    if (selected.isAfter(lastGregorianDate)) {
      return lastGregorianDate;
    }
    return selected;
  }
}

class _HijriDatePickerSheet extends StatefulWidget {
  const _HijriDatePickerSheet({
    required this.initialDate,
    required this.minYear,
    required this.maxYear,
    required this.daysInMonth,
    required this.monthName,
    required this.formatNumber,
  });

  final HijriDateInfo initialDate;
  final int minYear;
  final int maxYear;
  final int Function(int year, int month) daysInMonth;
  final String Function(int month) monthName;
  final String Function(int value) formatNumber;

  @override
  State<_HijriDatePickerSheet> createState() => _HijriDatePickerSheetState();
}

class _HijriDatePickerSheetState extends State<_HijriDatePickerSheet> {
  late int _year;
  late int _month;
  late int _day;

  @override
  void initState() {
    super.initState();
    _year = widget.initialDate.year;
    _month = widget.initialDate.month;
    _day = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;
    final maxDay = widget.daysInMonth(_year, _month);
    if (_day > maxDay) {
      _day = maxDay;
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.hijriDatePickerTitle,
              style: text.titleLarge.copyWith(fontWeight: AppTheme.weightBold),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: _year,
              decoration: InputDecoration(
                labelText: context.l10n.hijriDatePickerYearLabel,
              ),
              items: [
                for (var year = widget.minYear; year <= widget.maxYear; year++)
                  DropdownMenuItem<int>(
                    value: year,
                    child: Text(widget.formatNumber(year)),
                  ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _year = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: _month,
              decoration: InputDecoration(
                labelText: context.l10n.hijriDatePickerMonthLabel,
              ),
              items: [
                for (var month = 1; month <= 12; month++)
                  DropdownMenuItem<int>(
                    value: month,
                    child: Text(widget.monthName(month)),
                  ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _month = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: _day,
              decoration: InputDecoration(
                labelText: context.l10n.hijriDatePickerDayLabel,
              ),
              items: [
                for (var day = 1; day <= maxDay; day++)
                  DropdownMenuItem<int>(
                    value: day,
                    child: Text(widget.formatNumber(day)),
                  ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _day = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      MaterialLocalizations.of(context).cancelButtonLabel,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        _HijriDateSelection(
                          year: _year,
                          month: _month,
                          day: _day,
                        ),
                      );
                    },
                    child: Text(context.l10n.hijriDatePickerOpenAction),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HijriDateSelection {
  const _HijriDateSelection({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;
}
