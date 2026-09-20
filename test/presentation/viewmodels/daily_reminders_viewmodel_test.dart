import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/daily_reminders/shared/daily_reminder_notification_router.dart';
import 'package:quran_for_all/services/daily_reminder_schedule_planner.dart';

import '../../support/daily_reminder_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DailyReminderPack draftPack;
  late DailyReminderPack publishedPack;

  setUpAll(() async {
    draftPack = await loadDraftPack();
    publishedPack = await loadPublishedPack();
  });

  test(
    'draft content stays unavailable while published reminders release',
    () async {
      final draftVm = DailyRemindersViewModel(
        repository: MemoryDailyReminderRepository(draftPack),
        notificationGateway: FakeDailyReminderNotificationGateway(),
        clock: () => DateTime(2027, 1, 12, 12),
      );
      await draftVm.initialize('en');
      expect(draftVm.releasedRecords, isEmpty);

      final publishedVm = DailyRemindersViewModel(
        repository: MemoryDailyReminderRepository(publishedPack),
        notificationGateway: FakeDailyReminderNotificationGateway(),
        clock: () => DateTime(2027, 1, 12, 12),
      );
      await publishedVm.initialize('en');
      expect(publishedVm.releasedRecords, hasLength(122));
      expect(publishedVm.todayReminder?.item.id, 'dr-0122');
      draftVm.dispose();
      publishedVm.dispose();
    },
  );

  test(
    'read, saved and released history persist through resume and rollback',
    () async {
      var now = DateTime(2026, 9, 15, 12);
      final repository = MemoryDailyReminderRepository(publishedPack);
      final gateway = FakeDailyReminderNotificationGateway();
      final vm = DailyRemindersViewModel(
        repository: repository,
        notificationGateway: gateway,
        clock: () => now,
      );
      await vm.initialize('en');
      expect(vm.releasedRecords, hasLength(3));
      expect(vm.unreadCount, 3);
      expect(vm.todayReminder?.item.id, 'dr-0003');
      await vm.markRead('dr-0001');
      expect(vm.unreadCount, 2);
      await vm.toggleSaved('dr-0002');
      expect(vm.filteredHistory, hasLength(2));

      now = DateTime(2026, 9, 16, 12);
      await vm.refreshAvailability();
      expect(vm.releasedRecords, hasLength(4));
      now = DateTime(2026, 9, 14, 12);
      await vm.refreshAvailability();
      expect(vm.releasedRecords, hasLength(4));
      expect(vm.isRead('dr-0001'), isTrue);
      expect(vm.isSaved('dr-0002'), isTrue);
      vm.dispose();
    },
  );

  test(
    'future content is hidden and January end retains all history',
    () async {
      var now = DateTime(2026, 9, 13, 1);
      final repository = MemoryDailyReminderRepository(publishedPack);
      final vm = DailyRemindersViewModel(
        repository: repository,
        notificationGateway: FakeDailyReminderNotificationGateway(),
        clock: () => now,
      );
      await vm.initialize('en');
      expect(vm.releasedRecords, hasLength(1));
      now = DateTime(2027, 1, 13, 1);
      await vm.refreshAvailability();
      expect(vm.releasedRecords, hasLength(122));
      expect(vm.todayReminder, isNull);
      vm.dispose();
    },
  );

  testWidgets('router initializes and changes locale outside the build phase', (
    tester,
  ) async {
    final repository = MemoryDailyReminderRepository(publishedPack);
    final navigatorKey = GlobalKey<NavigatorState>();
    late DailyRemindersViewModel vm;
    late StateSetter updateHarness;
    var locale = 'en';

    await tester.pumpWidget(
      ChangeNotifierProvider<DailyRemindersViewModel>(
        create: (_) => vm = DailyRemindersViewModel(
          repository: repository,
          notificationGateway: FakeDailyReminderNotificationGateway(),
          clock: () => DateTime(2026, 9, 15, 12),
        ),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: StatefulBuilder(
            builder: (context, setState) {
              updateHarness = setState;
              return DailyReminderNotificationRouter(
                navigatorKey: navigatorKey,
                locale: locale,
                child: const Scaffold(body: Text('Dashboard')),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.packLoads, 1);
    expect(vm.pack, same(publishedPack));
    expect(tester.takeException(), isNull);

    updateHarness(() => locale = 'bn');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('notification policy suppresses drafts, opt-out and passed times', () {
    const enabled = DailyReminderPreferences(notificationsEnabled: true);
    expect(
      planDailyReminderOccurrences(
        pack: draftPack,
        preferences: enabled,
        locale: 'en',
        now: DateTime(2026, 9, 12),
      ),
      isEmpty,
    );
    expect(
      planDailyReminderOccurrences(
        pack: publishedPack,
        preferences: const DailyReminderPreferences(),
        locale: 'en',
        now: DateTime(2026, 9, 12),
      ),
      isEmpty,
    );
    final planned = planDailyReminderOccurrences(
      pack: publishedPack,
      preferences: enabled,
      locale: 'en',
      now: DateTime(2026, 9, 13, 9),
    );
    expect(planned, hasLength(32));
    expect(planned.first.contentId, 'dr-0002');
    expect(planned.map((entry) => entry.notificationId).toSet(), hasLength(32));
    expect(
      dailyReminderNotificationId(planned.first.occurrenceId),
      planned.first.notificationId,
    );
  });
}
