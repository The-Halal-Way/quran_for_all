import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_local_data_source.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_preferences_store.dart';
import 'package:quran_for_all/data/datasources/remote/prayer_times_api_service.dart';
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
      final updated = original.copyWith(
        method: PrayerCalculationMethod.karachi,
        madhab: PrayerMadhab.hanafi,
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
      expect(saved.madhab, PrayerMadhab.hanafi);
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

  test(
    'daily and monthly requests send chosen method, school and tuning',
    () async {
      final requested = <Uri>[];
      final client = MockClient((request) async {
        requested.add(request.url);
        return http.Response('{"status":"ERROR"}', 400);
      });
      final service = PrayerTimesApiService(client);
      final now = DateTime.utc(2026, 1, 1);
      final config = PrayerCalculationConfig.defaults().copyWith(
        method: PrayerCalculationMethod.malaysia,
        madhab: PrayerMadhab.hanafi,
        adjustments: const PrayerAdjustments(fajr: 4, asr: -3),
      );
      final profile = PrayerProfile(
        signature: 'test',
        locationIdentity: 'gps:3.14,101.69',
        latitude: 3.14,
        longitude: 101.69,
        latitudeBucket: 3.14,
        longitudeBucket: 101.69,
        timeZoneId: 'Asia/Kuala_Lumpur',
        calculation: config,
        displayLocationLabel: 'Kuala Lumpur',
        createdAtUtc: now,
        lastUsedAtUtc: now,
      );

      await expectLater(
        service.fetchDay(profile: profile, localDateKey: '2026-01-01'),
        throwsA(isA<PrayerTimesException>()),
      );
      await expectLater(
        service.fetchMonth(profile: profile, year: 2026, month: 1),
        throwsA(isA<PrayerTimesException>()),
      );

      expect(requested, hasLength(2));
      for (final url in requested) {
        expect(url.queryParameters['method'], '17');
        expect(url.queryParameters['school'], '1');
        expect(url.queryParameters['tune'], '0,4,0,0,-3,0,0,0,0');
      }
      client.close();
    },
  );

  test(
    'cached schedule is hidden when its calculation no longer matches',
    () async {
      final now = DateTime.utc(2026, 1, 1);
      final oldConfig = PrayerCalculationConfig.defaults();
      final selectedConfig = oldConfig.copyWith(madhab: PrayerMadhab.hanafi);
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
      final client = MockClient((_) async => http.Response('{}', 500));
      final repository = PrayerTimesRepositoryImpl(
        localDataSource: _StoredProfileSource(profile),
        preferencesStore: _SelectedConfigStore(selectedConfig),
        apiService: PrayerTimesApiService(client),
      );

      expect(await repository.loadCachedDashboardData(), isNull);
      client.close();
    },
  );
}
