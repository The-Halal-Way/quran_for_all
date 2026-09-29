import 'package:quran_for_all/l10n/app_localizations.dart';

typedef TasbeehSuggestion = ({String name, String arabic, String meaning});

List<TasbeehSuggestion> tasbeehSuggestions(AppLocalizations l10n) => [
  (
    name: l10n.tasbeehSuggestionAstaghfirullah,
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    meaning: l10n.tasbeehMeaningAstaghfirullah,
  ),
  (
    name: l10n.tasbeehSuggestionSubhanAllahiWaBihamdihi,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    meaning: l10n.tasbeehMeaningSubhanAllahiWaBihamdihi,
  ),
  (
    name: l10n.tasbeehSuggestionLaHawla,
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    meaning: l10n.tasbeehMeaningLaHawla,
  ),
  (
    name: l10n.tasbeehSuggestionSalawat,
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    meaning: l10n.tasbeehMeaningSalawat,
  ),
  (
    name: l10n.tasbeehSuggestionHasbunallah,
    arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    meaning: l10n.tasbeehMeaningHasbunallah,
  ),
  (
    name: l10n.tasbeehSuggestionSubhanAllahilAzim,
    arabic: 'سُبْحَانَ اللَّهِ الْعَظِيمِ',
    meaning: l10n.tasbeehMeaningSubhanAllahilAzim,
  ),
  (
    name: l10n.tasbeehSuggestionRabbiZidniIlma,
    // Quran 20:114.
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    meaning: l10n.tasbeehMeaningRabbiZidniIlma,
  ),
  (
    name: l10n.tasbeehSuggestionLaIlahaIllaAnta,
    // Quran 21:87.
    arabic:
        'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    meaning: l10n.tasbeehMeaningLaIlahaIllaAnta,
  ),
  (
    name: l10n.tasbeehSuggestionYaHayyuYaQayyum,
    arabic: 'يَا حَيُّ يَا قَيُّومُ',
    meaning: l10n.tasbeehMeaningYaHayyuYaQayyum,
  ),
  (
    name: l10n.tasbeehSuggestionTwoWords,
    // Sahih al-Bukhari 6682.
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
    meaning: l10n.tasbeehMeaningTwoWords,
  ),
  (
    name: l10n.tasbeehSuggestionTahlil,
    // Sahih al-Bukhari 3293.
    arabic:
        'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    meaning: l10n.tasbeehMeaningTahlil,
  ),
  (
    name: l10n.tasbeehSuggestionRabbanaAtina,
    // Quran 2:201.
    arabic:
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    meaning: l10n.tasbeehMeaningRabbanaAtina,
  ),
  (
    name: l10n.tasbeehSuggestionRabbiInni,
    // Quran 28:24.
    arabic: 'رَبِّ إِنِّي لِمَا أَنْزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ',
    meaning: l10n.tasbeehMeaningRabbiInni,
  ),
  (
    name: l10n.tasbeehSuggestionRabbanaLaTuzigh,
    // Quran 3:8.
    arabic:
        'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ',
    meaning: l10n.tasbeehMeaningRabbanaLaTuzigh,
  ),
];
