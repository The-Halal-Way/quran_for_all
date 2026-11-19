import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import 'package:quran_for_all/data/models/dhikr_reminders/dhikr_reminder.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/l10n/app_localizations_en.dart';
import 'package:quran_for_all/presentation/viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/dhikr_reminders/custom_dhikr_reminder_editor_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/dhikr_reminders/dhikr_reminders_view.dart';
import 'package:quran_for_all/presentation/widgets/dhikr_reminders/custom_dhikr_reminder_card.dart';
import 'package:quran_for_all/presentation/widgets/dhikr_reminders/custom_reminder_fields.dart';
import 'package:quran_for_all/presentation/widgets/dhikr_reminders/dhikr_notification_preview.dart';
import 'package:quran_for_all/presentation/widgets/dhikr_reminders/dhikr_sound_sheet.dart';
import 'package:quran_for_all/services/dhikr_reminders/dhikr_reminder_service.dart';
import 'package:quran_for_all/services/dhikr_reminders/dhikr_sound_preview.dart';
import 'package:quran_for_all/services/notifications/app_notification_coordinator.dart';

void main() {
  late _Coordinator coordinator;
  late DhikrRemindersViewModel vm;
  late _Settings settings;
  final en = AppLocalizationsEn();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    coordinator = _Coordinator();
    vm = DhikrRemindersViewModel(_Service(coordinator));
    settings = _Settings();
  });
  tearDown(() {
    vm.dispose();
    settings.dispose();
  });

  Widget app(
    Widget home, {
    String locale = 'en',
    Brightness brightness = Brightness.light,
    double scale = 1,
    double keyboard = 0,
  }) => MultiProvider(
    providers: [
      ChangeNotifierProvider<DhikrRemindersViewModel>.value(value: vm),
      ChangeNotifierProvider<SettingsViewModel>.value(value: settings),
    ],
    child: MaterialApp(
      key: ValueKey('$locale/$brightness/$scale/$keyboard'),
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: brightness == Brightness.light
          ? AppTheme.lightTheme
          : AppTheme.darkTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
          viewInsets: EdgeInsets.only(bottom: keyboard),
        ),
        child: child!,
      ),
      home: home,
    ),
  );

  Future<void> openEditor(WidgetTester tester) async {
    await tester.pumpWidget(app(const DhikrRemindersView()));
    await tester.pumpAndSettle();
    final add = find.text(en.dhikrAddCustom);
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(find.byType(CustomDhikrReminderEditorView), findsOneWidget);
  }

  testWidgets(
    'live preview, sound/interval selection, save, edit and confirmed delete',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await openEditor(tester);
      final title = find.byKey(const ValueKey('custom-reminder-title'));
      final subtitle = find.byKey(const ValueKey('custom-reminder-subtitle'));
      await tester.enterText(title, 'Read Quran');
      await tester.ensureVisible(subtitle);
      await tester.enterText(subtitle, 'Read a few verses today.');
      await tester.pump();
      var preview = tester.widget<DhikrNotificationPreview>(
        find.byType(DhikrNotificationPreview),
      );
      expect(preview.title, 'Read Quran');
      expect(preview.subtitle, 'Read a few verses today.');

      final soundTile = find.widgetWithText(ListTile, en.dhikrSoundTitle);
      await tester.ensureVisible(soundTile);
      await tester.tap(soundTile);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(en.dhikrSoundName('weddingNasheed')),
        300,
        scrollable: find.descendant(
          of: find.byType(DhikrSoundPicker),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(find.text(en.dhikrSoundName('weddingNasheed')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.dhikrApply));
      await tester.pumpAndSettle();
      preview = tester.widget<DhikrNotificationPreview>(
        find.byType(DhikrNotificationPreview),
      );
      expect(preview.sound, DhikrReminderSound.weddingNasheed);
      final intervalTile = find.widgetWithText(ListTile, en.dhikrIntervalTitle);
      await tester.ensureVisible(intervalTile);
      await tester.tap(intervalTile);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, en.dhikrMinutes('5')));
      await tester.tap(find.text(en.dhikrApply));
      await tester.pumpAndSettle();
      final toggle = find.byType(SwitchListTile);
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.dhikrSaveReminder));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDhikrReminderEditorView), findsNothing);
      final saved = vm.customReminders.single;
      expect(saved.title, 'Read Quran');
      expect(saved.subtitle, 'Read a few verses today.');
      expect(saved.settings.enabled, false);
      expect(saved.settings.intervalMinutes, 5);
      expect(saved.settings.sound, DhikrReminderSound.weddingNasheed);

      final menu = find.descendant(
        of: find.byType(CustomDhikrReminderCard),
        matching: find.byType(PopupMenuButton<String>),
      );
      await tester.ensureVisible(menu);
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.dhikrEditAction));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextFormField>(title).controller!.text,
        'Read Quran',
      );
      await tester.enterText(title, 'Read Surah Al-Kahf');
      await tester.tap(find.text(en.dhikrSaveReminder));
      await tester.pumpAndSettle();
      expect(vm.customReminders.single.id, saved.id);
      expect(vm.customReminders.single.title, 'Read Surah Al-Kahf');
      await tester.ensureVisible(menu);
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.dhikrDeleteAction));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, en.dhikrCancel));
      await tester.pumpAndSettle();
      expect(vm.customReminders, hasLength(1));
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.dhikrDeleteAction));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, en.dhikrDeleteAction));
      await tester.pumpAndSettle();
      expect(vm.customReminders, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'empty title and permission denial retain the editor and entered preview',
    (tester) async {
      await openEditor(tester);
      await tester.tap(find.text(en.dhikrSaveReminder));
      await tester.pumpAndSettle();
      expect(find.text(en.dhikrCustomTitleRequired), findsOneWidget);
      coordinator.allowed = false;
      await tester.enterText(
        find.byKey(const ValueKey('custom-reminder-title')),
        'Keep my words',
      );
      await tester.tap(find.text(en.dhikrSaveReminder));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDhikrReminderEditorView), findsOneWidget);
      expect(
        tester
            .widget<DhikrNotificationPreview>(
              find.byType(DhikrNotificationPreview),
            )
            .title,
        'Keep my words',
      );
      expect(vm.error, DhikrReminderError.permission);
      expect(vm.customReminders, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'editor fits narrow screens, both languages/themes, large text and keyboard',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final reminder = CustomDhikrReminder(
        id: CustomDhikrReminder.firstId,
        title: 'A reminder for today · আজকের স্মরণিকা',
        subtitle: 'Read a few verses and remember Allah. আল্লাহকে স্মরণ করুন।',
        settings: const DhikrReminder(),
      );
      for (final width in [320.0, 390.0]) {
        await tester.binding.setSurfaceSize(Size(width, 700));
        for (final locale in ['en', 'bn']) {
          for (final brightness in Brightness.values) {
            for (final keyboard in [0.0, 280.0]) {
              await tester.pumpWidget(
                app(
                  CustomDhikrReminderEditorView(reminder: reminder),
                  locale: locale,
                  brightness: brightness,
                  scale: 1.8,
                  keyboard: keyboard,
                ),
              );
              await tester.pumpAndSettle();
              final fields = find.byType(CustomReminderFields);
              await tester.scrollUntilVisible(
                fields,
                200,
                scrollable: find
                    .descendant(
                      of: find.byType(ListView),
                      matching: find.byType(Scrollable),
                    )
                    .first,
              );
              await tester.pumpAndSettle();
              expect(
                tester.takeException(),
                isNull,
                reason: '$width $locale $brightness $keyboard',
              );
            }
          }
        }
      }
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'sound picker supports play/stop and closes without continued audio',
    (tester) async {
      final preview = _Preview();
      addTearDown(preview.dispose);
      DhikrReminderSound? chosen;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  chosen = await showDhikrSoundSheet(
                    context,
                    DhikrReminderSound.arRahman,
                    preview: preview,
                  );
                },
                child: const Text('Open sounds'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open sounds'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(en.dhikrPreview).first);
      await tester.pumpAndSettle();
      expect(preview.activeSound, DhikrReminderSound.arRahman);
      expect(find.byTooltip(en.dhikrStopPreview), findsOneWidget);
      await tester.tap(find.byTooltip(en.dhikrStopPreview));
      await tester.pumpAndSettle();
      expect(preview.activeSound, isNull);
      await tester.tap(find.byTooltip(en.dhikrPreview).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.dhikrApply));
      await tester.pumpAndSettle();
      expect(chosen, DhikrReminderSound.arRahman);
      expect(preview.activeSound, isNull);
      expect(preview.stops, greaterThan(0));
      expect(tester.takeException(), isNull);
    },
  );
}

class _Coordinator extends AppNotificationCoordinator {
  _Coordinator() : super(plugin: _Plugin());
  bool allowed = true;
  @override
  Future<void> initialize() async {}
  @override
  Future<AppNotificationPermission> permissionStatus() async => allowed
      ? AppNotificationPermission.granted
      : AppNotificationPermission.denied;
  @override
  Future<AppNotificationPermission> requestPermission() => permissionStatus();
}

class _Plugin implements FlutterLocalNotificationsPlugin {
  @override
  Future<List<PendingNotificationRequest>>
  pendingNotificationRequests() async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Service extends DhikrReminderService {
  _Service(super.coordinator);
  @override
  bool get supported => true;
  @override
  Future<void> scheduleCustom(
    CustomDhikrReminder reminder,
    AppLocalizations strings,
  ) async {}
  @override
  Future<void> cancelCustom(CustomDhikrReminder reminder) async {}
}

class _Settings extends ChangeNotifier implements SettingsViewModel {
  @override
  AppSettings get settings => AppSettings.defaults();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Preview extends DhikrSoundPreview {
  int stops = 0;
  @override
  Future<void> toggle(DhikrReminderSound sound) async {
    activeSound = activeSound == sound ? null : sound;
    notifyListeners();
  }

  @override
  Future<void> stop({bool notify = true}) async {
    stops++;
    activeSound = null;
    if (notify) notifyListeners();
  }
}
