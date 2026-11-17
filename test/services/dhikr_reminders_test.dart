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
          sound: DhikrReminderSound.chime,
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
      expect(native['sound'], 'reminder_chime');
      expect(native['channelId'], 'dhikr_istighfar_chime_v1');
      expect(native['scheduleMode'], 'inexactAllowWhileIdle');
      final saved = await DhikrRemindersStore().load();
      expect(saved[durud]!.intervalMinutes, 5);
      expect(saved[istighfar]!.sound, DhikrReminderSound.chime);
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
