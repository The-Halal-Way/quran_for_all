import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import '../../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../views/daily_reminders/daily_reminders_view.dart';
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
    final info = DashboardViewModel().headerInfo(
      context.l10n,
      DateTime.now(),
      hijriDateAdjustment: adjustment,
    );
    final colors = Theme.of(context).colorScheme;
    final unreadReminders = context.select(
      (DailyRemindersViewModel vm) => vm.unreadCount,
    );
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [
                Color.lerp(colors.surface, MyColors.primaryLight, 0.08)!,
                Color.lerp(colors.surface, MyColors.tertiary, 0.04)!,
              ],
            ),
            border: Border.all(
              color: MyColors.primaryLight.withValues(alpha: 0.18),
            ),
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
                child: DashboardDailyReminderButton(
                  label: context.l10n.dailyRemindersTitle,
                  unreadCount: unreadReminders,
                  onTap: () =>
                      pushDashboardPage(context, const DailyRemindersView()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 340 ||
                MediaQuery.textScalerOf(context).scale(14) > 19;
            final hijri = DashboardDateLabel(
              label: info.hijriDateLabel,
              icon: Icons.nightlight_round,
              highlighted: true,
            );
            final date = DashboardDateLabel(
              label: info.dateLabel,
              icon: Icons.calendar_today_rounded,
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
