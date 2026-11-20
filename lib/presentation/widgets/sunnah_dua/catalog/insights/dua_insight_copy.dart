import '../../../../../data/models/dua/dua_catalog.dart';
import '../../../../../l10n/app_localizations.dart';

Iterable<String> duaInsightIntroCopy(
  DuaEntry entry,
  AppLocalizations l10n,
) sync* {
  final language = l10n.localeName;
  final insight = entry.insights;
  if (!insight.purpose.isEmpty) {
    yield l10n.duaPurposeLabel;
    yield insight.purpose.inLanguage(language);
  }
  for (final virtue in insight.reportedVirtues) {
    yield l10n.duaReportedVirtueLabel;
    yield virtue.text.inLanguage(language);
    yield* _references(virtue.references, language);
  }
  if (!insight.evidenceNote.isEmpty) {
    yield insight.evidenceNote.inLanguage(language);
  }
}

Iterable<String> duaInsightContextCopy(
  DuaEntry entry,
  AppLocalizations l10n,
) sync* {
  final insight = entry.insights;
  final language = l10n.localeName;
  if (!insight.significance.isEmpty) {
    yield l10n.duaMeaningReflection;
    yield insight.significance.inLanguage(language);
  }
  if (!insight.background.isEmpty) {
    yield l10n.duaBackgroundTitle;
    yield insight.background.inLanguage(language);
    yield* _references(insight.backgroundReferences, language);
  }
}

Iterable<String> _references(
  List<DuaInsightReference> sources,
  String language,
) sync* {
  for (final source in sources) {
    yield source.label.inLanguage(language);
    yield source.url;
    yield source.grading.label.inLanguage(language);
    yield source.grading.by.inLanguage(language);
    yield source.grading.attribution.inLanguage(language);
    yield source.grading.url;
    for (final opinion in source.grading.opinions) {
      yield opinion.label.inLanguage(language);
      yield opinion.by.inLanguage(language);
      yield opinion.attribution.inLanguage(language);
      yield opinion.url;
    }
  }
}
