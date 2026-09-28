import 'package:flutter/material.dart';

class NeedText {
  const NeedText(this.en, this.bn);

  final String en;
  final String bn;

  String of(bool isBangla) => isBangla ? bn : en;
}

enum NeedCategory { quran, salah, dhikr, dua, charity, specialTimes }

extension NeedCategoryDetails on NeedCategory {
  NeedText get title => switch (this) {
    NeedCategory.quran => const NeedText(
      'Quran Based Amals',
      'কুরআনভিত্তিক আমল',
    ),
    NeedCategory.salah => const NeedText(
      'Salah Based Amals',
      'নামাজভিত্তিক আমল',
    ),
    NeedCategory.dhikr => const NeedText(
      'Dhikr Based Amals',
      'জিকিরভিত্তিক আমল',
    ),
    NeedCategory.dua => const NeedText('Dua Based Amals', 'দোয়াভিত্তিক আমল'),
    NeedCategory.charity => const NeedText(
      'Charity Based Amals',
      'দানভিত্তিক আমল',
    ),
    NeedCategory.specialTimes => const NeedText(
      'Special Times for Dua',
      'দোয়ার বিশেষ সময়',
    ),
  };

  IconData get icon => switch (this) {
    NeedCategory.quran => Icons.menu_book_rounded,
    NeedCategory.salah => Icons.nights_stay_rounded,
    NeedCategory.dhikr => Icons.auto_awesome_rounded,
    NeedCategory.dua => Icons.volunteer_activism_rounded,
    NeedCategory.charity => Icons.favorite_rounded,
    NeedCategory.specialTimes => Icons.schedule_rounded,
  };
}

class NeedReference {
  const NeedReference(this.label, this.url);

  final String label;
  final String url;
}

enum NeedProgressKind { daily, juz, count }

class NeedAmal {
  const NeedAmal({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.steps,
    required this.authenticity,
    required this.evidenceNote,
    required this.timing,
    required this.references,
    this.progressKind = NeedProgressKind.daily,
    this.arabic,
    this.transliteration,
    this.meaning,
    this.duaNote,
  });

  final String id;
  final NeedCategory category;
  final NeedText title;
  final NeedText description;
  final List<NeedText> steps;
  final NeedText authenticity;
  final NeedText evidenceNote;
  final NeedText timing;
  final List<NeedReference> references;
  final NeedProgressKind progressKind;
  final String? arabic;
  final String? transliteration;
  final NeedText? meaning;
  final NeedText? duaNote;
}
