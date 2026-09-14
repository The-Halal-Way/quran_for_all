import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_for_all/data/datasources/local/daily_reminder_pack_parser.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:quran_for_all/domain/repositories/daily_reminder_repository.dart';
import 'package:quran_for_all/services/daily_reminder_notification_service.dart';

Future<String> loadDailyReminderJson() =>
    rootBundle.loadString('assets/json/daily_reminders.json');

Future<DailyReminderPack> loadDraftPack() async {
  final decoded =
      jsonDecode(await loadDailyReminderJson()) as Map<String, dynamic>;
  (decoded['metadata'] as Map<String, dynamic>)['reviewStatus'] =
      'needsEditorialReview';
  for (final item in decoded['items'] as List<dynamic>) {
    final map = item as Map<String, dynamic>;
    map['status'] = 'draft';
    for (final edition in (map['editions'] as Map<String, dynamic>).values) {
      (edition as Map<String, dynamic>)['reviewStatus'] =
          'needsEditorialReview';
    }
  }
  return parseDailyReminderPack(jsonEncode(decoded));
}

Future<DailyReminderPack> loadPublishedPack() async =>
    parseDailyReminderPack(await loadDailyReminderJson());

class MemoryDailyReminderRepository implements DailyReminderRepository {
  MemoryDailyReminderRepository(this.pack);

  final DailyReminderPack pack;
  DailyReminderUserState state = const DailyReminderUserState();
  DailyReminderPreferences preferences = const DailyReminderPreferences();
  Set<int> scheduledIds = {};
  int packLoads = 0;

  @override
  Future<DailyReminderPack> loadPack({bool forceRefresh = false}) async {
    packLoads++;
    return pack;
  }

  @override
  Future<DailyReminderPreferences> loadPreferences() async => preferences;

  @override
  Future<Set<int>> loadScheduledOccurrenceIds() async => {...scheduledIds};

  @override
  Future<DailyReminderUserState> loadUserState() async => state;

  @override
  Future<void> savePreferences(DailyReminderPreferences preferences) async {
    this.preferences = preferences;
  }

  @override
  Future<void> saveScheduledOccurrenceIds(Set<int> ids) async {
    scheduledIds = {...ids};
  }

  @override
  Future<void> saveUserState(DailyReminderUserState state) async {
    this.state = state;
  }
}

class FakeDailyReminderNotificationGateway
    implements DailyReminderNotificationGateway {
  ValueChanged<String>? openHandler;
  DailyReminderPermissionStatus status = DailyReminderPermissionStatus.granted;
  int rescheduleCalls = 0;
  int cancelCalls = 0;

  @override
  Future<void> cancelContent(
    DailyReminderPack pack,
    String contentId,
    Set<int> scheduledIds,
    ValueChanged<Set<int>> persistScheduledIds,
  ) async {
    cancelCalls++;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<DailyReminderPermissionStatus> permissionStatus() async => status;

  @override
  Future<void> reschedule({
    required DailyReminderPack pack,
    required DailyReminderPreferences preferences,
    required String locale,
    required Set<int> previouslyScheduledIds,
    required ValueChanged<Set<int>> persistScheduledIds,
    DateTime? now,
  }) async {
    rescheduleCalls++;
  }

  @override
  Future<DailyReminderPermissionStatus> requestPermission() async => status;

  @override
  void setOpenHandler(ValueChanged<String> handler) {
    openHandler = handler;
  }
}
