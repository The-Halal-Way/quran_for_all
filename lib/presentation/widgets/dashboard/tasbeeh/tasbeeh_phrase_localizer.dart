import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/domain/entities/tasbeeh/tasbeeh_phrase.dart';

extension TasbeehPhraseLabel on TasbeehPhrase {
  String label(AppLocalizations l10n) => builtInKey?.label(l10n) ?? name;

  String localizedMeaning(AppLocalizations l10n) =>
      builtInKey?.meaning(l10n) ?? meaning;
}

extension TasbeehPhraseLocalizer on TasbeehPhraseKey {
  String label(AppLocalizations l10n) {
    switch (this) {
      case TasbeehPhraseKey.subhanAllah:
        return l10n.tasbeehPhraseSubhanAllah;
      case TasbeehPhraseKey.alhamdulillah:
        return l10n.tasbeehPhraseAlhamdulillah;
      case TasbeehPhraseKey.allahuAkbar:
        return l10n.tasbeehPhraseAllahuAkbar;
      case TasbeehPhraseKey.laIlahaIllallah:
        return l10n.tasbeehPhraseLaIlahaIllallah;
    }
  }

  String meaning(AppLocalizations l10n) {
    switch (this) {
      case TasbeehPhraseKey.subhanAllah:
        return l10n.tasbeehMeaningSubhanAllah;
      case TasbeehPhraseKey.alhamdulillah:
        return l10n.tasbeehMeaningAlhamdulillah;
      case TasbeehPhraseKey.allahuAkbar:
        return l10n.tasbeehMeaningAllahuAkbar;
      case TasbeehPhraseKey.laIlahaIllallah:
        return l10n.tasbeehMeaningLaIlahaIllallah;
    }
  }
}
