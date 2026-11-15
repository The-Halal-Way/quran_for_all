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
      if (!_disposed) unawaited(loadPrayerTimes());
    });
  }

  final LoadPrayerTimesUseCase _loadPrayerTimesUseCase;

  Map<String, String>? _prayerTimes;
  Map<String, String>? _prayerTimeRanges;
  String _error = '';
  PrayerTimesErrorType _errorType = PrayerTimesErrorType.none;
  bool _loading = false;
  String? _nextPrayer;
  String? _currentPrayer;
  DateTime? _currentPrayerEndsAtUtc;
  tz.Location? _scheduleLocation;
  DateTime? _scheduleDate;
  Map<String, tz.TZDateTime> _schedule = const {};
  tz.TZDateTime? _tomorrowFajr;
  Timer? _scheduleTimer;
  int _loadVersion = 0;
  bool _disposed = false;

  Map<String, String>? get prayerTimes => _prayerTimes;
  Map<String, String>? get prayerTimeRanges => _prayerTimeRanges;
  String get error => _error;
  PrayerTimesErrorType get errorType => _errorType;
  bool get isLoading => _loading;
  String? get nextPrayer => _nextPrayer;
  String? get currentPrayer => _currentPrayer;
  DateTime? get currentPrayerEndsAtUtc => _currentPrayerEndsAtUtc;
  bool get hasData => _prayerTimes != null && _prayerTimes!.isNotEmpty;

  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    if (_disposed || _loading) {
      return;
    }
    final version = ++_loadVersion;

    if (!forceRefresh) {
      final cached = await _loadPrayerTimesUseCase.loadCached();
      if (version != _loadVersion) return;
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
      if (version != _loadVersion) return;
      _applyDashboardData(dashboardData);
      _error = '';
      _errorType = PrayerTimesErrorType.none;
      _loading = false;
      notifyListeners();
    } on PrayerTimesException catch (error) {
      if (version != _loadVersion) return;
      if (hasData) {
        _loading = false;
        notifyListeners();
        return;
      }

      _setError(error.message, _mapErrorType(error.type));
    } catch (error) {
      if (version != _loadVersion) return;
      _setError(
        'Failed to load prayer times: $error',
        PrayerTimesErrorType.unavailable,
      );
    }
  }

  Future<void> reloadForCalculationChange() async {
    ++_loadVersion;
    _prayerTimes = null;
    _prayerTimeRanges = null;
    _nextPrayer = null;
    _currentPrayer = null;
    _currentPrayerEndsAtUtc = null;
    _schedule = const {};
    _scheduleLocation = null;
    _scheduleDate = null;
    _tomorrowFajr = null;
    _scheduleTimer?.cancel();
    _scheduleTimer = null;
    _loading = false;
    _error = '';
    _errorType = PrayerTimesErrorType.none;
    notifyListeners();
    await loadPrayerTimes();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshOnResume());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    ++_loadVersion;
    _scheduleTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _refreshOnResume() async {
    final version = _loadVersion;
    try {
      final refreshed = await _loadPrayerTimesUseCase.refreshAfterResume();
      if (refreshed == null || version != _loadVersion) {
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
        ? tz.TZDateTime(
            location,
            fajr.year,
            fajr.month,
            fajr.day + 1,
            fajr.hour,
            fajr.minute,
            fajr.second,
          )
        : tz.TZDateTime.from(dashboardData.tomorrow!.fajrUtc, location);
    final todaySchedule = <String, tz.TZDateTime>{
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };

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
      'Isha': '${format.format(isha)} - ${format.format(tomorrowFajr)}',
    };
    _scheduleLocation = location;
    _scheduleDate = DateTime(fajr.year, fajr.month, fajr.day);
    _schedule = todaySchedule;
    _tomorrowFajr = tomorrowFajr;
    _syncCurrentPrayer(tz.TZDateTime.now(location));
    _scheduleTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      final location = _scheduleLocation;
      if (location == null) return;
      final now = tz.TZDateTime.now(location);
      final date = _scheduleDate;
      if (date == null ||
          now.year != date.year ||
          now.month != date.month ||
          now.day != date.day) {
        unawaited(loadPrayerTimes());
        return;
      }
      if (_syncCurrentPrayer(now)) notifyListeners();
    });
  }

  bool _syncCurrentPrayer(tz.TZDateTime now) {
    String current = 'Isha';
    String? next;
    tz.TZDateTime? end = _schedule['Fajr'];
    for (final entry in _schedule.entries) {
      if (entry.value.isAfter(now)) {
        next = entry.key;
        end = entry.value;
        break;
      }
      current = entry.key;
      next = null;
      end = null;
    }
    end ??= _tomorrowFajr;
    final changed =
        _currentPrayer != current ||
        _nextPrayer != next ||
        _currentPrayerEndsAtUtc != end?.toUtc();
    _currentPrayer = current;
    _nextPrayer = next;
    _currentPrayerEndsAtUtc = end?.toUtc();
    return changed;
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
