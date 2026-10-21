import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../../../models/quiz/quiz_attempt.dart';
import '../../../models/quiz/quiz_json.dart';

/// A feature-owned database, opened only on entry. Large question snapshots
/// never inflate the global SharedPreferences loaded during app startup.
class QuizLocalStore {
  QuizLocalStore({required this.databaseName});
  final String databaseName;
  Future<Database>? _database;
  Future<Database> get database =>
      _database ??= _open().catchError((Object error) {
        _database = null;
        throw error;
      });

  Future<Database> _open() async => openDatabase(
    path.join(await getDatabasesPath(), databaseName),
    version: 1,
    singleInstance: false,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE attempts ('
        'id TEXT PRIMARY KEY, quiz_id TEXT NOT NULL, status TEXT NOT NULL, '
        'updated_utc TEXT NOT NULL, completed_utc TEXT, summary TEXT, payload TEXT NOT NULL)',
      );
      await db.execute(
        "CREATE UNIQUE INDEX one_incomplete ON attempts(status) WHERE status = 'inProgress'",
      );
      await db.execute(
        'CREATE INDEX completed_attempts ON attempts(status, completed_utc DESC)',
      );
      await db.execute(
        'CREATE TABLE exposures (question_id TEXT PRIMARY KEY, last_seen_utc TEXT NOT NULL)',
      );
    },
  );

  Future<QuizAttempt?> loadActive() async {
    final rows = await (await database).query(
      'attempts',
      columns: ['payload'],
      where: 'status = ?',
      whereArgs: [QuizAttemptStatus.inProgress.name],
      limit: 1,
    );
    return rows.isEmpty
        ? null
        : _decodeAttempt(rows.single['payload'] as String);
  }

  Future<QuizAttempt> loadAttempt(String id) async {
    final rows = await (await database).query(
      'attempts',
      columns: ['payload'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) throw const FormatException('Saved attempt not found');
    return _decodeAttempt(rows.single['payload'] as String);
  }

  Future<List<QuizAttemptSummary>> loadHistory() async {
    final rows = await (await database).query(
      'attempts',
      columns: ['summary'],
      where: 'status = ?',
      whereArgs: [QuizAttemptStatus.completed.name],
      orderBy: 'completed_utc DESC',
    );
    return compute(
      _decodeSummaries,
      rows.map((row) => row['summary'] as String).toList(),
    );
  }

  Future<Map<String, DateTime>> loadExposures() async {
    final rows = await (await database).query('exposures');
    return {
      for (final row in rows)
        row['question_id'] as String: DateTime.parse(
          row['last_seen_utc'] as String,
        ).toUtc(),
    };
  }

  Future<void> save(
    QuizAttempt attempt, {
    String? displayedQuestionId,
    DateTime? displayedAt,
  }) async {
    final encoded = await compute(_encodeAttempt, attempt);
    await (await database).transaction((transaction) async {
      if (attempt.status == QuizAttemptStatus.inProgress) {
        final other = await transaction.query(
          'attempts',
          columns: ['id'],
          where: 'status = ? AND id != ?',
          whereArgs: [QuizAttemptStatus.inProgress.name, attempt.id],
          limit: 1,
        );
        if (other.isNotEmpty) {
          throw StateError('Another incomplete attempt exists');
        }
      }
      final values = <String, Object?>{
        'id': attempt.id,
        'quiz_id': attempt.config.quizId,
        'status': attempt.status.name,
        'updated_utc': attempt.updatedAtUtc.toIso8601String(),
        'completed_utc': attempt.completedAtUtc?.toIso8601String(),
        'summary': attempt.result == null
            ? null
            : jsonEncode(QuizAttemptSummary.fromAttempt(attempt).toJson()),
        'payload': encoded,
      };
      final updated = await transaction.update(
        'attempts',
        values,
        where: 'id = ?',
        whereArgs: [attempt.id],
      );
      if (updated == 0) await transaction.insert('attempts', values);
      if (displayedQuestionId != null) {
        await transaction.insert('exposures', {
          'question_id': displayedQuestionId,
          'last_seen_utc': displayedAt!.toUtc().toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> close() async {
    final pending = _database;
    _database = null;
    if (pending != null) await (await pending).close();
  }
}

String _encodeAttempt(QuizAttempt attempt) => jsonEncode(attempt.toJson());
Future<QuizAttempt> _decodeAttempt(String raw) =>
    compute(_parseAttempt, raw, debugLabel: 'knowledge-assessment-resume');
QuizAttempt _parseAttempt(String raw) =>
    QuizAttempt.fromJson(quizMap(jsonDecode(raw)));
List<QuizAttemptSummary> _decodeSummaries(List<String> raw) => raw
    .map((value) => QuizAttemptSummary.fromJson(quizMap(jsonDecode(value))))
    .toList(growable: false);
