import '../../../../../core/localization/l10n_extensions.dart';

class MakharijZoneGuide {
  const MakharijZoneGuide({
    required String zone,
    required String letters,
    required String locationCue,
    required String soundCue,
    required String commonMistake,
    required String drill,
  }) : _zone = zone,
       _letters = letters,
       _locationCue = locationCue,
       _soundCue = soundCue,
       _commonMistake = commonMistake,
       _drill = drill;

  final String _zone;
  final String _letters;
  final String _locationCue;
  final String _soundCue;
  final String _commonMistake;
  final String _drill;

  String get zone => LearnQuranTextLocalizer.translateRaw(_zone);
  String get letters => LearnQuranTextLocalizer.translateRaw(_letters);
  String get locationCue => LearnQuranTextLocalizer.translateRaw(_locationCue);
  String get soundCue => LearnQuranTextLocalizer.translateRaw(_soundCue);
  String get commonMistake =>
      LearnQuranTextLocalizer.translateRaw(_commonMistake);
  String get drill => LearnQuranTextLocalizer.translateRaw(_drill);
}

class MakharijComparisonGuide {
  const MakharijComparisonGuide({
    required String pair,
    required String distinction,
    required String practice,
    required String watchFor,
  }) : _pair = pair,
       _distinction = distinction,
       _practice = practice,
       _watchFor = watchFor;

  final String _pair;
  final String _distinction;
  final String _practice;
  final String _watchFor;

  String get pair => LearnQuranTextLocalizer.translateRaw(_pair);
  String get distinction => LearnQuranTextLocalizer.translateRaw(_distinction);
  String get practice => LearnQuranTextLocalizer.translateRaw(_practice);
  String get watchFor => LearnQuranTextLocalizer.translateRaw(_watchFor);
}

class MakharijDrillGuide {
  const MakharijDrillGuide({
    required String title,
    required List<String> steps,
    required String target,
  }) : _title = title,
       _steps = steps,
       _target = target;

  final String _title;
  final List<String> _steps;
  final String _target;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  List<String> get steps =>
      _steps.map(LearnQuranTextLocalizer.translateRaw).toList();
  String get target => LearnQuranTextLocalizer.translateRaw(_target);
}

class MakharijPhraseGuide {
  const MakharijPhraseGuide({
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

class MakharijRevisionGuide {
  const MakharijRevisionGuide({required String title, required String action})
    : _title = title,
      _action = action;

  final String _title;
  final String _action;

  String get title => LearnQuranTextLocalizer.translateRaw(_title);
  String get action => LearnQuranTextLocalizer.translateRaw(_action);
}

class MakharijLearningData {
  const MakharijLearningData._();

  static const List<String> learningFlow = [
    'Map the articulation zones',
    'Master throat letters',
    'Stabilize tongue-based sounds',
    'Control lips and ghunnah',
    'Correct confusion pairs',
    'Apply in Quran phrases',
    'Review and self-check',
  ];

  static const List<MakharijZoneGuide> zones = [
    MakharijZoneGuide(
      zone: 'Deep throat (aqsa al-halq)',
      letters: 'ء ه',
      locationCue: 'From the deepest throat origin.',
      soundCue: 'Start cleanly without adding extra glide.',
      commonMistake: 'Weak hamzah onset or breathy, unclear haa.',
      drill: 'ءَ أَ ءُ | هَ هِ هُ',
    ),
    MakharijZoneGuide(
      zone: 'Middle throat (wasat al-halq)',
      letters: 'ع ح',
      locationCue: 'From the mid-throat area with open passage.',
      soundCue: 'Keep controlled depth and stable airflow.',
      commonMistake: 'Reading ع as flat vowel or ح as regular h.',
      drill: 'عَ عِ عُ | حَ حِ حُ',
    ),
    MakharijZoneGuide(
      zone: 'Upper throat (adna al-halq)',
      letters: 'غ خ',
      locationCue: 'Near upper throat toward mouth entrance.',
      soundCue: 'Use textured friction without over-force.',
      commonMistake: 'Turning خ into soft h or collapsing غ sound.',
      drill: 'غَ غِ غُ | خَ خِ خُ',
    ),
    MakharijZoneGuide(
      zone: 'Back and middle tongue',
      letters: 'ق ك ج ش ي',
      locationCue: 'Back and center tongue contact points.',
      soundCue: 'Differentiate depth for ق/ك and spread for ش.',
      commonMistake: 'Reading ق like ك or reducing ش clarity.',
      drill: 'قَ كَ | جَ شَ يَ',
    ),
    MakharijZoneGuide(
      zone: 'Tongue tip and edge',
      letters: 'ت د ط ث ذ ظ س ز ص ض ن ل ر',
      locationCue: 'Tip/blade contacts with teeth and ridge zones.',
      soundCue: 'Use precise, brief contact then clear release.',
      commonMistake: 'Blending heavy and light pairs under speed.',
      drill: 'تَ دَ طَ | سَ صَ | ذَ زَ',
    ),
    MakharijZoneGuide(
      zone: 'Lips and nasal cavity',
      letters: 'ف ب م و + ghunnah',
      locationCue: 'Lip closure/rounding and nasal resonance support.',
      soundCue: 'Seal lips fully for ب/م and keep ف airy but sharp.',
      commonMistake: 'Air leak on lip letters and unstable ghunnah.',
      drill: 'فَ بَ مَ وَ | مّ نّ (ghunnah)',
    ),
  ];

  static const List<MakharijComparisonGuide> comparisons = [
    MakharijComparisonGuide(
      pair: 'ق / ك',
      distinction:
          'Qaaf is deeper from back tongue; kaaf is lighter and fronted.',
      practice: 'قَ كَ قَ كَ in slow and medium rounds.',
      watchFor: 'Do not flatten ق into ك.',
    ),
    MakharijComparisonGuide(
      pair: 'س / ص',
      distinction:
          'Seen stays light; saad carries heaviness and fuller resonance.',
      practice: 'سَ صَ سِ صِ in paired cycles.',
      watchFor: 'Avoid reading ص with thin tone.',
    ),
    MakharijComparisonGuide(
      pair: 'ت / ط',
      distinction: 'Taa is light; taa-heavy requires fuller pressure and tone.',
      practice: 'تَ طَ تُ طُ with equal pacing.',
      watchFor: 'Do not over-press ط into harsh sound.',
    ),
    MakharijComparisonGuide(
      pair: 'د / ذ',
      distinction: 'Dhaal uses softer front-edge release than daal.',
      practice: 'دَ ذَ دِ ذِ with tongue-position awareness.',
      watchFor: 'Do not replace ذ with ز or د.',
    ),
    MakharijComparisonGuide(
      pair: 'ح / ه and ع / ء',
      distinction: 'ح and ع are deeper throat sounds than ه and ء.',
      practice: 'حَ هَ | عَ ءَ while preserving depth contrast.',
      watchFor: 'Avoid merging both pairs into one sound quality.',
    ),
  ];

  static const List<MakharijDrillGuide> drills = [
    MakharijDrillGuide(
      title: 'Zone sweep drill',
      steps: [
        'Read one sample from each makhraj zone.',
        'Pause 1 second between zones to reset articulation.',
        'Repeat full sweep three times with equal clarity.',
      ],
      target: 'Build zone awareness and consistent letter identity.',
    ),
    MakharijDrillGuide(
      title: 'Throat precision drill',
      steps: [
        'Recite ء ه ع ح غ خ in slow sequence.',
        'Repeat each pair twice before moving on.',
        'Record and compare depth and friction quality.',
      ],
      target: 'Stabilize throat-origin distinctions.',
    ),
    MakharijDrillGuide(
      title: 'Tongue placement ladder',
      steps: [
        'Run ق/ك, س/ص, ت/ط, د/ذ sequence.',
        'Maintain same tempo for each pair.',
        'Repeat at medium speed without losing contrast.',
      ],
      target: 'Keep precision when pace increases.',
    ),
    MakharijDrillGuide(
      title: 'Lip and ghunnah control drill',
      steps: [
        'Read ف ب م و sets with clear lip motion.',
        'Add noon-meem ghunnah for two-count hum.',
        'Blend into one short phrase recitation.',
      ],
      target: 'Coordinate lips, airflow, and nasal resonance.',
    ),
  ];

  static const List<MakharijPhraseGuide> phrases = [
    MakharijPhraseGuide(
      arabic: 'مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'min sharri ma khalaq',
      focus: 'Kh articulation and clean shaddah emphasis.',
    ),
    MakharijPhraseGuide(
      arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
      transliteration: 'qul a`oodhu birabbin-naas',
      focus: 'Qaaf depth, `ayn onset, and smooth noon transition.',
    ),
    MakharijPhraseGuide(
      arabic: 'إِيَّاكَ نَعْبُدُ',
      transliteration: 'iyyaka na`budu',
      focus: 'Yaa clarity, `ayn control, and baa closure.',
    ),
    MakharijPhraseGuide(
      arabic: 'وَمِنْ غَاسِقٍ إِذَا وَقَبَ',
      transliteration: 'wa min ghasiqin idha waqab',
      focus: 'Ghayn texture and qaaf articulation contrast.',
    ),
    MakharijPhraseGuide(
      arabic: 'صِرَاطَ الَّذِينَ',
      transliteration: 'sirata alladhina',
      focus: 'Saad heaviness and dhaal release precision.',
    ),
  ];

  static const List<MakharijRevisionGuide> revision = [
    MakharijRevisionGuide(
      title: 'Zone recall',
      action: 'Name each zone and read two letters from it.',
    ),
    MakharijRevisionGuide(
      title: 'Pair correction',
      action: 'Run 5 confusion pairs and fix weak distinctions.',
    ),
    MakharijRevisionGuide(
      title: 'Phrase articulation pass',
      action: 'Read 3 phrases and mark one target letter each.',
    ),
    MakharijRevisionGuide(
      title: 'Audio self-audit',
      action: 'Record 30 seconds and note one articulation improvement.',
    ),
    MakharijRevisionGuide(
      title: 'Final recitation check',
      action: 'Recite one short surah with deliberate makharij focus.',
    ),
  ];
}
