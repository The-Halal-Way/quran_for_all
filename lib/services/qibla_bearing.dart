import 'dart:math' as math;

/// Initial great-circle bearing from a location to the Kaaba, clockwise from
/// geographic north. The calculation works without an internet connection.
class QiblaBearing {
  const QiblaBearing._();

  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  static double fromCoordinates(double latitude, double longitude) {
    final phi1 = latitude * math.pi / 180;
    final phi2 = kaabaLatitude * math.pi / 180;
    final deltaLambda = (kaabaLongitude - longitude) * math.pi / 180;
    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x =
        math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);
    final degrees = math.atan2(y, x) * 180 / math.pi;
    return (degrees + 360) % 360;
  }
}
