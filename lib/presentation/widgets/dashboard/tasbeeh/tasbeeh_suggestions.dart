import 'package:quran_for_all/l10n/app_localizations.dart';

typedef TasbeehSuggestion = ({String name, String arabic, String meaning});

List<TasbeehSuggestion> tasbeehSuggestions(AppLocalizations l10n) => [
  (
    name: l10n.tasbeehSuggestionShahada,
    arabic: 'لَا إِلَهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ',
    meaning: l10n.tasbeehMeaningShahada,
  ),
  (
    name: l10n.tasbeehSuggestionFourPhrases,
    arabic:
        'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
    meaning: l10n.tasbeehMeaningFourPhrases,
  ),
  (
    name: l10n.tasbeehSuggestionSalawatUmmi,
    arabic:
        'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ النَّبِيِّ الْأُمِّيِّ وَعَلَى آلِهِ وَسَلِّمْ تَسْلِيمًا',
    meaning: l10n.tasbeehMeaningSalawatUmmi,
  ),
  (
    name: l10n.tasbeehSuggestionSayyidulIstighfar,
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    meaning: l10n.tasbeehMeaningSayyidulIstighfar,
  ),
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
        'لَآ إِلَٰهَ إِلَّآ أَنتَ سُبْحَٰنَكَ إِنِّى كُنتُ مِنَ ٱلظَّٰلِمِينَ',
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
        'لَآ إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    meaning: l10n.tasbeehMeaningTahlil,
  ),
  (
    name: l10n.tasbeehSuggestionRabbanaAtina,
    // Quran 2:201.
    arabic:
        'رَبَّنَآ ءَاتِنَا فِى ٱلدُّنْيَا حَسَنَةًۭ وَفِى ٱلْءَاخِرَةِ حَسَنَةًۭ وَقِنَا عَذَابَ ٱلنَّارِ',
    meaning: l10n.tasbeehMeaningRabbanaAtina,
  ),
  (
    name: l10n.tasbeehSuggestionRabbiInni,
    // Quran 28:24.
    arabic: 'رَبِّ إِنِّى لِمَآ أَنزَلْتَ إِلَىَّ مِنْ خَيْرٍۢ فَقِيرٌۭ',
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
