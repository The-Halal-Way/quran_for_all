import 'dart:convert';

enum PrayerCalculationMethod {
  muslimWorldLeague(apiMethodId: 3);

  const PrayerCalculationMethod({required this.apiMethodId});

  final int apiMethodId;

  static PrayerCalculationMethod fromName(String? value) {
    return PrayerCalculationMethod.values.firstWhere(
      (method) => method.name == value,
      orElse: () => PrayerCalculationMethod.muslimWorldLeague,
    );
  }
}

enum PrayerMadhab {
  shafi(apiSchoolValue: 0),
  hanafi(apiSchoolValue: 1);

  const PrayerMadhab({required this.apiSchoolValue});

  final int apiSchoolValue;

  static PrayerMadhab fromName(String? value) {
    return PrayerMadhab.values.firstWhere(
      (madhab) => madhab.name == value,
      orElse: () => PrayerMadhab.shafi,
    );
  }
}

enum PrayerLatitudeAdjustmentMethod {
  middleOfNight(apiValue: 1),
  oneSeventh(apiValue: 2),
  angleBased(apiValue: 3);

  const PrayerLatitudeAdjustmentMethod({required this.apiValue});

  final int apiValue;

  static PrayerLatitudeAdjustmentMethod fromName(String? value) {
    return PrayerLatitudeAdjustmentMethod.values.firstWhere(
      (method) => method.name == value,
      orElse: () => PrayerLatitudeAdjustmentMethod.angleBased,
    );
  }
}

enum PrayerMidnightMode {
  standard(apiValue: 0),
  jafari(apiValue: 1);

  const PrayerMidnightMode({required this.apiValue});

  final int apiValue;

  static PrayerMidnightMode fromName(String? value) {
    return PrayerMidnightMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => PrayerMidnightMode.standard,
    );
  }
}

class PrayerAdjustments {
  const PrayerAdjustments({
    this.imsak = 0,
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.sunset = 0,
    this.isha = 0,
    this.midnight = 0,
  });

  final int imsak;
  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int sunset;
  final int isha;
  final int midnight;

  String get apiTuneString => [
    imsak,
    fajr,
    sunrise,
    dhuhr,
    asr,
    maghrib,
    sunset,
    isha,
    midnight,
  ].join(',');

  Map<String, int> toMap() {
    return {
      'imsak': imsak,
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'sunset': sunset,
      'isha': isha,
      'midnight': midnight,
    };
  }

  factory PrayerAdjustments.fromTuneString(String? value) {
    final parts = (value ?? '').split(',');
    final numbers = List<int>.generate(
      9,
      (index) => index < parts.length ? int.tryParse(parts[index]) ?? 0 : 0,
    );

    return PrayerAdjustments(
      imsak: numbers[0],
      fajr: numbers[1],
      sunrise: numbers[2],
      dhuhr: numbers[3],
      asr: numbers[4],
      maghrib: numbers[5],
      sunset: numbers[6],
      isha: numbers[7],
      midnight: numbers[8],
    );
  }
}

class PrayerCalculationConfig {
  const PrayerCalculationConfig({
    required this.method,
    required this.madhab,
    required this.adjustments,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.paramsVersion,
    this.shafaq = 'general',
    this.sehriOffsetMinutes = 10,
  });

  factory PrayerCalculationConfig.defaults() {
    return const PrayerCalculationConfig(
      method: PrayerCalculationMethod.muslimWorldLeague,
      madhab: PrayerMadhab.shafi,
      adjustments: PrayerAdjustments(),
      latitudeAdjustmentMethod: PrayerLatitudeAdjustmentMethod.angleBased,
      midnightMode: PrayerMidnightMode.standard,
      paramsVersion: 1,
    );
  }

  final PrayerCalculationMethod method;
  final PrayerMadhab madhab;
  final PrayerAdjustments adjustments;
  final PrayerLatitudeAdjustmentMethod latitudeAdjustmentMethod;
  final PrayerMidnightMode midnightMode;
  final int paramsVersion;
  final String shafaq;
  final int sehriOffsetMinutes;

  String signatureSeed() {
    return jsonEncode({
      'method': method.name,
      'madhab': madhab.name,
      'adjustments': adjustments.toMap(),
      'latitudeAdjustmentMethod': latitudeAdjustmentMethod.name,
      'midnightMode': midnightMode.name,
      'shafaq': shafaq,
      'sehriOffsetMinutes': sehriOffsetMinutes,
      'paramsVersion': paramsVersion,
    });
  }
}

class PrayerProfile {
  const PrayerProfile({
    required this.signature,
    required this.locationIdentity,
    required this.latitude,
    required this.longitude,
    required this.latitudeBucket,
    required this.longitudeBucket,
    required this.timeZoneId,
    required this.calculation,
    required this.displayLocationLabel,
    required this.createdAtUtc,
    required this.lastUsedAtUtc,
  });

  final String signature;
  final String locationIdentity;
  final double latitude;
  final double longitude;
  final double latitudeBucket;
  final double longitudeBucket;
  final String timeZoneId;
  final PrayerCalculationConfig calculation;
  final String displayLocationLabel;
  final DateTime createdAtUtc;
  final DateTime lastUsedAtUtc;

  PrayerProfile copyWith({DateTime? lastUsedAtUtc}) {
    return PrayerProfile(
      signature: signature,
      locationIdentity: locationIdentity,
      latitude: latitude,
      longitude: longitude,
      latitudeBucket: latitudeBucket,
      longitudeBucket: longitudeBucket,
      timeZoneId: timeZoneId,
      calculation: calculation,
      displayLocationLabel: displayLocationLabel,
      createdAtUtc: createdAtUtc,
      lastUsedAtUtc: lastUsedAtUtc ?? this.lastUsedAtUtc,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'signature': signature,
      'location_identity': locationIdentity,
      'latitude': latitude,
      'longitude': longitude,
      'latitude_bucket': latitudeBucket,
      'longitude_bucket': longitudeBucket,
      'timezone_id': timeZoneId,
      'calculation_method': calculation.method.name,
      'madhab': calculation.madhab.name,
      'adjustments_tune': calculation.adjustments.apiTuneString,
      'latitude_adjustment_method': calculation.latitudeAdjustmentMethod.name,
      'midnight_mode': calculation.midnightMode.name,
      'shafaq': calculation.shafaq,
      'sehri_offset_minutes': calculation.sehriOffsetMinutes,
      'params_version': calculation.paramsVersion,
      'display_location_label': displayLocationLabel,
      'created_at_utc': createdAtUtc.toIso8601String(),
      'last_used_at_utc': lastUsedAtUtc.toIso8601String(),
    };
  }

  factory PrayerProfile.fromMap(Map<String, Object?> map) {
    return PrayerProfile(
      signature: map['signature'] as String,
      locationIdentity: map['location_identity'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      latitudeBucket: (map['latitude_bucket'] as num).toDouble(),
      longitudeBucket: (map['longitude_bucket'] as num).toDouble(),
      timeZoneId: map['timezone_id'] as String,
      calculation: PrayerCalculationConfig(
        method: PrayerCalculationMethod.fromName(
          map['calculation_method'] as String?,
        ),
        madhab: PrayerMadhab.fromName(map['madhab'] as String?),
        adjustments: PrayerAdjustments.fromTuneString(
          map['adjustments_tune'] as String?,
        ),
        latitudeAdjustmentMethod: PrayerLatitudeAdjustmentMethod.fromName(
          map['latitude_adjustment_method'] as String?,
        ),
        midnightMode: PrayerMidnightMode.fromName(
          map['midnight_mode'] as String?,
        ),
        shafaq: (map['shafaq'] as String?) ?? 'general',
        sehriOffsetMinutes: ((map['sehri_offset_minutes'] as num?) ?? 10)
            .toInt(),
        paramsVersion: ((map['params_version'] as num?) ?? 1).toInt(),
      ),
      displayLocationLabel: map['display_location_label'] as String,
      createdAtUtc: DateTime.parse(map['created_at_utc'] as String).toUtc(),
      lastUsedAtUtc: DateTime.parse(map['last_used_at_utc'] as String).toUtc(),
    );
  }
}

class PrayerDay {
  const PrayerDay({
    required this.profileSignature,
    required this.localDateKey,
    required this.timeZoneId,
    required this.fajrUtc,
    required this.sunriseUtc,
    required this.dhuhrUtc,
    required this.asrUtc,
    required this.maghribUtc,
    required this.ishaUtc,
    required this.fetchedAtUtc,
    required this.sourceRevision,
  });

  final String profileSignature;
  final String localDateKey;
  final String timeZoneId;
  final DateTime fajrUtc;
  final DateTime sunriseUtc;
  final DateTime dhuhrUtc;
  final DateTime asrUtc;
  final DateTime maghribUtc;
  final DateTime ishaUtc;
  final DateTime fetchedAtUtc;
  final String sourceRevision;

  Map<String, Object?> toMap() {
    return {
      'profile_signature': profileSignature,
      'local_date_key': localDateKey,
      'timezone_id': timeZoneId,
      'fajr_utc': fajrUtc.toIso8601String(),
      'sunrise_utc': sunriseUtc.toIso8601String(),
      'dhuhr_utc': dhuhrUtc.toIso8601String(),
      'asr_utc': asrUtc.toIso8601String(),
      'maghrib_utc': maghribUtc.toIso8601String(),
      'isha_utc': ishaUtc.toIso8601String(),
      'fetched_at_utc': fetchedAtUtc.toIso8601String(),
      'source_revision': sourceRevision,
    };
  }

  factory PrayerDay.fromMap(Map<String, Object?> map) {
    return PrayerDay(
      profileSignature: map['profile_signature'] as String,
      localDateKey: map['local_date_key'] as String,
      timeZoneId: map['timezone_id'] as String,
      fajrUtc: DateTime.parse(map['fajr_utc'] as String).toUtc(),
      sunriseUtc: DateTime.parse(map['sunrise_utc'] as String).toUtc(),
      dhuhrUtc: DateTime.parse(map['dhuhr_utc'] as String).toUtc(),
      asrUtc: DateTime.parse(map['asr_utc'] as String).toUtc(),
      maghribUtc: DateTime.parse(map['maghrib_utc'] as String).toUtc(),
      ishaUtc: DateTime.parse(map['isha_utc'] as String).toUtc(),
      fetchedAtUtc: DateTime.parse(map['fetched_at_utc'] as String).toUtc(),
      sourceRevision: map['source_revision'] as String,
    );
  }
}

class PrayerSyncState {
  const PrayerSyncState({
    required this.profileSignature,
    required this.windowStartDateKey,
    required this.windowEndDateKey,
    required this.missingDateKeys,
    this.lastTodaySyncAtUtc,
    this.lastFullWindowSyncAtUtc,
    this.retryAfterUtc,
    this.lastErrorCode,
    this.consecutiveFailureCount = 0,
  });

  final String profileSignature;
  final String windowStartDateKey;
  final String windowEndDateKey;
  final List<String> missingDateKeys;
  final DateTime? lastTodaySyncAtUtc;
  final DateTime? lastFullWindowSyncAtUtc;
  final DateTime? retryAfterUtc;
  final String? lastErrorCode;
  final int consecutiveFailureCount;

  PrayerSyncState copyWith({
    String? windowStartDateKey,
    String? windowEndDateKey,
    List<String>? missingDateKeys,
    DateTime? lastTodaySyncAtUtc,
    DateTime? lastFullWindowSyncAtUtc,
    DateTime? retryAfterUtc,
    String? lastErrorCode,
    int? consecutiveFailureCount,
  }) {
    return PrayerSyncState(
      profileSignature: profileSignature,
      windowStartDateKey: windowStartDateKey ?? this.windowStartDateKey,
      windowEndDateKey: windowEndDateKey ?? this.windowEndDateKey,
      missingDateKeys: missingDateKeys ?? this.missingDateKeys,
      lastTodaySyncAtUtc: lastTodaySyncAtUtc ?? this.lastTodaySyncAtUtc,
      lastFullWindowSyncAtUtc:
          lastFullWindowSyncAtUtc ?? this.lastFullWindowSyncAtUtc,
      retryAfterUtc: retryAfterUtc ?? this.retryAfterUtc,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
      consecutiveFailureCount:
          consecutiveFailureCount ?? this.consecutiveFailureCount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'profile_signature': profileSignature,
      'window_start_date_key': windowStartDateKey,
      'window_end_date_key': windowEndDateKey,
      'missing_date_keys_json': jsonEncode(missingDateKeys),
      'last_today_sync_at_utc': lastTodaySyncAtUtc?.toIso8601String(),
      'last_full_window_sync_at_utc': lastFullWindowSyncAtUtc
          ?.toIso8601String(),
      'retry_after_utc': retryAfterUtc?.toIso8601String(),
      'last_error_code': lastErrorCode,
      'consecutive_failure_count': consecutiveFailureCount,
    };
  }

  factory PrayerSyncState.fromMap(Map<String, Object?> map) {
    return PrayerSyncState(
      profileSignature: map['profile_signature'] as String,
      windowStartDateKey: map['window_start_date_key'] as String,
      windowEndDateKey: map['window_end_date_key'] as String,
      missingDateKeys:
          ((jsonDecode((map['missing_date_keys_json'] as String?) ?? '[]')
                      as List)
                  .cast<Object?>())
              .map((value) => value.toString())
              .toList(),
      lastTodaySyncAtUtc: map['last_today_sync_at_utc'] == null
          ? null
          : DateTime.parse(map['last_today_sync_at_utc'] as String).toUtc(),
      lastFullWindowSyncAtUtc: map['last_full_window_sync_at_utc'] == null
          ? null
          : DateTime.parse(
              map['last_full_window_sync_at_utc'] as String,
            ).toUtc(),
      retryAfterUtc: map['retry_after_utc'] == null
          ? null
          : DateTime.parse(map['retry_after_utc'] as String).toUtc(),
      lastErrorCode: map['last_error_code'] as String?,
      consecutiveFailureCount: ((map['consecutive_failure_count'] as num?) ?? 0)
          .toInt(),
    );
  }
}

class PrayerDashboardData {
  const PrayerDashboardData({
    required this.profile,
    required this.today,
    required this.generatedAtUtc,
    this.tomorrow,
    this.lastSuccessfulSyncAtUtc,
    this.isFallbackProfile = false,
    this.isWindowComplete = false,
  });

  final PrayerProfile profile;
  final PrayerDay today;
  final PrayerDay? tomorrow;
  final DateTime generatedAtUtc;
  final DateTime? lastSuccessfulSyncAtUtc;
  final bool isFallbackProfile;
  final bool isWindowComplete;

  PrayerDashboardData copyWith({
    PrayerProfile? profile,
    PrayerDay? today,
    PrayerDay? tomorrow,
    DateTime? generatedAtUtc,
    DateTime? lastSuccessfulSyncAtUtc,
    bool? isFallbackProfile,
    bool? isWindowComplete,
  }) {
    return PrayerDashboardData(
      profile: profile ?? this.profile,
      today: today ?? this.today,
      tomorrow: tomorrow ?? this.tomorrow,
      generatedAtUtc: generatedAtUtc ?? this.generatedAtUtc,
      lastSuccessfulSyncAtUtc:
          lastSuccessfulSyncAtUtc ?? this.lastSuccessfulSyncAtUtc,
      isFallbackProfile: isFallbackProfile ?? this.isFallbackProfile,
      isWindowComplete: isWindowComplete ?? this.isWindowComplete,
    );
  }
}

class PrayerWidgetDaySnapshot {
  const PrayerWidgetDaySnapshot({
    required this.localDateKey,
    required this.fajrUtcMillis,
    required this.sunriseUtcMillis,
    required this.dhuhrUtcMillis,
    required this.asrUtcMillis,
    required this.maghribUtcMillis,
    required this.ishaUtcMillis,
  });

  final String localDateKey;
  final int fajrUtcMillis;
  final int sunriseUtcMillis;
  final int dhuhrUtcMillis;
  final int asrUtcMillis;
  final int maghribUtcMillis;
  final int ishaUtcMillis;

  Map<String, Object?> toJson() {
    return {
      'localDateKey': localDateKey,
      'fajrUtcMillis': fajrUtcMillis,
      'sunriseUtcMillis': sunriseUtcMillis,
      'dhuhrUtcMillis': dhuhrUtcMillis,
      'asrUtcMillis': asrUtcMillis,
      'maghribUtcMillis': maghribUtcMillis,
      'ishaUtcMillis': ishaUtcMillis,
    };
  }

  factory PrayerWidgetDaySnapshot.fromJson(Map<String, Object?> json) {
    return PrayerWidgetDaySnapshot(
      localDateKey: json['localDateKey'] as String,
      fajrUtcMillis: (json['fajrUtcMillis'] as num).toInt(),
      sunriseUtcMillis: (json['sunriseUtcMillis'] as num).toInt(),
      dhuhrUtcMillis: (json['dhuhrUtcMillis'] as num).toInt(),
      asrUtcMillis: (json['asrUtcMillis'] as num).toInt(),
      maghribUtcMillis: (json['maghribUtcMillis'] as num).toInt(),
      ishaUtcMillis: (json['ishaUtcMillis'] as num).toInt(),
    );
  }
}

class PrayerWidgetSnapshot {
  const PrayerWidgetSnapshot({
    required this.profileSignature,
    required this.timeZoneId,
    required this.locationLabel,
    required this.generatedAtUtcMillis,
    required this.lastSuccessfulSyncAtUtcMillis,
    required this.days,
  });

  final String profileSignature;
  final String timeZoneId;
  final String locationLabel;
  final int generatedAtUtcMillis;
  final int? lastSuccessfulSyncAtUtcMillis;
  final List<PrayerWidgetDaySnapshot> days;

  String toJsonString() {
    return jsonEncode({
      'profileSignature': profileSignature,
      'timeZoneId': timeZoneId,
      'locationLabel': locationLabel,
      'generatedAtUtcMillis': generatedAtUtcMillis,
      'lastSuccessfulSyncAtUtcMillis': lastSuccessfulSyncAtUtcMillis,
      'days': days.map((day) => day.toJson()).toList(),
    });
  }

  factory PrayerWidgetSnapshot.fromJsonString(String value) {
    final json = jsonDecode(value) as Map<String, Object?>;
    return PrayerWidgetSnapshot(
      profileSignature: json['profileSignature'] as String,
      timeZoneId: json['timeZoneId'] as String,
      locationLabel: json['locationLabel'] as String,
      generatedAtUtcMillis: (json['generatedAtUtcMillis'] as num).toInt(),
      lastSuccessfulSyncAtUtcMillis:
          (json['lastSuccessfulSyncAtUtcMillis'] as num?)?.toInt(),
      days: ((json['days'] as List?) ?? const <Object?>[])
          .map(
            (entry) => PrayerWidgetDaySnapshot.fromJson(
              Map<String, Object?>.from(entry as Map),
            ),
          )
          .toList(),
    );
  }
}

enum PrayerRepositoryErrorType {
  permissionDenied,
  permissionDeniedForever,
  locationDisabled,
  network,
  unavailable,
}

class PrayerTimesException implements Exception {
  const PrayerTimesException(this.type, this.message);

  final PrayerRepositoryErrorType type;
  final String message;

  @override
  String toString() => 'PrayerTimesException($type, $message)';
}
