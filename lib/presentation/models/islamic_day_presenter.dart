import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/islamic_days/islamic_day.dart';
import '../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../data/models/islamic_days/islamic_day_rule.dart';
import '../../l10n/app_localizations.dart';

String islamicDayCategoryLabel(
  AppLocalizations l10n,
  IslamicDayCategory category,
) => switch (category) {
  IslamicDayCategory.worship => l10n.islamicDaysCategoryWorship,
  IslamicDayCategory.fasting => l10n.islamicDaysCategoryFasting,
  IslamicDayCategory.season => l10n.islamicDaysCategorySeason,
  IslamicDayCategory.celebration => l10n.islamicDaysCategoryCelebration,
};

IconData islamicDayIcon(IslamicDayCategory category) => switch (category) {
  IslamicDayCategory.worship => Icons.mosque_outlined,
  IslamicDayCategory.fasting => Icons.nightlight_round,
  IslamicDayCategory.season => Icons.auto_awesome_outlined,
  IslamicDayCategory.celebration => Icons.celebration_outlined,
};

Color islamicDayAccent(BuildContext context, IslamicDayCategory category) {
  final scheme = Theme.of(context).colorScheme;
  return switch (category) {
    IslamicDayCategory.worship => scheme.tertiary,
    IslamicDayCategory.fasting => scheme.primary,
    IslamicDayCategory.season => scheme.secondary,
    IslamicDayCategory.celebration => scheme.error,
  };
}

String islamicDayMonth(AppLocalizations l10n, int month) => [
  l10n.hijriMonthMuharram,
  l10n.hijriMonthSafar,
  l10n.hijriMonthRabiAlAwwal,
  l10n.hijriMonthRabiAlThani,
  l10n.hijriMonthJumadaAlAwwal,
  l10n.hijriMonthJumadaAlThani,
  l10n.hijriMonthRajab,
  l10n.hijriMonthShaban,
  l10n.hijriMonthRamadan,
  l10n.hijriMonthShawwal,
  l10n.hijriMonthDhulQadah,
  l10n.hijriMonthDhulHijjah,
][month - 1];

String islamicDayNumber(AppLocalizations l10n, int number) =>
    NumberFormat('0', l10n.localeName).format(number);

String islamicDayHijriLabel(
  AppLocalizations l10n,
  IslamicDayOccurrence occurrence,
) => l10n.hijriDateFull(
  islamicDayNumber(l10n, occurrence.hijri.day),
  islamicDayMonth(l10n, occurrence.hijri.month),
  islamicDayNumber(l10n, occurrence.hijri.year),
);

String islamicDayGregorianLabel(AppLocalizations l10n, DateTime date) =>
    DateFormat.yMMMd(l10n.localeName).format(date);

String islamicDayRuleLabel(AppLocalizations l10n, IslamicDayRule rule) {
  if (rule.type == IslamicDayReminderType.weekly) {
    final days = [
      l10n.hijriWeekdayMon,
      l10n.hijriWeekdayTue,
      l10n.hijriWeekdayWed,
      l10n.hijriWeekdayThu,
      l10n.hijriWeekdayFri,
      l10n.hijriWeekdaySat,
      l10n.hijriWeekdaySun,
    ];
    return '${l10n.islamicDaysWeekly} · ${rule.weekdays.map((day) => days[day - 1]).join(' / ')}';
  }
  final dayLabel = rule.hijriDays.isNotEmpty
      ? rule.hijriDays.map((day) => islamicDayNumber(l10n, day)).join(', ')
      : '${islamicDayNumber(l10n, rule.firstDay ?? 1)}–${islamicDayNumber(l10n, rule.lastDay ?? 30)}';
  if (rule.type == IslamicDayReminderType.hijriMonthly) {
    return '${l10n.islamicDaysMonthly} · $dayLabel';
  }
  return '${l10n.islamicDaysAnnual} · $dayLabel ${islamicDayMonth(l10n, rule.hijriMonth!)}';
}
