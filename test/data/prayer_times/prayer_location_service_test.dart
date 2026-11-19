import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:quran_for_all/services/prayer_location_service.dart';
import 'offline_prayer_calculator_test.dart' show profile;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const geo = MethodChannel('flutter.baseflow.com/geolocator');
  const timezone = MethodChannel('flutter_timezone');
  var enabled = true;
  var permission = 2;
  var failure = false;
  var zone = 'Asia/Dhaka';
  final calls = <MethodCall>[];
  setUp(() {
    enabled = true;
    permission = 2;
    failure = false;
    zone = 'Asia/Dhaka';
    calls.clear();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(timezone, (_) async => zone);
    messenger.setMockMethodCallHandler(geo, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'isLocationServiceEnabled':
          return enabled;
        case 'checkPermission':
          return permission;
        case 'requestPermission':
          return permission;
        case 'getLastKnownPosition':
          return null;
        case 'getCurrentPosition':
          if (failure) throw PlatformException(code: 'LOCATION_UPDATE_FAILURE');
          return <String, Object>{
            'latitude': 23.81,
            'longitude': 90.41,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'accuracy': 30.0,
            'altitude': 0.0,
            'heading': 0.0,
            'speed': 0.0,
            'speed_accuracy': 0.0,
          };
      }
      return null;
    });
  });
  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(geo, null);
    messenger.setMockMethodCallHandler(timezone, null);
  });
  final service = PrayerLocationService();
  test('fresh install requests a location fix with a time limit', () async {
    final result = await service.resolve(
      config: PrayerCalculationConfig.defaults(),
      savedProfile: null,
      refresh: false,
      requestPermission: true,
    );
    expect(result.profile.latitude, 23.81);
    expect(result.profile.timeZoneId, 'Asia/Dhaka');
    expect(result.isFallback, isFalse);
    expect(calls.map((c) => c.method), contains('getCurrentPosition'));
  });
  test(
    'returning launch reuses saved coordinates without a GPS or permission wait',
    () async {
      enabled = false;
      permission = 0;
      final result = await service.resolve(
        config: PrayerCalculationConfig.defaults(),
        savedProfile: profile(),
        refresh: false,
        requestPermission: true,
      );
      expect(result.isFallback, isTrue);
      expect(calls, isEmpty);
    },
  );
  test(
    'location disabled on first use reports a clear location error',
    () async {
      enabled = false;
      await expectLater(
        service.resolve(
          config: PrayerCalculationConfig.defaults(),
          savedProfile: null,
          refresh: false,
          requestPermission: true,
        ),
        throwsA(
          isA<PrayerTimesException>().having(
            (e) => e.type,
            'type',
            PrayerRepositoryErrorType.locationDisabled,
          ),
        ),
      );
    },
  );
  test('permission denied on first use never invents a default city', () async {
    permission = 0;
    await expectLater(
      service.resolve(
        config: PrayerCalculationConfig.defaults(),
        savedProfile: null,
        refresh: false,
        requestPermission: true,
      ),
      throwsA(
        isA<PrayerTimesException>().having(
          (e) => e.type,
          'type',
          PrayerRepositoryErrorType.permissionDenied,
        ),
      ),
    );
  });
  test(
    'failed fresh fix retains saved coordinates and current timezone',
    () async {
      failure = true;
      zone = 'Asia/Kuala_Lumpur';
      final result = await service.resolve(
        config: PrayerCalculationConfig.defaults(),
        savedProfile: profile(),
        refresh: true,
        requestPermission: false,
      );
      expect(result.profile.timeZoneId, zone);
      expect(result.isFallback, isTrue);
      expect(result.profile.latitude, 23.81);
    },
  );
  test('background resume never prompts for denied permission', () async {
    permission = 0;
    await service.resolve(
      config: PrayerCalculationConfig.defaults(),
      savedProfile: profile(),
      refresh: true,
      requestPermission: false,
    );
    expect(calls.map((c) => c.method), isNot(contains('requestPermission')));
  });
}
