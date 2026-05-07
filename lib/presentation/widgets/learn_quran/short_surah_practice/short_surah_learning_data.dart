class ShortSurahFocusGuide {
  const ShortSurahFocusGuide({
    required this.surah,
    required this.objective,
    required this.keyTheme,
    required this.recitationTarget,
    required this.practicePrompt,
  });

  final String surah;
  final String objective;
  final String keyTheme;
  final String recitationTarget;
  final String practicePrompt;
}

class ShortSurahTajweedFocusGuide {
  const ShortSurahTajweedFocusGuide({
    required this.focus,
    required this.rule,
    required this.drill,
    required this.commonMistake,
    required this.correction,
  });

  final String focus;
  final String rule;
  final String drill;
  final String commonMistake;
  final String correction;
}

class ShortSurahMemorizationCycleGuide {
  const ShortSurahMemorizationCycleGuide({
    required this.phase,
    required this.action,
    required this.duration,
    required this.goal,
  });

  final String phase;
  final String action;
  final String duration;
  final String goal;
}

class ShortSurahSalahReadinessGuide {
  const ShortSurahSalahReadinessGuide({
    required this.checkpoint,
    required this.whatToDo,
    required this.successMarker,
  });

  final String checkpoint;
  final String whatToDo;
  final String successMarker;
}

class ShortSurahMeaningLinkGuide {
  const ShortSurahMeaningLinkGuide({
    required this.reference,
    required this.arabic,
    required this.transliteration,
    required this.message,
    required this.recitationCue,
  });

  final String reference;
  final String arabic;
  final String transliteration;
  final String message;
  final String recitationCue;
}

class ShortSurahRevisionGuide {
  const ShortSurahRevisionGuide({required this.title, required this.action});

  final String title;
  final String action;
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
