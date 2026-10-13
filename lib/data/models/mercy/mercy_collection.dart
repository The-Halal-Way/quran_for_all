import 'dart:ui' show Locale;

enum MercyCollectionKind { hadith, stories }

extension MercyCollectionKindX on MercyCollectionKind {
  String get assetPath => switch (this) {
    MercyCollectionKind.hadith => 'assets/json/hadith_for_the_heart.json',
    MercyCollectionKind.stories =>
      'assets/json/stories_that_touch_the_heart.json',
  };
}

class MercyCollection {
  const MercyCollection({
    required this.kind,
    required this.key,
    required this.title,
    required this.description,
    required this.contentNote,
    required this.entries,
  });

  final MercyCollectionKind kind;
  final String key;
  final Map<String, String> title;
  final Map<String, String> description;
  final Map<String, String> contentNote;
  final List<MercyEntry> entries;

  String localizedTitle(Locale locale) => _localized(title, locale);

  String localizedDescription(Locale locale) => _localized(description, locale);

  String localizedContentNote(Locale locale) => _localized(contentNote, locale);

  String _localized(Map<String, String> values, Locale locale) =>
      values[locale.languageCode] ??
      values['en'] ??
      values.values.firstOrNull ??
      '';
}

class MercyEntry {
  const MercyEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.sourceTitle,
    required this.blocks,
  });

  final int id;
  final Map<String, String> title;
  final Map<String, String> content;
  final Map<String, String> sourceTitle;
  final Map<String, List<MercyBlock>> blocks;

  String localizedTitle(Locale locale) => _localized(title, locale);

  String localizedContent(Locale locale) => _localized(content, locale);

  String localizedSourceTitle(Locale locale) => _localized(sourceTitle, locale);

  List<MercyBlock> localizedBlocks(Locale locale) {
    final localized = blocks[locale.languageCode] ?? blocks['en'];
    if (localized != null && localized.isNotEmpty) return localized;

    return localizedContent(locale)
        .split(RegExp(r'\n\s*\n|\n'))
        .map((text) => text.trim())
        .where((text) => text.isNotEmpty)
        .map((text) => MercyBlock(type: 'paragraph', text: text))
        .toList(growable: false);
  }

  String _localized(Map<String, String> values, Locale locale) =>
      values[locale.languageCode] ??
      values['en'] ??
      values.values.firstOrNull ??
      '';
}

class MercyBlock {
  const MercyBlock({required this.type, required this.text});

  final String type;
  final String text;
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
