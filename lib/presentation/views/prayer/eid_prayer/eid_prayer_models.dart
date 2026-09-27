enum EidKind { fitr, adha }

enum EidGuideTopic { overview, prayer, dayPlan, remembrance }

/// Display copy adapted from the Eid prayer document supplied for this feature.
/// References stay with the claims they accompany.
class EidText {
  const EidText(this.en, this.bn);

  final String en;
  final String bn;

  String inLanguage(bool bangla) => bangla ? bn : en;
}

class EidEntry {
  const EidEntry({
    required this.title,
    required this.body,
    this.arabic,
    this.pronunciation,
    this.meaning,
    this.reference,
    this.badge,
  }) : assert(arabic == null || (pronunciation != null && meaning != null));

  final EidText title;
  final EidText body;
  final String? arabic;
  final EidText? pronunciation;
  final EidText? meaning;
  final String? reference;
  final EidText? badge;
}

class EidSection {
  const EidSection({required this.title, required this.entries, this.intro});

  final EidText title;
  final EidText? intro;
  final List<EidEntry> entries;
}
