import 'dart:ui' show Locale;

class ProphecyBook {
  const ProphecyBook({required this.parts});

  final List<ProphecyPart> parts;

  int get itemCount =>
      parts.fold(0, (total, part) => total + part.items.length);
}

class ProphecyPart {
  const ProphecyPart({
    required this.partNumber,
    required this.title,
    required this.items,
  });

  final int partNumber;
  final Map<String, String> title;
  final List<ProphecyItem> items;

  String localizedTitle(Locale locale) =>
      title[locale.languageCode] ?? title['en'] ?? title.values.first;
}

class ProphecyItem {
  const ProphecyItem({
    required this.id,
    required this.sourceNumbers,
    required this.title,
    required this.content,
    required this.fallbackContentLocales,
    required this.references,
    required this.detailsPage,
  });

  final String id;
  final List<int> sourceNumbers;
  final Map<String, String> title;
  final Map<String, String> content;
  final Set<String> fallbackContentLocales;
  final List<ProphecyReference> references;
  final ProphecyDetailsPage? detailsPage;

  String localizedTitle(Locale locale) =>
      title[locale.languageCode] ?? title['en'] ?? title.values.first;

  String localizedContent(Locale locale) {
    final languageCode = locale.languageCode;
    final localized = content[languageCode];
    if (localized != null && !fallbackContentLocales.contains(languageCode)) {
      return localized;
    }
    return content['en'] ?? (content.isEmpty ? '' : content.values.first);
  }

  bool usesEnglishFallback(Locale locale) {
    final languageCode = locale.languageCode;
    return languageCode != 'en' &&
        (fallbackContentLocales.contains(languageCode) ||
            !content.containsKey(languageCode));
  }
}

class ProphecyReference {
  const ProphecyReference({required this.id, required this.text});

  final int id;
  final String text;
}

class ProphecyDetailsPage {
  const ProphecyDetailsPage({required this.route, this.url});

  final String route;
  final String? url;
}
