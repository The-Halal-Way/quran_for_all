import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../domain/entities/prayer_times/prayer_times_models.dart';

class PrayerTimesApiService {
  const PrayerTimesApiService(this._client);

  final http.Client _client;

  Future<PrayerDay> fetchDay({
    required PrayerProfile profile,
    required String localDateKey,
  }) async {
    final parts = localDateKey.split('-');
    final date = '${parts[2]}-${parts[1]}-${parts[0]}';
    final response = await _client.get(
      Uri.https('api.aladhan.com', '/v1/timings/$date', {
        'latitude': profile.latitude.toString(),
        'longitude': profile.longitude.toString(),
        'method': profile.calculation.method.apiMethodId.toString(),
        'school': profile.calculation.madhab.apiSchoolValue.toString(),
        'timezonestring': profile.timeZoneId,
        'tune': profile.calculation.adjustments.apiTuneString,
        'latitudeAdjustmentMethod': profile
            .calculation
            .latitudeAdjustmentMethod
            .apiValue
            .toString(),
        'midnightMode': profile.calculation.midnightMode.apiValue.toString(),
        'shafaq': profile.calculation.shafaq,
        'iso8601': 'true',
      }),
    );

    final json = _decode(response);
    return _parsePrayerDay(
      Map<String, Object?>.from(json['data'] as Map),
      profile,
    );
  }

  Future<List<PrayerDay>> fetchMonth({
    required PrayerProfile profile,
    required int year,
    required int month,
  }) async {
    final response = await _client.get(
      Uri.https('api.aladhan.com', '/v1/calendar/$year/$month', {
        'latitude': profile.latitude.toString(),
        'longitude': profile.longitude.toString(),
        'method': profile.calculation.method.apiMethodId.toString(),
        'school': profile.calculation.madhab.apiSchoolValue.toString(),
        'timezonestring': profile.timeZoneId,
        'tune': profile.calculation.adjustments.apiTuneString,
        'latitudeAdjustmentMethod': profile
            .calculation
            .latitudeAdjustmentMethod
            .apiValue
            .toString(),
        'midnightMode': profile.calculation.midnightMode.apiValue.toString(),
        'shafaq': profile.calculation.shafaq,
        'iso8601': 'true',
      }),
    );

    final json = _decode(response);
    final data = (json['data'] as List?) ?? const <Object?>[];

    return data
        .map(
          (entry) =>
              _parsePrayerDay(Map<String, Object?>.from(entry as Map), profile),
        )
        .toList();
  }

  Map<String, Object?> _decode(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, Object?>;
    if (response.statusCode == 200) {
      return json;
    }

    throw PrayerTimesException(
      PrayerRepositoryErrorType.network,
      (json['status'] as String?) ?? 'Prayer API request failed',
    );
  }

  PrayerDay _parsePrayerDay(Map<String, Object?> raw, PrayerProfile profile) {
    final timings = Map<String, Object?>.from(raw['timings'] as Map);
    final date = Map<String, Object?>.from(raw['date'] as Map);
    final gregorian = Map<String, Object?>.from(date['gregorian'] as Map);

    return PrayerDay(
      profileSignature: profile.signature,
      localDateKey: _gregorianApiDateToKey(gregorian['date'] as String),
      timeZoneId: profile.timeZoneId,
      fajrUtc: DateTime.parse(timings['Fajr'] as String).toUtc(),
      sunriseUtc: DateTime.parse(timings['Sunrise'] as String).toUtc(),
      dhuhrUtc: DateTime.parse(timings['Dhuhr'] as String).toUtc(),
      asrUtc: DateTime.parse(timings['Asr'] as String).toUtc(),
      maghribUtc: DateTime.parse(timings['Maghrib'] as String).toUtc(),
      ishaUtc: DateTime.parse(timings['Isha'] as String).toUtc(),
      fetchedAtUtc: DateTime.now().toUtc(),
      sourceRevision:
          'aladhan:${profile.calculation.method.apiMethodId}:${profile.calculation.madhab.apiSchoolValue}:${profile.calculation.paramsVersion}',
    );
  }

  String _gregorianApiDateToKey(String value) {
    final parts = value.split('-');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }
}
