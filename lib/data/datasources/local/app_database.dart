import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constants/db_constants.dart';
import '../../../core/utils/string_utils.dart';
import '../../models/ayah_model.dart';
import '../../models/bookmark_model.dart';
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
      onUpgrade: _onUpgrade,
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
        tafsir_en TEXT NOT NULL DEFAULT '',
        tafsir_bn TEXT NOT NULL DEFAULT '',
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

    await _createBookmarksTable(db);

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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createBookmarksTable(db);
    }

    if (oldVersion < 3) {
      await _addTafsirColumns(db);
    }

    if (oldVersion < 4) {
      await _addTafsirColumns(db);
      await _resetTafsirColumns(db);
    }
  }

  Future<void> _createBookmarksTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbConstants.tableBookmarks} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        surah_id INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        CHECK (type IN ('surah', 'ayah')),
        CHECK (
          (type = 'surah' AND ayah_number = 0) OR
          (type = 'ayah' AND ayah_number > 0)
        ),
        UNIQUE(type, surah_id, ayah_number)
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_bookmarks_type_time ON ${DbConstants.tableBookmarks}(type, created_at DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_bookmarks_surah_ayah ON ${DbConstants.tableBookmarks}(surah_id, ayah_number)',
    );
  }

  Future<void> _addTafsirColumns(Database db) async {
    if (!await _hasColumn(db, DbConstants.tableAyahs, 'tafsir_en')) {
      await db.execute(
        "ALTER TABLE ${DbConstants.tableAyahs} ADD COLUMN tafsir_en TEXT NOT NULL DEFAULT ''",
      );
    }

    if (!await _hasColumn(db, DbConstants.tableAyahs, 'tafsir_bn')) {
      await db.execute(
        "ALTER TABLE ${DbConstants.tableAyahs} ADD COLUMN tafsir_bn TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<void> _resetTafsirColumns(Database db) async {
    await db.execute(
      "UPDATE ${DbConstants.tableAyahs} SET tafsir_en = '', tafsir_bn = ''",
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

  Future<bool> hasTafsirData() async {
    final db = await database;

    if (!await _hasColumn(db, DbConstants.tableAyahs, 'tafsir_en')) {
      return false;
    }

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as count
      FROM ${DbConstants.tableAyahs}
      WHERE TRIM(tafsir_en) <> '' OR TRIM(tafsir_bn) <> ''
      ''',
    );
    final count = result.first['count'] as int? ?? 0;
    return count > 0;
  }

  Future<bool> hasLocalizedTafsirData() async {
    final db = await database;

    if (!await _hasColumn(db, DbConstants.tableAyahs, 'tafsir_en')) {
      return false;
    }

    final rows = await db.query(
      DbConstants.tableAyahs,
      columns: const ['tafsir_en', 'tafsir_bn'],
      where: "TRIM(tafsir_en) <> '' OR TRIM(tafsir_bn) <> ''",
      limit: 500,
    );

    for (final row in rows) {
      final tafsirEn = (row['tafsir_en'] as String? ?? '').trim();
      final tafsirBn = (row['tafsir_bn'] as String? ?? '').trim();

      if (_containsLatinScript(tafsirEn) || _containsBanglaScript(tafsirBn)) {
        return true;
      }
    }

    return false;
  }

  Future<void> saveTafsirData({
    required Map<int, String> tafsirEnByAyahId,
    required Map<int, String> tafsirBnByAyahId,
  }) async {
    if (tafsirEnByAyahId.isEmpty && tafsirBnByAyahId.isEmpty) {
      return;
    }

    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      final ayahIds = <int>{
        ...tafsirEnByAyahId.keys,
        ...tafsirBnByAyahId.keys,
      };

      for (final ayahId in ayahIds) {
        final updateMap = <String, Object?>{};
        if (tafsirEnByAyahId.containsKey(ayahId)) {
          updateMap['tafsir_en'] = tafsirEnByAyahId[ayahId];
        }
        if (tafsirBnByAyahId.containsKey(ayahId)) {
          updateMap['tafsir_bn'] = tafsirBnByAyahId[ayahId];
        }
        if (updateMap.isEmpty) {
          continue;
        }

        batch.update(
          DbConstants.tableAyahs,
          updateMap,
          where: 'id = ?',
          whereArgs: [ayahId],
        );
      }

      await batch.commit(noResult: true);
    });
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

  Future<void> addBookmark(BookmarkModel bookmark) async {
    final db = await database;
    await db.insert(
      DbConstants.tableBookmarks,
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeBookmark(
    BookmarkType type, {
    required int surahId,
    int? ayahNumber,
  }) async {
    final db = await database;
    await db.delete(
      DbConstants.tableBookmarks,
      where: 'type = ? AND surah_id = ? AND ayah_number = ?',
      whereArgs: [
        type.dbValue,
        surahId,
        type == BookmarkType.surah ? 0 : (ayahNumber ?? 0),
      ],
    );
  }

  Future<bool> isBookmarked(
    BookmarkType type, {
    required int surahId,
    int? ayahNumber,
  }) async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableBookmarks,
      columns: const ['id'],
      where: 'type = ? AND surah_id = ? AND ayah_number = ?',
      whereArgs: [
        type.dbValue,
        surahId,
        type == BookmarkType.surah ? 0 : (ayahNumber ?? 0),
      ],
      limit: 1,
    );

    return rows.isNotEmpty;
  }

  Future<List<BookmarkModel>> getBookmarks({BookmarkType? type}) async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableBookmarks,
      where: type == null ? null : 'type = ?',
      whereArgs: type == null ? null : [type.dbValue],
      orderBy: 'created_at DESC',
    );

    return rows.map(BookmarkModel.fromMap).toList();
  }

  Future<Set<int>> getBookmarkedSurahIds() async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableBookmarks,
      columns: const ['surah_id'],
      where: 'type = ?',
      whereArgs: [BookmarkType.surah.dbValue],
    );

    return rows.map((row) => row['surah_id']).whereType<int>().toSet();
  }

  Future<Set<int>> getBookmarkedAyahNumbers(int surahId) async {
    final db = await database;
    final rows = await db.query(
      DbConstants.tableBookmarks,
      columns: const ['ayah_number'],
      where: 'type = ? AND surah_id = ?',
      whereArgs: [BookmarkType.ayah.dbValue, surahId],
    );

    return rows.map((row) => row['ayah_number']).whereType<int>().toSet();
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<bool> _hasColumn(
    DatabaseExecutor db,
    String table,
    String column,
  ) async {
    final tableInfo = await db.rawQuery('PRAGMA table_info($table)');
    for (final row in tableInfo) {
      if ((row['name'] as String?) == column) {
        return true;
      }
    }
    return false;
  }

  bool _containsLatinScript(String text) {
    return RegExp(r'[A-Za-z]').hasMatch(text);
  }

  bool _containsBanglaScript(String text) {
    return RegExp(r'[\u0980-\u09FF]').hasMatch(text);
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
