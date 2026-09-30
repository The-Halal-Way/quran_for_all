import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/dashboard/compass/compass_view.dart';
import '../../../views/dashboard/hijri_calendar/hijri_calendar_view.dart';
import '../../../views/dashboard/tasbeeh/tasbeeh_view.dart';
import '../../../views/dashboard/zakat_calculator/zakat_calculator_view.dart';
import '../../../views/dashboard/ramadan/ramadan_view.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_view.dart';
import '../../../views/sunnah_dua/duah/daily_duah_view.dart';
import '../../../views/sunnah_dua/duah/duah_ninty_nine_view.dart';
import '../../common/app_icon_grid_section.dart';
import 'dashboard_navigation.dart';

List<AppIconGridItem> dashboardActions(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  const light = AppThemeColors.light;
  return [
    AppIconGridItem(
      icon: CupertinoIcons.sun_haze_fill,
      label: context.l10n.dashboardActionDailyDua,
      description: context.l10n.dashboardActionDailyDuaSub,
      accent: dark ? MyColors.tertiaryDark : light.cyan,
      onTap: () => pushDashboardPage(context, const DailyDuahView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.moon_stars_fill,
      label: context.l10n.dashboardActionRamadan,
      description: context.l10n.dashboardActionRamadanSub,
      accent: dark ? MyColors.secondary : light.violet,
      onTap: () => pushDashboardPage(context, const RamadanView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.circle_grid_hex_fill,
      label: context.l10n.dashboardActionNintyNineNames,
      description: context.l10n.dashboardActionNintyNineNamesSub,
      accent: dark ? MyColors.primaryLight : light.brand,
      onTap: () => pushDashboardPage(context, const DuahNintyNineView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.moon_stars,
      label: context.l10n.prayerReferenceEidActionTitle,
      description: context.l10n.prayerReferenceEidActionSubtitle,
      accent: dark ? MyColors.tertiaryDark : light.coral,
      onTap: () => pushDashboardPage(context, const EidPrayerView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.calendar,
      label: context.l10n.dashboardActionHijriCalendar,
      description: context.l10n.dashboardActionHijriCalendarSub,
      accent: dark ? MyColors.secondary : light.violet,
      onTap: () => pushDashboardPage(context, const HijriCalendarView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.compass_fill,
      label: context.l10n.dashboardActionQiblaCompass,
      description: context.l10n.dashboardActionQiblaCompassSub,
      accent: dark ? MyColors.primaryLight : light.cyan,
      onTap: () => pushDashboardPage(context, const CompassView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.hand_draw_fill,
      label: context.l10n.dashboardActionTasbeeh,
      description: context.l10n.dashboardActionTasbeehSub,
      accent: dark ? MyColors.tertiaryDark : light.brand,
      onTap: () => pushDashboardPage(context, const TasbeehView()),
    ),
    AppIconGridItem(
      icon: CupertinoIcons.gift_fill,
      label: context.l10n.dashboardActionZakatCalculator,
      description: context.l10n.dashboardActionZakatCalculatorSub,
      accent: dark ? MyColors.secondary : light.warning,
      onTap: () => pushDashboardPage(context, const ZakatCalculatorView()),
    ),
  ];
}
