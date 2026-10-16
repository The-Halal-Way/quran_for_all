import 'package:flutter/material.dart';
import 'package:quran_for_all/presentation/views/daily_reminders/daily_hadith_view.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import 'dashboard_daily_reminder_button.dart';
import 'dashboard_navigation.dart';

class DashboardCalendarHeader extends StatelessWidget {
  const DashboardCalendarHeader({super.key, required this.unreadReminders});

  final int unreadReminders;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
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
            onTap: () => pushDashboardPage(context, const DailyHadithView()),
          ),
        ),
      ],
    );
  }
}
