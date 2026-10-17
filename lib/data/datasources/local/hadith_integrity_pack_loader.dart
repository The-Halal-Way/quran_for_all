import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/hadith_integrity/hadith_integrity_library.dart';

typedef HadithIntegrityAssetLoader = Future<String> Function(String path);

/// Loads the integrity library on demand after the reader route is opened.
class HadithIntegrityPackLoader {
  HadithIntegrityPackLoader({HadithIntegrityAssetLoader? assetLoader})
    : _assetLoader = assetLoader ?? rootBundle.loadString;

  final HadithIntegrityAssetLoader _assetLoader;

  Future<HadithIntegrityLibrary> loadLibrary() async {
    final raw = await Future.wait(
      HadithIntegrityCollectionKind.values.map(
        (kind) => _assetLoader(kind.assetPath),
      ),
    );
    final parsed = <HadithIntegrityCollectionKind, HadithIntegrityCollection>{
      for (var index = 0; index < raw.length; index++)
        HadithIntegrityCollectionKind.values[index]: _parse(
          HadithIntegrityCollectionKind.values[index],
          raw[index],
        ),
    };

    return HadithIntegrityLibrary(
      popularNarrations: [
        parsed[HadithIntegrityCollectionKind.popularPart1]!,
        parsed[HadithIntegrityCollectionKind.popularPart2]!,
        parsed[HadithIntegrityCollectionKind.popularPart3]!,
        parsed[HadithIntegrityCollectionKind.popularPart4]!,
        parsed[HadithIntegrityCollectionKind.popularPart5]!,
      ],
      verificationGuide:
          parsed[HadithIntegrityCollectionKind.verificationGuide]!,
      statusExplained: parsed[HadithIntegrityCollectionKind.statusExplained]!,
      misconceptions: parsed[HadithIntegrityCollectionKind.misconceptions]!,
      authenticWarnings:
          parsed[HadithIntegrityCollectionKind.authenticWarnings]!,
    );
  }

  HadithIntegrityCollection _parse(
    HadithIntegrityCollectionKind kind,
    String raw,
  ) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException(
        'Hadith integrity collection is not an object',
      );
    }
    final root = _map(decoded);
    final section = _map(root['section']);
    return HadithIntegrityCollection(
      kind: kind,
      section: HadithIntegritySection(
        key: section['key']?.toString() ?? kind.name,
        title: HadithIntegrityText(_localized(section['title'])),
        subtitle: HadithIntegrityText(_localized(section['subtitle'])),
        description: HadithIntegrityText(_localized(section['description'])),
        editorialNote: HadithIntegrityText(
          _localized(section['editorial_note']),
        ),
      ),
      items: _items(root['items']),
      statusGroups: _statusGroups(root['groups']),
      displayRules: _displayRules(root['display_rules']),
      sources: _sources(root['sources']),
    );
  }

  List<HadithIntegrityItem> _items(Object? raw) {
    if (raw is! List) return const [];
    return List.unmodifiable(
      raw.whereType<Map>().map((value) {
        final item = _map(value);
        return HadithIntegrityItem(
          id: (item['id'] as num?)?.toInt() ?? 0,
          kind: item['kind']?.toString(),
          type: item['type']?.toString(),
          category: item['category']?.toString(),
          arabic: item['arabic']?.toString(),
          title: _text(item['title']),
          text: _text(item['text']),
          content: _text(item['content']),
          action: _text(item['action']),
          explanation: _text(item['explanation']),
          lesson: _text(item['lesson']),
          misconception: _text(item['misconception']),
          correction: _text(item['correction']),
          userAction: _text(item['user_action']),
          status: _status(item['status']),
          source: _source(item['source']),
          reference: _reference(item['reference']),
        );
      }),
    );
  }

  List<HadithIntegrityStatusGroup> _statusGroups(Object? raw) {
    if (raw is! List) return const [];
    return List.unmodifiable(
      raw.whereType<Map>().map((value) {
        final group = _map(value);
        final items = group['items'];
        return HadithIntegrityStatusGroup(
          key: group['key']?.toString() ?? '',
          title: HadithIntegrityText(_localized(group['title'])),
          items: items is List
              ? List.unmodifiable(
                  items.whereType<Map>().map((rawItem) {
                    final item = _map(rawItem);
                    return HadithIntegrityStatusItem(
                      code: item['code']?.toString() ?? '',
                      arabic: item['arabic']?.toString(),
                      title: HadithIntegrityText(_localized(item['title'])),
                      meaning: HadithIntegrityText(_localized(item['meaning'])),
                      appLabel: _text(item['app_label']),
                      importantNote: _text(item['important_note']),
                    );
                  }),
                )
              : const [],
        );
      }),
    );
  }

  Map<String, List<String>> _displayRules(Object? raw) {
    if (raw is! Map) return const {};
    return Map.unmodifiable({
      for (final entry in raw.entries)
        if (entry.value is List)
          entry.key.toString(): List<String>.unmodifiable(
            (entry.value as List).whereType<String>(),
          ),
    });
  }

  List<HadithIntegritySource> _sources(Object? raw) {
    if (raw is! List) return const [];
    return List.unmodifiable(
      raw.whereType<Map>().map((value) {
        final source = _map(value);
        return HadithIntegritySource(
          title: source['title']?.toString() ?? '',
          url: source['url']?.toString(),
        );
      }),
    );
  }

  HadithIntegrityText? _text(Object? raw) =>
      raw is Map ? HadithIntegrityText(_localized(raw)) : null;

  HadithIntegrityStatus? _status(Object? raw) {
    if (raw is! Map) return null;
    final status = _map(raw);
    return HadithIntegrityStatus(
      code: status['code']?.toString() ?? '',
      label: _text(status['label']) ?? HadithIntegrityText(_localized(status)),
    );
  }

  HadithIntegritySource? _source(Object? raw) {
    if (raw is! Map) return null;
    final source = _map(raw);
    return HadithIntegritySource(
      title: source['title']?.toString() ?? '',
      url: source['url']?.toString(),
    );
  }

  HadithIntegrityReference? _reference(Object? raw) {
    if (raw is! Map) return null;
    final reference = _map(raw);
    return HadithIntegrityReference(
      collection: reference['collection']?.toString(),
      hadithNumber: reference['hadith_number']?.toString(),
      grading: reference['grading']?.toString(),
      url: reference['url']?.toString(),
    );
  }

  Map<String, dynamic> _map(Object? raw) =>
      raw is Map ? Map<String, dynamic>.from(raw) : const <String, dynamic>{};

  Map<String, String> _localized(Object? raw) {
    if (raw is! Map) return const {};
    return Map.unmodifiable({
      for (final entry in raw.entries)
        if (entry.value is String) entry.key.toString(): entry.value as String,
    });
  }
}
