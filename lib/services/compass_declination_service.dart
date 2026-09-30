import 'dart:io';

import 'package:flutter/services.dart';

/// Android's compass heading is magnetic; Qibla bearings use geographic north.
/// iOS flutter_compass already supplies a true-north heading.
class CompassDeclinationService {
  const CompassDeclinationService();

  static const _channel = MethodChannel('quran_for_all/compass');

  Future<double> at({
    required double latitude,
    required double longitude,
    required double altitude,
  }) async {
    if (!Platform.isAndroid) return 0;
    try {
      return await _channel.invokeMethod<double>('declination', {
            'latitude': latitude,
            'longitude': longitude,
            'altitude': altitude.isFinite ? altitude : 0.0,
          }) ??
          0;
    } on PlatformException {
      return 0;
    } on MissingPluginException {
      return 0;
    }
  }
}
