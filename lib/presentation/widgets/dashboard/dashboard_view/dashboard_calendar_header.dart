import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'dashboard_daily_hadith_action.dart';

class DashboardCalendarHeader extends StatelessWidget {
  const DashboardCalendarHeader({super.key});

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
        const Align(
          alignment: AlignmentDirectional.centerEnd,
          child: DashboardDailyHadithAction(),
        ),
      ],
    );
  }
}
