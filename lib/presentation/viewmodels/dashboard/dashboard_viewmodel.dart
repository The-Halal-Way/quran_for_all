import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/learn_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'package:quran_for_all/services/hijri_calendar_service.dart';

import 'models/dashboard_view_data.dart';

class DashboardViewModel {
  DashboardViewModel({
    HijriCalendarService hijriCalendarService = const HijriCalendarService(),
  }) : _hijriCalendarService = hijriCalendarService;

  final HijriCalendarService _hijriCalendarService;

  DashboardHeaderInfo headerInfo(
    AppLocalizations l10n,
    DateTime now, {
    int hijriDateAdjustment = 0,
  }) {
    final hijriDate = _hijriCalendarService.fromGregorian(
      now,
      adjustmentDays: hijriDateAdjustment,
    );

    return DashboardHeaderInfo(
      dateLabel: DateFormat('EEE, d MMM', l10n.localeName).format(now),
      hijriDateLabel: l10n.hijriDateFull(
        _formatNumber(l10n, hijriDate.day),
        _monthName(l10n, hijriDate.month),
        _formatNumber(l10n, hijriDate.year),
      ),
    );
  }

  DashboardContinueCardsInfo continueCardsInfo({
    required AppLocalizations l10n,
    required ReadQuranViewModel readViewModel,
    required LearnQuranViewModel learnViewModel,
  }) {
    final hasLastRead =
        readViewModel.lastRead != null && readViewModel.lastReadSurah != null;
    final lastRead = readViewModel.lastRead;
    final lastReadSurah = readViewModel.lastReadSurah;

    final reading = DashboardContinueCardInfo(
      subtitle: hasLastRead
          ? '${lastReadSurah!.nameEnglish} (${lastReadSurah.nameArabic})'
          : l10n.dashboardContinueReadingStartSubtitle,
      detail: hasLastRead
          ? l10n.dashboardContinueReadingAyahDetail(
              lastRead!.ayahNumber,
              lastReadSurah!.nameTranslated.isNotEmpty
                  ? lastReadSurah.nameTranslated
                  : l10n.dashboardQuranLabel,
            )
          : l10n.dashboardContinueReadingStartDetail,
      hasExistingProgress: hasLastRead,
      surah: lastReadSurah,
      ayahNumber: lastRead?.ayahNumber,
    );

    final nextLesson = learnViewModel.nextLesson;
    final nextModule = nextLesson != null
        ? learnViewModel.moduleForLesson(nextLesson.id)
        : (learnViewModel.modules.isNotEmpty
              ? learnViewModel.modules.first
              : null);

    final learning = DashboardContinueLearningInfo(
      subtitle:
          nextLesson?.title ?? l10n.dashboardContinueLearningStartSubtitle,
      detail: nextModule != null
          ? l10n.dashboardContinueLearningModuleDetail(
              nextModule.title,
              nextModule.lessons.length,
            )
          : l10n.dashboardContinueLearningStartDetail,
    );

    return DashboardContinueCardsInfo(reading: reading, learning: learning);
  }

  IconData prayerIcon(String prayer) {
    switch (prayer) {
      case 'Sehri':
        return Icons.nightlight_round;
      case 'Fajr':
        return Icons.wb_twilight_rounded;
      case 'Sunrise':
        return Icons.wb_sunny_rounded;
      case 'Dhuhr':
        return Icons.light_mode_rounded;
      case 'Asr':
        return Icons.cloud_rounded;
      case 'Maghrib':
        return Icons.nights_stay_rounded;
      case 'Isha':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  String localizedPrayerName(AppLocalizations l10n, String prayer) {
    switch (prayer) {
      case 'Sehri':
        return l10n.dashboardPrayerSehri;
      case 'Fajr':
        return l10n.dashboardPrayerFajr;
      case 'Sunrise':
        return l10n.dashboardPrayerSunrise;
      case 'Dhuhr':
        return l10n.dashboardPrayerDhuhr;
      case 'Asr':
        return l10n.dashboardPrayerAsr;
      case 'Maghrib':
        return l10n.dashboardPrayerMaghrib;
      case 'Isha':
        return l10n.dashboardPrayerIsha;
      default:
        return prayer;
    }
  }

  String _monthName(AppLocalizations l10n, int month) {
    return switch (month) {
      1 => l10n.hijriMonthMuharram,
      2 => l10n.hijriMonthSafar,
      3 => l10n.hijriMonthRabiAlAwwal,
      4 => l10n.hijriMonthRabiAlThani,
      5 => l10n.hijriMonthJumadaAlAwwal,
      6 => l10n.hijriMonthJumadaAlThani,
      7 => l10n.hijriMonthRajab,
      8 => l10n.hijriMonthShaban,
      9 => l10n.hijriMonthRamadan,
      10 => l10n.hijriMonthShawwal,
      11 => l10n.hijriMonthDhulQadah,
      12 => l10n.hijriMonthDhulHijjah,
      _ => '',
    };
  }

  String _formatNumber(AppLocalizations l10n, int value) {
    final raw = value.toString();
    if (!l10n.localeName.startsWith('bn')) {
      return raw;
    }

    const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return raw.split('').map((char) {
      final digit = int.tryParse(char);
      return digit == null ? char : digits[digit];
    }).join();
  }
}
