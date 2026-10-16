import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_hadith_viewmodel.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import '../../../viewmodels/dashboard/models/dashboard_view_data.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../islamic_days/shared/islamic_days_artwork.dart';
import 'dashboard_calendar_header.dart';
import 'dashboard_islamic_day_summary.dart';

/// Combines today's calendar context and the next Islamic occasion.
///
/// Keeping both pieces in one surface makes the top of the dashboard feel
/// like one daily briefing instead of two unrelated cards.
class DashboardDateContext extends StatelessWidget {
  const DashboardDateContext({super.key});

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
    final occasion = context.select(
      (IslamicDaysViewModel vm) => (
        entry: vm.today.isNotEmpty ? vm.today.first : vm.upcoming.firstOrNull,
        todayCount: vm.today.length,
      ),
    );
    final unreadReminders = context.select(
      (DailyHadithViewModel vm) => vm.unreadCount,
    );

    return _DashboardDateContextSurface(
      info: info,
      occasion: occasion,
      unreadReminders: unreadReminders,
    );
  }
}

class _DashboardDateContextSurface extends StatelessWidget {
  const _DashboardDateContextSurface({
    required this.info,
    required this.occasion,
    required this.unreadReminders,
  });

  final DashboardHeaderInfo info;
  final ({IslamicDayOccurrence? entry, int todayCount}) occasion;
  final int unreadReminders;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final firstAccent = dark
        ? MyColors.primaryLight
        : AppThemeColors.light.brand;
    final secondAccent = dark ? MyColors.tertiary : AppThemeColors.light.cyan;
    final entry = occasion.entry;
    final isToday = occasion.todayCount > 0;
    final prohibited =
        entry?.dayFasting == IslamicDayFasting.prohibited && isToday;
    final occasionAccent = prohibited ? colors.error : colors.primary;
    final hasDetails =
        prohibited || occasion.todayCount > 1 || (entry != null && !isToday);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: firstAccent.withValues(alpha: .2)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(colors.surface, firstAccent, 0.08)!,
            Color.lerp(colors.surface, secondAccent, 0.04)!,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            PositionedDirectional(
              end: -30,
              bottom: -48,
              width: 170,
              height: 170,
              child: Opacity(
                opacity: .16,
                child: IslamicDaysArtwork(color: occasionAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                children: [
                  DashboardCalendarHeader(
                    info: info,
                    unreadReminders: unreadReminders,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: .5),
                  ),
                  DashboardIslamicDaySummary(
                    entry: entry,
                    todayCount: occasion.todayCount,
                    isToday: isToday,
                    prohibited: prohibited,
                    hasDetails: hasDetails,
                    accent: occasionAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
