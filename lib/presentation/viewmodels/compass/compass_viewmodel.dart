import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_for_all/services/permission_helper.dart';
import 'package:quran_for_all/services/qibla_api_service.dart';

const double kFallbackQiblaDegrees = 293.0;
const double kHeadingCorrectionDegrees = 270.0;
const double kQiblaSnapZone = 5.0;

enum CompassInitErrorType {
  none,
  locationDenied,
  locationBlocked,
  locationDisabled,
  generic,
}

class CompassInitializationException implements Exception {
  const CompassInitializationException(this.type, this.message);

  final CompassInitErrorType type;
  final String message;

  @override
  String toString() => message;
}

class CompassViewModel extends ChangeNotifier {
  CompassViewModel({
    PermissionHelper? permissionHelper,
    QiblaApiService? qiblaApiService,
  }) : _permissionHelper = permissionHelper ?? const PermissionHelper(),
       _qiblaApiService = qiblaApiService ?? const QiblaApiService();

  final PermissionHelper _permissionHelper;
  final QiblaApiService _qiblaApiService;

  double _rawHeading = 0.0;
  double _smoothHeading = 0.0;
  String _directionLabel = 'North';
  bool _isListening = false;
  bool _isApiFallback = false;
  bool _isInitializing = true;
  double _qiblaDegrees = kFallbackQiblaDegrees;
  String _initError = '';
  CompassInitErrorType _initErrorType = CompassInitErrorType.none;
  CompassListeningSession? _compassSession;
  bool _isDisposed = false;

  double get rawHeading => _rawHeading;
  double get smoothHeading => _smoothHeading;
  String get directionLabel => _directionLabel;
  bool get isListening => _isListening;
  bool get isApiFallback => _isApiFallback;
  bool get isInitializing => _isInitializing;
  double get qiblaDegrees => _qiblaDegrees;
  String get initError => _initError;
  CompassInitErrorType get initErrorType => _initErrorType;

  double get qiblaOffset => (_qiblaDegrees - _smoothHeading + 360) % 360;

  bool get facingMecca =>
      _isListening &&
      (qiblaOffset < kQiblaSnapZone || qiblaOffset > 360 - kQiblaSnapZone);

  bool get showLoadingState =>
      _isInitializing || (!_isListening && !_isApiFallback);

  Future<void> initialize() async {
    await _stopCompass();
    if (_isDisposed) {
      return;
    }

    _isInitializing = true;
    _initError = '';
    _initErrorType = CompassInitErrorType.none;
    _notifyListenersIfActive();

    try {
      final position = await _getCurrentPosition();
      if (_isDisposed) {
        return;
      }

      final qiblaDirection = await _qiblaApiService.fetchQiblaDirection(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (_isDisposed) {
        return;
      }

      final hasNativeCompass = await _permissionHelper
          .hasNativeCompassFeature();
      if (_isDisposed) {
        return;
      }

      CompassListeningSession? session;

      if (hasNativeCompass) {
        session = await _permissionHelper.startCompassWithPermission(
          onHeadingChanged: (heading) {
            if (_isDisposed) {
              return;
            }

            _rawHeading = (heading + 360) % 360;
          },
          onDirectionChanged: (direction) {
            if (_isDisposed) {
              return;
            }

            _directionLabel = direction;
            _notifyListenersIfActive();
          },
          headingCorrectionDegrees: kHeadingCorrectionDegrees,
        );
      }

      if (_isDisposed) {
        unawaited(session?.cancel());
        return;
      }

      _compassSession = session;
      final started = session != null;

      _qiblaDegrees = qiblaDirection ?? kFallbackQiblaDegrees;
      _isListening = started;
      _isApiFallback = !started;
      _isInitializing = false;
      _directionLabel = started ? _directionLabel : 'No compass sensor';
      _rawHeading = started ? _rawHeading : 0;
      _smoothHeading = started ? _smoothHeading : 0;
      _initError = '';
      _initErrorType = CompassInitErrorType.none;
      _notifyListenersIfActive();
    } catch (e) {
      if (_isDisposed) {
        return;
      }

      _isListening = false;
      _isApiFallback = false;
      _isInitializing = false;
      if (e is CompassInitializationException) {
        _initError = e.message;
        _initErrorType = e.type;
      } else {
        _initError = 'Failed to initialize compass/Qibla: $e';
        _initErrorType = CompassInitErrorType.generic;
      }
      _notifyListenersIfActive();
    }
  }

  void updateSmoothHeading() {
    if (_isDisposed) {
      return;
    }

    final previous = _smoothHeading;
    var diff = _rawHeading - _smoothHeading;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    final next = _smoothHeading + diff * 0.10;
    _smoothHeading = (next + 360) % 360;

    if ((previous - _smoothHeading).abs() >= 0.05) {
      _notifyListenersIfActive();
    }
  }

  Future<void> retry() async {
    await initialize();
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_stopCompass());
    super.dispose();
  }

  Future<void> _stopCompass() {
    final session = _compassSession;
    _compassSession = null;
    return session?.cancel() ?? Future<void>.value();
  }

  void _notifyListenersIfActive() {
    if (_isDisposed) {
      return;
    }

    notifyListeners();
  }

  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const CompassInitializationException(
        CompassInitErrorType.locationDisabled,
        'Location services are disabled',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const CompassInitializationException(
          CompassInitErrorType.locationDenied,
          'Location permission denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const CompassInitializationException(
        CompassInitErrorType.locationBlocked,
        'Location permission permanently denied',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
