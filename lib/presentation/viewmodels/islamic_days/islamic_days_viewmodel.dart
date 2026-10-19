import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../data/datasources/local/islamic_days_progress_store.dart';
import '../../../data/models/daily_task_model.dart';
import '../../../data/models/islamic_days/islamic_day.dart';
import '../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../data/models/islamic_days/islamic_days_preferences.dart';
import '../../../data/repositories/islamic_days_repository.dart';
import '../../../services/islamic_days/islamic_day_rule_evaluator.dart';
import '../../../services/islamic_days/islamic_days_notification_service.dart';
import '../../../services/notifications/app_notification_coordinator.dart';
import '../../models/islamic_day_tracker_tasks.dart';

class IslamicDaysViewModel extends ChangeNotifier with WidgetsBindingObserver {
  IslamicDaysViewModel({
    required IslamicDaysRepository repository,
    required IslamicDaysNotificationService notifications,
    IslamicDayRuleEvaluator evaluator = const IslamicDayRuleEvaluator(),
    DateTime Function()? clock,
  }) : _repository = repository,
       _notifications = notifications,
       _evaluator = evaluator,
       _clock = clock ?? DateTime.now,
       _progress = IslamicDaysProgressStore(repository) {
    notifications.setOpenHandler((payload) {
      if (_disposed) return;
      final id = payload['eventId'];
      final date = DateTime.tryParse(payload['date'] as String? ?? '');
      if (id is String && date != null) {
        _pendingOpen = (eventId: id, date: date);
        _notify();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    // Keep the dashboard's local date current without loading the catalog.
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => refresh());
  }

  final IslamicDaysRepository _repository;
  final IslamicDaysNotificationService _notifications;
  final IslamicDayRuleEvaluator _evaluator;
  final DateTime Function() _clock;
  final IslamicDaysProgressStore _progress;
  List<IslamicDay> _catalog = [];
  List<IslamicDayOccurrence> _today = [];
  List<IslamicDayOccurrence> _upcoming = [];
  IslamicDaysPreferences _preferences = const IslamicDaysPreferences();
  AppNotificationPermission _permission = AppNotificationPermission.unknown;
  Future<void>? _initialization;
  Future<void> _notificationWork = Future.value();
  Timer? _timer;
  String _locale = 'en';
  int _adjustment = 0;
  String? _dateSignature;
  bool _disposed = false;
  bool _loading = false;
  bool _savingPreferences = false;
  Object? _error;
  Object? _notificationError;
  ({String eventId, DateTime date})? _pendingOpen;

  bool get isLoading => _loading;
  bool get ready => _catalog.isNotEmpty;
  bool get savingPreferences => _savingPreferences;
  Object? get error => _error;
  Object? get notificationError => _notificationError;
  IslamicDaysPreferences get preferences => _preferences;
  AppNotificationPermission get permission => _permission;
  List<IslamicDayOccurrence> get today => _today;
  List<IslamicDayOccurrence> get upcoming => _upcoming;
  List<IslamicDay> get catalog => _catalog;
  DateTime get localNow => _clock().toLocal();
  int get adjustment => _adjustment;
  ({String eventId, DateTime date})? get pendingOpen => _pendingOpen;
  List<DailyTask> get trackerTasks => islamicDayTrackerTasks(_today, _progress);

  bool isSaved(String id) => _progress.saved.contains(id);
  bool isCompleted(String key) => _progress.completed(key);
  bool isTracked(IslamicDayOccurrence occurrence) =>
      _progress.tracked(occurrence);

  List<IslamicDayOccurrence> get guides => [
    for (final event in _catalog)
      for (final occurrence in [
        ..._today,
        ..._upcoming,
      ].where((entry) => entry.event.id == event.id).take(1))
        occurrence,
  ];

  List<IslamicDayOccurrence> get saved =>
      guides.where((entry) => isSaved(entry.event.id)).toList();

  Future<void> initialize(String locale, int adjustment) async {
    _locale = locale;
    _adjustment = adjustment;
    if (_initialization != null) return _initialization;
    _initialization = _load();
    return _initialization;
  }

  Future<void> _load() async {
    _loading = true;
    _error = null;
    _notify();
    try {
      _catalog = await _repository.loadCatalog();
      _preferences = await _repository.loadPreferences();
      await _progress.load();
      if (_disposed) return;
      _recompute();
      // Native notification failures should not hide offline guidance.
      await _reschedule();
    } catch (error) {
      _error = error;
      _initialization = null;
    } finally {
      _loading = false;
      _notify();
    }
  }

  void _recompute() {
    final now = localNow;
    _today = _evaluator.forDate(
      _catalog,
      now,
      adjustment: _adjustment,
      isOnHajj: _preferences.isOnHajj,
    );
    _upcoming = _evaluator.nextOccurrences(
      _catalog,
      now,
      adjustment: _adjustment,
      isOnHajj: _preferences.isOnHajj,
    );
    _dateSignature = '${islamicDayDateKey(now)}|${now.timeZoneOffset}';
    _notify();
  }

  Future<void> configure(String locale, int adjustment) async {
    if (_locale == locale && _adjustment == adjustment) return;
    _locale = locale;
    _adjustment = adjustment;
    // The app shell may update preferences without opening this feature.
    if (!ready || _loading) return;
    _recompute();
    await _reschedule();
  }

  Future<void> refresh({bool force = false}) async {
    if (_disposed) return;
    final now = localNow;
    final signature = '${islamicDayDateKey(now)}|${now.timeZoneOffset}';
    if (!force && signature == _dateSignature) return;
    if (!ready) {
      _dateSignature = signature;
      _notify();
      return;
    }
    _recompute();
    await _reschedule();
  }

  IslamicDayOccurrence? occurrenceFor(String id, DateTime date) {
    final matching = _evaluator.forDate(
      _catalog,
      date,
      adjustment: _adjustment,
      isOnHajj: _preferences.isOnHajj,
    );
    for (final occurrence in matching) {
      if (occurrence.event.id == id) return occurrence;
    }
    // A calendar adjustment can move a previously saved occurrence.
    for (final occurrence in [..._today, ..._upcoming]) {
      if (occurrence.event.id == id) return occurrence;
    }
    return null;
  }

  Future<void> toggleSaved(String id) async {
    await _progress.toggleSaved(id);
    _notify();
  }

  Future<void> toggleAction(
    IslamicDayOccurrence occurrence,
    IslamicDayAction action,
  ) async {
    final current = occurrenceFor(occurrence.event.id, occurrence.date);
    if (current == null ||
        !current.availableActions.any((entry) => entry.id == action.id)) {
      return;
    }
    await _progress.toggleCompleted(current.actionKey(action));
    _notify();
  }

  Future<void> toggleTrackerTask(String taskId) async {
    final key = taskId.substring(islamicDayTaskPrefix.length);
    if (!trackerTasks.any((task) => task.id == taskId)) return;
    await _progress.toggleCompleted(key);
    _notify();
  }

  Future<void> addToTracker(IslamicDayOccurrence occurrence) async {
    await _progress.addToTracker(occurrence);
    _notify();
  }

  Future<void> updatePreferences(IslamicDaysPreferences preferences) async {
    if (_savingPreferences) return;
    _savingPreferences = true;
    _notify();
    try {
      var updated = preferences;
      if (preferences.notificationsEnabled &&
          !_preferences.notificationsEnabled) {
        _permission = await _notifications.coordinator.requestPermission();
        updated = preferences.copyWith(
          notificationsEnabled:
              _permission == AppNotificationPermission.granted,
        );
      }
      await _repository.savePreferences(updated);
      _preferences = updated;
      _recompute();
      await _reschedule();
    } finally {
      _savingPreferences = false;
      _notify();
    }
  }

  Future<void> _reschedule() {
    final operation = _notificationWork.then((_) async {
      if (_disposed) return;
      _notificationError = null;
      try {
        await _notifications.coordinator.initialize();
        _permission = await _notifications.coordinator.permissionStatus();
        final ids = (await _repository.loadSet(
          'notifications',
        )).map(int.tryParse).whereType<int>().toSet();
        await _notifications.reschedule(
          catalog: _catalog,
          preferences: _preferences,
          evaluator: _evaluator,
          previousIds: ids,
          locale: _locale,
          adjustment: _adjustment,
          persistIds: (ids) => _repository.saveSet(
            'notifications',
            ids.map((id) => id.toString()).toSet(),
          ),
        );
      } catch (error) {
        _notificationError = error;
      }
      _notify();
    });
    _notificationWork = operation.catchError((Object _) {});
    return operation;
  }

  ({String eventId, DateTime date})? takePendingOpen() {
    final result = _pendingOpen;
    _pendingOpen = null;
    _notify();
    return result;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh(force: true));
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _notifications.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
