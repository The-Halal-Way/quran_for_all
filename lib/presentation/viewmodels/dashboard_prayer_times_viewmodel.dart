import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/prayer_times/prayer_time_zone_helper.dart';
import '../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../domain/usecases/prayer_times/load_prayer_times_usecase.dart';

enum PrayerTimesErrorType {
  none,
  permissionDenied,
  permissionDeniedForever,
  locationDisabled,
  unavailable,
}

class DashboardPrayerTimesViewModel extends ChangeNotifier
    with WidgetsBindingObserver {
  DashboardPrayerTimesViewModel({
    required LoadPrayerTimesUseCase loadPrayerTimesUseCase,
  }) : _loadPrayerTimesUseCase = loadPrayerTimesUseCase {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(loadPrayerTimes());
    });
  }

  final LoadPrayerTimesUseCase _loadPrayerTimesUseCase;

  Map<String, String>? _prayerTimes;
  Map<String, String>? _prayerTimeRanges;
  String _error = '';
  PrayerTimesErrorType _errorType = PrayerTimesErrorType.none;
  bool _loading = false;
  String? _nextPrayer;
  bool _warmingUpcomingDays = false;

  Map<String, String>? get prayerTimes => _prayerTimes;
  Map<String, String>? get prayerTimeRanges => _prayerTimeRanges;
  String get error => _error;
  PrayerTimesErrorType get errorType => _errorType;
  bool get isLoading => _loading;
  String? get nextPrayer => _nextPrayer;
  bool get hasData => _prayerTimes != null && _prayerTimes!.isNotEmpty;

  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    if (_loading) {
      return;
    }

    if (!forceRefresh) {
      final cached = await _loadPrayerTimesUseCase.loadCached();
      if (cached != null) {
        _applyDashboardData(cached);
        _error = '';
        _errorType = PrayerTimesErrorType.none;
        notifyListeners();
      }
    }

    _loading = !hasData;
    if (_loading) {
      _error = '';
      _errorType = PrayerTimesErrorType.none;
      notifyListeners();
    }

    try {
      final dashboardData = await _loadPrayerTimesUseCase.syncToday(
        forceRefresh: forceRefresh,
      );
      _applyDashboardData(dashboardData);
      _scheduleWarmUpcoming(forceRefresh: forceRefresh);
      _error = '';
      _errorType = PrayerTimesErrorType.none;
      _loading = false;
      notifyListeners();
    } on PrayerTimesException catch (error) {
      if (hasData) {
        _loading = false;
        notifyListeners();
        return;
      }

      _setError(error.message, _mapErrorType(error.type));
    } catch (error) {
      _setError(
        'Failed to load prayer times: $error',
        PrayerTimesErrorType.unavailable,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshOnResume());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _refreshOnResume() async {
    try {
      final refreshed = await _loadPrayerTimesUseCase.refreshAfterResume();
      if (refreshed == null) {
        return;
      }

      _applyDashboardData(refreshed);
      _error = '';
      _errorType = PrayerTimesErrorType.none;
      notifyListeners();
    } catch (_) {
      // Keep the current local state if the resume sync cannot improve it.
    }
  }

  void _scheduleWarmUpcoming({required bool forceRefresh}) {
    if (_warmingUpcomingDays) {
      return;
    }

    _warmingUpcomingDays = true;
    unawaited(
      _loadPrayerTimesUseCase
          .warmUpcoming(forceRefresh: forceRefresh)
          .then((dashboardData) {
            if (dashboardData == null) {
              return;
            }

            _applyDashboardData(dashboardData);
            notifyListeners();
          })
          .catchError((_) {
            // Background completion failure should not displace current data.
          })
          .whenComplete(() {
            _warmingUpcomingDays = false;
          }),
    );
  }

  void _applyDashboardData(PrayerDashboardData dashboardData) {
    PrayerTimeZoneHelper.ensureInitialized();
    final location = PrayerTimeZoneHelper.locationFor(
      dashboardData.profile.timeZoneId,
    );
    final format = DateFormat('hh:mm a');
    final fajr = tz.TZDateTime.from(dashboardData.today.fajrUtc, location);
    final sunrise = tz.TZDateTime.from(
      dashboardData.today.sunriseUtc,
      location,
    );
    final dhuhr = tz.TZDateTime.from(dashboardData.today.dhuhrUtc, location);
    final asr = tz.TZDateTime.from(dashboardData.today.asrUtc, location);
    final maghrib = tz.TZDateTime.from(
      dashboardData.today.maghribUtc,
      location,
    );
    final isha = tz.TZDateTime.from(dashboardData.today.ishaUtc, location);
    final imsak = fajr.subtract(
      Duration(minutes: dashboardData.profile.calculation.sehriOffsetMinutes),
    );
    final sehriStart = tz.TZDateTime(location, fajr.year, fajr.month, fajr.day);
    final tomorrowFajr = dashboardData.tomorrow == null
        ? null
        : tz.TZDateTime.from(dashboardData.tomorrow!.fajrUtc, location);
    final nowInLocation = tz.TZDateTime.now(location);
    final todaySchedule = <String, tz.TZDateTime>{
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };

    String? nextPrayerKey;
    for (final entry in todaySchedule.entries) {
      if (entry.value.isAfter(nowInLocation)) {
        nextPrayerKey = entry.key;
        break;
      }
    }

    _prayerTimes = {
      'Sehri': format.format(imsak),
      'Fajr': format.format(fajr),
      'Sunrise': format.format(sunrise),
      'Dhuhr': format.format(dhuhr),
      'Asr': format.format(asr),
      'Maghrib': format.format(maghrib),
      'Isha': format.format(isha),
    };
    _prayerTimeRanges = {
      'Sehri': '${format.format(sehriStart)} - ${format.format(imsak)}',
      'Fajr': '${format.format(fajr)} - ${format.format(sunrise)}',
      'Dhuhr': '${format.format(dhuhr)} - ${format.format(asr)}',
      'Asr': '${format.format(asr)} - ${format.format(maghrib)}',
      'Maghrib': '${format.format(maghrib)} - ${format.format(isha)}',
      if (tomorrowFajr != null)
        'Isha': '${format.format(isha)} - ${format.format(tomorrowFajr)}',
    };
    _nextPrayer = nextPrayerKey;
  }

  PrayerTimesErrorType _mapErrorType(PrayerRepositoryErrorType type) {
    return switch (type) {
      PrayerRepositoryErrorType.permissionDenied =>
        PrayerTimesErrorType.permissionDenied,
      PrayerRepositoryErrorType.permissionDeniedForever =>
        PrayerTimesErrorType.permissionDeniedForever,
      PrayerRepositoryErrorType.locationDisabled =>
        PrayerTimesErrorType.locationDisabled,
      PrayerRepositoryErrorType.network => PrayerTimesErrorType.unavailable,
      PrayerRepositoryErrorType.unavailable => PrayerTimesErrorType.unavailable,
    };
  }

  void _setError(String message, PrayerTimesErrorType type) {
    _error = message;
    _errorType = type;
    _loading = false;
    notifyListeners();
  }
}
