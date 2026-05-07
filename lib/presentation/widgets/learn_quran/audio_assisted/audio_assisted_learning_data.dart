import '../../../../core/localization/l10n_extensions.dart';

class AudioListeningDrillGuide {
  const AudioListeningDrillGuide({
    required String title,
    required String goal,
    required List<String> steps,
    required String successMarker,
  }) : _title = title,
       _goal = goal,
       _steps = steps,
       _successMarker = successMarker;

  final String _title;
  final String _goal;
  final List<String> _steps;
  final String _successMarker;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get goal => LearnQuranTextLocalizer.translateRaw(_goal);
  List<String> get steps =>
      _steps.map(LearnQuranTextLocalizer.translateRaw).toList();
  String get successMarker =>
      LearnQuranTextLocalizer.translateRaw(_successMarker);
}

class AudioShadowDrillGuide {
  const AudioShadowDrillGuide({
    required String level,
    required String pacing,
    required String action,
    required String watchFor,
  }) : _level = level,
       _pacing = pacing,
       _action = action,
       _watchFor = watchFor;

  final String _level;
  final String _pacing;
  final String _action;
  final String _watchFor;

  String get level => LearnQuranTextLocalizer.translateRaw(_level);
  String get pacing => LearnQuranTextLocalizer.translateRaw(_pacing);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
  String get watchFor => LearnQuranTextLocalizer.translateRaw(_watchFor);
}

class AudioErrorSpotGuide {
  const AudioErrorSpotGuide({
    required String category,
    required String checkPrompt,
    required String commonSigns,
    required String fix,
  }) : _category = category,
       _checkPrompt = checkPrompt,
       _commonSigns = commonSigns,
       _fix = fix;

  final String _category;
  final String _checkPrompt;
  final String _commonSigns;
  final String _fix;

  String get category => LearnQuranTextLocalizer.translateRaw(_category);
  String get checkPrompt => LearnQuranTextLocalizer.translateRaw(_checkPrompt);
  String get commonSigns => LearnQuranTextLocalizer.translateRaw(_commonSigns);
  String get fix => LearnQuranTextLocalizer.translateRaw(_fix);
}

class AudioSessionPlanGuide {
  const AudioSessionPlanGuide({
    required String phase,
    required String duration,
    required String task,
    required String output,
  }) : _phase = phase,
       _duration = duration,
       _task = task,
       _output = output;

  final String _phase;
  final String _duration;
  final String _task;
  final String _output;

  String get phase => LearnQuranTextLocalizer.translateRaw(_phase);
  String get duration => LearnQuranTextLocalizer.translateRaw(_duration);
  String get task => LearnQuranTextLocalizer.translateRaw(_task);
  String get output => LearnQuranTextLocalizer.translateRaw(_output);
}

class AudioRecitationSampleGuide {
  const AudioRecitationSampleGuide({
    required String reference,
    required String focus,
    required String listenFor,
    required String repeatTarget,
  }) : _reference = reference,
       _focus = focus,
       _listenFor = listenFor,
       _repeatTarget = repeatTarget;

  final String _reference;
  final String _focus;
  final String _listenFor;
  final String _repeatTarget;

  String get reference => LearnQuranTextLocalizer.translateRaw(_reference);
  String get focus => LearnQuranTextLocalizer.translateRaw(_focus);
  String get listenFor => LearnQuranTextLocalizer.translateRaw(_listenFor);
  String get repeatTarget =>
      LearnQuranTextLocalizer.translateRaw(_repeatTarget);
}

class AudioRevisionGuide {
  const AudioRevisionGuide({required String title, required String action})
    : _title = title,
      _action = action;

  final String _title;
  final String _action;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
}

class AudioAssistedLearningData {
  const AudioAssistedLearningData._();

  static const List<String> learningFlow = [
    'Focused listening warm-up',
    'Shadow recitation rounds',
    'Error spotting and correction',
    'Session planning and pacing',
    'Targeted sample practice',
    'Self-record and compare',
    'Revision and mastery check',
  ];

  static const List<AudioListeningDrillGuide> listeningDrills = [
    AudioListeningDrillGuide(
      title: 'Three-pass listening loop',
      goal: 'Catch pronunciation details before speaking.',
      steps: [
        'Pass 1: Listen for full ayah rhythm only.',
        'Pass 2: Listen for articulation points and clear consonants.',
        'Pass 3: Listen for madd and stop positions.',
      ],
      successMarker: 'You can describe 2 specific sound details from memory.',
    ),
    AudioListeningDrillGuide(
      title: 'Keyword listening map',
      goal: 'Track recurring words and transitions in short ayahs.',
      steps: [
        'Mark repeated words while listening.',
        'Note where pace slows or emphasis increases.',
        'Replay and verify your markings.',
      ],
      successMarker: 'At least 80% of marked points match replay.',
    ),
    AudioListeningDrillGuide(
      title: 'Breath point detection',
      goal: 'Recognize where to breathe without breaking meaning.',
      steps: [
        'Listen once and guess breath points.',
        'Listen again and compare with actual pause points.',
        'Adjust your planned breathing map.',
      ],
      successMarker: 'No mid-word or weak-boundary breath positions.',
    ),
  ];

  static const List<AudioShadowDrillGuide> shadowDrills = [
    AudioShadowDrillGuide(
      level: 'Soft shadow',
      pacing: 'Slow',
      action: 'Recite quietly under the audio to match shape and timing.',
      watchFor: 'Do not rush to catch up after missed syllables.',
    ),
    AudioShadowDrillGuide(
      level: 'Aligned shadow',
      pacing: 'Medium',
      action: 'Match start/end of phrases exactly with reciter.',
      watchFor: 'Avoid clipping long vowels to stay aligned.',
    ),
    AudioShadowDrillGuide(
      level: 'Lag shadow',
      pacing: 'Medium',
      action: 'Recite half-second behind audio for control and memory support.',
      watchFor: 'Keep transitions smooth instead of pausing between words.',
    ),
    AudioShadowDrillGuide(
      level: 'Solo transfer',
      pacing: 'Natural',
      action: 'Stop audio and recite same ayah independently.',
      watchFor: 'Retain same rhythm and stops learned from shadow round.',
    ),
  ];

  static const List<AudioErrorSpotGuide> errorSpotting = [
    AudioErrorSpotGuide(
      category: 'Madd length drift',
      checkPrompt: 'Are natural madd sounds kept at consistent count?',
      commonSigns: 'Long vowels become short on repeated rounds.',
      fix: 'Use finger count for each madd and re-run phrase twice.',
    ),
    AudioErrorSpotGuide(
      category: 'Heavy/light confusion',
      checkPrompt: 'Are heavy letters distinct from lighter neighbors?',
      commonSigns: 'Saad sounds like seen, qaaf sounds like kaaf.',
      fix: 'Isolate pair words and shadow slowly before full recitation.',
    ),
    AudioErrorSpotGuide(
      category: 'Stop/restart instability',
      checkPrompt: 'Do you pause at safe boundaries only?',
      commonSigns: 'Breath break in weak positions or word merges.',
      fix: 'Mark stop points visually and practice planned pauses.',
    ),
    AudioErrorSpotGuide(
      category: 'Rhythm inconsistency',
      checkPrompt: 'Does speed remain stable from start to end?',
      commonSigns: 'Fast opening then slowed ending from breath loss.',
      fix: 'Train one ayah per breath with controlled, even tempo.',
    ),
  ];

  static const List<AudioSessionPlanGuide> sessionPlans = [
    AudioSessionPlanGuide(
      phase: 'Warm-up listening',
      duration: '3 min',
      task: 'Run one focused listening loop on selected ayah.',
      output: 'One list of target sound cues.',
    ),
    AudioSessionPlanGuide(
      phase: 'Shadow training',
      duration: '5 min',
      task: 'Complete soft and aligned shadow rounds.',
      output: 'Stable phrase timing match with audio.',
    ),
    AudioSessionPlanGuide(
      phase: 'Solo recitation',
      duration: '4 min',
      task: 'Recite without audio using learned rhythm.',
      output: 'Independent recitation with minimal hesitation.',
    ),
    AudioSessionPlanGuide(
      phase: 'Error correction',
      duration: '4 min',
      task: 'Identify two mistakes and apply targeted fixes.',
      output: 'Improved second attempt recording.',
    ),
    AudioSessionPlanGuide(
      phase: 'Final check',
      duration: '2 min',
      task: 'One clean pass at prayer pace.',
      output: 'Confidence-ready recitation sample.',
    ),
  ];

  static const List<AudioRecitationSampleGuide> sampleTargets = [
    AudioRecitationSampleGuide(
      reference: 'Al-Alaq 96:1-5',
      focus: 'Clear articulation in command and revelation phrases.',
      listenFor: 'Strong qaf and balanced pause points.',
      repeatTarget: '2 shadow rounds + 1 solo pass.',
    ),
    AudioRecitationSampleGuide(
      reference: 'Al-Qadr 97:1-5',
      focus: 'Rhythm consistency in repeated phrase structure.',
      listenFor: 'Stable tempo and smooth phrase joins.',
      repeatTarget: '3 loop rounds with one self-record.',
    ),
    AudioRecitationSampleGuide(
      reference: 'Al-Kawthar 108:1-3',
      focus: 'Concise ayah delivery with confident endings.',
      listenFor: 'No clipped endings and clear command transition.',
      repeatTarget: '1 listening pass + 2 independent recitations.',
    ),
  ];

  static const List<AudioRevisionGuide> revision = [
    AudioRevisionGuide(
      title: 'Daily listening drill',
      action: 'Complete one 3-pass listening loop on a short ayah.',
    ),
    AudioRevisionGuide(
      title: 'Shadow consistency check',
      action: 'Run two shadow rounds and compare phrase timing.',
    ),
    AudioRevisionGuide(
      title: 'Error-spot routine',
      action: 'Detect and fix two recurring pronunciation mistakes.',
    ),
    AudioRevisionGuide(
      title: 'Self-record compare',
      action: 'Record one passage and compare with reference playback.',
    ),
    AudioRevisionGuide(
      title: 'Weekly confidence pass',
      action: 'Recite 3 short passages in one uninterrupted session.',
    ),
  ];
}
