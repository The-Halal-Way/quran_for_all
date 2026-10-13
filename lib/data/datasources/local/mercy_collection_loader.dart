import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/mercy/mercy_collection.dart';

class MercyCollectionLoader {
  MercyCollectionLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<MercyCollection> load(MercyCollectionKind kind) async {
    final raw = await _bundle.loadString(kind.assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Mercy collection is not an object');
    }

    final root = Map<String, dynamic>.from(decoded);
    final section = _map(root['section']);
    final rawEntries = root['items'] ?? root['stories'];
    if (rawEntries is! List) {
      throw const FormatException('Mercy collection has no entries');
    }

    return MercyCollection(
      kind: kind,
      key: _string(section['key']),
      title: _localizedMap(section['title']),
      description: _localizedMap(section['description']),
      contentNote: _localizedMap(section['content_note']),
      entries: List.unmodifiable(
        rawEntries.map(_parseEntry).toList(growable: false),
      ),
    );
  }

  MercyEntry _parseEntry(Object? raw) {
    if (raw is! Map) {
      throw const FormatException('Mercy entry is not an object');
    }
    final entry = Map<String, dynamic>.from(raw);
    return MercyEntry(
      id: (entry['id'] as num?)?.toInt() ?? 0,
      title: _localizedMap(entry['title']),
      content: _localizedMap(entry['content']),
      sourceTitle: _localizedMap(entry['source_title']),
      blocks: _blocksMap(entry['blocks']),
    );
  }

  Map<String, List<MercyBlock>> _blocksMap(Object? raw) {
    if (raw is! Map) return const {};
    final result = <String, List<MercyBlock>>{};
    for (final entry in raw.entries) {
      if (entry.value is! List) continue;
      result[entry.key.toString()] = List.unmodifiable(
        (entry.value as List)
            .whereType<Map>()
            .map(
              (block) => MercyBlock(
                type: _string(block['type']),
                text: _string(block['text']),
              ),
            )
            .where((block) => block.text.isNotEmpty)
            .toList(growable: false),
      );
    }
    return Map.unmodifiable(result);
  }

  Map<String, String> _localizedMap(Object? raw) {
    if (raw is! Map) return const {};
    return Map.unmodifiable({
      for (final entry in raw.entries)
        if (entry.value is String) entry.key.toString(): entry.value as String,
    });
  }

  Map<String, dynamic> _map(Object? raw) =>
      raw is Map ? Map<String, dynamic>.from(raw) : const <String, dynamic>{};

  String _string(Object? value) => value is String ? value.trim() : '';
}
