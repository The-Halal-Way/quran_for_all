class WordByWordVocabGuide {
  const WordByWordVocabGuide({
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.usage,
  });

  final String arabic;
  final String transliteration;
  final String meaning;
  final String usage;
}

class WordByWordRootGuide {
  const WordByWordRootGuide({
    required this.root,
    required this.family,
    required this.coreMeaning,
    required this.examples,
    required this.tip,
  });

  final String root;
  final String family;
  final String coreMeaning;
  final String examples;
  final String tip;
}

class WordByWordConnectorGuide {
  const WordByWordConnectorGuide({
    required this.word,
    required this.function,
    required this.sample,
    required this.readingCue,
  });

  final String word;
  final String function;
  final String sample;
  final String readingCue;
}

class WordByWordPhraseGuide {
  const WordByWordPhraseGuide({
    required this.arabic,
    required this.transliteration,
    required this.breakdown,
    required this.meaning,
  });

  final String arabic;
  final String transliteration;
  final String breakdown;
  final String meaning;
}

class WordByWordAyahPracticeGuide {
  const WordByWordAyahPracticeGuide({
    required this.reference,
    required this.arabic,
    required this.transliteration,
    required this.focus,
  });

  final String reference;
  final String arabic;
  final String transliteration;
  final String focus;
}

class WordByWordRevisionGuide {
  const WordByWordRevisionGuide({required this.title, required this.action});

  final String title;
  final String action;
}

class WordByWordLearningData {
  const WordByWordLearningData._();

  static const List<String> learningFlow = [
    'High-frequency vocabulary',
    'Root-family awareness',
    'Connector words and particles',
    'Phrase-by-phrase breakdown',
    'Ayah-level meaning mapping',
    'Guided reflection summary',
    'Revision and self-check',
  ];

  static const List<WordByWordVocabGuide> coreVocabulary = [
    WordByWordVocabGuide(
      arabic: 'اللَّه',
      transliteration: 'Allah',
      meaning: 'Allah (God)',
      usage: 'Central name repeated throughout the Quran.',
    ),
    WordByWordVocabGuide(
      arabic: 'رَبّ',
      transliteration: 'rabb',
      meaning: 'Lord, Sustainer',
      usage: 'Appears in dua, praise, and dependence contexts.',
    ),
    WordByWordVocabGuide(
      arabic: 'يَوْم',
      transliteration: 'yawm',
      meaning: 'Day',
      usage: 'Often linked to Judgment, worship, and time reminders.',
    ),
    WordByWordVocabGuide(
      arabic: 'آيَة',
      transliteration: 'ayah',
      meaning: 'Sign, verse',
      usage: 'Refers to Quran verses and signs in creation.',
    ),
    WordByWordVocabGuide(
      arabic: 'إِيمَان',
      transliteration: 'iman',
      meaning: 'Faith',
      usage: 'Used with belief, trust, and righteous action themes.',
    ),
    WordByWordVocabGuide(
      arabic: 'عِلْم',
      transliteration: 'ilm',
      meaning: 'Knowledge',
      usage: 'Linked with learning, evidence, and humility.',
    ),
    WordByWordVocabGuide(
      arabic: 'رَحْمَة',
      transliteration: 'rahmah',
      meaning: 'Mercy',
      usage: 'Frequently paired with forgiveness and guidance.',
    ),
    WordByWordVocabGuide(
      arabic: 'هُدًى',
      transliteration: 'hudan',
      meaning: 'Guidance',
      usage: 'Describes Quran as direction for believers.',
    ),
    WordByWordVocabGuide(
      arabic: 'نُور',
      transliteration: 'nur',
      meaning: 'Light',
      usage: 'Used for faith, revelation, and clarity.',
    ),
    WordByWordVocabGuide(
      arabic: 'صَبْر',
      transliteration: 'sabr',
      meaning: 'Patience',
      usage: 'Appears in trials, worship, and moral growth.',
    ),
    WordByWordVocabGuide(
      arabic: 'شُكْر',
      transliteration: 'shukr',
      meaning: 'Gratitude',
      usage: 'Connected to blessings and obedience.',
    ),
    WordByWordVocabGuide(
      arabic: 'قَلْب',
      transliteration: 'qalb',
      meaning: 'Heart',
      usage: 'Used for sincerity, understanding, and reform.',
    ),
  ];

  static const List<WordByWordRootGuide> roots = [
    WordByWordRootGuide(
      root: 'ر-ح-م',
      family: 'rahmah, rahim, arham',
      coreMeaning: 'Mercy and compassionate care',
      examples: 'الرَّحْمٰن, الرَّحِيم, رَحْمَة',
      tip: 'When this root appears, look for mercy-related meaning.',
    ),
    WordByWordRootGuide(
      root: 'غ-ف-ر',
      family: 'ghafur, maghfirah, yaghfir',
      coreMeaning: 'Forgiveness and covering faults',
      examples: 'غَفُور, مَغْفِرَة, يَغْفِرُ',
      tip: 'This root often appears with tawbah and mercy themes.',
    ),
    WordByWordRootGuide(
      root: 'ه-د-ي',
      family: 'huda, yahdi, ihdina',
      coreMeaning: 'Guidance and direction',
      examples: 'هُدًى, يَهْدِي, اهْدِنَا',
      tip: 'Track this root in recitation to notice guidance requests.',
    ),
    WordByWordRootGuide(
      root: 'ع-ل-م',
      family: 'ilm, allama, alim',
      coreMeaning: 'Knowledge and awareness',
      examples: 'عِلْم, عَلَّمَ, عَلِيم',
      tip: 'Same root, different patterns; meaning stays in knowledge space.',
    ),
    WordByWordRootGuide(
      root: 'ص-ب-ر',
      family: 'sabr, sabirin, isbir',
      coreMeaning: 'Patience and steadfastness',
      examples: 'صَبْر, الصَّابِرِين, اصْبِرْ',
      tip: 'Connect this root with endurance and worship discipline.',
    ),
  ];

  static const List<WordByWordConnectorGuide> connectors = [
    WordByWordConnectorGuide(
      word: 'وَ',
      function: 'And',
      sample: 'وَالْعَصْرِ',
      readingCue: 'Attach smoothly to the following word in flow.',
    ),
    WordByWordConnectorGuide(
      word: 'فَ',
      function: 'So/Then',
      sample: 'فَصَلِّ',
      readingCue: 'Signals sequence or result; keep transition quick.',
    ),
    WordByWordConnectorGuide(
      word: 'ثُمَّ',
      function: 'Then (with delay/order)',
      sample: 'ثُمَّ رَدَدْنَاهُ',
      readingCue: 'Shows a staged order; pause mentally before next idea.',
    ),
    WordByWordConnectorGuide(
      word: 'إِنَّ',
      function: 'Indeed/Truly (emphasis)',
      sample: 'إِنَّا أَعْطَيْنَاكَ',
      readingCue: 'Read as emphasis marker and identify what is emphasized.',
    ),
    WordByWordConnectorGuide(
      word: 'مِنْ',
      function: 'From',
      sample: 'مِنَ الْجِنَّةِ',
      readingCue: 'Link it to source/origin meaning in phrase context.',
    ),
    WordByWordConnectorGuide(
      word: 'إِلَى',
      function: 'To/Toward',
      sample: 'إِلَى رَبِّكَ',
      readingCue: 'Notice destination direction in the sentence.',
    ),
  ];

  static const List<WordByWordPhraseGuide> phraseBreakdowns = [
    WordByWordPhraseGuide(
      arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      transliteration: 'al-hamdu lillahi rabbil alamin',
      breakdown:
          'الْحَمْدُ (all praise) | لِلَّهِ (belongs to Allah) | رَبِّ (Lord of) | الْعَالَمِينَ (all worlds)',
      meaning: 'All praise belongs to Allah, Lord of all worlds.',
    ),
    WordByWordPhraseGuide(
      arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      transliteration: 'iyyaka nabudu wa iyyaka nastaeen',
      breakdown:
          'إِيَّاكَ (You alone) | نَعْبُدُ (we worship) | وَ (and) | إِيَّاكَ (You alone) | نَسْتَعِينُ (we seek help)',
      meaning: 'You alone we worship, and You alone we ask for help.',
    ),
    WordByWordPhraseGuide(
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      transliteration: 'qul huwa Allahu ahad',
      breakdown: 'قُلْ (say) | هُوَ (He is) | اللَّهُ (Allah) | أَحَدٌ (One)',
      meaning: 'Say: He is Allah, One.',
    ),
    WordByWordPhraseGuide(
      arabic: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
      transliteration: 'inna ataynaka al-kawthar',
      breakdown:
          'إِنَّا (indeed We) | أَعْطَيْنَاكَ (have given you) | الْكَوْثَرَ (abundance)',
      meaning: 'Indeed We have granted you abundance.',
    ),
  ];

  static const List<WordByWordAyahPracticeGuide> ayahPractice = [
    WordByWordAyahPracticeGuide(
      reference: 'Al-Asr 103:1-3',
      arabic: 'وَالْعَصْرِ ... إِلَّا الَّذِينَ آمَنُوا ...',
      transliteration: 'wal asr ... illa alladhina amanu ...',
      focus: 'Track connectors (wa, illa) and key nouns/verbs by role.',
    ),
    WordByWordAyahPracticeGuide(
      reference: 'Al-Ikhlas 112:1-4',
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ...',
      transliteration: 'qul huwa Allahu ahad ...',
      focus: 'Identify declaration words and repeated references to Allah.',
    ),
    WordByWordAyahPracticeGuide(
      reference: 'Al-Kawthar 108:1-3',
      arabic: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ ...',
      transliteration: 'inna ataynaka al-kawthar ...',
      focus: 'Map emphasis particles and command-response flow.',
    ),
  ];

  static const List<WordByWordRevisionGuide> revision = [
    WordByWordRevisionGuide(
      title: 'Vocabulary sprint',
      action: 'Review 20 high-frequency words and recall meanings quickly.',
    ),
    WordByWordRevisionGuide(
      title: 'Root family check',
      action:
          'Group 10 words into their correct roots and explain core meaning.',
    ),
    WordByWordRevisionGuide(
      title: 'Connector scan',
      action: 'Find connector words in one short surah and explain their role.',
    ),
    WordByWordRevisionGuide(
      title: 'Phrase translation pass',
      action: 'Break down 3 phrases word by word without translation notes.',
    ),
    WordByWordRevisionGuide(
      title: 'Meaning-led recitation',
      action:
          'Recite one short surah while summarizing each ayah in one sentence.',
    ),
  ];
}
