import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constants/db_constants.dart';
import '../../../core/utils/string_utils.dart';
import '../../models/ayah_model.dart';
import '../../models/last_read_model.dart';
import '../../models/surah_model.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get database async {
    return _database ??= await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, DbConstants.databaseName);

    return openDatabase(
      fullPath,
      version: DbConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.tableSurahs} (
        id INTEGER PRIMARY KEY,
        name_arabic TEXT NOT NULL,
        name_english TEXT NOT NULL,
        name_translated TEXT NOT NULL,
        revelation_type TEXT NOT NULL,
        total_ayahs INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableAyahs} (
        id INTEGER PRIMARY KEY,
        surah_id INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        juz_number INTEGER NOT NULL,
        hizb_quarter INTEGER NOT NULL,
        page_number INTEGER NOT NULL,
        arabic_text TEXT NOT NULL,
        transliteration_en TEXT NOT NULL,
        transliteration_bn TEXT NOT NULL,
        translation_en TEXT NOT NULL,
        translation_bn TEXT NOT NULL,
        audio_url TEXT NOT NULL,
        FOREIGN KEY (surah_id) REFERENCES ${DbConstants.tableSurahs}(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.tableLastRead} (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        surah_id INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE VIRTUAL TABLE ${DbConstants.tableAyahFts}
      USING fts4(ayah_id, content)
    ''');

    await db.execute(
      'CREATE INDEX idx_ayah_surah ON ${DbConstants.tableAyahs}(surah_id, ayah_number)',
    );
    await db.execute(
      'CREATE INDEX idx_ayah_juz ON ${DbConstants.tableAyahs}(juz_number)',
    );
  }

  Future<bool> hasQuranData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DbConstants.tableAyahs}',
    );
    final count = result.first['count'] as int? ?? 0;
    return count > 0;
  }

  Future<void> insertQuranData({
    required List<SurahModel> surahs,
    required List<AyahModel> ayahs,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete(DbConstants.tableSurahs);
      await txn.delete(DbConstants.tableAyahs);
      await txn.rawDelete('DELETE FROM ${DbConstants.tableAyahFts}');

      final surahBatch = txn.batch();
      for (final surah in surahs) {
        surahBatch.insert(
          DbConstants.tableSurahs,
          surah.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await surahBatch.commit(noResult: true);

      final ayahBatch = txn.batch();
      final ftsBatch = txn.batch();

      for (final ayah in ayahs) {
        ayahBatch.insert(
          DbConstants.tableAyahs,
          ayah.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        ftsBatch.insert(DbConstants.tableAyahFts, {
          'ayah_id': ayah.id,
          'content': _buildSearchContent(ayah),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await ayahBatch.commit(noResult: true);
      await ftsBatch.commit(noResult: true);
    });
  }

  Future<List<SurahModel>> getAllSurahs() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT
        s.id,
        s.name_arabic,
        s.name_english,
        s.name_translated,
        s.revelation_type,
        CASE
          WHEN s.total_ayahs > 0 THEN s.total_ayahs
          ELSE (
            SELECT COUNT(*)
            FROM ${DbConstants.tableAyahs} a
            WHERE a.surah_id = s.id
          )
        END AS total_ayahs
      FROM ${DbConstants.tableSurahs} s
      ORDER BY s.id ASC
    ''');

    return rows.map(SurahModel.fromMap).toList();
  }

  Future<List<AyahModel>> getAyahsBySurah(int surahId) async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableAyahs,
      where: 'surah_id = ?',
      whereArgs: [surahId],
      orderBy: 'ayah_number ASC',
    );

    return rows.map(AyahModel.fromMap).toList();
  }

  Future<AyahModel?> getAyah(int surahId, int ayahNumber) async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableAyahs,
      where: 'surah_id = ? AND ayah_number = ?',
      whereArgs: [surahId, ayahNumber],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return AyahModel.fromMap(rows.first);
  }

  Future<List<AyahModel>> getAyahsByJuz(int juz, {int limit = 80}) async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableAyahs,
      where: 'juz_number = ?',
      whereArgs: [juz],
      orderBy: 'surah_id ASC, ayah_number ASC',
      limit: limit,
    );

    return rows.map(AyahModel.fromMap).toList();
  }

  Future<List<SurahModel>> searchSurahs(String query) async {
    final db = await database;
    final numeric = int.tryParse(query);
    final likePattern = '%${StringUtils.compactWhitespace(query)}%';

    final rows = await db.query(
      DbConstants.tableSurahs,
      where:
          'name_arabic LIKE ? OR name_english LIKE ? OR name_translated LIKE ? OR id = ?',
      whereArgs: [likePattern, likePattern, likePattern, numeric ?? -1],
      orderBy: 'id ASC',
      limit: 30,
    );

    return rows.map(SurahModel.fromMap).toList();
  }

  Future<List<AyahModel>> searchAyahsByKeyword(
    String query, {
    int limit = 80,
  }) async {
    final db = await database;
    final ftsQuery = StringUtils.sanitizeFtsQuery(query);

    if (ftsQuery.isNotEmpty) {
      try {
        final rows = await db.rawQuery(
          '''
          SELECT a.*
          FROM ${DbConstants.tableAyahFts} f
          JOIN ${DbConstants.tableAyahs} a ON a.id = f.ayah_id
          WHERE ${DbConstants.tableAyahFts} MATCH ?
          LIMIT ?
          ''',
          [ftsQuery, limit],
        );

        if (rows.isNotEmpty) {
          return rows.map(AyahModel.fromMap).toList();
        }
      } on DatabaseException {
        // If FTS fails for complex input, fallback to LIKE query.
      }
    }

    final likePattern = '%${StringUtils.compactWhitespace(query)}%';
    final rows = await db.query(
      DbConstants.tableAyahs,
      where:
          'arabic_text LIKE ? OR transliteration_en LIKE ? OR transliteration_bn LIKE ? OR translation_en LIKE ? OR translation_bn LIKE ?',
      whereArgs: [
        likePattern,
        likePattern,
        likePattern,
        likePattern,
        likePattern,
      ],
      limit: limit,
      orderBy: 'surah_id ASC, ayah_number ASC',
    );

    return rows.map(AyahModel.fromMap).toList();
  }

  Future<void> saveLastRead(int surahId, int ayahNumber) async {
    final db = await database;
    await db.insert(
      DbConstants.tableLastRead,
      LastReadModel(
        surahId: surahId,
        ayahNumber: ayahNumber,
        updatedAt: DateTime.now(),
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LastReadModel?> getLastRead() async {
    final db = await database;
    final rows = await db.query(DbConstants.tableLastRead, limit: 1);

    if (rows.isEmpty) {
      return null;
    }

    return LastReadModel.fromMap(rows.first);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  String _buildSearchContent(AyahModel ayah) {
    return [
      ayah.arabicText,
      ayah.transliterationEn,
      ayah.transliterationBn,
      ayah.translationEn,
      ayah.translationBn,
    ].join(' ');
  }
}
