import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_for_all/services/compass_declination_service.dart';
import 'package:quran_for_all/services/permission_helper.dart';
import 'package:quran_for_all/services/qibla_api_service.dart';
import 'package:quran_for_all/services/qibla_bearing.dart';

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
    CompassDeclinationService? declinationService,
    Future<Position> Function()? positionProvider,
  }) : _permissionHelper = permissionHelper ?? const PermissionHelper(),
       _qiblaApiService = qiblaApiService ?? const QiblaApiService(),
       _declinationService =
           declinationService ?? const CompassDeclinationService(),
       _positionProvider = positionProvider;

  final PermissionHelper _permissionHelper;
  final QiblaApiService _qiblaApiService;
  final CompassDeclinationService _declinationService;
  final Future<Position> Function()? _positionProvider;

  double _rawHeading = 0.0;
  double _smoothHeading = 0.0;
  bool _isListening = false;
  bool _isInitializing = true;
  double _qiblaDegrees = 0;
  bool _isApiBearing = false;
  CompassInitErrorType _initErrorType = CompassInitErrorType.none;
  CompassListeningSession? _compassSession;
  bool _isDisposed = false;
  int _requestId = 0;
  bool _hasHeading = false;

  double get smoothHeading => _smoothHeading;
  bool get isListening => _isListening;
  bool get isInitializing => _isInitializing;
  double get qiblaDegrees => _qiblaDegrees;
  bool get isApiBearing => _isApiBearing;
  CompassInitErrorType get initErrorType => _initErrorType;

  double get qiblaOffset => (_qiblaDegrees - _smoothHeading + 360) % 360;

  bool get facingMecca =>
      _isListening &&
      (qiblaOffset < kQiblaSnapZone || qiblaOffset > 360 - kQiblaSnapZone);

  Future<void> initialize() async {
    final requestId = ++_requestId;
    await _stopCompass();
    if (_isDisposed || requestId != _requestId) {
      return;
    }

    _isInitializing = true;
    _initErrorType = CompassInitErrorType.none;
    _isListening = false;
    _isApiBearing = false;
    _rawHeading = 0;
    _smoothHeading = 0;
    _hasHeading = false;
    _notifyListenersIfActive();

    try {
      final position = await (_positionProvider ?? _getCurrentPosition)();
      if (_isDisposed || requestId != _requestId) {
        return;
      }

      // A location fix is sufficient for Qibla. Network lookup can refine the
      // bearing later, but must never prevent the offline calculation.
      _qiblaDegrees = QiblaBearing.fromCoordinates(
        position.latitude,
        position.longitude,
      );

      unawaited(_updateApiBearing(position, requestId));
      final declination = await _declinationService.at(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
      );
      if (_isDisposed || requestId != _requestId) return;

      CompassListeningSession? session;

      try {
        session = await _permissionHelper.startCompassWithPermission(
          onHeadingChanged: (heading) {
            if (_isDisposed || requestId != _requestId) {
              return;
            }

            _rawHeading = (heading + declination + 360) % 360;
            if (!_hasHeading) {
              _smoothHeading = _rawHeading;
              _hasHeading = true;
            }
          },
          onUnavailable: () {
            if (_isDisposed || requestId != _requestId) return;
            _isListening = false;
            unawaited(_stopCompass());
            _notifyListenersIfActive();
          },
        );
      } catch (error) {
        debugPrint('Compass sensor unavailable: $error');
      }

      if (_isDisposed || requestId != _requestId) {
        unawaited(session?.cancel());
        return;
      }

      _compassSession = session;
      final started = session != null;

      _isListening = started;
      _isInitializing = false;
      _initErrorType = CompassInitErrorType.none;
      _notifyListenersIfActive();
    } catch (e) {
      if (_isDisposed || requestId != _requestId) {
        return;
      }

      _isListening = false;
      _isInitializing = false;
      if (e is CompassInitializationException) {
        _initErrorType = e.type;
      } else {
        debugPrint('Failed to initialize compass/Qibla: $e');
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
    _requestId++;
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

  Future<void> _updateApiBearing(Position position, int requestId) async {
    try {
      final bearing = await _qiblaApiService
          .fetchQiblaDirection(
            latitude: position.latitude,
            longitude: position.longitude,
          )
          .timeout(const Duration(seconds: 4));
      if (bearing == null || _isDisposed || requestId != _requestId) return;
      _qiblaDegrees = bearing;
      _isApiBearing = true;
      _notifyListenersIfActive();
    } catch (_) {
      // Local great-circle bearing remains valid offline.
    }
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
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }
}
