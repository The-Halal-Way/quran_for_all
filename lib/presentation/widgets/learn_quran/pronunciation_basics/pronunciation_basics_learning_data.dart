import '../../../../core/localization/l10n_extensions.dart';

class PronunciationContrastGuide {
  const PronunciationContrastGuide({
    required String pair,
    required String lightExample,
    required String heavyExample,
    required String keyDifference,
    required String coachTip,
  }) : _pair = pair,
       _lightExample = lightExample,
       _heavyExample = heavyExample,
       _keyDifference = keyDifference,
       _coachTip = coachTip;

  final String _pair;
  final String _lightExample;
  final String _heavyExample;
  final String _keyDifference;
  final String _coachTip;

  String get pair => LearnQuranTextLocalizer.translateRaw(_pair);
  String get lightExample => LearnQuranTextLocalizer.translateRaw(_lightExample);
  String get heavyExample => LearnQuranTextLocalizer.translateRaw(_heavyExample);
  String get keyDifference =>
      LearnQuranTextLocalizer.translateRaw(_keyDifference);
  String get coachTip => LearnQuranTextLocalizer.translateRaw(_coachTip);
}

class PronunciationPostureGuide {
  const PronunciationPostureGuide({
    required String focus,
    required String indicator,
    required String doThis,
    required String avoidThis,
  }) : _focus = focus,
       _indicator = indicator,
       _doThis = doThis,
       _avoidThis = avoidThis;

  final String _focus;
  final String _indicator;
  final String _doThis;
  final String _avoidThis;

  String get focus => LearnQuranTextLocalizer.translateRaw(_focus);
  String get indicator => LearnQuranTextLocalizer.translateRaw(_indicator);
  String get doThis => LearnQuranTextLocalizer.translateRaw(_doThis);
  String get avoidThis => LearnQuranTextLocalizer.translateRaw(_avoidThis);
}

class MaddPatternGuide {
  const MaddPatternGuide({
    required String label,
    required String sound,
    required String count,
    required String example,
    required String note,
  }) : _label = label,
       _sound = sound,
       _count = count,
       _example = example,
       _note = note;

  final String _label;
  final String _sound;
  final String _count;
  final String _example;
  final String _note;

  String get label => LearnQuranTextLocalizer.translateRaw(_label);
  String get sound => LearnQuranTextLocalizer.translateRaw(_sound);
  String get count => LearnQuranTextLocalizer.translateRaw(_count);
  String get example => LearnQuranTextLocalizer.translateRaw(_example);
  String get note => LearnQuranTextLocalizer.translateRaw(_note);
}

class StopRestartGuide {
  const StopRestartGuide({
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

class FlowDrillGuide {
  const FlowDrillGuide({
    required String title,
    required List<String> steps,
    required String goal,
  }) : _title = title,
       _steps = steps,
       _goal = goal;

  final String _title;
  final List<String> _steps;
  final String _goal;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  List<String> get steps =>
      _steps.map(LearnQuranTextLocalizer.translateRaw).toList();
  String get goal => LearnQuranTextLocalizer.translateRaw(_goal);
}

class AppliedPhraseGuide {
  const AppliedPhraseGuide({
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

class RevisionChecklistGuide {
  const RevisionChecklistGuide({required String title, required String action})
    : _title = title,
      _action = action;

  final String _title;
  final String _action;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
}

class PronunciationBasicsLearningData {
  const PronunciationBasicsLearningData._();

  static const List<String> learningFlow = [
    'Heavy vs light contrast',
    'Posture and articulation cues',
    'Madd timing control',
    'Stopping without extra vowels',
    'Restart consistency',
    'Applied phrase drills',
    'Revision and self-check',
  ];

  static const List<PronunciationContrastGuide> contrasts = [
    PronunciationContrastGuide(
      pair: 'ق / ك',
      lightExample: 'كَتَبَ (kataba)',
      heavyExample: 'قَدْ (qad)',
      keyDifference: 'Qaaf is deeper from the back of tongue; kaaf is lighter.',
      coachTip: 'Keep qaaf full and back-focused. Do not flatten it into kaaf.',
    ),
    PronunciationContrastGuide(
      pair: 'ص / س',
      lightExample: 'سَبِيل (sabil)',
      heavyExample: 'صِرَاط (sirat)',
      keyDifference: 'Saad is heavy and fuller; seen stays thin and forward.',
      coachTip: 'Darken saad slightly, but avoid over-pressing the jaw.',
    ),
    PronunciationContrastGuide(
      pair: 'ط / ت',
      lightExample: 'تُبْ (tub)',
      heavyExample: 'طُور (tur)',
      keyDifference:
          'Taa-heavy carries weight; regular taa is lighter and clear.',
      coachTip:
          'For ط, keep tongue contact firm and release with a fuller tone.',
    ),
    PronunciationContrastGuide(
      pair: 'ظ / ز',
      lightExample: 'زَكَى (zaka)',
      heavyExample: 'ظُلْم (zulm)',
      keyDifference:
          'Zaa-heavy keeps thickness, while zay is narrow and lighter.',
      coachTip: 'Do not let ظ collapse into ز during fast recitation.',
    ),
    PronunciationContrastGuide(
      pair: 'ح / ه',
      lightExample: 'هُدًى (huda)',
      heavyExample: 'حَقّ (haqq)',
      keyDifference:
          'Haa (ح) is deeper breath from throat; haa (ه) is lighter.',
      coachTip: 'Avoid substituting both with the same English-style h sound.',
    ),
    PronunciationContrastGuide(
      pair: 'ذ / د',
      lightExample: 'دِين (din)',
      heavyExample: 'ذِكْر (dhikr)',
      keyDifference: 'Dhaal has softer, front-edge release than daal.',
      coachTip:
          'Place tongue near upper teeth for ذ, not fully behind ridge like د.',
    ),
  ];

  static const List<PronunciationPostureGuide> postureCues = [
    PronunciationPostureGuide(
      focus: 'Jaw relaxation',
      indicator: 'steady opening',
      doThis: 'Keep jaw naturally open without stiffness during long sounds.',
      avoidThis: 'Do not lock jaw; tension distorts heavy/light contrast.',
    ),
    PronunciationPostureGuide(
      focus: 'Tongue precision',
      indicator: 'clean contact points',
      doThis: 'Touch exact articulation points briefly and release cleanly.',
      avoidThis: 'Do not drag tongue placement across nearby letters.',
    ),
    PronunciationPostureGuide(
      focus: 'Lip control',
      indicator: 'clear rounding/closure',
      doThis: 'Round for damma sounds and close fully for baa/meem stops.',
      avoidThis: 'Do not leak air at lip closures.',
    ),
    PronunciationPostureGuide(
      focus: 'Airflow balance',
      indicator: 'smooth breath stream',
      doThis: 'Maintain even airflow across phrases.',
      avoidThis: 'Avoid sudden force bursts that break rhythm.',
    ),
    PronunciationPostureGuide(
      focus: 'Voice tone',
      indicator: 'stable loudness',
      doThis: 'Use moderate tone for clarity and control.',
      avoidThis: 'Do not shout heavy letters or whisper light letters.',
    ),
  ];

  static const List<MaddPatternGuide> maddPatterns = [
    MaddPatternGuide(
      label: 'Natural madd with alif',
      sound: 'aa',
      count: '2 beats',
      example: 'قَالَ (qaala)',
      note: 'Count evenly: 1-2, without stretching beyond control.',
    ),
    MaddPatternGuide(
      label: 'Natural madd with yaa',
      sound: 'ee',
      count: '2 beats',
      example: 'قِيلَ (qeela)',
      note: 'Keep tone stable from start to end of the vowel.',
    ),
    MaddPatternGuide(
      label: 'Natural madd with waaw',
      sound: 'oo',
      count: '2 beats',
      example: 'يَقُولُ (yaqulu)',
      note: 'Round lips lightly and avoid collapsing into a short u.',
    ),
    MaddPatternGuide(
      label: 'Madd in phrase flow',
      sound: 'aa/ee/oo',
      count: '2 beats each',
      example: 'فِي قُلُوبِهِمْ (fee quloobihim)',
      note: 'Do not speed up the second syllable after a madd.',
    ),
  ];

  static const List<StopRestartGuide> stopRestartRules = [
    StopRestartGuide(
      rule: 'Stop on sukoon-like ending',
      pauseAction: 'End with a clean consonant stop.',
      restartAction: 'Restart from the nearest complete word.',
      example: '... قُلْ | هُوَ اللَّهُ ...',
    ),
    StopRestartGuide(
      rule: 'No extra vowel at stop',
      pauseAction: 'Cut sound cleanly without adding "uh".',
      restartAction: 'Resume with clear first syllable.',
      example: 'رَبّ (stop as rabb, not rabbu).',
    ),
    StopRestartGuide(
      rule: 'Planned breath pause',
      pauseAction: 'Pause at phrase boundary, not middle of attached meaning.',
      restartAction: 'Take one calm breath, then restart with same tempo.',
      example: '... الْفَلَقِ | مِنْ شَرِّ ...',
    ),
    StopRestartGuide(
      rule: 'Restart with tone continuity',
      pauseAction: 'Finish line at comfortable tone.',
      restartAction: 'Restart with similar loudness and rhythm.',
      example: 'Avoid restarting too loud after quiet stop.',
    ),
  ];

  static const List<FlowDrillGuide> flowDrills = [
    FlowDrillGuide(
      title: '2-beat pacing drill',
      steps: [
        'Read one short line at slow pace.',
        'Tap two beats for each natural madd.',
        'Repeat three times with same tempo.',
      ],
      goal: 'Build consistent timing and prevent rushing.',
    ),
    FlowDrillGuide(
      title: 'Contrast chain drill',
      steps: [
        'Recite ق ك ق ك slowly.',
        'Repeat with ص س ص س and ط ت ط ت.',
        'Use mirror or audio feedback for clarity.',
      ],
      goal: 'Lock heavy/light distinction under repetition.',
    ),
    FlowDrillGuide(
      title: 'Stop-release drill',
      steps: [
        'Read 5 words ending with sukoon.',
        'Stop each word cleanly without echo vowel.',
        'Restart each word with steady tone.',
      ],
      goal: 'Improve ending clarity and restart confidence.',
    ),
    FlowDrillGuide(
      title: 'Single-breath phrase drill',
      steps: [
        'Choose one short ayah phrase.',
        'Read in one controlled breath at medium speed.',
        'Repeat while preserving pronunciation quality.',
      ],
      goal: 'Strengthen flow without sacrificing letter accuracy.',
    ),
  ];

  static const List<AppliedPhraseGuide> appliedPhrases = [
    AppliedPhraseGuide(
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      transliteration: 'qul huwa Allahu ahad',
      focus: 'Qaaf depth, clean sukoon on laam, and balanced flow.',
    ),
    AppliedPhraseGuide(
      arabic: 'إِنَّا أَعْطَيْنَاكَ',
      transliteration: 'inna aataynaka',
      focus: 'Natural madd timing and smooth transition after hamzah.',
    ),
    AppliedPhraseGuide(
      arabic: 'مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'min sharri ma khalaq',
      focus: 'Controlled stop/release and clear kh sound.',
    ),
    AppliedPhraseGuide(
      arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      transliteration: 'ihdina as-sirata al-mustaqim',
      focus: 'Heavy/light contrast and stable phrase pacing.',
    ),
    AppliedPhraseGuide(
      arabic: 'فِي قُلُوبِهِمْ',
      transliteration: 'fee quloobihim',
      focus: 'Yaa madd count and rounded waaw sound.',
    ),
  ];

  static const List<RevisionChecklistGuide> revisionChecklist = [
    RevisionChecklistGuide(
      title: 'Contrast warm-up',
      action: 'Recite three heavy/light pairs in slow and medium speed.',
    ),
    RevisionChecklistGuide(
      title: 'Posture check',
      action: 'Review jaw, tongue, and lip cues before practice line.',
    ),
    RevisionChecklistGuide(
      title: 'Madd count check',
      action: 'Read one line and hold each natural madd for exactly 2 beats.',
    ),
    RevisionChecklistGuide(
      title: 'Pause-restart check',
      action: 'Do two deliberate stops and restart each phrase clearly.',
    ),
    RevisionChecklistGuide(
      title: 'Self-record review',
      action: 'Record 30 seconds and note one strength plus one correction.',
    ),
  ];
}
