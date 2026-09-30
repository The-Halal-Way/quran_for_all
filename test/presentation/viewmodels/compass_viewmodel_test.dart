import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/compass/compass_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_content.dart';
import 'package:quran_for_all/services/compass_declination_service.dart';
import 'package:quran_for_all/services/permission_helper.dart';
import 'package:quran_for_all/services/qibla_api_service.dart';
import 'package:quran_for_all/services/qibla_bearing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('great-circle Qibla bearings use the current coordinates', () {
    expect(
      QiblaBearing.fromCoordinates(23.8103, 90.4125),
      closeTo(277.57, 0.1),
    );
    expect(
      QiblaBearing.fromCoordinates(51.5074, -0.1278),
      closeTo(118.99, 0.1),
    );
    expect(
      QiblaBearing.fromCoordinates(40.7128, -74.0060),
      closeTo(58.48, 0.1),
    );
  });

  test('no sensor leaves a usable local bearing without internet', () async {
    final sensor = _FakePermissionHelper(available: false);
    final model = _model(sensor);

    await model.initialize();

    expect(model.isInitializing, isFalse);
    expect(model.isListening, isFalse);
    expect(model.initErrorType, CompassInitErrorType.none);
    expect(model.qiblaDegrees, closeTo(277.57, 0.1));
    expect(model.isApiBearing, isFalse);
    model.dispose();
  });

  test('online bearing can update the stationary guide', () async {
    final model = _model(
      _FakePermissionHelper(available: false),
      qiblaApiService: const _OnlineQiblaApiService(),
    );

    await model.initialize();

    expect(model.isListening, isFalse);
    expect(model.qiblaDegrees, 300);
    expect(model.isApiBearing, isTrue);
    model.dispose();
  });

  test(
    'native heading uses sensor degrees plus magnetic declination',
    () async {
      final sensor = _FakePermissionHelper(available: true, initialHeading: 90);
      final model = _model(sensor);

      await model.initialize();

      expect(model.isListening, isTrue);
      expect(model.smoothHeading, 95);
      expect(model.qiblaOffset, closeTo(182.57, 0.1));
      sensor.onUnavailable?.call();
      expect(model.isListening, isFalse);
      model.dispose();
    },
  );

  test('a phone pointing toward Qibla reports alignment', () async {
    final sensor = _FakePermissionHelper(
      available: true,
      initialHeading: 272.57,
    );
    final model = _model(sensor);

    await model.initialize();

    expect(model.facingMecca, isTrue);
    model.dispose();
  });

  testWidgets('fallback guide fits a compact Bangla screen', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final model = _model(_FakePermissionHelper(available: false));
    await model.initialize();
    addTearDown(model.dispose);

    await tester.pumpWidget(_app(model, const Locale('bn')));
    await tester.pumpAndSettle();

    expect(find.byType(CompassContent), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('উত্তরমুখী নির্দেশিকা ব্যবহার করুন'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('live guide fits a compact English screen', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final model = _model(
      _FakePermissionHelper(available: true, initialHeading: 90),
    );
    await model.initialize();
    addTearDown(model.dispose);

    await tester.pumpWidget(_app(model, const Locale('en')));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Turn left 177°'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(CompassViewModel model, Locale locale) =>
    ChangeNotifierProvider<CompassViewModel>.value(
      value: model,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CompassContent(),
      ),
    );

CompassViewModel _model(
  _FakePermissionHelper sensor, {
  QiblaApiService qiblaApiService = const _OfflineQiblaApiService(),
}) => CompassViewModel(
  permissionHelper: sensor,
  qiblaApiService: qiblaApiService,
  declinationService: const _FakeDeclinationService(),
  positionProvider: () async => Position(
    longitude: 90.4125,
    latitude: 23.8103,
    timestamp: DateTime(2026),
    accuracy: 10,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  ),
);

class _FakePermissionHelper extends PermissionHelper {
  _FakePermissionHelper({required this.available, this.initialHeading = 0});

  final bool available;
  final double initialHeading;
  VoidCallback? onUnavailable;

  @override
  Future<CompassListeningSession?> startCompassWithPermission({
    required Function(double heading) onHeadingChanged,
    VoidCallback? onUnavailable,
  }) async {
    this.onUnavailable = onUnavailable;
    if (!available) return null;
    onHeadingChanged(initialHeading);
    return CompassListeningSession(() async {});
  }
}

class _FakeDeclinationService extends CompassDeclinationService {
  const _FakeDeclinationService();

  @override
  Future<double> at({
    required double latitude,
    required double longitude,
    required double altitude,
  }) async => 5;
}

class _OfflineQiblaApiService extends QiblaApiService {
  const _OfflineQiblaApiService();

  @override
  Future<double?> fetchQiblaDirection({
    required double latitude,
    required double longitude,
  }) async => null;
}

class _OnlineQiblaApiService extends QiblaApiService {
  const _OnlineQiblaApiService();

  @override
  Future<double?> fetchQiblaDirection({
    required double latitude,
    required double longitude,
  }) async => 300;
}
