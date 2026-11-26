import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_local_data_source.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_preferences_store.dart';
import 'package:quran_for_all/data/datasources/local/offline_prayer_calculator.dart';
import 'package:quran_for_all/core/prayer_times/offline_prayer_parameters.dart';
import 'package:quran_for_all/data/repositories/prayer_times_repository_impl.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StoredProfileSource extends PrayerTimesLocalDataSource {
  _StoredProfileSource(this.profile);

  final PrayerProfile profile;

  @override
  Future<PrayerProfile?> getProfile(String signature) async => profile;
}

class _SelectedConfigStore extends PrayerTimesPreferencesStore {
  _SelectedConfigStore(this.config);

  final PrayerCalculationConfig config;

  @override
  Future<String?> getActiveProfileSignature() async => 'old-profile';

  @override
  Future<PrayerCalculationConfig> getCalculationConfig() async => config;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('home_widget');
  final widgetCalls = <MethodCall>[];
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    widgetCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          widgetCalls.add(call);
          return true;
        });
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'calculation choices and all nine offsets persist with their order',
    () async {
      final store = PrayerTimesPreferencesStore();
      final original = await store.getCalculationConfig();
      expect(original.madhab, PrayerMadhab.hanafi);
      final updated = original.copyWith(
        method: PrayerCalculationMethod.karachi,
        madhab: PrayerMadhab.shafi,
        adjustments: const PrayerAdjustments(
          imsak: -1,
          fajr: 2,
          sunrise: 3,
          dhuhr: -4,
          asr: 5,
          maghrib: -6,
          sunset: 7,
          isha: 8,
          midnight: -9,
        ),
      );

      await store.saveCalculationConfig(updated);
      final saved = await store.getCalculationConfig();

      expect(saved.method, PrayerCalculationMethod.karachi);
      expect(saved.madhab, PrayerMadhab.shafi);
      expect(saved.adjustments.apiTuneString, '-1,2,3,-4,5,-6,7,8,-9');
      expect(saved.signatureSeed(), updated.signatureSeed());
      expect(saved.signatureSeed(), isNot(original.signatureSeed()));
      expect(
        widgetCalls
            .where((call) => call.method == 'saveWidgetData')
            .single
            .arguments['data'],
        '',
      );
    },
  );

  test('offline parameters preserve the selected school and tuning', () {
    final config = PrayerCalculationConfig.defaults().copyWith(
      method: PrayerCalculationMethod.malaysia,
      madhab: PrayerMadhab.hanafi,
      adjustments: const PrayerAdjustments(fajr: 4, asr: -3),
    );
    final parameters = OfflinePrayerParameters.forDate(
      config,
      DateTime(2026, 1, 1),
    );
    expect(parameters.fajrAngle, 20);
    expect(parameters.ishaAngle, 18);
    expect(parameters.madhab!.name, 'hanafi');
    expect(parameters.adjustments.values, containsAll([4, -3]));
  });

  test(
    'cached schedule is hidden when its calculation no longer matches',
    () async {
      final now = DateTime.utc(2026, 1, 1);
      final oldConfig = PrayerCalculationConfig.defaults();
      final selectedConfig = oldConfig.copyWith(madhab: PrayerMadhab.shafi);
      final profile = PrayerProfile(
        signature: 'old-profile',
        locationIdentity: 'gps:23.81,90.41',
        latitude: 23.81,
        longitude: 90.41,
        latitudeBucket: 23.81,
        longitudeBucket: 90.41,
        timeZoneId: 'Asia/Dhaka',
        calculation: oldConfig,
        displayLocationLabel: 'Dhaka',
        createdAtUtc: now,
        lastUsedAtUtc: now,
      );
      final repository = PrayerTimesRepositoryImpl(
        localDataSource: _StoredProfileSource(profile),
        preferencesStore: _SelectedConfigStore(selectedConfig),
        calculator: const OfflinePrayerCalculator(),
      );

      expect(await repository.loadCachedDashboardData(), isNull);
    },
  );
}
