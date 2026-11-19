/// Astronomical events without prayer-method or user minute adjustments.
class PrayerSolarTimes {
  const PrayerSolarTimes({
    required this.sunriseUtc,
    required this.noonUtc,
    required this.sunsetUtc,
  });

  final DateTime sunriseUtc;
  final DateTime noonUtc;
  final DateTime sunsetUtc;

  Map<String, Object?> toJson() => {
    'sunrise': sunriseUtc.toIso8601String(),
    'noon': noonUtc.toIso8601String(),
    'sunset': sunsetUtc.toIso8601String(),
  };

  factory PrayerSolarTimes.fromJson(Map<String, Object?> json) =>
      PrayerSolarTimes(
        sunriseUtc: DateTime.parse(json['sunrise'] as String).toUtc(),
        noonUtc: DateTime.parse(json['noon'] as String).toUtc(),
        sunsetUtc: DateTime.parse(json['sunset'] as String).toUtc(),
      );
}
