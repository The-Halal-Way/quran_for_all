import '../../../../../core/localization/l10n_extensions.dart';

class ShortSurahFocusGuide {
  const ShortSurahFocusGuide({
    required String surah,
    required String objective,
    required String keyTheme,
    required String recitationTarget,
    required String practicePrompt,
  }) : _surah = surah,
       _objective = objective,
       _keyTheme = keyTheme,
       _recitationTarget = recitationTarget,
       _practicePrompt = practicePrompt;

  final String _surah;
  final String _objective;
  final String _keyTheme;
  final String _recitationTarget;
  final String _practicePrompt;

  String get surah => LearnQuranTextLocalizer.translateRaw(_surah);
  String get objective => LearnQuranTextLocalizer.translateRaw(_objective);
  String get keyTheme => LearnQuranTextLocalizer.translateRaw(_keyTheme);
  String get recitationTarget =>
      LearnQuranTextLocalizer.translateRaw(_recitationTarget);
  String get practicePrompt =>
      LearnQuranTextLocalizer.translateRaw(_practicePrompt);
}

class ShortSurahTajweedFocusGuide {
  const ShortSurahTajweedFocusGuide({
    required String focus,
    required String rule,
    required String drill,
    required String commonMistake,
    required String correction,
  }) : _focus = focus,
       _rule = rule,
       _drill = drill,
       _commonMistake = commonMistake,
       _correction = correction;

  final String _focus;
  final String _rule;
  final String _drill;
  final String _commonMistake;
  final String _correction;

  String get focus => LearnQuranTextLocalizer.translateRaw(_focus);
  String get rule => LearnQuranTextLocalizer.translateRaw(_rule);
  String get drill => LearnQuranTextLocalizer.translateRaw(_drill);
  String get commonMistake =>
      LearnQuranTextLocalizer.translateRaw(_commonMistake);
  String get correction => LearnQuranTextLocalizer.translateRaw(_correction);
}

class ShortSurahMemorizationCycleGuide {
  const ShortSurahMemorizationCycleGuide({
    required String phase,
    required String action,
    required String duration,
    required String goal,
  }) : _phase = phase,
       _action = action,
       _duration = duration,
       _goal = goal;

  final String _phase;
  final String _action;
  final String _duration;
  final String _goal;

  String get phase => LearnQuranTextLocalizer.translateRaw(_phase);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
  String get duration => LearnQuranTextLocalizer.translateRaw(_duration);
  String get goal => LearnQuranTextLocalizer.translateRaw(_goal);
}

class ShortSurahSalahReadinessGuide {
  const ShortSurahSalahReadinessGuide({
    required String checkpoint,
    required String whatToDo,
    required String successMarker,
  }) : _checkpoint = checkpoint,
       _whatToDo = whatToDo,
       _successMarker = successMarker;

  final String _checkpoint;
  final String _whatToDo;
  final String _successMarker;

  String get checkpoint => LearnQuranTextLocalizer.translateRaw(_checkpoint);
  String get whatToDo => LearnQuranTextLocalizer.translateRaw(_whatToDo);
  String get successMarker =>
      LearnQuranTextLocalizer.translateRaw(_successMarker);
}

class ShortSurahMeaningLinkGuide {
  const ShortSurahMeaningLinkGuide({
    required String reference,
    required String arabic,
    required String transliteration,
    required String message,
    required String recitationCue,
  }) : _reference = reference,
       _arabic = arabic,
       _transliteration = transliteration,
       _message = message,
       _recitationCue = recitationCue;

  final String _reference;
  final String _arabic;
  final String _transliteration;
  final String _message;
  final String _recitationCue;

  String get reference => LearnQuranTextLocalizer.translateRaw(_reference);
  String get arabic => LearnQuranTextLocalizer.translateRaw(_arabic);
  String get transliteration =>
      LearnQuranTextLocalizer.translateRaw(_transliteration);
  String get message => LearnQuranTextLocalizer.translateRaw(_message);
  String get recitationCue =>
      LearnQuranTextLocalizer.translateRaw(_recitationCue);
}

class ShortSurahRevisionGuide {
  const ShortSurahRevisionGuide({required String title, required String action})
    : _title = title,
      _action = action;

  final String _title;
  final String _action;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
}

class ShortSurahLearningData {
  const ShortSurahLearningData._();

  static const List<String> learningFlow = [
    'Surah objective map',
    'Tajweed focus by surah',
    'Memorization cycle',
    'Fluency and breath pacing',
    'Salah readiness checks',
    'Meaning-linked recitation',
    'Revision and mastery',
  ];

  static const List<ShortSurahFocusGuide> surahFocus = [
    ShortSurahFocusGuide(
      surah: 'Al-Fatihah (1)',
      objective: 'Build stable daily salah recitation with correct flow.',
      keyTheme: 'Praise, worship, and dua for guidance.',
      recitationTarget:
          'Recite all 7 ayahs with balanced pace and stop control.',
      practicePrompt:
          'Recite once slowly for articulation, then once with salah tempo.',
    ),
    ShortSurahFocusGuide(
      surah: 'Al-Ikhlas (112)',
      objective: 'Strengthen clarity in concise declaration verses.',
      keyTheme: 'Tawheed and absolute oneness of Allah.',
      recitationTarget: 'Keep each ayah distinct with clean endings.',
      practicePrompt:
          'Read 3 rounds and mark one tajweed focus per ayah before final round.',
    ),
    ShortSurahFocusGuide(
      surah: 'Al-Falaq (113)',
      objective: 'Maintain smooth rhythm in protective supplication style.',
      keyTheme: 'Seeking protection from external harms.',
      recitationTarget: 'Apply measured pace in repeated مِنْ شَرِّ pattern.',
      practicePrompt:
          'Practice ayah-to-ayah transitions without rushing the recurring pattern.',
    ),
    ShortSurahFocusGuide(
      surah: 'An-Naas (114)',
      objective:
          'Control repeated consonant clusters while preserving meaning.',
      keyTheme: 'Seeking refuge from hidden whispering harms.',
      recitationTarget:
          'Recite with steady breathing and consistent articulation.',
      practicePrompt:
          'Do one breath-managed recitation and review weak consonant points.',
    ),
    ShortSurahFocusGuide(
      surah: 'Al-Kawthar (108)',
      objective: 'Practice short but precise command-response recitation.',
      keyTheme: 'Divine gift, gratitude, and devotion.',
      recitationTarget:
          'Deliver each ayah clearly with confident stop/restart.',
      practicePrompt:
          'Read each ayah separately, then connect all three in one fluent pass.',
    ),
    ShortSurahFocusGuide(
      surah: 'Al-Asr (103)',
      objective: 'Train warning-and-exception structure in recitation meaning.',
      keyTheme: 'Time, loss, and path of salvation.',
      recitationTarget:
          'Highlight transition into exception phrase إِلَّا الَّذِينَ آمَنُوا.',
      practicePrompt:
          'Pause mentally on structural shift and continue with stable tone.',
    ),
  ];

  static const List<ShortSurahTajweedFocusGuide> tajweedFocus = [
    ShortSurahTajweedFocusGuide(
      focus: 'Madd discipline',
      rule: 'Natural madd should stay consistent at 2 counts.',
      drill:
          'Practice key words in Al-Fatihah and Al-Ikhlas with fixed beat count.',
      commonMistake:
          'Randomly shortening long vowels during faster recitation.',
      correction: 'Use finger beats and keep count equal across rounds.',
    ),
    ShortSurahTajweedFocusGuide(
      focus: 'Qalqalah at stop',
      rule: 'Qalqalah letters bounce briefly without added vowel.',
      drill: 'Train stop endings from Al-Falaq and Al-Masad examples.',
      commonMistake: 'Over-bounce that creates an extra syllable.',
      correction: 'Release quickly and avoid opening into a full vowel sound.',
    ),
    ShortSurahTajweedFocusGuide(
      focus: 'Noon/tanween transitions',
      rule: 'Apply correct izhar, idgham, iqlab, or ikhfa behavior.',
      drill: 'Isolate phrases with مِنْ and tanween endings in short surahs.',
      commonMistake: 'Reading all noon/tanween patterns with one style.',
      correction: 'Identify next letter first, then apply rule intentionally.',
    ),
    ShortSurahTajweedFocusGuide(
      focus: 'Waqf and restart',
      rule: 'Pause at complete units and restart from coherent boundaries.',
      drill:
          'Mark safe stops in Al-Fatihah and An-Naas, then recite with plan.',
      commonMistake: 'Stopping at weak positions that break meaning.',
      correction: 'Follow meaning units and keep restart tone consistent.',
    ),
  ];

  static const List<ShortSurahMemorizationCycleGuide> memorizationCycle = [
    ShortSurahMemorizationCycleGuide(
      phase: 'Listen',
      action: 'Play one ayah 3 times with full attention.',
      duration: '2 min',
      goal: 'Capture melody, articulation, and pause points.',
    ),
    ShortSurahMemorizationCycleGuide(
      phase: 'Echo',
      action: 'Repeat immediately after audio, one phrase at a time.',
      duration: '3 min',
      goal: 'Match pronunciation and timing with model recitation.',
    ),
    ShortSurahMemorizationCycleGuide(
      phase: 'Segment',
      action: 'Break surah into ayah blocks and practice each block twice.',
      duration: '4 min',
      goal: 'Secure memory with controlled chunking.',
    ),
    ShortSurahMemorizationCycleGuide(
      phase: 'Connect',
      action: 'Join all ayahs in one smooth recitation pass.',
      duration: '3 min',
      goal: 'Build continuity without forgetting transitions.',
    ),
    ShortSurahMemorizationCycleGuide(
      phase: 'Self-check',
      action: 'Recite from memory and compare with mushaf/audio.',
      duration: '3 min',
      goal: 'Detect and fix missed words, timing, and stops.',
    ),
  ];

  static const List<ShortSurahSalahReadinessGuide> salahReadiness = [
    ShortSurahSalahReadinessGuide(
      checkpoint: 'Accuracy check',
      whatToDo: 'Recite without skipping or replacing words.',
      successMarker: 'Zero word omissions in one full pass.',
    ),
    ShortSurahSalahReadinessGuide(
      checkpoint: 'Tajweed check',
      whatToDo: 'Apply selected tajweed focus points intentionally.',
      successMarker: 'At least 3 target rules are applied correctly.',
    ),
    ShortSurahSalahReadinessGuide(
      checkpoint: 'Breath check',
      whatToDo: 'Use planned breathing at natural phrase boundaries.',
      successMarker: 'No forced mid-word breathing.',
    ),
    ShortSurahSalahReadinessGuide(
      checkpoint: 'Pace check',
      whatToDo: 'Maintain calm, prayer-suitable rhythm.',
      successMarker: 'Steady speed from first ayah to last.',
    ),
    ShortSurahSalahReadinessGuide(
      checkpoint: 'Confidence check',
      whatToDo: 'Recite once in salah simulation standing posture.',
      successMarker: 'Complete recitation with no hesitation restarts.',
    ),
  ];

  static const List<ShortSurahMeaningLinkGuide> meaningLink = [
    ShortSurahMeaningLinkGuide(
      reference: 'Al-Ikhlas 112:1',
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      transliteration: 'qul huwa Allahu ahad',
      message: 'Declare Allah as absolutely One.',
      recitationCue:
          'Read with confident declaration tone and a clean stop at the end.',
    ),
    ShortSurahMeaningLinkGuide(
      reference: 'Al-Falaq 113:1',
      arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
      transliteration: 'qul aoodhu birabbil-falaq',
      message: 'Seek protection in the Lord of daybreak.',
      recitationCue:
          'Keep flow calm and supplicative, especially from أَعُوذُ to رَبِّ.',
    ),
    ShortSurahMeaningLinkGuide(
      reference: 'An-Naas 114:1-2',
      arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ مَلِكِ النَّاسِ',
      transliteration: 'qul aoodhu birabbin-nas malikin-nas',
      message: 'Seek refuge in the Lord and King of mankind.',
      recitationCue:
          'Emphasize repeated النَّاسِ with steady breath and clear articulation.',
    ),
    ShortSurahMeaningLinkGuide(
      reference: 'Al-Asr 103:2-3',
      arabic: 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ إِلَّا الَّذِينَ آمَنُوا',
      transliteration: 'inna al-insana lafi khusr illa alladhina amanu',
      message: 'Humanity is in loss except people of faith and action.',
      recitationCue:
          'Mark the shift at إِلَّا with clear contrast in pacing and attention.',
    ),
  ];

  static const List<ShortSurahRevisionGuide> revision = [
    ShortSurahRevisionGuide(
      title: 'Daily 2-surah cycle',
      action: 'Recite two selected surahs with one tajweed focus each.',
    ),
    ShortSurahRevisionGuide(
      title: 'Alternate speed pass',
      action: 'Read one round slow and one round normal salah pace.',
    ),
    ShortSurahRevisionGuide(
      title: 'Meaning link pass',
      action: 'State one key message per ayah before reciting.',
    ),
    ShortSurahRevisionGuide(
      title: 'Audio comparison',
      action: 'Record and compare one surah with a reference reciter.',
    ),
    ShortSurahRevisionGuide(
      title: 'Weekly mastery check',
      action: 'Complete 4 short surahs in one continuous confidence session.',
    ),
  ];
}
