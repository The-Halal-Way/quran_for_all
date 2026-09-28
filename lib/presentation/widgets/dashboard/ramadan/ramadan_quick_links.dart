import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/hijri_calendar/hijri_calendar_view.dart';
import '../../../views/dashboard/tasbeeh/tasbeeh_view.dart';
import '../../../views/dashboard/zakat_calculator/zakat_calculator_view.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_view.dart';
import '../../../views/quran/read_quran/read_quran_view.dart';
import '../../../views/sunnah_dua/duah/daily_duah_view.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';
import 'ramadan_quick_link.dart';

class RamadanQuickLinks extends StatelessWidget {
  const RamadanQuickLinks({super.key, required this.isBangla});

  final bool isBangla;

  void _open(BuildContext context, Widget page) =>
      Navigator.of(context).push(AppPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 500;
      final width = compact
          ? (constraints.maxWidth - AppSpacing.md) / 2
          : (constraints.maxWidth - AppSpacing.md * 3) / 4;
      final scheme = Theme.of(context).colorScheme;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          RamadanQuickLink(
            width: width,
            icon: Icons.menu_book_rounded,
            label: ramadanLabel(isBangla, 'Read Qur’an', 'কুরআন পড়ুন'),
            color: scheme.tertiary,
            onTap: () => _open(context, const ReadQuranView()),
          ),
          RamadanQuickLink(
            width: width,
            icon: Icons.calendar_month_rounded,
            label: ramadanLabel(
              isBangla,
              'Hijri calendar',
              'হিজরি ক্যালেন্ডার',
            ),
            color: scheme.secondary,
            onTap: () => _open(context, const HijriCalendarView()),
          ),
          RamadanQuickLink(
            width: width,
            icon: Icons.auto_stories_rounded,
            label: ramadanLabel(isBangla, 'Daily du’a', 'প্রতিদিনের দোয়া'),
            color: scheme.tertiary,
            onTap: () => _open(context, const DailyDuahView()),
          ),
          RamadanQuickLink(
            width: width,
            icon: Icons.fingerprint_rounded,
            label: ramadanLabel(isBangla, 'Tasbeeh', 'তাসবিহ'),
            color: scheme.secondary,
            onTap: () => _open(context, const TasbeehView()),
          ),
          RamadanQuickLink(
            width: width,
            icon: Icons.volunteer_activism_rounded,
            label: ramadanLabel(isBangla, 'Zakat', 'যাকাত'),
            color: scheme.tertiary,
            onTap: () => _open(context, const ZakatCalculatorView()),
          ),
          RamadanQuickLink(
            width: width,
            icon: Icons.celebration_rounded,
            label: ramadanLabel(isBangla, 'Eid prayer', 'ঈদের নামাজ'),
            color: scheme.secondary,
            onTap: () => _open(context, const EidPrayerView()),
          ),
        ],
      );
    },
  );
}
