import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../../models/ruqyah/ruqyah_index.dart';
import '../../../models/ruqyah/ruqyah_reading.dart';
import '../../../models/ruqyah/ruqyah_routine.dart';
import '../../../models/ruqyah/ruqyah_text.dart';

/// Constructing this loader performs no I/O. Failed loads can be retried.
class RuqyahAssetLoader {
  RuqyahAssetLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  final _cache = <String, Future<RuqyahJson>>{};
  final _loaded = <String, RuqyahJson>{};
  static const directory = 'assets/json/ruqyah';

  Future<RuqyahJson> _load(String file) {
    final loaded = _loaded[file];
    if (loaded != null) return Future.value(loaded);
    return _cache.putIfAbsent(file, () async {
      try {
        final text = await _bundle.loadString('$directory/$file');
        final json = text.length > 48000
            ? await compute(_decodeRuqyah, text)
            : _decodeRuqyah(text);
        checkRuqyahVersion(json);
        _loaded[file] = json;
        return json;
      } catch (_) {
        _cache.remove(file);
        rethrow;
      }
    });
  }

  Future<RuqyahIndex> loadIndex() async =>
      RuqyahIndex.fromJson(await _load('index.json'));

  Future<Map<String, RuqyahReading>> loadReadings(
    String language, {
    bool includeExtended = false,
  }) async {
    final code = language == 'bn' ? 'bn' : 'en';
    final index = await loadIndex();
    final entries = <String, RuqyahReading>{};
    for (final pack in ['core', if (includeExtended) 'extended']) {
      final prefix = pack == 'core' ? 'readings' : 'long_readings';
      final raw = await _load('$prefix.json');
      final localized = await _load('${prefix}_$code.json');
      if (localized['language'] != code) {
        throw const FormatException('Wrong Ruqyah language pack.');
      }
      final translations = ruqyahObject(localized['readings']);
      final summaries = index.readings.where((s) => s.pack == pack).toList();
      if (translations.length != summaries.length) {
        throw const FormatException('Incompatible Ruqyah translation pack.');
      }
      final loaded = <String>{};
      for (final json in ruqyahObjects(raw['readings'])) {
        final id = ruqyahString(json['id']);
        final summary = summaries.where((e) => e.id == id).firstOrNull;
        if (summary == null || entries.containsKey(id)) {
          throw const FormatException('Incompatible Ruqyah reading pack.');
        }
        entries[id] = RuqyahReading(
          summary: summary,
          json: json,
          translation: ruqyahObject(translations[id]),
        );
        loaded.add(id);
      }
      if (loaded.length != summaries.length) {
        throw const FormatException('Missing Ruqyah readings.');
      }
    }
    return Map.unmodifiable(entries);
  }

  Future<RuqyahRoutine> loadRoutine(String id) async {
    final index = await loadIndex();
    final summary = index.routines.where((r) => r.id == id).firstOrNull;
    if (summary == null) throw const FormatException('Missing Ruqyah routine.');
    final raw = await _load(
      summary.collection == null ? 'routines.json' : 'collections.json',
    );
    final routine = ruqyahObjects(
      raw['routines'],
    ).where((e) => e['id'] == id).firstOrNull;
    if (routine == null) throw const FormatException('Missing Ruqyah routine.');
    final result = RuqyahRoutine.fromJson(
      routine,
      index.readings.map((e) => e.id).toSet(),
    );
    if (summary.guideId != result.summary.guideId ||
        summary.group != result.summary.group ||
        summary.reported != result.summary.reported ||
        summary.collection?.verseCount !=
            result.summary.collection?.verseCount ||
        summary.collection?.surahCount !=
            result.summary.collection?.surahCount ||
        summary.collection?.passageCount !=
            result.summary.collection?.passageCount) {
      throw const FormatException('Incompatible Ruqyah routine metadata.');
    }
    return result;
  }

  Future<List<RuqyahGuide>> loadGuides(String language) async {
    final code = language == 'bn' ? 'bn' : 'en';
    final index = await loadIndex();
    final raw = await _load('guides_$code.json');
    if (raw['language'] != code) {
      throw const FormatException('Wrong guide language.');
    }
    final guides = List<RuqyahGuide>.unmodifiable(
      ruqyahObjects(raw['guides']).map(RuqyahGuide.fromJson),
    );
    final readingIds = index.readings.map((r) => r.id).toSet();
    final routineIds = index.routines.map((r) => r.id).toSet();
    if (guides.length != index.guides.length ||
        guides.map((g) => g.id).toSet().length != guides.length) {
      throw const FormatException('Incompatible Ruqyah guide pack.');
    }
    for (final guide in guides) {
      final summary = index.guides.where((g) => g.id == guide.id).firstOrNull;
      if (summary == null ||
          summary.group != guide.group ||
          summary.basis != guide.basis ||
          guide.readingIds.any((id) => !readingIds.contains(id)) ||
          guide.routineIds.any((id) => !routineIds.contains(id))) {
        throw const FormatException('Invalid Ruqyah guide references.');
      }
    }
    return guides;
  }
}

RuqyahJson _decodeRuqyah(String text) => ruqyahObject(jsonDecode(text));
