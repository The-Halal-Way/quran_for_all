import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/presentation/views/daily_reminders/daily_hadith_view.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/models/dashboard_view_data.dart';
import 'dashboard_daily_reminder_button.dart';
import 'dashboard_date_label.dart';
import 'dashboard_navigation.dart';

class DashboardCalendarHeader extends StatelessWidget {
  const DashboardCalendarHeader({
    super.key,
    required this.info,
    required this.unreadReminders,
  });

  final DashboardHeaderInfo info;
  final int unreadReminders;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Stack(
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
