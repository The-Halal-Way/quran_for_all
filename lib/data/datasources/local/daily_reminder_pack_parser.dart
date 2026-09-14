import 'dart:convert';
import 'dart:ui' show TextDirection;

import '../../models/daily_reminders/daily_reminder_pack.dart';

/// Pure entry point used by [compute]. Asset and plugin access must stay out of
/// this function so decode, validation, and typed conversion all run together.
DailyReminderPack parseDailyReminderPack(String rawJson) {
  final decoded = jsonDecode(rawJson);
  final root = _map(decoded, 'root');
  if (_integer(root, 'schemaVersion') != 2) {
    throw const FormatException('Daily reminder schemaVersion must be 2');
  }

  final packId = _string(root, 'packId');
  final revision = _integer(root, 'revision');
  final defaultLocale = _string(root, 'defaultLocale').toLowerCase();
  final supportedLocales = _strings(root, 'supportedLocales');
  if (!supportedLocales.contains(defaultLocale)) {
    throw const FormatException('defaultLocale must be supported');
  }

  final sources = _parseSources(_map(root['sources'], 'sources'));
  final passages = _parsePassages(_map(root['passages'], 'passages'), sources);
  final assets = _parseAssets(_map(root['assets'], 'assets'));
  final unavailable = <String>{};
  final itemIds = <String>{};
  final items = <DailyReminderItem>[];
  for (final rawItem in _list(root, 'items')) {
    final itemMap = _map(rawItem, 'item');
    final item = _parseItem(
      itemMap,
      packRevision: revision,
      sources: sources,
      passages: passages,
      assets: assets,
      unavailable: unavailable,
    );
    if (!itemIds.add(item.id)) {
      throw FormatException('Duplicate item id: ${item.id}');
    }
    items.add(item);
  }

  final scheduleIds = <String>{};
  final scheduledContentIds = <String>{};
  final schedule = <DailyReminderSchedule>[];
  for (final rawEntry in _list(root, 'schedule')) {
    final entry = _parseSchedule(_map(rawEntry, 'schedule entry'));
    if (!scheduleIds.add(entry.id)) {
      throw FormatException('Duplicate schedule id: ${entry.id}');
    }
    if (!itemIds.contains(entry.contentId)) {
      throw FormatException('Unknown scheduled content: ${entry.contentId}');
    }
    if (!scheduledContentIds.add(entry.contentId)) {
      throw FormatException(
        'Content scheduled more than once: ${entry.contentId}',
      );
    }
    schedule.add(entry);
  }
  schedule.sort((a, b) => a.localDate.compareTo(b.localDate));
  for (var i = 1; i < schedule.length; i++) {
    final expected = schedule[i - 1].localDate.toLocalDateTime().add(
      const Duration(days: 1),
    );
    if (schedule[i].localDate != LocalCalendarDate.fromDateTime(expected)) {
      throw FormatException(
        'Schedule is not consecutive at ${schedule[i].localDate}',
      );
    }
  }

  final metadata = _map(root['metadata'], 'metadata');
  final declaredCount = _integer(metadata, 'dayCount');
  if (declaredCount != items.length || declaredCount != schedule.length) {
    throw const FormatException('Metadata dayCount does not match pack');
  }
  final declaredStart = LocalCalendarDate.parse(_string(metadata, 'startDate'));
  final declaredEnd = LocalCalendarDate.parse(_string(metadata, 'endDate'));
  if (schedule.isEmpty ||
      schedule.first.localDate != declaredStart ||
      schedule.last.localDate != declaredEnd) {
    throw const FormatException('Metadata dates do not match schedule');
  }

  final retention = _map(root['retentionPolicy'], 'retentionPolicy');
  return DailyReminderPack(
    packId: packId,
    revision: revision,
    defaultLocale: defaultLocale,
    supportedLocales: List.unmodifiable(supportedLocales),
    reviewStatus: _string(metadata, 'reviewStatus'),
    sources: Map.unmodifiable(sources),
    passages: Map.unmodifiable(passages),
    assets: Map.unmodifiable(assets),
    items: List.unmodifiable(items),
    schedule: List.unmodifiable(schedule),
    retentionPolicy: DailyReminderRetentionPolicy(
      keepReleasedContent: _boolean(retention, 'keepReleasedContent'),
      keepReadContent: _boolean(retention, 'keepReadContent'),
      keepUnreadContent: _boolean(retention, 'keepUnreadContent'),
      hideFutureContent: _boolean(retention, 'hideFutureContent'),
      autoDelete: _boolean(retention, 'autoDelete'),
    ),
    unavailableItemIds: Set.unmodifiable(unavailable),
  );
}

Map<String, DailyReminderSource> _parseSources(Map<String, dynamic> raw) {
  final result = <String, DailyReminderSource>{};
  for (final entry in raw.entries) {
    final value = _map(entry.value, 'source ${entry.key}');
    final id = _string(value, 'id');
    if (id != entry.key) throw FormatException('Source key/id mismatch: $id');
    final type = _string(value, 'type');
    if (type != 'quran' && type != 'hadith') {
      throw FormatException('Unsupported source type: $type');
    }
    final url = _string(value, 'url');
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw FormatException('Invalid source URL: $url');
    }
    result[id] = DailyReminderSource(
      id: id,
      type: type,
      displayName: _string(value, 'displayName'),
      url: url,
      surah: _optionalInt(value, 'surah'),
      verseStart: _optionalInt(value, 'verseStart'),
      verseEnd: _optionalInt(value, 'verseEnd'),
      collection: _optionalString(value, 'collection'),
      referenceNumber: _optionalString(value, 'referenceNumber'),
      numberingEdition: _optionalString(value, 'numberingEdition'),
      grading: _optionalString(value, 'grading'),
    );
  }
  return result;
}

Map<String, DailyReminderPassage> _parsePassages(
  Map<String, dynamic> raw,
  Map<String, DailyReminderSource> sources,
) {
  final result = <String, DailyReminderPassage>{};
  for (final entry in raw.entries) {
    final value = _map(entry.value, 'passage ${entry.key}');
    final id = _string(value, 'id');
    if (id != entry.key) throw FormatException('Passage key/id mismatch: $id');
    final sourceIds = _strings(value, 'sourceIds');
    _validateLinks(sourceIds, sources.keys, 'passage source');
    result[id] = DailyReminderPassage(
      id: id,
      language: _string(value, 'language'),
      direction: _direction(_string(value, 'direction')),
      text: _string(value, 'text'),
      isExcerpt: _boolean(value, 'isExcerpt'),
      sourceIds: List.unmodifiable(sourceIds),
    );
  }
  return result;
}

Map<String, DailyReminderAsset> _parseAssets(Map<String, dynamic> raw) {
  final result = <String, DailyReminderAsset>{};
  for (final entry in raw.entries) {
    final value = _map(entry.value, 'asset ${entry.key}');
    final id = _string(value, 'id');
    if (id != entry.key) throw FormatException('Asset key/id mismatch: $id');
    final bundled = _optionalString(value, 'bundledAssetPath');
    final remote = _optionalString(value, 'remoteUrl');
    if ((bundled == null || bundled.isEmpty) &&
        (remote == null || remote.isEmpty)) {
      throw FormatException('Asset has no location: $id');
    }
    result[id] = DailyReminderAsset(
      id: id,
      mimeType: _string(value, 'mimeType'),
      bundledAssetPath: bundled,
      remoteUrl: remote,
    );
  }
  return result;
}

DailyReminderItem _parseItem(
  Map<String, dynamic> raw, {
  required int packRevision,
  required Map<String, DailyReminderSource> sources,
  required Map<String, DailyReminderPassage> passages,
  required Map<String, DailyReminderAsset> assets,
  required Set<String> unavailable,
}) {
  final id = _string(raw, 'id');
  if (_integer(raw, 'schemaVersion') != 2) {
    throw FormatException('Item $id has unsupported schema');
  }
  final sourceIds = _strings(raw, 'sourceIds');
  final passageIds = _strings(raw, 'originalPassageIds');
  _validateLinks(sourceIds, sources.keys, 'item source');
  _validateLinks(passageIds, passages.keys, 'original passage');

  final editionMap = _map(raw['editions'], 'item editions');
  final editions = <String, DailyReminderEdition>{};
  for (final entry in editionMap.entries) {
    final locale = entry.key.toLowerCase();
    final parsed = _parseEdition(
      _map(entry.value, 'edition $locale'),
      itemId: id,
      sources: sources,
      passages: passages,
      assets: assets,
      unavailable: unavailable,
    );
    if (parsed.locale.toLowerCase() != locale) {
      throw FormatException('Edition locale key mismatch on $id');
    }
    editions[locale] = parsed;
  }
  if (editions.isEmpty) throw FormatException('Item $id has no editions');
  final revision = _integer(raw, 'revision');
  if (revision > packRevision) {
    throw FormatException('Item revision exceeds pack revision: $id');
  }
  return DailyReminderItem(
    id: id,
    revision: revision,
    sequence: _integer(raw, 'sequence'),
    kind: _string(raw, 'kind'),
    tags: List.unmodifiable(_strings(raw, 'tags')),
    defaultLocale: _string(raw, 'defaultLocale').toLowerCase(),
    sourceIds: List.unmodifiable(sourceIds),
    originalPassageIds: List.unmodifiable(passageIds),
    editions: Map.unmodifiable(editions),
    status: _string(raw, 'status'),
    updatedAt: DateTime.parse(_string(raw, 'updatedAt')),
    editorialNote: _string(raw, 'editorialNote'),
  );
}

DailyReminderEdition _parseEdition(
  Map<String, dynamic> raw, {
  required String itemId,
  required Map<String, DailyReminderSource> sources,
  required Map<String, DailyReminderPassage> passages,
  required Map<String, DailyReminderAsset> assets,
  required Set<String> unavailable,
}) {
  final blockIds = <String>{};
  final blocks = <DailyReminderBlock>[];
  for (final rawBlock in _list(raw, 'blocks')) {
    final map = _map(rawBlock, 'block');
    final id = _string(map, 'id');
    if (!blockIds.add(id)) throw FormatException('Duplicate block id: $id');
    final required = map['required'] as bool? ?? false;
    final typeName = _string(map, 'type');
    final type = _blockType(typeName);
    if (type == null) {
      if (required) unavailable.add(itemId);
      continue;
    }
    final sourceIds = _optionalStrings(map, 'sourceIds');
    _validateLinks(sourceIds, sources.keys, 'block source');
    final passageId = _optionalString(map, 'passageId');
    if (passageId != null && !passages.containsKey(passageId)) {
      throw FormatException('Unknown passage link: $passageId');
    }
    final assetId = _optionalString(map, 'assetId');
    if (assetId != null && !assets.containsKey(assetId)) {
      throw FormatException('Unknown asset link: $assetId');
    }
    blocks.add(
      DailyReminderBlock(
        id: id,
        type: type,
        required: required,
        role: _optionalString(map, 'role'),
        language: _optionalString(map, 'language'),
        direction: _direction(_optionalString(map, 'direction') ?? 'ltr'),
        text: _optionalString(map, 'text'),
        label: _optionalString(map, 'label'),
        style: _optionalString(map, 'style'),
        actionType: _optionalString(map, 'actionType'),
        targetId: _optionalString(map, 'targetId'),
        value: _optionalString(map, 'value'),
        passageId: passageId,
        assetId: assetId,
        sourceIds: List.unmodifiable(sourceIds),
        items: List.unmodifiable(_optionalStrings(map, 'items')),
        ordered: map['ordered'] as bool? ?? false,
        level: _optionalInt(map, 'level'),
        translator: _optionalString(map, 'translator'),
        scheme: _optionalString(map, 'scheme'),
        altText: _optionalString(map, 'altText'),
        caption: _optionalString(map, 'caption'),
        transcript: _optionalString(map, 'transcript'),
      ),
    );
  }
  final notification = _map(raw['notification'], 'notification');
  final imageAssetId = _optionalString(notification, 'imageAssetId');
  if (imageAssetId != null && !assets.containsKey(imageAssetId)) {
    throw FormatException('Unknown notification asset: $imageAssetId');
  }
  return DailyReminderEdition(
    locale: _string(raw, 'locale').toLowerCase(),
    title: _string(raw, 'title'),
    summary: _string(raw, 'summary'),
    notification: DailyReminderNotificationCopy(
      title: _string(notification, 'title'),
      body: _string(notification, 'body'),
      imageAssetId: imageAssetId,
    ),
    blocks: List.unmodifiable(blocks),
    reviewStatus: _string(raw, 'reviewStatus'),
    basedOnRevision: _integer(raw, 'basedOnRevision'),
  );
}

DailyReminderSchedule _parseSchedule(Map<String, dynamic> raw) {
  final purpose = _string(raw, 'purpose');
  if (purpose != 'dailyRelease') {
    throw FormatException('Unsupported schedule purpose: $purpose');
  }
  return DailyReminderSchedule(
    id: _string(raw, 'id'),
    contentId: _string(raw, 'contentId'),
    localDate: LocalCalendarDate.parse(_string(raw, 'localDate')),
    purpose: purpose,
    sendNotification: _boolean(raw, 'sendNotification'),
  );
}

DailyReminderBlockType? _blockType(String value) {
  for (final type in DailyReminderBlockType.values) {
    if (type.name == value) return type;
  }
  return null;
}

TextDirection _direction(String value) => switch (value) {
  'rtl' => TextDirection.rtl,
  'ltr' => TextDirection.ltr,
  _ => throw FormatException('Unsupported text direction: $value'),
};

void _validateLinks(
  Iterable<String> ids,
  Iterable<String> valid,
  String label,
) {
  final validSet = valid.toSet();
  for (final id in ids) {
    if (!validSet.contains(id)) throw FormatException('Unknown $label: $id');
  }
}

Map<String, dynamic> _map(Object? value, String label) {
  if (value is! Map) throw FormatException('$label must be an object');
  return value.map((key, value) => MapEntry(key.toString(), value));
}

List<dynamic> _list(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is! List) throw FormatException('$key must be a list');
  return value;
}

String _string(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$key must be a non-empty string');
  }
  return value;
}

String? _optionalString(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value == null) return null;
  if (value is! String) throw FormatException('$key must be a string');
  return value;
}

int _integer(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is! int) throw FormatException('$key must be an integer');
  return value;
}

int? _optionalInt(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value == null) return null;
  if (value is! int) throw FormatException('$key must be an integer');
  return value;
}

bool _boolean(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is! bool) throw FormatException('$key must be a boolean');
  return value;
}

List<String> _strings(Map<String, dynamic> map, String key) {
  final value = _list(map, key);
  if (value.any((entry) => entry is! String)) {
    throw FormatException('$key must contain strings');
  }
  return value.cast<String>();
}

List<String> _optionalStrings(Map<String, dynamic> map, String key) =>
    map[key] == null ? const [] : _strings(map, key);
