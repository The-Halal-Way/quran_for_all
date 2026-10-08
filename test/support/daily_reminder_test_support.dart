import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_for_all/data/datasources/local/daily_hadith_pack_parser.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:quran_for_all/domain/repositories/daily_hadith_repository.dart';
import 'package:quran_for_all/services/daily_hadith_notification_service.dart';

Future<String> loadDailyHadithJson() =>
    rootBundle.loadString('assets/json/daily_hadith.json');

Future<DailyHadithPack> loadDraftPack() async {
  final decoded =
      jsonDecode(await loadDailyHadithJson()) as Map<String, dynamic>;
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
  return parseDailyHadithPack(jsonEncode(decoded));
}

Future<DailyHadithPack> loadPublishedPack() async =>
    parseDailyHadithPack(await loadDailyHadithJson());

class MemoryDailyHadithRepository implements DailyHadithRepository {
  MemoryDailyHadithRepository(this.pack);

  final DailyHadithPack pack;
  DailyHadithUserState state = const DailyHadithUserState();
  DailyHadithPreferences preferences = const DailyHadithPreferences();
  Set<int> scheduledIds = {};
  int packLoads = 0;

  @override
  Future<DailyHadithPack> loadPack({bool forceRefresh = false}) async {
    packLoads++;
    return pack;
  }

  @override
  Future<DailyHadithPreferences> loadPreferences() async => preferences;

  @override
  Future<Set<int>> loadScheduledOccurrenceIds() async => {...scheduledIds};

  @override
  Future<DailyHadithUserState> loadUserState() async => state;

  @override
  Future<void> savePreferences(DailyHadithPreferences preferences) async {
    this.preferences = preferences;
  }

  @override
  Future<void> saveScheduledOccurrenceIds(Set<int> ids) async {
    scheduledIds = {...ids};
  }

  @override
  Future<void> saveUserState(DailyHadithUserState state) async {
    this.state = state;
  }
}

class FakeDailyHadithNotificationGateway
    implements DailyHadithNotificationGateway {
  ValueChanged<String>? openHandler;
  DailyHadithPermissionStatus status = DailyHadithPermissionStatus.granted;
  int rescheduleCalls = 0;
  int cancelCalls = 0;

  @override
  Future<void> cancelContent(
    DailyHadithPack pack,
    String contentId,
    Set<int> scheduledIds,
    ValueChanged<Set<int>> persistScheduledIds,
  ) async {
    cancelCalls++;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<DailyHadithPermissionStatus> permissionStatus() async => status;

  @override
  Future<void> reschedule({
    required DailyHadithPack pack,
    required DailyHadithPreferences preferences,
    required String locale,
    required Set<int> previouslyScheduledIds,
    required ValueChanged<Set<int>> persistScheduledIds,
    DateTime? now,
  }) async {
    rescheduleCalls++;
  }

  @override
  Future<DailyHadithPermissionStatus> requestPermission() async => status;

  @override
  void setOpenHandler(ValueChanged<String> handler) {
    openHandler = handler;
  }
}
