import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/prophecies/prophecy_book.dart';

typedef PropheciesAssetLoader = Future<String> Function(String path);

class PropheciesPackLoader {
  PropheciesPackLoader({PropheciesAssetLoader? assetLoader})
    : _assetLoader = assetLoader ?? rootBundle.loadString;

  static const assetPaths = [
    'assets/json/prophecies_part1.json',
    'assets/json/prophecies_part2.json',
  ];

  final PropheciesAssetLoader _assetLoader;
  ProphecyBook? _cache;
  Future<ProphecyBook>? _inFlight;

  Future<ProphecyBook> load({bool forceRefresh = false}) {
    if (!forceRefresh && _cache != null) return Future.value(_cache);
    if (_inFlight != null) return _inFlight!;
    final operation = _loadAndParse();
    _inFlight = operation;
    operation.then<void>(
      (_) {
        if (identical(_inFlight, operation)) _inFlight = null;
      },
      onError: (Object error, StackTrace stackTrace) {
        if (identical(_inFlight, operation)) _inFlight = null;
      },
    );
    return operation;
  }

  Future<ProphecyBook> _loadAndParse() async {
    final parts = <ProphecyPart>[];
    for (var index = 0; index < assetPaths.length; index++) {
      final raw = await _assetLoader(assetPaths[index]);
      parts.add(_parsePart(jsonDecode(raw), fallbackPartNumber: index + 1));
    }
    final book = ProphecyBook(parts: List.unmodifiable(parts));
    _cache = book;
    return book;
  }

  ProphecyPart _parsePart(Object? raw, {required int fallbackPartNumber}) {
    if (raw is! Map) {
      throw const FormatException('Prophecy pack is not an object');
    }
    final root = Map<String, dynamic>.from(raw);
    final title = _localizedMap(root['title']);
    final partNumber = (root['part'] as num?)?.toInt() ?? fallbackPartNumber;
    final rawItems = root['items'];
    if (rawItems is! List) {
      throw const FormatException('Prophecy pack has no item list');
    }
    return ProphecyPart(
      partNumber: partNumber,
      title: title,
      items: List.unmodifiable(
        rawItems.map((item) => _parseItem(item)).toList(growable: false),
      ),
    );
  }

  ProphecyItem _parseItem(Object? raw) {
    if (raw is! Map) {
      throw const FormatException('Prophecy item is not an object');
    }
    final item = Map<String, dynamic>.from(raw);
    final localization = item['localization'];
    if (localization is! Map) {
      throw const FormatException('Prophecy item has no localization');
    }
    final localized = <String, Map<String, dynamic>>{};
    for (final entry in localization.entries) {
      if (entry.value is Map) {
        localized[entry.key.toString()] = Map<String, dynamic>.from(
          entry.value,
        );
      }
    }
    final titles = <String, String>{};
    final contents = <String, String>{};
    final fallbackContentLocales = <String>{};
    for (final entry in localized.entries) {
      final value = entry.value;
      final title = value['title'];
      final content = value['content'];
      if (title is String && title.trim().isNotEmpty) titles[entry.key] = title;
      if (content is String) {
        contents[entry.key] = content;
        if (value['isFallbackEnglish'] == true ||
            (entry.key != 'en' && content == localized['en']?['content'])) {
          fallbackContentLocales.add(entry.key);
        }
      }
    }
    if (titles.isEmpty) {
      throw const FormatException('Prophecy item has no title');
    }

    final sourceNumbers = (item['sourceNumbers'] is List)
        ? (item['sourceNumbers'] as List)
              .whereType<num>()
              .map((value) => value.toInt())
              .toList()
        : const <int>[];
    final references = <ProphecyReference>[];
    if (item['references'] is List) {
      for (final reference in item['references'] as List) {
        if (reference is! Map) continue;
        final id = (reference['id'] as num?)?.toInt();
        final text = reference['text'];
        if (id != null && text is String && text.trim().isNotEmpty) {
          references.add(ProphecyReference(id: id, text: text));
        }
      }
    }
    final rawDetails = item['detailsPage'];
    ProphecyDetailsPage? detailsPage;
    if (rawDetails is Map && rawDetails['route'] is String) {
      detailsPage = ProphecyDetailsPage(
        route: rawDetails['route'] as String,
        url: rawDetails['url'] is String ? rawDetails['url'] as String : null,
      );
    }
    return ProphecyItem(
      id: item['id']?.toString() ?? '',
      sourceNumbers: List.unmodifiable(sourceNumbers),
      title: Map.unmodifiable(titles),
      content: Map.unmodifiable(contents),
      fallbackContentLocales: Set.unmodifiable(fallbackContentLocales),
      references: List.unmodifiable(references),
      detailsPage: detailsPage,
    );
  }

  Map<String, String> _localizedMap(Object? raw) {
    if (raw is! Map) return const <String, String>{};
    return Map.unmodifiable({
      for (final entry in raw.entries)
        if (entry.value is String) entry.key.toString(): entry.value as String,
    });
  }
}
