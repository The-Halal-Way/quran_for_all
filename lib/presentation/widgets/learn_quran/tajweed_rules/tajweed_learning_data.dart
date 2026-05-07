import '../../../../core/localization/l10n_extensions.dart';

class TajweedRuleFamilyGuide {
  const TajweedRuleFamilyGuide({
    required String rule,
    required String trigger,
    required String howToRead,
    required String example,
    required String coachNote,
  }) : _rule = rule,
       _trigger = trigger,
       _howToRead = howToRead,
       _example = example,
       _coachNote = coachNote;

  final String _rule;
  final String _trigger;
  final String _howToRead;
  final String _example;
  final String _coachNote;

  String get rule => LearnQuranTextLocalizer.translateRaw(_rule);
  String get trigger => LearnQuranTextLocalizer.translateRaw(_trigger);
  String get howToRead => LearnQuranTextLocalizer.translateRaw(_howToRead);
  String get example => LearnQuranTextLocalizer.translateRaw(_example);
  String get coachNote => LearnQuranTextLocalizer.translateRaw(_coachNote);
}

class TajweedMeemRuleGuide {
  const TajweedMeemRuleGuide({
    required String rule,
    required String trigger,
    required String delivery,
    required String example,
    required String mistake,
  }) : _rule = rule,
       _trigger = trigger,
       _delivery = delivery,
       _example = example,
       _mistake = mistake;

  final String _rule;
  final String _trigger;
  final String _delivery;
  final String _example;
  final String _mistake;

  String get rule => LearnQuranTextLocalizer.translateRaw(_rule);
  String get trigger => LearnQuranTextLocalizer.translateRaw(_trigger);
  String get delivery => LearnQuranTextLocalizer.translateRaw(_delivery);
  String get example => LearnQuranTextLocalizer.translateRaw(_example);
  String get mistake => LearnQuranTextLocalizer.translateRaw(_mistake);
}

class TajweedQalqalahGuide {
  const TajweedQalqalahGuide({
    required String letter,
    required String sample,
    required String when,
    required String note,
  }) : _letter = letter,
       _sample = sample,
       _when = when,
       _note = note;

  final String _letter;
  final String _sample;
  final String _when;
  final String _note;

  String get letter => LearnQuranTextLocalizer.translateRaw(_letter);
  String get sample => LearnQuranTextLocalizer.translateRaw(_sample);
  String get when => LearnQuranTextLocalizer.translateRaw(_when);
  String get note => LearnQuranTextLocalizer.translateRaw(_note);
}

class TajweedMaddGuide {
  const TajweedMaddGuide({
    required String type,
    required String count,
    required String example,
    required String tip,
  }) : _type = type,
       _count = count,
       _example = example,
       _tip = tip;

  final String _type;
  final String _count;
  final String _example;
  final String _tip;

  String get type => LearnQuranTextLocalizer.translateRaw(_type);
  String get count => LearnQuranTextLocalizer.translateRaw(_count);
  String get example => LearnQuranTextLocalizer.translateRaw(_example);
  String get tip => LearnQuranTextLocalizer.translateRaw(_tip);
}

class TajweedWaqfGuide {
  const TajweedWaqfGuide({
    required String rule,
    required String pauseAction,
    required String restartAction,
    required String example,
  }) : _rule = rule,
       _pauseAction = pauseAction,
       _restartAction = restartAction,
       _example = example;

  final String _rule;
  final String _pauseAction;
  final String _restartAction;
  final String _example;

  String get rule => LearnQuranTextLocalizer.translateRaw(_rule);
  String get pauseAction => LearnQuranTextLocalizer.translateRaw(_pauseAction);
  String get restartAction =>
      LearnQuranTextLocalizer.translateRaw(_restartAction);
  String get example => LearnQuranTextLocalizer.translateRaw(_example);
}

class TajweedPhraseGuide {
  const TajweedPhraseGuide({
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

class TajweedRevisionGuide {
  const TajweedRevisionGuide({required String title, required String action})
    : _title = title,
      _action = action;

  final String _title;
  final String _action;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
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
