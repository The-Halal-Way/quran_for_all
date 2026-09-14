import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/views/prayer/prayer_view.dart';

class PrayerTestApp extends StatelessWidget {
  const PrayerTestApp({
    super.key,
    required this.model,
    this.locale = 'en',
    this.brightness = Brightness.light,
    this.scale = 1,
    this.theme,
    this.home,
  });

  final PrayerTestViewModel model;
  final String locale;
  final Brightness brightness;
  final double scale;
  final ThemeData? theme;
  final Widget? home;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<DashboardPrayerTimesViewModel>.value(
        value: model,
        child: MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: theme ?? ThemeData(brightness: brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: home ?? const PrayerView(),
        ),
      );
}

class PrayerTestViewModel extends ChangeNotifier
    implements DashboardPrayerTimesViewModel {
  int refreshes = 0;
  @override
  bool hasData = true;
  @override
  bool isLoading = false;
  @override
  String currentPrayer = 'Asr';
  @override
  PrayerTimesErrorType errorType = PrayerTimesErrorType.none;
  @override
  String get error =>
      errorType == PrayerTimesErrorType.none ? '' : 'unavailable';
  @override
  Map<String, String> get prayerTimes => hasData
      ? const {
          'Sehri': '4:20 AM',
          'Fajr': '4:30 AM',
          'Sunrise': '5:45 AM',
          'Dhuhr': '12:05 PM',
          'Asr': '4:25 PM',
          'Maghrib': '6:15 PM',
          'Isha': '7:30 PM',
        }
      : const {};
  @override
  Map<String, String> get prayerTimeRanges => hasData
      ? const {
          'Sehri': '12:00 AM - 4:20 AM',
          'Fajr': '4:30 AM - 5:45 AM',
          'Sunrise': '5:45 AM - 6:00 AM',
          'Dhuhr': '12:05 PM - 4:25 PM',
          'Asr': '4:25 PM - 6:15 PM',
          'Maghrib': '6:15 PM - 7:30 PM',
          'Isha': '7:30 PM - 4:30 AM',
        }
      : const {};
  @override
  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    if (forceRefresh) refreshes++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
