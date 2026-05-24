import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_for_all/services/permission_helper.dart';
import 'package:quran_for_all/services/qibla_api_service.dart';

const double kFallbackQiblaDegrees = 293.0;
const double kHeadingCorrectionDegrees = 270.0;
const double kQiblaSnapZone = 5.0;

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

  double get rawHeading => _rawHeading;
  double get smoothHeading => _smoothHeading;
  String get directionLabel => _directionLabel;
  bool get isListening => _isListening;
  bool get isApiFallback => _isApiFallback;
  bool get isInitializing => _isInitializing;
  double get qiblaDegrees => _qiblaDegrees;
  String get initError => _initError;

  double get qiblaOffset => (_qiblaDegrees - _smoothHeading + 360) % 360;

  bool get facingMecca =>
      _isListening &&
      (qiblaOffset < kQiblaSnapZone || qiblaOffset > 360 - kQiblaSnapZone);

  bool get showLoadingState =>
      _isInitializing || (!_isListening && !_isApiFallback);

  Future<void> initialize() async {
    _isInitializing = true;
    _initError = '';
    notifyListeners();

    try {
      final position = await _getCurrentPosition();
      final qiblaDirection = await _qiblaApiService.fetchQiblaDirection(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final hasNativeCompass = await _permissionHelper
          .hasNativeCompassFeature();
      var started = false;

      if (hasNativeCompass) {
        started = await _permissionHelper.startCompassWithPermission(
          onHeadingChanged: (heading) {
            _rawHeading = (heading + 360) % 360;
          },
          onDirectionChanged: (direction) {
            _directionLabel = direction;
            notifyListeners();
          },
          headingCorrectionDegrees: kHeadingCorrectionDegrees,
        );
      }

      _qiblaDegrees = qiblaDirection ?? kFallbackQiblaDegrees;
      _isListening = started;
      _isApiFallback = !started;
      _isInitializing = false;
      _directionLabel = started ? _directionLabel : 'No compass sensor';
      _rawHeading = started ? _rawHeading : 0;
      _smoothHeading = started ? _smoothHeading : 0;
      _initError = '';
      notifyListeners();
    } catch (e) {
      _isListening = false;
      _isApiFallback = false;
      _isInitializing = false;
      _initError = 'Failed to initialize compass/Qibla: $e';
      notifyListeners();
    }
  }

  void updateSmoothHeading() {
    final previous = _smoothHeading;
    var diff = _rawHeading - _smoothHeading;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    final next = _smoothHeading + diff * 0.10;
    _smoothHeading = (next + 360) % 360;

    if ((previous - _smoothHeading).abs() >= 0.05) {
      notifyListeners();
    }
  }

  Future<void> retry() async {
    await initialize();
  }

  Future<Position> _getCurrentPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
