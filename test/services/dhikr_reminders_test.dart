import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/data/datasources/local/dhikr_reminders_store.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/dhikr_reminders/dhikr_reminder.dart';
import 'package:quran_for_all/data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/l10n/app_localizations_en.dart';
import 'package:quran_for_all/l10n/app_localizations_bn.dart';
import 'package:quran_for_all/presentation/viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/dhikr_reminders/dhikr_reminders_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_shortcut_catalog.dart';
import 'package:quran_for_all/presentation/widgets/dhikr_reminders/dhikr_reminder_card.dart';
import 'package:quran_for_all/services/dhikr_reminders/dhikr_reminder_service.dart';
import 'package:quran_for_all/services/notifications/app_notification_coordinator.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  late List<MethodCall> calls;
  late Map<int, Map<String, dynamic>> pending;
  late bool allowed, grantRequest, failSchedule;
  late DhikrRemindersViewModel vm;
  final en = AppLocalizationsEn();
  const durud = DhikrReminderKind.durud;
  const istighfar = DhikrReminderKind.istighfar;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    SharedPreferences.setMockInitialValues({});
    calls = [];
    pending = {};
    allowed = true;
    grantRequest = false;
    failSchedule = false;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call);
      switch (call.method) {
        case 'initialize':
          return true;
        case 'getNotificationAppLaunchDetails':
          return {'notificationLaunchedApp': false};
        case 'areNotificationsEnabled':
          return allowed;
        case 'requestNotificationsPermission':
          allowed = grantRequest;
          return allowed;
        case 'pendingNotificationRequests':
          return pending.values.toList();
        case 'periodicallyShowWithDuration':
          if (failSchedule) throw PlatformException(code: 'schedule_failed');
          final args = Map<String, dynamic>.from(call.arguments as Map);
          pending[args['id'] as int] = {
            'id': args['id'],
            'title': args['title'],
            'body': args['body'],
            'payload': args['payload'],
          };
          return null;
        case 'cancel':
          pending.remove((call.arguments as Map)['id']);
          return null;
        case 'show':
          return null;
        default:
          throw MissingPluginException(call.method);
      }
    });
    vm = DhikrRemindersViewModel(
      DhikrReminderService(AppNotificationCoordinator()),
    );
  });

  tearDown(() {
    vm.dispose();
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'default startup is off and does not initialize native notifications',
    () async {
      await vm.configure(en);
      expect(vm.reminder(durud).enabled, false);
      expect(vm.reminder(istighfar).enabled, false);
      expect(calls, isEmpty);
    },
  );

  test(
    'permission denial leaves reminder off and does not persist an enabled flag',
    () async {
      allowed = false;
      await vm.configure(en);
      await vm.update(durud, vm.reminder(durud).copyWith(enabled: true));
      expect(vm.error, DhikrReminderError.permission);
      expect(vm.reminder(durud).enabled, false);
      expect(pending, isEmpty);
      expect((await DhikrRemindersStore().load())[durud]!.enabled, false);
      expect(
        calls.where((call) => call.method == 'requestNotificationsPermission'),
        hasLength(1),
      );
    },
  );

  test(
    'two schedules persist independent intervals and native sound channels',
    () async {
      await vm.configure(en);
      await vm.update(
        durud,
        const DhikrReminder(enabled: true, intervalMinutes: 5),
      );
      await vm.update(
        istighfar,
        const DhikrReminder(
          enabled: true,
          intervalMinutes: 120,
          sound: DhikrReminderSound.quran,
        ),
      );
      expect(
        pending.keys,
        unorderedEquals([durud.notificationId, istighfar.notificationId]),
      );
      final schedules = calls
          .where((call) => call.method == 'periodicallyShowWithDuration')
          .toList();
      final args = schedules.last.arguments as Map;
      expect(
        args['repeatIntervalMilliseconds'],
        const Duration(minutes: 120).inMilliseconds,
      );
      final native = args['platformSpecifics'] as Map;
      expect(native['sound'], 'quran_notification');
      expect(native['channelId'], 'dhikr_istighfar_quran_v2');
      expect(native['scheduleMode'], 'inexactAllowWhileIdle');
      final saved = await DhikrRemindersStore().load();
      expect(saved[durud]!.intervalMinutes, 5);
      expect(saved[istighfar]!.sound, DhikrReminderSound.quran);
    },
  );

  test(
    'reopening retains interval countdown; locale changes replace active content',
    () async {
      await vm.configure(en);
      await vm.update(durud, const DhikrReminder(enabled: true));
      final reopened = DhikrRemindersViewModel(vm.service);
      addTearDown(reopened.dispose);
      final count = calls
          .where((call) => call.method == 'periodicallyShowWithDuration')
          .length;
      await reopened.configure(en);
      expect(
        calls.where((call) => call.method == 'periodicallyShowWithDuration'),
        hasLength(count),
      );
      await reopened.configure(AppLocalizationsBn());
      expect(pending[durud.notificationId]!['title'], 'দরুদ');
      expect(
        calls.where((call) => call.method == 'periodicallyShowWithDuration'),
        hasLength(count + 1),
      );
    },
  );

  test(
    'disabling cancels its own reminder and leaves other features and dhikr alone',
    () async {
      await vm.configure(en);
      await vm.update(durud, const DhikrReminder(enabled: true));
      await vm.update(istighfar, const DhikrReminder(enabled: true));
      pending[700000001] = {
        'id': 700000001,
        'title': 'Hadith',
        'body': '',
        'payload': '',
      };
      await vm.update(durud, vm.reminder(durud).copyWith(enabled: false));
      expect(
        pending.keys,
        unorderedEquals([istighfar.notificationId, 700000001]),
      );
    },
  );

  test(
    'revoked permission cancels delivery and restored permission recovers enabled settings',
    () async {
      await vm.configure(en);
      await vm.update(durud, const DhikrReminder(enabled: true));
      allowed = false;
      await vm.configure(en, checkPermission: true);
      expect(pending, isEmpty);
      expect(vm.reminder(durud).enabled, true);
      allowed = true;
      await vm.configure(en, checkPermission: true);
      expect(pending.keys, [durud.notificationId]);
    },
  );

  test('native scheduling failure never saves an enabled reminder', () async {
    await vm.configure(en);
    failSchedule = true;
    await vm.update(durud, const DhikrReminder(enabled: true));
    expect(vm.error, DhikrReminderError.save);
    expect(vm.reminder(durud).enabled, false);
    expect(pending, isEmpty);
  });

  test(
    'test notification uses separate id without enabling periodic reminders',
    () async {
      await vm.configure(en);
      expect(await vm.test(durud), true);
      final shown =
          calls.singleWhere((call) => call.method == 'show').arguments as Map;
      expect(shown['id'], durud.testNotificationId);
      expect(
        jsonDecode(shown['payload'] as String)['feature'],
        'dhikrReminders',
      );
      expect(vm.reminder(durud).enabled, false);
      expect(pending, isEmpty);
    },
  );

  test(
    'legacy demo preferences migrate and active schedules use the new sounds',
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        DhikrRemindersStore.key,
        jsonEncode({
          'durud': {'enabled': true, 'intervalMinutes': 7, 'sound': 'chime'},
        }),
      );
      await vm.configure(en);
      expect(vm.reminder(durud).sound, DhikrReminderSound.rahman);
      expect(vm.reminder(durud).intervalMinutes, 7);
      final args =
          calls
                  .firstWhere(
                    (call) => call.method == 'periodicallyShowWithDuration',
                  )
                  .arguments
              as Map;
      expect(
        (args['platformSpecifics'] as Map)['sound'],
        'rahman_notification',
      );
    },
  );

  test(
    'custom reminders persist separate titles, intervals, sounds and unique IDs',
    () async {
      await vm.configure(en);
      expect(
        await vm.saveCustom(
          title: ' Read Quran ',
          subtitle: ' A few verses ',
          settings: const DhikrReminder(
            enabled: true,
            intervalMinutes: 15,
            sound: DhikrReminderSound.quran,
          ),
        ),
        true,
      );
      expect(
        await vm.saveCustom(
          title: 'Gratitude',
          subtitle: '',
          settings: const DhikrReminder(
            enabled: true,
            intervalMinutes: 120,
            sound: DhikrReminderSound.allahHu,
          ),
        ),
        true,
      );
      final first = vm.customReminders.first;
      final second = vm.customReminders.last;
      expect(first.id, isNot(second.id));
      expect(first.testNotificationId, isNot(second.id));
      expect(pending[first.id]!['title'], 'Read Quran');
      expect(pending[first.id]!['body'], 'A few verses');
      final schedules = calls.where(
        (call) => call.method == 'periodicallyShowWithDuration',
      );
      final native =
          (schedules.last.arguments as Map)['platformSpecifics'] as Map;
      expect(native['sound'], 'allah_hu_allah_hu_notification');
      expect(native['channelId'], 'dhikr_custom_allahHu_v2');
      final saved = await DhikrRemindersStore().loadCustom();
      expect(saved.items.map((item) => item.title), [
        'Read Quran',
        'Gratitude',
      ]);
      expect(saved.nextId, second.id + 2);
      expect(saved.items.last.settings.intervalMinutes, 120);
    },
  );

  test(
    'custom permission denial preserves the form state without creating a schedule',
    () async {
      await vm.configure(en);
      allowed = false;
      expect(
        await vm.saveCustom(
          title: 'My reminder',
          subtitle: '',
          settings: const DhikrReminder(enabled: true),
        ),
        false,
      );
      expect(vm.error, DhikrReminderError.permission);
      expect(vm.customReminders, isEmpty);
      expect(pending, isEmpty);
      expect((await DhikrRemindersStore().loadCustom()).items, isEmpty);
      expect(
        await vm.saveCustom(
          title: 'Saved off',
          subtitle: '',
          settings: const DhikrReminder(),
        ),
        true,
      );
      expect(vm.customReminders.single.settings.enabled, false);
    },
  );

  test(
    'editing, toggling and deleting only affect the selected custom reminder',
    () async {
      await vm.configure(en);
      await vm.update(durud, const DhikrReminder(enabled: true));
      await vm.saveCustom(
        title: 'First',
        subtitle: '',
        settings: const DhikrReminder(enabled: true),
      );
      await vm.saveCustom(
        title: 'Second',
        subtitle: '',
        settings: const DhikrReminder(enabled: true),
      );
      final first = vm.customReminders.first;
      final second = vm.customReminders.last;
      await vm.saveCustom(
        id: first.id,
        title: 'Edited',
        subtitle: 'New body',
        settings: first.settings.copyWith(
          intervalMinutes: 5,
          sound: DhikrReminderSound.ramadan,
        ),
      );
      expect(pending[first.id]!['title'], 'Edited');
      await vm.saveCustom(
        id: first.id,
        title: 'Edited',
        subtitle: 'New body',
        settings: first.settings.copyWith(enabled: false),
      );
      expect(pending.keys, unorderedEquals([durud.notificationId, second.id]));
      expect(await vm.deleteCustom(first.id), true);
      expect(vm.customReminders.single.id, second.id);
      await vm.saveCustom(
        title: 'Third',
        subtitle: '',
        settings: const DhikrReminder(),
      );
      expect(vm.customReminders.last.id, greaterThan(second.id));
    },
  );

  test(
    'custom schedules retain their countdown and text across reopening and language changes',
    () async {
      await vm.configure(en);
      await vm.saveCustom(
        title: 'My words',
        subtitle: 'Keep this text',
        settings: const DhikrReminder(enabled: true),
      );
      final id = vm.customReminders.single.id;
      final count = calls
          .where((call) => call.method == 'periodicallyShowWithDuration')
          .length;
      final reopened = DhikrRemindersViewModel(vm.service);
      addTearDown(reopened.dispose);
      await reopened.configure(AppLocalizationsBn());
      expect(
        calls.where((call) => call.method == 'periodicallyShowWithDuration'),
        hasLength(count),
      );
      expect(pending[id]!['body'], 'Keep this text');
      allowed = false;
      await reopened.configure(en, checkPermission: true);
      expect(pending, isEmpty);
      expect(reopened.customReminders.single.settings.enabled, true);
      allowed = true;
      await reopened.configure(en, checkPermission: true);
      expect(pending.keys, [id]);
    },
  );

  test(
    'custom create, edit and delete roll back native changes if persistence fails',
    () async {
      final store = _FailingCustomStore();
      final customVm = DhikrRemindersViewModel(vm.service, store: store);
      addTearDown(customVm.dispose);
      await customVm.configure(en);
      store.fail = true;
      expect(
        await customVm.saveCustom(
          title: 'Unsaved',
          subtitle: '',
          settings: const DhikrReminder(enabled: true),
        ),
        false,
      );
      expect(pending, isEmpty);
      expect(customVm.customReminders, isEmpty);
      store.fail = false;
      await customVm.saveCustom(
        title: 'Original',
        subtitle: '',
        settings: const DhikrReminder(enabled: true),
      );
      final item = customVm.customReminders.single;
      store.fail = true;
      expect(
        await customVm.saveCustom(
          id: item.id,
          title: 'Failed edit',
          subtitle: '',
          settings: item.settings,
        ),
        false,
      );
      expect(pending[item.id]!['title'], 'Original');
      expect(await customVm.deleteCustom(item.id), false);
      expect(customVm.customReminders.single.title, 'Original');
      expect(pending[item.id]!['title'], 'Original');
    },
  );

  test(
    'custom native failures are retryable and tests never enable the reminder',
    () async {
      await vm.configure(en);
      failSchedule = true;
      expect(
        await vm.saveCustom(
          title: 'Retry',
          subtitle: '',
          settings: const DhikrReminder(enabled: true),
        ),
        false,
      );
      expect(vm.error, DhikrReminderError.save);
      expect(vm.customReminders, isEmpty);
      failSchedule = false;
      await vm.saveCustom(
        title: 'Saved off',
        subtitle: 'Test body',
        settings: const DhikrReminder(),
      );
      final item = vm.customReminders.single;
      expect(await vm.testCustom(item.id), true);
      final shown =
          calls.lastWhere((call) => call.method == 'show').arguments as Map;
      expect(shown['id'], item.testNotificationId);
      expect(shown['title'], 'Saved off');
      expect(jsonDecode(shown['payload'] as String)['id'], item.id);
      expect(vm.customReminders.single.settings.enabled, false);
    },
  );

  test(
    'duplicate or invalid custom IDs and malformed preferences are rejected',
    () async {
      expect(
        () => CustomDhikrReminder(
          id: durud.notificationId,
          title: 'Invalid',
          settings: const DhikrReminder(),
        ),
        throwsFormatException,
      );
      final item = CustomDhikrReminder(
        id: CustomDhikrReminder.firstId,
        title: 'Valid',
        settings: const DhikrReminder(),
      );
      expect(
        () => CustomDhikrReminders(nextId: item.id + 2, items: [item, item]),
        throwsFormatException,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(DhikrRemindersStore.customKey, '{broken');
      await vm.configure(en);
      expect(vm.ready, false);
      expect(vm.error, DhikrReminderError.load);
      await prefs.remove(DhikrRemindersStore.customKey);
      await vm.configure(en);
      expect(vm.ready, true);
    },
  );

  test(
    'iOS capacity cannot evict other schedules, but existing reminders can be updated',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      FlutterLocalNotificationsPlatform.instance =
          IOSFlutterLocalNotificationsPlugin();
      for (var index = 0; index < 64; index++) {
        pending[700000000 + index] = {
          'id': 700000000 + index,
          'title': 'Other',
          'body': '',
          'payload': '',
        };
      }
      final item = CustomDhikrReminder(
        id: CustomDhikrReminder.firstId,
        title: 'Custom',
        settings: const DhikrReminder(
          enabled: true,
          sound: DhikrReminderSound.quran,
        ),
      );
      await expectLater(
        vm.service.scheduleCustom(item, en),
        throwsA(isA<DhikrReminderCapacityException>()),
      );
      expect(pending, hasLength(64));
      pending.remove(700000000);
      pending[item.id] = {
        'id': item.id,
        'title': 'Before',
        'body': '',
        'payload': '',
      };
      await vm.service.scheduleCustom(item, en);
      expect(pending[item.id]!['title'], 'Custom');
      final args =
          calls
                  .lastWhere(
                    (call) => call.method == 'periodicallyShowWithDuration',
                  )
                  .arguments
              as Map;
      expect(
        (args['platformSpecifics'] as Map)['sound'],
        'quran_notification.wav',
      );
    },
  );

  testWidgets(
    'dashboard replacement opens settings; both cards fit large text in both languages',
    (tester) async {
      final settings = _Settings();
      addTearDown(settings.dispose);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(320, 700));
      for (final locale in ['en', 'bn']) {
        for (final brightness in Brightness.values) {
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<DhikrRemindersViewModel>.value(
                  value: vm,
                ),
                ChangeNotifierProvider<SettingsViewModel>.value(
                  value: settings,
                ),
              ],
              child: MaterialApp(
                key: ValueKey('$locale/$brightness'),
                locale: Locale(locale),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(brightness: brightness),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.8)),
                  child: child!,
                ),
                home: Builder(
                  builder: (context) {
                    final item = dashboardActions(context)[3];
                    return Scaffold(
                      body: TextButton(
                        onPressed: item.onTap,
                        child: Text(item.label),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextButton));
          await tester.pumpAndSettle();
          expect(find.byType(DhikrRemindersView), findsOneWidget);
          await tester.scrollUntilVisible(
            find.byKey(const ValueKey(istighfar)),
            400,
          );
          expect(find.byType(DhikrReminderCard), findsWidgets);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
      debugDefaultTargetPlatformOverride = null;
    },
  );
}

class _Settings extends ChangeNotifier implements SettingsViewModel {
  @override
  AppSettings get settings => AppSettings.defaults();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingCustomStore extends DhikrRemindersStore {
  bool fail = false;
  @override
  Future<void> saveCustom(CustomDhikrReminders reminders) async {
    if (fail) throw StateError('Simulated persistence failure');
    await super.saveCustom(reminders);
  }
}
