import 'dart:ui' show Locale;

enum HadithIntegrityCollectionKind {
  popularPart1,
  popularPart2,
  popularPart3,
  popularPart4,
  popularPart5,
  verificationGuide,
  statusExplained,
  misconceptions,
  authenticWarnings,
}

extension HadithIntegrityCollectionKindX on HadithIntegrityCollectionKind {
  String get assetPath => switch (this) {
    HadithIntegrityCollectionKind.popularPart1 =>
      'assets/json/hadith_integrity/unauthenticated_hadiths_part_1.json',
    HadithIntegrityCollectionKind.popularPart2 =>
      'assets/json/hadith_integrity/unauthenticated_hadiths_part_2.json',
    HadithIntegrityCollectionKind.popularPart3 =>
      'assets/json/hadith_integrity/unauthenticated_hadiths_part_3.json',
    HadithIntegrityCollectionKind.popularPart4 =>
      'assets/json/hadith_integrity/unauthenticated_hadiths_part_4.json',
    HadithIntegrityCollectionKind.popularPart5 =>
      'assets/json/hadith_integrity/unauthenticated_hadiths_part_5.json',
    HadithIntegrityCollectionKind.verificationGuide =>
      'assets/json/hadith_integrity/hadith_verification_guide.json',
    HadithIntegrityCollectionKind.statusExplained =>
      'assets/json/hadith_integrity/hadith_status_explained.json',
    HadithIntegrityCollectionKind.misconceptions =>
      'assets/json/hadith_integrity/hadith_misconceptions.json',
    HadithIntegrityCollectionKind.authenticWarnings =>
      'assets/json/hadith_integrity/authentic_warnings_against_fabrication.json',
  };

  bool get isPopularNarrations => switch (this) {
    HadithIntegrityCollectionKind.popularPart1 ||
    HadithIntegrityCollectionKind.popularPart2 ||
    HadithIntegrityCollectionKind.popularPart3 ||
    HadithIntegrityCollectionKind.popularPart4 ||
    HadithIntegrityCollectionKind.popularPart5 => true,
    _ => false,
  };
}

class HadithIntegrityLibrary {
  const HadithIntegrityLibrary({
    required this.popularNarrations,
    required this.verificationGuide,
    required this.statusExplained,
    required this.misconceptions,
    required this.authenticWarnings,
  });

  final List<HadithIntegrityCollection> popularNarrations;
  final HadithIntegrityCollection verificationGuide;
  final HadithIntegrityCollection statusExplained;
  final HadithIntegrityCollection misconceptions;
  final HadithIntegrityCollection authenticWarnings;

  Iterable<HadithIntegrityCollection> get collections sync* {
    yield* popularNarrations;
    yield verificationGuide;
    yield statusExplained;
    yield misconceptions;
    yield authenticWarnings;
  }
}

class HadithIntegrityCollection {
  const HadithIntegrityCollection({
    required this.kind,
    required this.section,
    required this.items,
    required this.statusGroups,
    required this.displayRules,
    required this.sources,
  });

  final HadithIntegrityCollectionKind kind;
  final HadithIntegritySection section;
  final List<HadithIntegrityItem> items;
  final List<HadithIntegrityStatusGroup> statusGroups;
  final Map<String, List<String>> displayRules;
  final List<HadithIntegritySource> sources;

  String localizedTitle(Locale locale) => section.title.localized(locale);

  String localizedSubtitle(Locale locale) => section.subtitle.localized(locale);

  String localizedDescription(Locale locale) =>
      section.description.localized(locale);

  String localizedEditorialNote(Locale locale) =>
      section.editorialNote.localized(locale);
}

class HadithIntegritySection {
  const HadithIntegritySection({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.editorialNote,
  });

  final String key;
  final HadithIntegrityText title;
  final HadithIntegrityText subtitle;
  final HadithIntegrityText description;
  final HadithIntegrityText editorialNote;
}

class HadithIntegrityItem {
  const HadithIntegrityItem({
    required this.id,
    required this.kind,
    required this.type,
    required this.category,
    required this.arabic,
    required this.title,
    required this.text,
    required this.content,
    required this.action,
    required this.explanation,
    required this.lesson,
    required this.misconception,
    required this.correction,
    required this.userAction,
    required this.status,
    required this.source,
    required this.reference,
  });

  final int id;
  final String? kind;
  final String? type;
  final String? category;
  final String? arabic;
  final HadithIntegrityText? title;
  final HadithIntegrityText? text;
  final HadithIntegrityText? content;
  final HadithIntegrityText? action;
  final HadithIntegrityText? explanation;
  final HadithIntegrityText? lesson;
  final HadithIntegrityText? misconception;
  final HadithIntegrityText? correction;
  final HadithIntegrityText? userAction;
  final HadithIntegrityStatus? status;
  final HadithIntegritySource? source;
  final HadithIntegrityReference? reference;

  String localized(String field, Locale locale) {
    final text = switch (field) {
      'title' => title,
      'text' => textValue,
      'content' => content,
      'action' => action,
      'explanation' => explanation,
      'lesson' => lesson,
      'misconception' => misconception,
      'correction' => correction,
      'user_action' => userAction,
      'status' => status?.label,
      _ => null,
    };
    return text?.localized(locale) ?? '';
  }

  HadithIntegrityText? get textValue => text;

  String plain(String field) => switch (field) {
    'arabic' => arabic ?? '',
    'kind' => kind ?? '',
    'type' => type ?? '',
    'category' => category ?? '',
    'status_code' => status?.code ?? '',
    _ => '',
  };
}

class HadithIntegrityStatus {
  const HadithIntegrityStatus({required this.code, required this.label});

  final String code;
  final HadithIntegrityText label;
}

class HadithIntegrityReference {
  const HadithIntegrityReference({
    required this.collection,
    required this.hadithNumber,
    required this.grading,
    required this.url,
  });

  final String? collection;
  final String? hadithNumber;
  final String? grading;
  final String? url;
}

class HadithIntegrityStatusGroup {
  const HadithIntegrityStatusGroup({
    required this.key,
    required this.title,
    required this.items,
  });

  final String key;
  final HadithIntegrityText title;
  final List<HadithIntegrityStatusItem> items;
}

class HadithIntegrityStatusItem {
  const HadithIntegrityStatusItem({
    required this.code,
    required this.arabic,
    required this.title,
    required this.meaning,
    required this.appLabel,
    required this.importantNote,
  });

  final String code;
  final String? arabic;
  final HadithIntegrityText title;
  final HadithIntegrityText meaning;
  final HadithIntegrityText? appLabel;
  final HadithIntegrityText? importantNote;
}

class HadithIntegritySource {
  const HadithIntegritySource({required this.title, required this.url});

  final String title;
  final String? url;
}

class HadithIntegrityText {
  const HadithIntegrityText(this.values);

  final Map<String, String> values;

  String localized(Locale locale) =>
      values[locale.languageCode] ??
      values['en'] ??
      values.values.firstOrNull ??
      '';
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
