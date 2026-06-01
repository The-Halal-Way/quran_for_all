import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/learn_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'package:quran_for_all/services/hijri_calendar_service.dart';

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
      dateLabel: DateFormat('EEEE, d MMMM').format(now),
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

  DashboardPalette palette({required bool isDark}) {
    return DashboardPalette(
      cardBg: isDark ? MyColors.darkCard : MyColors.cardFill,
      textMain: isDark ? MyColors.darkTextPrimary : MyColors.textPrimary,
      textSub: isDark ? MyColors.darkTextSecondary : MyColors.textSecondary,
      textHint: isDark ? MyColors.darkTextTertiary : MyColors.textTertiary,
      divider: isDark ? MyColors.darkDivider : MyColors.divider,
    );
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

class DashboardHeaderInfo {
  const DashboardHeaderInfo({
    required this.dateLabel,
    required this.hijriDateLabel,
  });

  final String dateLabel;
  final String hijriDateLabel;
}

class DashboardContinueCardsInfo {
  const DashboardContinueCardsInfo({
    required this.reading,
    required this.learning,
  });

  final DashboardContinueCardInfo reading;
  final DashboardContinueLearningInfo learning;
}

class DashboardContinueCardInfo {
  const DashboardContinueCardInfo({
    required this.subtitle,
    required this.detail,
    required this.hasExistingProgress,
    this.surah,
    this.ayahNumber,
  });

  final String subtitle;
  final String detail;
  final bool hasExistingProgress;
  final SurahModel? surah;
  final int? ayahNumber;
}

class DashboardContinueLearningInfo {
  const DashboardContinueLearningInfo({
    required this.subtitle,
    required this.detail,
  });

  final String subtitle;
  final String detail;
}

class DashboardPalette {
  const DashboardPalette({
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.textHint,
    required this.divider,
  });

  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final Color textHint;
  final Color divider;
}
