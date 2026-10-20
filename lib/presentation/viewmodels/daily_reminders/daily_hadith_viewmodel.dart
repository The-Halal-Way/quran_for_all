import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

import '../../../domain/repositories/daily_hadith_repository.dart';
import '../../../services/daily_hadith_notification_service.dart';

enum DailyHadithFeedFilter { all, unread, saved }

class DailyHadithRecord {
  const DailyHadithRecord({required this.item, required this.schedule});

  final DailyHadithItem item;
  final DailyHadithSchedule schedule;
}

class DailyHadithViewModel extends ChangeNotifier with WidgetsBindingObserver {
  DailyHadithViewModel({
    required DailyHadithRepository repository,
    required DailyHadithNotificationGateway notificationGateway,
    DateTime Function()? clock,
  }) : _repository = repository,
       _notificationGateway = notificationGateway,
       _clock = clock ?? DateTime.now {
    _notificationGateway.setOpenHandler(_handleNotificationOpen);
    WidgetsBinding.instance.addObserver(this);
  }

  final DailyHadithRepository _repository;
  final DailyHadithNotificationGateway _notificationGateway;
  final DateTime Function() _clock;

  DailyHadithPack? _pack;
  List<DailyHadithRecord>? _releasedRecords;
  DailyHadithUserState _userState = const DailyHadithUserState();
  DailyHadithPreferences _preferences = const DailyHadithPreferences();
  DailyHadithPermissionStatus _permissionStatus =
      DailyHadithPermissionStatus.unknown;
  Set<int> _scheduledIds = {};
  bool _isLoading = false;
  Object? _error;
  String _locale = 'en';
  String _query = '';
  String? _kindFilter;
  DailyHadithFeedFilter _feedFilter = DailyHadithFeedFilter.all;
  String? _pendingOpenContentId;
  Timer? _midnightTimer;
  Future<void>? _initialization;

  bool get isLoading => _isLoading;
  Object? get error => _error;
  DailyHadithPack? get pack => _pack;
  DailyHadithPreferences get preferences => _preferences;
  DailyHadithPermissionStatus get permissionStatus => _permissionStatus;
  String get query => _query;
  String? get kindFilter => _kindFilter;
  DailyHadithFeedFilter get feedFilter => _feedFilter;
  String? get pendingOpenContentId => _pendingOpenContentId;

  List<String> get availableKinds {
    final kinds = _pack?.items.map((item) => item.kind).toSet().toList() ?? [];
    kinds.sort();
    return kinds;
  }

  LocalCalendarDate get effectiveDate =>
      LocalCalendarDate.fromDateTime(_clock());

  List<DailyHadithRecord> get releasedRecords {
    final cached = _releasedRecords;
    if (cached != null) return cached;
    final pack = _pack;
    if (pack == null) return const [];
    final records = <DailyHadithRecord>[];
    for (final entry in pack.schedule) {
      final item = pack.itemById(entry.contentId);
      if (item == null || pack.unavailableItemIds.contains(item.id)) {
        continue;
      }
      if (!item.isProductionEligible(_locale)) {
        continue;
      }
      final available = _userState.releasedContentIds.contains(item.id);
      if (available) {
        records.add(DailyHadithRecord(item: item, schedule: entry));
      }
    }
    records.sort(
      (a, b) => b.schedule.localDate.compareTo(a.schedule.localDate),
    );
    return _releasedRecords = List.unmodifiable(records);
  }

  DailyHadithRecord? get todayReminder {
    for (final record in releasedRecords) {
      if (record.schedule.localDate == effectiveDate) return record;
    }
    return null;
  }

  int get unreadCount =>
      releasedRecords.where((record) => !isRead(record.item.id)).length;

  List<DailyHadithRecord> get filteredHistory {
    final todayId = todayReminder?.item.id;
    return releasedRecords
        .where((record) {
          if (record.item.id == todayId) return false;
          if (_kindFilter != null && record.item.kind != _kindFilter) {
            return false;
          }
          final isRead = _userState.readAtByContentId.containsKey(
            record.item.id,
          );
          final isSaved = _userState.savedContentIds.contains(record.item.id);
          if (_feedFilter == DailyHadithFeedFilter.unread && isRead) {
            return false;
          }
          if (_feedFilter == DailyHadithFeedFilter.saved && !isSaved) {
            return false;
          }
          if (_query.isEmpty) return true;
          final resolved = resolveEdition(record.item);
          if (resolved == null) return false;
          final haystack = [
            resolved.edition.title,
            resolved.edition.summary,
            ...resolved.edition.blocks.expand(
              (block) =>
                  [block.text, block.label, block.value].whereType<String>(),
            ),
            ...record.item.sourceIds.map(
              (id) => _pack?.sources[id]?.displayName ?? '',
            ),
          ].join(' ').toLowerCase();
          return haystack.contains(_query.toLowerCase());
        })
        .toList(growable: false);
  }

  Future<void> initialize(String locale, {bool forceRefresh = false}) {
    if (_locale != locale) _releasedRecords = null;
    _locale = locale;
    return _initialization ??= _initialize(
      forceRefresh: forceRefresh,
    ).whenComplete(() => _initialization = null);
  }

  /// Notification routing needs the native callback, not the JSON catalog.
  Future<void> prepareNotifications() async {
    try {
      await _notificationGateway.initialize();
    } catch (_) {
      // Offline content can still be opened if native setup is unavailable.
    }
  }

  Future<void> _initialize({required bool forceRefresh}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _notificationGateway.initialize();
      final results = await Future.wait<Object>([
        _repository.loadPack(forceRefresh: forceRefresh),
        _repository.loadUserState(),
        _repository.loadPreferences(),
        _repository.loadScheduledOccurrenceIds(),
      ]);
      _pack = results[0] as DailyHadithPack;
      _releasedRecords = null;
      _userState = results[1] as DailyHadithUserState;
      _preferences = results[2] as DailyHadithPreferences;
      _scheduledIds = results[3] as Set<int>;
      _permissionStatus = await _notificationGateway.permissionStatus();
      await refreshAvailability(reschedule: true);
      _scheduleMidnightRefresh();
    } catch (error) {
      _error = error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> localeChanged(String locale) async {
    if (_locale == locale) return;
    _locale = locale;
    _releasedRecords = null;
    notifyListeners();
    await _reschedule();
  }

  Future<void> refreshAvailability({bool reschedule = false}) async {
    final pack = _pack;
    if (pack == null) return;
    final today = LocalCalendarDate.fromDateTime(_clock());
    var highWater = _userState.highWaterDate;
    if (highWater == null || highWater < today) highWater = today;
    final released = <String>{..._userState.releasedContentIds};
    for (final entry in pack.schedule) {
      final item = pack.itemById(entry.contentId);
      if (item != null &&
          entry.localDate <= highWater &&
          item.isProductionEligible(_locale) &&
          !pack.unavailableItemIds.contains(item.id)) {
        released.add(item.id);
      }
    }
    _userState = DailyHadithUserState(
      readAtByContentId: _userState.readAtByContentId,
      savedContentIds: _userState.savedContentIds,
      releasedContentIds: released,
      highWaterDate: highWater,
    );
    _releasedRecords = null;
    await _repository.saveUserState(_userState);
    if (reschedule) await _reschedule();
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value.trim();
    notifyListeners();
  }

  void setKindFilter(String? value) {
    _kindFilter = value;
    notifyListeners();
  }

  void setFeedFilter(DailyHadithFeedFilter value) {
    _feedFilter = value;
    notifyListeners();
  }

  bool isRead(String contentId) =>
      _userState.readAtByContentId.containsKey(contentId);
  bool isSaved(String contentId) =>
      _userState.savedContentIds.contains(contentId);

  ResolvedDailyHadithEdition? resolveEdition(DailyHadithItem item) =>
      item.resolveEdition(_locale, approvedOnly: true);

  Future<void> markRead(String contentId) async {
    if (isRead(contentId)) return;
    _userState = DailyHadithUserState(
      readAtByContentId: {..._userState.readAtByContentId, contentId: _clock()},
      savedContentIds: _userState.savedContentIds,
      releasedContentIds: _userState.releasedContentIds,
      highWaterDate: _userState.highWaterDate,
    );
    await _repository.saveUserState(_userState);
    final pack = _pack;
    if (pack != null) {
      await _notificationGateway.cancelContent(
        pack,
        contentId,
        _scheduledIds,
        _persistScheduledIds,
      );
    }
    notifyListeners();
  }

  Future<void> toggleSaved(String contentId) async {
    final saved = {..._userState.savedContentIds};
    saved.contains(contentId) ? saved.remove(contentId) : saved.add(contentId);
    _userState = DailyHadithUserState(
      readAtByContentId: _userState.readAtByContentId,
      savedContentIds: saved,
      releasedContentIds: _userState.releasedContentIds,
      highWaterDate: _userState.highWaterDate,
    );
    await _repository.saveUserState(_userState);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _preferences = _preferences.copyWith(notificationsEnabled: enabled);
    await _repository.savePreferences(_preferences);
    if (enabled) {
      _permissionStatus = await _notificationGateway.requestPermission();
    }
    notifyListeners();
    await _reschedule();
  }

  Future<void> setReminderTime(int hour, int minute) async {
    _preferences = _preferences.copyWith(hour: hour, minute: minute);
    await _repository.savePreferences(_preferences);
    notifyListeners();
    await _reschedule();
  }

  Future<void> setKindEnabled(String kind, bool enabled) async {
    final kinds = {..._preferences.enabledKinds};
    enabled ? kinds.add(kind) : kinds.remove(kind);
    _preferences = _preferences.copyWith(enabledKinds: kinds);
    await _repository.savePreferences(_preferences);
    notifyListeners();
    await _reschedule();
  }

  DailyHadithRecord? recordForContentId(String id) {
    for (final record in releasedRecords) {
      if (record.item.id == id) return record;
    }
    return null;
  }

  String? takePendingOpenContentId() {
    final value = _pendingOpenContentId;
    _pendingOpenContentId = null;
    return value;
  }

  void _handleNotificationOpen(String contentId) {
    _pendingOpenContentId = contentId;
    notifyListeners();
  }

  Future<void> _reschedule() async {
    final pack = _pack;
    if (pack == null) return;
    await _notificationGateway.reschedule(
      pack: pack,
      preferences: _preferences,
      locale: _locale,
      previouslyScheduledIds: _scheduledIds,
      persistScheduledIds: _persistScheduledIds,
    );
  }

  void _persistScheduledIds(Set<int> ids) {
    _scheduledIds = ids;
    unawaited(_repository.saveScheduledOccurrenceIds(ids));
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = _clock();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _midnightTimer = Timer(
      nextMidnight.difference(now) + const Duration(seconds: 1),
      () {
        unawaited(refreshAvailability(reschedule: true));
        _scheduleMidnightRefresh();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pack != null) {
      unawaited(refreshAvailability(reschedule: true));
      unawaited(_updatePermission());
      _scheduleMidnightRefresh();
    }
  }

  Future<void> _updatePermission() async {
    _permissionStatus = await _notificationGateway.permissionStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _midnightTimer?.cancel();
    super.dispose();
  }
}
