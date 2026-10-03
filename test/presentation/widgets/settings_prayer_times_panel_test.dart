import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_preferences_store.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/settings/settings_view/settings_prayer_times_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PrayerModel extends ChangeNotifier
    implements DashboardPrayerTimesViewModel {
  int reloads = 0;

  @override
  Future<void> reloadForCalculationChange() async {
    reloads++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('home_widget');
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => true);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('method, school and local offset save and refresh', (
    tester,
  ) async {
    final store = PrayerTimesPreferencesStore();
    final model = _PrayerModel();
    addTearDown(model.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<PrayerTimesPreferencesStore>.value(value: store),
          ChangeNotifierProvider<DashboardPrayerTimesViewModel>.value(
            value: model,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(child: SettingsPrayerTimesPanel()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('prayer-method')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('University of Islamic Sciences, Karachi').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('prayer-school')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hanafi').last);
    await tester.pumpAndSettle();

    final fajr = find.byKey(const ValueKey('prayer-adjustment-fajr'));
    await tester.ensureVisible(fajr);
    await tester.enterText(fajr, '61');
    final save = find.text('Save prayer settings');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(model.reloads, 0);
    expect(find.text('Enter a number from -60 to +60'), findsOneWidget);

    await tester.ensureVisible(fajr);
    await tester.enterText(fajr, '7');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    final config = await store.getCalculationConfig();
    expect(config.method, PrayerCalculationMethod.karachi);
    expect(config.madhab, PrayerMadhab.hanafi);
    expect(config.adjustments.fajr, 7);
    expect(model.reloads, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('panel remains usable at large text size in Bangla', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = PrayerTimesPreferencesStore();
    final model = _PrayerModel();
    addTearDown(model.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<PrayerTimesPreferencesStore>.value(value: store),
          ChangeNotifierProvider<DashboardPrayerTimesViewModel>.value(
            value: model,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('bn'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(child: SettingsPrayerTimesPanel()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('নামাজের সময় গণনা'), findsOneWidget);
    final save = find.text('নামাজের সেটিংস সংরক্ষণ করুন');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
