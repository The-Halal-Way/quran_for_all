class PronunciationContrastGuide {
  const PronunciationContrastGuide({
    required this.pair,
    required this.lightExample,
    required this.heavyExample,
    required this.keyDifference,
    required this.coachTip,
  });

  final String pair;
  final String lightExample;
  final String heavyExample;
  final String keyDifference;
  final String coachTip;
}

class PronunciationPostureGuide {
  const PronunciationPostureGuide({
    required this.focus,
    required this.indicator,
    required this.doThis,
    required this.avoidThis,
  });

  final String focus;
  final String indicator;
  final String doThis;
  final String avoidThis;
}

class MaddPatternGuide {
  const MaddPatternGuide({
    required this.label,
    required this.sound,
    required this.count,
    required this.example,
    required this.note,
  });

  final String label;
  final String sound;
  final String count;
  final String example;
  final String note;
}

class StopRestartGuide {
  const StopRestartGuide({
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

class FlowDrillGuide {
  const FlowDrillGuide({
    required this.title,
    required this.steps,
    required this.goal,
  });

  final String title;
  final List<String> steps;
  final String goal;
}

class AppliedPhraseGuide {
  const AppliedPhraseGuide({
    required this.arabic,
    required this.transliteration,
    required this.focus,
  });

  final String arabic;
  final String transliteration;
  final String focus;
}

class RevisionChecklistGuide {
  const RevisionChecklistGuide({required this.title, required this.action});

  final String title;
  final String action;
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
