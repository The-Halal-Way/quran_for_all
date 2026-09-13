import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/dashboard/dashboard_action_item.dart';
import '../../../views/dashboard/compass/compass_view.dart';
import '../../../views/dashboard/hijri_calendar/hijri_calendar_view.dart';
import '../../../views/dashboard/tasbeeh/tasbeeh_view.dart';
import '../../../views/sunnah_dua/duah/daily_duah_view.dart';
import '../../../views/sunnah_dua/duah/duah_ninty_nine_view.dart';
import '../../../views/sunnah_dua/duah/powerful_duah_view.dart';
import '../../../views/sunnah_dua/sunnah_dua_view.dart';
import 'dashboard_navigation.dart';

List<DashboardActionItem> dashboardDuaActions(BuildContext context) => [
  DashboardActionItem(
    icon: Icons.wb_twilight_rounded,
    label: context.l10n.dashboardActionDailyDua,
    sublabel: context.l10n.dashboardActionDailyDuaSub,
    color: MyColors.tertiaryDark,
    onTap: () => pushDashboardPage(context, const DailyDuahView()),
  ),
  DashboardActionItem(
    icon: Icons.bolt_rounded,
    label: context.l10n.dashboardActionPowerfulDua,
    sublabel: context.l10n.dashboardActionPowerfulDuaSub,
    color: MyColors.secondary,
    onTap: () => pushDashboardPage(context, const PowerfulDuahView()),
  ),
  DashboardActionItem(
    icon: Icons.diamond_rounded,
    label: context.l10n.dashboardActionNintyNineNames,
    sublabel: context.l10n.dashboardActionNintyNineNamesSub,
    color: MyColors.primaryLight,
    onTap: () => pushDashboardPage(context, const DuahNintyNineView()),
  ),
  DashboardActionItem(
    icon: Icons.auto_awesome_rounded,
    label: context.l10n.dashboardActionSunnahDua,
    sublabel: context.l10n.dashboardActionSunnahDuaSub,
    color: MyColors.tertiaryDark,
    onTap: () =>
        pushDashboardPage(context, const SunnahDuaView(showBackButton: true)),
  ),
];

List<DashboardActionItem> dashboardToolActions(BuildContext context) => [
  DashboardActionItem(
    icon: Icons.calendar_month_rounded,
    label: context.l10n.dashboardActionHijriCalendar,
    sublabel: context.l10n.dashboardActionHijriCalendarSub,
    color: MyColors.secondary,
    onTap: () => pushDashboardPage(context, const HijriCalendarView()),
  ),
  DashboardActionItem(
    icon: Icons.explore_rounded,
    label: context.l10n.dashboardActionQiblaCompass,
    sublabel: context.l10n.dashboardActionQiblaCompassSub,
    color: MyColors.primaryLight,
    onTap: () => pushDashboardPage(context, const CompassView()),
  ),
  DashboardActionItem(
    icon: Icons.touch_app_rounded,
    label: context.l10n.dashboardActionTasbeeh,
    sublabel: context.l10n.dashboardActionTasbeehSub,
    color: MyColors.tertiaryDark,
    onTap: () => pushDashboardPage(context, const TasbeehView()),
  ),
];
