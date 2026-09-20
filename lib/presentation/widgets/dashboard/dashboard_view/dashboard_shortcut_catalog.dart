import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/dashboard/compass/compass_view.dart';
import '../../../views/dashboard/hijri_calendar/hijri_calendar_view.dart';
import '../../../views/dashboard/tasbeeh/tasbeeh_view.dart';
import '../../../views/sunnah_dua/duah/daily_duah_view.dart';
import '../../../views/sunnah_dua/duah/duah_ninty_nine_view.dart';
import '../../../views/sunnah_dua/duah/powerful_duah_view.dart';
import '../../../views/sunnah_dua/sunnah_dua_view.dart';
import '../../common/app_icon_grid_section.dart';
import 'dashboard_navigation.dart';

List<AppIconGridItem> dashboardActions(BuildContext context) => [
  AppIconGridItem(
    icon: Icons.wb_twilight_rounded,
    label: context.l10n.dashboardActionDailyDua,
    description: context.l10n.dashboardActionDailyDuaSub,
    accent: MyColors.tertiaryDark,
    onTap: () => pushDashboardPage(context, const DailyDuahView()),
  ),
  AppIconGridItem(
    icon: Icons.bolt_rounded,
    label: context.l10n.dashboardActionPowerfulDua,
    description: context.l10n.dashboardActionPowerfulDuaSub,
    accent: MyColors.secondary,
    onTap: () => pushDashboardPage(context, const PowerfulDuahView()),
  ),
  AppIconGridItem(
    icon: Icons.diamond_rounded,
    label: context.l10n.dashboardActionNintyNineNames,
    description: context.l10n.dashboardActionNintyNineNamesSub,
    accent: MyColors.primaryLight,
    onTap: () => pushDashboardPage(context, const DuahNintyNineView()),
  ),
  AppIconGridItem(
    icon: Icons.auto_awesome_rounded,
    label: context.l10n.dashboardActionSunnahDua,
    description: context.l10n.dashboardActionSunnahDuaSub,
    accent: MyColors.tertiaryDark,
    onTap: () =>
        pushDashboardPage(context, const SunnahDuaView(showBackButton: true)),
  ),
  AppIconGridItem(
    icon: Icons.calendar_month_rounded,
    label: context.l10n.dashboardActionHijriCalendar,
    description: context.l10n.dashboardActionHijriCalendarSub,
    accent: MyColors.secondary,
    onTap: () => pushDashboardPage(context, const HijriCalendarView()),
  ),
  AppIconGridItem(
    icon: Icons.explore_rounded,
    label: context.l10n.dashboardActionQiblaCompass,
    description: context.l10n.dashboardActionQiblaCompassSub,
    accent: MyColors.primaryLight,
    onTap: () => pushDashboardPage(context, const CompassView()),
  ),
  AppIconGridItem(
    icon: Icons.touch_app_rounded,
    label: context.l10n.dashboardActionTasbeeh,
    description: context.l10n.dashboardActionTasbeehSub,
    accent: MyColors.tertiaryDark,
    onTap: () => pushDashboardPage(context, const TasbeehView()),
  ),
];
