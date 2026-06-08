import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/prayer_times/prayer_times_models.dart';

class PrayerTimesLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    return _database ??= await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, 'quran_for_all_prayer_times.db');

    return openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE prayer_profiles (
            signature TEXT PRIMARY KEY,
            location_identity TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            latitude_bucket REAL NOT NULL,
            longitude_bucket REAL NOT NULL,
            timezone_id TEXT NOT NULL,
            calculation_method TEXT NOT NULL,
            madhab TEXT NOT NULL,
            adjustments_tune TEXT NOT NULL,
            latitude_adjustment_method TEXT NOT NULL,
            midnight_mode TEXT NOT NULL,
            shafaq TEXT,
            sehri_offset_minutes INTEGER NOT NULL DEFAULT 10,
            params_version INTEGER NOT NULL,
            display_location_label TEXT NOT NULL,
            created_at_utc TEXT NOT NULL,
            last_used_at_utc TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE prayer_days (
            profile_signature TEXT NOT NULL,
            local_date_key TEXT NOT NULL,
            timezone_id TEXT NOT NULL,
            fajr_utc TEXT NOT NULL,
            sunrise_utc TEXT NOT NULL,
            dhuhr_utc TEXT NOT NULL,
            asr_utc TEXT NOT NULL,
            maghrib_utc TEXT NOT NULL,
            isha_utc TEXT NOT NULL,
            fetched_at_utc TEXT NOT NULL,
            source_revision TEXT NOT NULL,
            PRIMARY KEY (profile_signature, local_date_key)
          )
        ''');

        await db.execute('''
          CREATE TABLE prayer_sync_state (
            profile_signature TEXT PRIMARY KEY,
            window_start_date_key TEXT NOT NULL,
            window_end_date_key TEXT NOT NULL,
            missing_date_keys_json TEXT NOT NULL,
            last_today_sync_at_utc TEXT,
            last_full_window_sync_at_utc TEXT,
            retry_after_utc TEXT,
            last_error_code TEXT,
            consecutive_failure_count INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute(
          'CREATE INDEX idx_prayer_profiles_last_used ON prayer_profiles(last_used_at_utc)',
        );
        await db.execute(
          'CREATE INDEX idx_prayer_days_date ON prayer_days(profile_signature, local_date_key)',
        );
      },
    );
  }

  Future<void> upsertProfile(PrayerProfile profile) async {
    final db = await database;
    await db.insert(
      'prayer_profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PrayerProfile?> getProfile(String signature) async {
    final db = await database;
    final rows = await db.query(
      'prayer_profiles',
      where: 'signature = ?',
      whereArgs: [signature],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }

    return PrayerProfile.fromMap(rows.first);
  }

  Future<List<PrayerProfile>> getInactiveProfilesBefore(
    DateTime cutoffUtc, {
    required String activeSignature,
  }) async {
    final db = await database;
    final rows = await db.query(
      'prayer_profiles',
      where: 'signature != ? AND last_used_at_utc < ?',
      whereArgs: [activeSignature, cutoffUtc.toIso8601String()],
    );

    return rows.map(PrayerProfile.fromMap).toList();
  }

  Future<void> deleteProfiles(List<String> signatures) async {
    if (signatures.isEmpty) {
      return;
    }

    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final signature in signatures) {
        batch.delete(
          'prayer_days',
          where: 'profile_signature = ?',
          whereArgs: [signature],
        );
        batch.delete(
          'prayer_sync_state',
          where: 'profile_signature = ?',
          whereArgs: [signature],
        );
        batch.delete(
          'prayer_profiles',
          where: 'signature = ?',
          whereArgs: [signature],
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> upsertPrayerDay(PrayerDay day) async {
    final db = await database;
    await db.insert(
      'prayer_days',
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertPrayerDays(List<PrayerDay> days) async {
    if (days.isEmpty) {
      return;
    }

    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final day in days) {
        batch.insert(
          'prayer_days',
          day.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<PrayerDay?> getPrayerDay(
    String profileSignature,
    String localDateKey,
  ) async {
    final db = await database;
    final rows = await db.query(
      'prayer_days',
      where: 'profile_signature = ? AND local_date_key = ?',
      whereArgs: [profileSignature, localDateKey],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }

    return PrayerDay.fromMap(rows.first);
  }

  Future<List<PrayerDay>> getPrayerDaysInRange(
    String profileSignature,
    String startDateKey,
    String endDateKey,
  ) async {
    final db = await database;
    final rows = await db.query(
      'prayer_days',
      where:
          'profile_signature = ? AND local_date_key >= ? AND local_date_key <= ?',
      whereArgs: [profileSignature, startDateKey, endDateKey],
      orderBy: 'local_date_key ASC',
    );

    return rows.map(PrayerDay.fromMap).toList();
  }

  Future<PrayerSyncState?> getSyncState(String profileSignature) async {
    final db = await database;
    final rows = await db.query(
      'prayer_sync_state',
      where: 'profile_signature = ?',
      whereArgs: [profileSignature],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }

    return PrayerSyncState.fromMap(rows.first);
  }

  Future<void> upsertSyncState(PrayerSyncState state) async {
    final db = await database;
    await db.insert(
      'prayer_sync_state',
      state.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePrayerDaysOutsideRange({
    required String profileSignature,
    required String keepFromDateKey,
    required String keepToDateKey,
  }) async {
    final db = await database;
    await db.delete(
      'prayer_days',
      where:
          'profile_signature = ? AND (local_date_key < ? OR local_date_key > ?)',
      whereArgs: [profileSignature, keepFromDateKey, keepToDateKey],
    );
  }
}
