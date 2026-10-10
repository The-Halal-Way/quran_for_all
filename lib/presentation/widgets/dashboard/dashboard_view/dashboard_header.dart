import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import 'package:quran_for_all/presentation/views/daily_reminders/daily_hadith_view.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import 'dashboard_daily_reminder_button.dart';
import 'dashboard_date_label.dart';
import 'dashboard_navigation.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final adjustment = context.select(
      (SettingsViewModel vm) => vm.settings.hijriDateAdjustment,
    );
    final today = context.select((IslamicDaysViewModel vm) {
      final now = vm.localNow;
      return (year: now.year, month: now.month, day: now.day);
    });
    final info = DashboardViewModel().headerInfo(
      context.l10n,
      DateTime(today.year, today.month, today.day),
      hijriDateAdjustment: adjustment,
    );
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final firstAccent = dark
        ? MyColors.primaryLight
        : AppThemeColors.light.brand;
    final secondAccent = dark ? MyColors.tertiary : AppThemeColors.light.cyan;
    final unreadReminders = context.select(
      (DailyHadithViewModel vm) => vm.unreadCount,
    );
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [
                Color.lerp(colors.surface, firstAccent, 0.08)!,
                Color.lerp(colors.surface, secondAccent, 0.04)!,
              ],
            ),
            border: Border.all(color: firstAccent.withValues(alpha: 0.18)),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTheme.text(
                  context,
                ).dashboardBismillah.copyWith(color: colors.onSurface),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: DashboardDailyHadithButton(
                  label: context.l10n.dailyHadithTitle,
                  unreadCount: unreadReminders,
                  onTap: () =>
                      pushDashboardPage(context, const DailyHadithView()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 340 ||
                MediaQuery.textScalerOf(context).scale(14) > 19;
            final hijri = DashboardDateLabel(
              label: info.hijriDateLabel,
              icon: CupertinoIcons.moon_stars_fill,
              highlighted: true,
            );
            final date = DashboardDateLabel(
              label: info.dateLabel,
              icon: CupertinoIcons.calendar_today,
            );
            return stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [hijri, const SizedBox(height: 6), date],
                  )
                : Row(
                    children: [
                      Expanded(child: hijri),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: date),
                    ],
                  );
          },
        ),
      ],
    );
  }
}
