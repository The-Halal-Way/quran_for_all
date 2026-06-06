import '../../../../../core/localization/l10n_extensions.dart';

class ArabicLetterGuide {
  const ArabicLetterGuide({
    required this.symbol,
    required String name,
    required String transliteration,
    required String visualCue,
  }) : _name = name,
       _transliteration = transliteration,
       _visualCue = visualCue;

  final String symbol;
  final String _name;
  final String _transliteration;
  final String _visualCue;

  String get name => LearnQuranTextLocalizer.translateRaw(_name);
  String get transliteration =>
      LearnQuranTextLocalizer.translateRaw(_transliteration);
  String get visualCue => LearnQuranTextLocalizer.translateRaw(_visualCue);
}

class LetterFamilyGuide {
  const LetterFamilyGuide({
    required String title,
    required String goal,
    required List<String> letters,
    required String tip,
  }) : _title = title,
       _goal = goal,
       _letters = letters,
       _tip = tip;

  final String _title;
  final String _goal;
  final List<String> _letters;
  final String _tip;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get goal => LearnQuranTextLocalizer.translateRaw(_goal);
  List<String> get letters =>
      _letters.map(LearnQuranTextLocalizer.translateRaw).toList();
  String get tip => LearnQuranTextLocalizer.translateRaw(_tip);
}

class SimilarLetterGuide {
  const SimilarLetterGuide({
    required String letters,
    required String differenceRule,
    required String practice,
    required String commonMistake,
  }) : _letters = letters,
       _differenceRule = differenceRule,
       _practice = practice,
       _commonMistake = commonMistake;

  final String _letters;
  final String _differenceRule;
  final String _practice;
  final String _commonMistake;

  String get letters => LearnQuranTextLocalizer.translateRaw(_letters);
  String get differenceRule =>
      LearnQuranTextLocalizer.translateRaw(_differenceRule);
  String get practice => LearnQuranTextLocalizer.translateRaw(_practice);
  String get commonMistake =>
      LearnQuranTextLocalizer.translateRaw(_commonMistake);
}

class ArticulationZoneGuide {
  const ArticulationZoneGuide({
    required String zone,
    required String letters,
    required String hint,
    required String watchFor,
  }) : _zone = zone,
       _letters = letters,
       _hint = hint,
       _watchFor = watchFor;

  final String _zone;
  final String _letters;
  final String _hint;
  final String _watchFor;

  String get zone => LearnQuranTextLocalizer.translateRaw(_zone);
  String get letters => LearnQuranTextLocalizer.translateRaw(_letters);
  String get hint => LearnQuranTextLocalizer.translateRaw(_hint);
  String get watchFor => LearnQuranTextLocalizer.translateRaw(_watchFor);
}

class HarakahPatternGuide {
  const HarakahPatternGuide({
    required String baseLetter,
    required String fatha,
    required String kasra,
    required String damma,
    required String sukoon,
  }) : _baseLetter = baseLetter,
       _fatha = fatha,
       _kasra = kasra,
       _damma = damma,
       _sukoon = sukoon;

  final String _baseLetter;
  final String _fatha;
  final String _kasra;
  final String _damma;
  final String _sukoon;

  String get baseLetter => LearnQuranTextLocalizer.translateRaw(_baseLetter);
  String get fatha => LearnQuranTextLocalizer.translateRaw(_fatha);
  String get kasra => LearnQuranTextLocalizer.translateRaw(_kasra);
  String get damma => LearnQuranTextLocalizer.translateRaw(_damma);
  String get sukoon => LearnQuranTextLocalizer.translateRaw(_sukoon);
}

class ReadingExampleGuide {
  const ReadingExampleGuide({
    required String arabic,
    required String transliteration,
    required String focus,
  }) : _arabic = arabic,
       _transliteration = transliteration,
       _focus = focus;

  final String _arabic;
  final String _transliteration;
  final String _focus;

  String get arabic => LearnQuranTextLocalizer.translateRaw(_arabic);
  String get transliteration =>
      LearnQuranTextLocalizer.translateRaw(_transliteration);
  String get focus => LearnQuranTextLocalizer.translateRaw(_focus);
}

class RevisionBlockGuide {
  const RevisionBlockGuide({required String title, required String drill})
    : _title = title,
      _drill = drill;

  final String _title;
  final String _drill;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get drill => LearnQuranTextLocalizer.translateRaw(_drill);
}

class ArabicLettersLearningData {
  const ArabicLettersLearningData._();

  static const List<String> learningFlow = [
    'Alphabet map',
    'Shape families',
    'Comparison drills',
    'Articulation cues',
    'Harakat practice',
    'Revision challenge',
  ];

  static const List<ArabicLetterGuide> alphabet = [
    ArabicLetterGuide(
      symbol: 'ا',
      name: 'Alif',
      transliteration: 'aa',
      visualCue: 'Straight vertical stroke',
    ),
    ArabicLetterGuide(
      symbol: 'ب',
      name: 'Baa',
      transliteration: 'b',
      visualCue: 'One dot below',
    ),
    ArabicLetterGuide(
      symbol: 'ت',
      name: 'Taa',
      transliteration: 't',
      visualCue: 'Two dots above',
    ),
    ArabicLetterGuide(
      symbol: 'ث',
      name: 'Thaa',
      transliteration: 'th',
      visualCue: 'Three dots above',
    ),
    ArabicLetterGuide(
      symbol: 'ج',
      name: 'Jeem',
      transliteration: 'j',
      visualCue: 'Body with one dot below',
    ),
    ArabicLetterGuide(
      symbol: 'ح',
      name: 'Haa',
      transliteration: 'h',
      visualCue: 'Same body without dots',
    ),
    ArabicLetterGuide(
      symbol: 'خ',
      name: 'Khaa',
      transliteration: 'kh',
      visualCue: 'Same body with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'د',
      name: 'Daal',
      transliteration: 'd',
      visualCue: 'Single right curve',
    ),
    ArabicLetterGuide(
      symbol: 'ذ',
      name: 'Dhaal',
      transliteration: 'dh',
      visualCue: 'Daal shape with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'ر',
      name: 'Raa',
      transliteration: 'r',
      visualCue: 'Short descending curve',
    ),
    ArabicLetterGuide(
      symbol: 'ز',
      name: 'Zay',
      transliteration: 'z',
      visualCue: 'Raa shape with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'س',
      name: 'Seen',
      transliteration: 's',
      visualCue: 'Three-tooth shape',
    ),
    ArabicLetterGuide(
      symbol: 'ش',
      name: 'Sheen',
      transliteration: 'sh',
      visualCue: 'Seen with three dots above',
    ),
    ArabicLetterGuide(
      symbol: 'ص',
      name: 'Saad',
      transliteration: 's',
      visualCue: 'Broad closed curve',
    ),
    ArabicLetterGuide(
      symbol: 'ض',
      name: 'Daad',
      transliteration: 'd',
      visualCue: 'Saad with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'ط',
      name: 'Taa (heavy)',
      transliteration: 't',
      visualCue: 'Rounded body with stem',
    ),
    ArabicLetterGuide(
      symbol: 'ظ',
      name: 'Zaa',
      transliteration: 'z',
      visualCue: 'Heavy taa with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'ع',
      name: 'Ayn',
      transliteration: 'a',
      visualCue: 'Open-loop throat letter',
    ),
    ArabicLetterGuide(
      symbol: 'غ',
      name: 'Ghayn',
      transliteration: 'gh',
      visualCue: 'Ayn with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'ف',
      name: 'Faa',
      transliteration: 'f',
      visualCue: 'Loop with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'ق',
      name: 'Qaaf',
      transliteration: 'q',
      visualCue: 'Loop with two dots above',
    ),
    ArabicLetterGuide(
      symbol: 'ك',
      name: 'Kaaf',
      transliteration: 'k',
      visualCue: 'Tall stem with angle',
    ),
    ArabicLetterGuide(
      symbol: 'ل',
      name: 'Laam',
      transliteration: 'l',
      visualCue: 'Long upward stroke',
    ),
    ArabicLetterGuide(
      symbol: 'م',
      name: 'Meem',
      transliteration: 'm',
      visualCue: 'Rounded closed bowl',
    ),
    ArabicLetterGuide(
      symbol: 'ن',
      name: 'Noon',
      transliteration: 'n',
      visualCue: 'Bowl with one dot above',
    ),
    ArabicLetterGuide(
      symbol: 'ه',
      name: 'Haa (light)',
      transliteration: 'h',
      visualCue: 'Open breathing circle',
    ),
    ArabicLetterGuide(
      symbol: 'و',
      name: 'Waaw',
      transliteration: 'w',
      visualCue: 'Small loop and tail',
    ),
    ArabicLetterGuide(
      symbol: 'ي',
      name: 'Yaa',
      transliteration: 'y',
      visualCue: 'Two dots below in isolated form',
    ),
    ArabicLetterGuide(
      symbol: 'ء',
      name: 'Hamzah',
      transliteration: 'glottal stop',
      visualCue: 'Quick throat stop mark',
    ),
  ];

  static const List<LetterFamilyGuide> shapeFamilies = [
    LetterFamilyGuide(
      title: 'Skeleton Family: ب ت ث',
      goal: 'Learn one base shape and read dots correctly.',
      letters: ['ب', 'ت', 'ث'],
      tip: 'Say the dot count first, then the letter name.',
    ),
    LetterFamilyGuide(
      title: 'Skeleton Family: ج ح خ',
      goal: 'Keep shape constant and change only the dot rule.',
      letters: ['ج', 'ح', 'خ'],
      tip: 'No dot is ح, below dot is ج, above dot is خ.',
    ),
    LetterFamilyGuide(
      title: 'Curved Pair: د ذ and ر ز',
      goal: 'Spot the same body with and without dot.',
      letters: ['د', 'ذ', 'ر', 'ز'],
      tip: 'If you see one dot above the curve, pick the dotted partner.',
    ),
    LetterFamilyGuide(
      title: 'Tooth Family: س ش',
      goal: 'Read three teeth shape with dot awareness.',
      letters: ['س', 'ش'],
      tip: 'Three dots above converts س into ش.',
    ),
    LetterFamilyGuide(
      title: 'Heavy Pair Families',
      goal: 'Separate light and heavy look-alikes.',
      letters: ['ص', 'ض', 'ط', 'ظ'],
      tip: 'Heavy letters sound fuller and often have broader shapes.',
    ),
    LetterFamilyGuide(
      title: 'Throat Pair: ع غ',
      goal: 'Control sound depth while observing one-dot difference.',
      letters: ['ع', 'غ'],
      tip: 'غ keeps the same body as ع with one dot above.',
    ),
    LetterFamilyGuide(
      title: 'Loop Pair: ف ق',
      goal: 'Distinguish one dot and two dots quickly.',
      letters: ['ف', 'ق'],
      tip: 'Practice as a pair repeatedly: فَ then قَ.',
    ),
  ];

  static const List<SimilarLetterGuide> comparisons = [
    SimilarLetterGuide(
      letters: 'ب / ت / ث',
      differenceRule: 'Same body; 1 dot below, 2 above, 3 above.',
      practice: 'بَ تَ ثَ, بِ تِ ثِ, بُ تُ ثُ',
      commonMistake: 'Reading dot position too quickly and swapping ب with ت.',
    ),
    SimilarLetterGuide(
      letters: 'ج / ح / خ',
      differenceRule:
          'Same body; below dot for ج, no dot for ح, above dot for خ.',
      practice: 'جَ حَ خَ',
      commonMistake:
          'Pronouncing ح like English h; it is deeper and breathier.',
    ),
    SimilarLetterGuide(
      letters: 'د / ذ and ر / ز',
      differenceRule:
          'Each dotted form adds one dot above the same curved shape.',
      practice: 'دَ ذَ, رَ زَ',
      commonMistake: 'Skipping the subtle sound difference between د and ذ.',
    ),
    SimilarLetterGuide(
      letters: 'س / ش',
      differenceRule: 'Three dots above turns seen into sheen.',
      practice: 'سَ شَ, سُ شُ',
      commonMistake: 'Forgetting that ش uses a "sh" sound, not plain s.',
    ),
    SimilarLetterGuide(
      letters: 'ص / ض and ط / ظ',
      differenceRule:
          'Dotted version adds one dot above; both pairs are heavy sounds.',
      practice: 'صَ ضَ, طَ ظَ',
      commonMistake:
          'Making heavy letters too light and losing Quranic weight.',
    ),
    SimilarLetterGuide(
      letters: 'ع / غ and ف / ق',
      differenceRule: 'Dot difference plus articulation shift.',
      practice: 'عَ غَ, فَ قَ',
      commonMistake: 'Collapsing ق into ك when reciting quickly.',
    ),
  ];

  static const List<ArticulationZoneGuide> articulationZones = [
    ArticulationZoneGuide(
      zone: 'Deep throat',
      letters: 'ء هـ ع ح غ خ',
      hint: 'Open the throat gently and avoid squeezing.',
      watchFor: 'Do not replace ع or ح with a flat English sound.',
    ),
    ArticulationZoneGuide(
      zone: 'Tongue tip and blade',
      letters: 'ت د ط ث ذ ظ س ص ز ن ل',
      hint: 'Use precise tongue placement near the upper teeth/ridge.',
      watchFor: 'Do not blur ث with س or ذ with ز.',
    ),
    ArticulationZoneGuide(
      zone: 'Mid/back tongue',
      letters: 'ج ش ي ق ك',
      hint: 'Lift middle or back of tongue depending on the letter.',
      watchFor: 'Keep ق deeper than ك.',
    ),
    ArticulationZoneGuide(
      zone: 'Lips and airflow',
      letters: 'ف ب م و',
      hint: 'Use clear lip closure/opening and controlled air release.',
      watchFor: 'For ف, touch lower lip to upper teeth lightly.',
    ),
  ];

  static const List<HarakahPatternGuide> harakahPatterns = [
    HarakahPatternGuide(
      baseLetter: 'ب',
      fatha: 'بَ',
      kasra: 'بِ',
      damma: 'بُ',
      sukoon: 'بْ',
    ),
    HarakahPatternGuide(
      baseLetter: 'ت',
      fatha: 'تَ',
      kasra: 'تِ',
      damma: 'تُ',
      sukoon: 'تْ',
    ),
    HarakahPatternGuide(
      baseLetter: 'ن',
      fatha: 'نَ',
      kasra: 'نِ',
      damma: 'نُ',
      sukoon: 'نْ',
    ),
    HarakahPatternGuide(
      baseLetter: 'ل',
      fatha: 'لَ',
      kasra: 'لِ',
      damma: 'لُ',
      sukoon: 'لْ',
    ),
  ];

  static const List<ReadingExampleGuide> readingExamples = [
    ReadingExampleGuide(
      arabic: 'بِسْمِ',
      transliteration: 'bismi',
      focus: 'Kasra on baa and sukoon on seen.',
    ),
    ReadingExampleGuide(
      arabic: 'قُلْ',
      transliteration: 'qul',
      focus: 'Qaaf sound depth and clean sukoon on laam.',
    ),
    ReadingExampleGuide(
      arabic: 'رَبّ',
      transliteration: 'rabb',
      focus: 'Strong baa closure and clear consonant ending.',
    ),
    ReadingExampleGuide(
      arabic: 'نُور',
      transliteration: 'nur',
      focus: 'Damma on noon and smooth transition to waaw.',
    ),
    ReadingExampleGuide(
      arabic: 'خَلَقَ',
      transliteration: 'khalaqa',
      focus: 'Differentiate kh sound from plain h.',
    ),
  ];

  static const List<RevisionBlockGuide> revisionBlocks = [
    RevisionBlockGuide(
      title: 'Rapid recognition drill (2 min)',
      drill:
          'Point to 15 random letters and name each within two seconds. Repeat missed letters twice.',
    ),
    RevisionBlockGuide(
      title: 'Comparison drill (2 min)',
      drill:
          'Alternate pairs: ب/ت/ث, ج/ح/خ, د/ذ, ر/ز, س/ش, ص/ض, ط/ظ, ع/غ, ف/ق.',
    ),
    RevisionBlockGuide(
      title: 'Pronunciation drill (3 min)',
      drill:
          'Recite one short set from each articulation zone slowly while monitoring mouth position.',
    ),
    RevisionBlockGuide(
      title: 'Harakat drill (3 min)',
      drill:
          'Read each pattern row: fatha, kasra, damma, sukoon. Keep rhythm steady and vowels crisp.',
    ),
    RevisionBlockGuide(
      title: 'Mini reading check (2 min)',
      drill:
          'Read five beginner examples and identify the key rule used in each word.',
    ),
  ];
}
