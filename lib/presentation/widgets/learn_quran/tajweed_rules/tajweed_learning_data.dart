class TajweedRuleFamilyGuide {
  const TajweedRuleFamilyGuide({
    required this.rule,
    required this.trigger,
    required this.howToRead,
    required this.example,
    required this.coachNote,
  });

  final String rule;
  final String trigger;
  final String howToRead;
  final String example;
  final String coachNote;
}

class TajweedMeemRuleGuide {
  const TajweedMeemRuleGuide({
    required this.rule,
    required this.trigger,
    required this.delivery,
    required this.example,
    required this.mistake,
  });

  final String rule;
  final String trigger;
  final String delivery;
  final String example;
  final String mistake;
}

class TajweedQalqalahGuide {
  const TajweedQalqalahGuide({
    required this.letter,
    required this.sample,
    required this.when,
    required this.note,
  });

  final String letter;
  final String sample;
  final String when;
  final String note;
}

class TajweedMaddGuide {
  const TajweedMaddGuide({
    required this.type,
    required this.count,
    required this.example,
    required this.tip,
  });

  final String type;
  final String count;
  final String example;
  final String tip;
}

class TajweedWaqfGuide {
  const TajweedWaqfGuide({
    required this.rule,
    required this.pauseAction,
    required this.restartAction,
    required this.example,
  });

  final String rule;
  final String pauseAction;
  final String restartAction;
  final String example;
}

class TajweedPhraseGuide {
  const TajweedPhraseGuide({
    required this.arabic,
    required this.transliteration,
    required this.focus,
  });

  final String arabic;
  final String transliteration;
  final String focus;
}

class TajweedRevisionGuide {
  const TajweedRevisionGuide({required this.title, required this.action});

  final String title;
  final String action;
}

class TajweedLearningData {
  const TajweedLearningData._();

  static const List<String> learningFlow = [
    'Noon/tanween rules',
    'Meem saakin rules',
    'Qalqalah control',
    'Madd timing',
    'Waqf and restart',
    'Applied phrase reading',
    'Revision and self-check',
  ];

  static const List<TajweedRuleFamilyGuide> noonTanweenRules = [
    TajweedRuleFamilyGuide(
      rule: 'Izhar',
      trigger: 'Noon saakin/tanween before throat letters',
      howToRead: 'Pronounce noon/tanween clearly without merging.',
      example: 'مِنْ هَادٍ (min had)',
      coachNote: 'Keep sound clear and direct, no nasal blending.',
    ),
    TajweedRuleFamilyGuide(
      rule: 'Idgham',
      trigger: 'Noon saakin/tanween before ي ر م ل و ن',
      howToRead: 'Merge into next letter, with or without ghunnah by type.',
      example: 'مِنْ رَبِّهِمْ (mir rabbihim)',
      coachNote: 'Do not keep noon fully separate in true idgham positions.',
    ),
    TajweedRuleFamilyGuide(
      rule: 'Iqlab',
      trigger: 'Noon saakin/tanween before ب',
      howToRead: 'Convert noon/tanween into a hidden meem with ghunnah.',
      example: 'أَنْبِئْهُمْ (ambi hum)',
      coachNote: 'Show ghunnah but avoid exaggerated lip closure.',
    ),
    TajweedRuleFamilyGuide(
      rule: 'Ikhfa',
      trigger: 'Noon saakin/tanween before remaining ikhfa letters',
      howToRead: 'Read between izhar and idgham with controlled ghunnah.',
      example: 'مِنْ شَرٍّ (min sharr)',
      coachNote: 'Keep transition smooth; do not fully hide clarity.',
    ),
  ];

  static const List<TajweedMeemRuleGuide> meemSaakinRules = [
    TajweedMeemRuleGuide(
      rule: 'Ikhfa Shafawi',
      trigger: 'Meem saakin before ب',
      delivery: 'Hide meem with ghunnah and soft lip readiness.',
      example: 'تَرْمِيهِمْ بِحِجَارَةٍ',
      mistake: 'Do not read full clear meem before baa.',
    ),
    TajweedMeemRuleGuide(
      rule: 'Idgham Shafawi',
      trigger: 'Meem saakin before م',
      delivery: 'Merge with ghunnah while maintaining measured timing.',
      example: 'لَكُمْ مَا',
      mistake: 'Avoid weak merge or dropping ghunnah.',
    ),
    TajweedMeemRuleGuide(
      rule: 'Izhar Shafawi',
      trigger: 'Meem saakin before all other letters',
      delivery: 'Read meem clearly with full lip closure.',
      example: 'هُمْ فِيهَا',
      mistake: 'Do not nasalize where izhar shafawi is required.',
    ),
  ];

  static const List<TajweedQalqalahGuide> qalqalah = [
    TajweedQalqalahGuide(
      letter: 'ق',
      sample: 'الْفَلَقْ (at stop)',
      when: 'Stronger at waqf, lighter during continuation',
      note: 'Bounce briefly without adding full vowel.',
    ),
    TajweedQalqalahGuide(
      letter: 'ط',
      sample: 'أَحَطْتُ',
      when: 'Notice bounce when letter carries sukoon',
      note: 'Keep articulation point stable before release.',
    ),
    TajweedQalqalahGuide(
      letter: 'ب',
      sample: 'تَبَّ',
      when: 'Clear in stressed/sukoon contexts',
      note: 'Do not over-bounce into an extra syllable.',
    ),
    TajweedQalqalahGuide(
      letter: 'ج / د',
      sample: 'وَجْه / قَدْ',
      when: 'Observe controlled bounce at stop',
      note: 'Maintain clarity without harsh impact.',
    ),
  ];

  static const List<TajweedMaddGuide> madd = [
    TajweedMaddGuide(
      type: 'Natural Madd (Madd Asli)',
      count: '2 counts',
      example: 'قَالَ / فِي / يَقُولُ',
      tip: 'Keep count steady and equal across repetitions.',
    ),
    TajweedMaddGuide(
      type: 'Madd in connected phrases',
      count: '2 counts baseline',
      example: 'فِي قُلُوبِهِمْ',
      tip: 'Do not shorten madd when recitation speed increases.',
    ),
    TajweedMaddGuide(
      type: 'Waqf-influenced length awareness',
      count: 'Based on stop context',
      example: 'Ending words before stop',
      tip: 'Use teacher-guided moderation; avoid random stretching.',
    ),
  ];

  static const List<TajweedWaqfGuide> waqf = [
    TajweedWaqfGuide(
      rule: 'Stop at complete meaning unit',
      pauseAction: 'Pause where phrase meaning naturally completes.',
      restartAction: 'Restart from a coherent word boundary.',
      example: '... الْفَلَقِ | مِنْ شَرِّ ...',
    ),
    TajweedWaqfGuide(
      rule: 'No trailing vowel echo',
      pauseAction: 'Close ending cleanly without adding "uh".',
      restartAction: 'Begin next phrase with clear first syllable.',
      example: 'رَبّ at stop, not rabbu.',
    ),
    TajweedWaqfGuide(
      rule: 'Restart with same tone level',
      pauseAction: 'Finish calmly and keep breath controlled.',
      restartAction: 'Resume at similar pitch and speed.',
      example: 'Avoid sudden loud re-entry after soft stop.',
    ),
  ];

  static const List<TajweedPhraseGuide> phrases = [
    TajweedPhraseGuide(
      arabic: 'مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'min sharri ma khalaq',
      focus: 'Ikhfa transition and kh articulation.',
    ),
    TajweedPhraseGuide(
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      transliteration: 'qul huwa Allahu ahad',
      focus: 'Qalqalah at stop and clean waqf handling.',
    ),
    TajweedPhraseGuide(
      arabic: 'إِنَّا أَعْطَيْنَاكَ',
      transliteration: 'inna a`taynaka',
      focus: 'Madd timing and smooth hamzah transition.',
    ),
    TajweedPhraseGuide(
      arabic: 'تَبَّتْ يَدَا أَبِي لَهَبٍ',
      transliteration: 'tabbat yada abi lahab',
      focus: 'Qalqalah feel and stop discipline.',
    ),
    TajweedPhraseGuide(
      arabic: 'مِنْ بَعْدِ مَا',
      transliteration: 'min ba`di ma',
      focus: 'Noon/tanween and meem-based transitions.',
    ),
  ];

  static const List<TajweedRevisionGuide> revision = [
    TajweedRevisionGuide(
      title: 'Rule identification',
      action: 'Label tajweed rule in 8 short examples before reciting.',
    ),
    TajweedRevisionGuide(
      title: 'Noon/meem drill',
      action:
          'Run one cycle each for izhar, idgham, iqlab, ikhfa, and meem rules.',
    ),
    TajweedRevisionGuide(
      title: 'Qalqalah check',
      action: 'Read 5 qalqalah words at stop and verify bounce control.',
    ),
    TajweedRevisionGuide(
      title: 'Madd and waqf check',
      action: 'Recite one ayah with fixed madd count and planned pauses.',
    ),
    TajweedRevisionGuide(
      title: 'Integrated recitation',
      action:
          'Recite one short surah with active rule awareness and self-review.',
    ),
  ];
}
