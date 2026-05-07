class LearnQuranLesson {
  const LearnQuranLesson({
    required this.id,
    required this.title,
    required this.objective,
    required this.practicePrompt,
    required this.durationMinutes,
    this.sampleSurahId,
    this.sampleAyahNumber,
  });

  final String id;
  final String title;
  final String objective;
  final String practicePrompt;
  final int durationMinutes;
  final int? sampleSurahId;
  final int? sampleAyahNumber;

  bool get hasAudioSample => sampleSurahId != null && sampleAyahNumber != null;
}

class LearnQuranModule {
  const LearnQuranModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.level,
    required this.estimatedMinutes,
    required this.lessons,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String level;
  final int estimatedMinutes;
  final List<LearnQuranLesson> lessons;
}

class LearnQuranContent {
  const LearnQuranContent._();

  static const List<LearnQuranModule> modules = [
    LearnQuranModule(
      id: 'arabic_letters',
      title: 'Arabic Letters',
      subtitle: 'From alphabet recognition to first reading drills',
      description:
          'Master the full Arabic letter foundation used in Quran reading: isolated forms, similar-letter distinction, beginner pronunciation, and practical review drills.',
      level: 'Beginner',
      estimatedMinutes: 110,
      lessons: [
        LearnQuranLesson(
          id: 'arabic_letters_1',
          title: 'Alphabet orientation and letter names',
          objective:
              'Identify all 29 letters by name and symbol in isolated form.',
          practicePrompt:
              'Use call-and-response: say each name aloud while pointing to its symbol from right to left.',
          durationMinutes: 14,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_2',
          title: 'Isolated forms and visual anchors',
          objective:
              'Recognize stable isolated shapes and memorize visual anchors for each letter.',
          practicePrompt:
              'Practice the full isolated letter map and describe one shape cue for every row.',
          durationMinutes: 12,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_3',
          title: 'Dot families and shape groups',
          objective:
              'Distinguish letters that share a skeleton but differ by dot count and dot position.',
          practicePrompt:
              'Run the dot-family drill: baa/taa/thaa, jeem/haa/khaa, and faa/qaaf.',
          durationMinutes: 15,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_4',
          title: 'Similar-letter comparison practice',
          objective:
              'Avoid common beginner confusion by mastering high-risk look-alike sets.',
          practicePrompt:
              'Use the comparison grid and read each pair in contrast: د/ذ, ر/ز, س/ش, ص/ض, ط/ظ, ع/غ.',
          durationMinutes: 14,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_5',
          title: 'Pronunciation and articulation zones',
          objective:
              'Produce letters from throat, tongue, and lips using beginner-safe articulation cues.',
          practicePrompt:
              'Practice each zone slowly with short bursts and watch for common mistakes in airflow and tongue placement.',
          durationMinutes: 16,
          sampleSurahId: 113,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_6',
          title: 'Short vowels (harakat) in action',
          objective: 'Read fatha, kasra, and damma with clear vowel quality.',
          practicePrompt:
              'Cycle through consonant-vowel sets such as بَ بِ بُ and نَ نِ نُ while keeping a steady pace.',
          durationMinutes: 14,
          sampleSurahId: 1,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_7',
          title: 'Sukoon and closed syllables',
          objective:
              'Read silent endings and closed syllables without adding extra vowels.',
          practicePrompt:
              'Practice short words like بسم, قل, and رب with calm stops and clean endings.',
          durationMinutes: 12,
          sampleSurahId: 112,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_8',
          title: 'Revision challenge and confidence check',
          objective:
              'Consolidate recognition, pronunciation, and reading readiness in one guided review.',
          practicePrompt:
              'Complete the final review: identify random letters, compare look-alikes, then read beginner examples with harakat.',
          durationMinutes: 13,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'pronunciation_basics',
      title: 'Pronunciation Basics',
      subtitle: 'Heavy-light clarity, madd, and recitation flow',
      description:
          'Build clear Quran pronunciation through contrast training, articulation cues, controlled lengthening, and guided pause-restart drills.',
      level: 'Beginner',
      estimatedMinutes: 105,
      lessons: [
        LearnQuranLesson(
          id: 'pronunciation_1',
          title: 'Heavy and light sound awareness',
          objective:
              'Differentiate thick (tafkheem) and thin (tarqeeq) sounds in beginner-friendly contrasts.',
          practicePrompt:
              'Compare qaaf/kaaf, saad/seen, and taa/taa-heavy slowly while keeping mouth posture stable.',
          durationMinutes: 14,
          sampleSurahId: 97,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_2',
          title: 'Mouth posture and articulation setup',
          objective:
              'Stabilize lips, tongue, and jaw positions for clear consonants before speed practice.',
          practicePrompt:
              'Practice posture cues in short sets: qa, ka, sa, sha, da, dha with intentional precision.',
          durationMinutes: 12,
        ),
        LearnQuranLesson(
          id: 'pronunciation_3',
          title: 'Lengthening (madd) basics',
          objective: 'Hold natural madd for two counts consistently.',
          practicePrompt:
              'Use finger counting and beat pacing for aa, ee, and oo sounds in short words.',
          durationMinutes: 14,
          sampleSurahId: 108,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_4',
          title: 'Controlled stopping and release',
          objective:
              'End sounds clearly at sukoon and avoid adding extra vowel echoes after stops.',
          practicePrompt:
              'Practice closed endings in words like قل, رب, and الفلق with crisp final consonants.',
          durationMinutes: 12,
          sampleSurahId: 112,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_5',
          title: 'Contrast-pair precision drill',
          objective:
              'Prevent pronunciation mixing by drilling common confusing pairs in sequence.',
          practicePrompt:
              'Run pair drills for س/ص, د/ذ, ز/ظ, ق/ك, and ح/ه in three slow rounds.',
          durationMinutes: 15,
        ),
        LearnQuranLesson(
          id: 'pronunciation_6',
          title: 'Rhythm and breath pacing',
          objective:
              'Recite with a steady tempo using short breath groups instead of rushed delivery.',
          practicePrompt:
              'Use a 2-2 beat rhythm and inhale only at planned phrase boundaries.',
          durationMinutes: 12,
          sampleSurahId: 103,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_7',
          title: 'Pausing and restarting in ayahs',
          objective:
              'Pause at safe points and restart cleanly without distorting word meaning.',
          practicePrompt:
              'Read selected ayahs with one deliberate stop and one correct restart per line.',
          durationMinutes: 13,
          sampleSurahId: 96,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_8',
          title: 'Production review and confidence check',
          objective:
              'Consolidate clarity, pacing, and stop/restart control in a guided final review.',
          practicePrompt:
              'Complete the review block: pair contrast, madd count, pause-restart, then one self-recorded recitation.',
          durationMinutes: 13,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'makharij',
      title: 'Makharij',
      subtitle: 'Mapped articulation zones and precision drills',
      description:
          'Learn the exact articulation origins of Quran letters through zone mapping, contrast practice, and guided phrase drills.',
      level: 'Beginner to Intermediate',
      estimatedMinutes: 110,
      lessons: [
        LearnQuranLesson(
          id: 'makharij_1',
          title: 'Makharij map fundamentals',
          objective:
              'Understand the major articulation zones and how each zone shapes sound quality.',
          practicePrompt:
              'Review the zone map and point each letter to its origin before reciting it.',
          durationMinutes: 12,
        ),
        LearnQuranLesson(
          id: 'makharij_2',
          title: 'Deep and middle throat letters',
          objective:
              'Produce ء ه ع ح with correct throat depth and controlled breath.',
          practicePrompt:
              'Alternate pairs slowly: ء/ه and ع/ح while preserving each letter identity.',
          durationMinutes: 14,
          sampleSurahId: 113,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'makharij_3',
          title: 'Upper throat letters',
          objective: 'Differentiate غ and خ from lighter nearby sounds.',
          practicePrompt:
              'Practice غ/خ in short words and monitor airflow friction consistency.',
          durationMinutes: 12,
          sampleSurahId: 113,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'makharij_4',
          title: 'Tongue-zone articulation',
          objective:
              'Articulate letters from tongue tip, blade, middle, and back with precision.',
          practicePrompt:
              'Drill ق/ك, ج/ش, and ت/د/ط sets while maintaining placement discipline.',
          durationMinutes: 16,
        ),
        LearnQuranLesson(
          id: 'makharij_5',
          title: 'Lips and nasal resonance',
          objective:
              'Use lips and ghunnah correctly for ف ب م و and nasal continuity.',
          practicePrompt:
              'Practice lip closure/release and ghunnah on noon-meem combinations.',
          durationMinutes: 13,
          sampleSurahId: 114,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'makharij_6',
          title: 'Confusion-pair correction',
          objective:
              'Fix common articulation confusion in similar or neighboring letters.',
          practicePrompt:
              'Run correction pairs: ق/ك, س/ص, ت/ط, د/ذ, ح/ه, ع/ء in three rounds.',
          durationMinutes: 14,
        ),
        LearnQuranLesson(
          id: 'makharij_7',
          title: 'Applied articulation in short phrases',
          objective:
              'Transfer makharij control from drills into connected Quran phrase reading.',
          practicePrompt:
              'Recite selected phrases and annotate one articulation focus in each phrase.',
          durationMinutes: 14,
          sampleSurahId: 1,
          sampleAyahNumber: 7,
        ),
        LearnQuranLesson(
          id: 'makharij_8',
          title: 'Makharij review and mastery check',
          objective:
              'Consolidate zone awareness, pair correction, and phrase accuracy in one final routine.',
          practicePrompt:
              'Complete the review cycle: map, zone drill, pair correction, then one recorded phrase recitation.',
          durationMinutes: 15,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'tajweed_rules',
      title: 'Tajweed Rules',
      subtitle: 'Rule-by-rule application with guided drills',
      description:
          'Learn and apply core tajweed rules step by step with focused examples, correction drills, and integrated recitation practice.',
      level: 'Intermediate',
      estimatedMinutes: 120,
      lessons: [
        LearnQuranLesson(
          id: 'tajweed_1',
          title: 'Tajweed orientation and listening baseline',
          objective:
              'Understand why tajweed matters and identify major rule families before drilling.',
          practicePrompt:
              'Listen to one short recitation and mark where rules like ikhfa, qalqalah, and madd occur.',
          durationMinutes: 12,
        ),
        LearnQuranLesson(
          id: 'tajweed_2',
          title: 'Noon saakin and tanween: izhar and idgham',
          objective:
              'Apply clear pronunciation (izhar) and merging (idgham) in correct letter contexts.',
          practicePrompt:
              'Classify examples into izhar or idgham and recite each with deliberate pacing.',
          durationMinutes: 16,
          sampleSurahId: 96,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'tajweed_3',
          title: 'Noon saakin and tanween: iqlab and ikhfa',
          objective:
              'Differentiate hidden and converted sounds while preserving ghunnah control.',
          practicePrompt:
              'Practice iqlab before baa and ikhfa before target letters in short phrase sets.',
          durationMinutes: 16,
          sampleSurahId: 113,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'tajweed_4',
          title: 'Meem saakin rules in flow',
          objective:
              'Differentiate ikhfa shafawi, idgham shafawi, and izhar shafawi inside connected recitation.',
          practicePrompt:
              'Practice meem endings before baa/meem/other letters with controlled lip closure.',
          durationMinutes: 15,
          sampleSurahId: 105,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'tajweed_5',
          title: 'Qalqalah and stop-position bounce',
          objective:
              'Deliver qalqalah letters with clear bounce at stop and continuation positions without exaggeration.',
          practicePrompt:
              'Read qalqalah examples at wasl and waqf and compare bounce intensity.',
          durationMinutes: 14,
          sampleSurahId: 111,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'tajweed_6',
          title: 'Madd and vowel length discipline',
          objective:
              'Apply basic madd timing consistently so long vowels remain controlled and accurate.',
          practicePrompt:
              'Use beat-count pacing for natural madd and verify consistent length across a short ayah.',
          durationMinutes: 15,
          sampleSurahId: 108,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'tajweed_7',
          title: 'Waqf and ibtida (pause and restart)',
          objective:
              'Pause and restart at safe points without changing meaning or breaking tajweed quality.',
          practicePrompt:
              'Practice one-ayah passages with planned stops and clean restarts.',
          durationMinutes: 15,
          sampleSurahId: 1,
          sampleAyahNumber: 7,
        ),
        LearnQuranLesson(
          id: 'tajweed_8',
          title: 'Integrated tajweed application review',
          objective:
              'Combine noon/tanween, meem saakin, qalqalah, madd, and waqf in one structured recitation round.',
          practicePrompt:
              'Annotate one short surah with rule labels, then recite it slowly with full rule awareness.',
          durationMinutes: 17,
          sampleSurahId: 112,
          sampleAyahNumber: 4,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'word_by_word',
      title: 'Word-by-Word Learning',
      subtitle: 'Vocabulary, roots, and ayah meaning mapping',
      description:
          'Build practical Quran understanding through high-frequency vocabulary, root-pattern recognition, connector awareness, and phrase-by-phrase meaning drills.',
      level: 'Beginner',
      estimatedMinutes: 115,
      lessons: [
        LearnQuranLesson(
          id: 'word_1',
          title: 'High-frequency vocabulary foundation',
          objective:
              'Memorize core Quran words that appear repeatedly across short surahs.',
          practicePrompt:
              'Study 20 common words and identify at least 10 inside guided examples.',
          durationMinutes: 14,
        ),
        LearnQuranLesson(
          id: 'word_2',
          title: 'Connector words and particles',
          objective:
              'Recognize linking words such as وَ, فَ, and إِنَّ to follow sentence flow.',
          practicePrompt:
              'Highlight connectors in short phrases and explain their role in meaning sequence.',
          durationMinutes: 13,
        ),
        LearnQuranLesson(
          id: 'word_3',
          title: 'Root family recognition',
          objective:
              'Identify shared roots and infer general meaning from related word forms.',
          practicePrompt:
              'Group words by root (for example ر-ح-م, غ-ف-ر, ه-د-ي) and summarize each root theme.',
          durationMinutes: 14,
        ),
        LearnQuranLesson(
          id: 'word_4',
          title: 'Short phrase word mapping',
          objective:
              'Break short Quran phrases into word-by-word translation blocks.',
          practicePrompt:
              'Map each word in two phrases, then restate complete meaning in one sentence.',
          durationMinutes: 14,
          sampleSurahId: 103,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'word_5',
          title: 'Ayah-level meaning mapping',
          objective:
              'Connect vocabulary, connectors, and roots in complete ayah understanding.',
          practicePrompt:
              'Take one ayah, label each word role, then explain the ayah meaning aloud.',
          durationMinutes: 15,
          sampleSurahId: 1,
          sampleAyahNumber: 2,
        ),
        LearnQuranLesson(
          id: 'word_6',
          title: 'Meaning-led recitation drill',
          objective:
              'Recite short surahs while mentally tracking phrase meaning in sequence.',
          practicePrompt:
              'Recite one short surah slowly and pause after each ayah to summarize meaning.',
          durationMinutes: 15,
          sampleSurahId: 112,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'word_7',
          title: 'Reflection and message summary',
          objective:
              'Extract key message points from short passages using learned vocabulary.',
          practicePrompt:
              'Write 3 short reflections from one surah using your word-by-word notes.',
          durationMinutes: 14,
        ),
        LearnQuranLesson(
          id: 'word_8',
          title: 'Integrated word-by-word review',
          objective:
              'Combine vocabulary recall, root detection, and ayah mapping in one final round.',
          practicePrompt:
              'Complete a final review cycle: word test, root test, phrase mapping, then one meaning-led recitation.',
          durationMinutes: 16,
          sampleSurahId: 108,
          sampleAyahNumber: 3,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'short_surah_practice',
      title: 'Short Surah Practice',
      subtitle: 'Salah-ready recitation with memorization flow',
      description:
          'Practice essential short surahs through memorization cycles, tajweed targets, meaning-linked recitation, and prayer-ready fluency checks.',
      level: 'Beginner to Intermediate',
      estimatedMinutes: 110,
      lessons: [
        LearnQuranLesson(
          id: 'short_surah_1',
          title: 'Al-Fatihah structure and flow',
          objective:
              'Recite Al-Fatihah with stable pace and confident phrase transitions.',
          practicePrompt:
              'Read one slow round and one salah-tempo round while tracking phrase boundaries.',
          durationMinutes: 14,
          sampleSurahId: 1,
          sampleAyahNumber: 7,
        ),
        LearnQuranLesson(
          id: 'short_surah_2',
          title: 'Al-Fatihah tajweed and stop points',
          objective:
              'Apply madd, waqf, and clear ending control within Al-Fatihah recitation.',
          practicePrompt:
              'Mark safe stops and recite with deliberate pause-restart discipline.',
          durationMinutes: 14,
          sampleSurahId: 1,
          sampleAyahNumber: 6,
        ),
        LearnQuranLesson(
          id: 'short_surah_3',
          title: 'Al-Ikhlas precision practice',
          objective:
              'Deliver concise declaration ayahs with strong clarity and clean endings.',
          practicePrompt:
              'Recite Al-Ikhlas three rounds and correct one issue after each round.',
          durationMinutes: 13,
          sampleSurahId: 112,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'short_surah_4',
          title: 'Al-Falaq protective rhythm training',
          objective:
              'Maintain smooth rhythm and controlled transitions in repeated protection phrases.',
          practicePrompt:
              'Practice recurring مِنْ شَرِّ segments with steady pace and articulation.',
          durationMinutes: 14,
          sampleSurahId: 113,
          sampleAyahNumber: 5,
        ),
        LearnQuranLesson(
          id: 'short_surah_5',
          title: 'An-Naas articulation and breath control',
          objective:
              'Strengthen consonant precision and breathing consistency across repeated structures.',
          practicePrompt:
              'Recite An-Naas in one breath-managed flow and review weak consonant points.',
          durationMinutes: 14,
          sampleSurahId: 114,
          sampleAyahNumber: 6,
        ),
        LearnQuranLesson(
          id: 'short_surah_6',
          title: 'Al-Kawthar fluency and confidence drill',
          objective:
              'Improve command-response recitation clarity in a compact three-ayah surah.',
          practicePrompt:
              'Read each ayah separately, then join all three in one smooth pass.',
          durationMinutes: 13,
          sampleSurahId: 108,
          sampleAyahNumber: 3,
        ),
        LearnQuranLesson(
          id: 'short_surah_7',
          title: 'Al-Asr meaning-led pacing',
          objective:
              'Recite warning-and-exception structure with clear emphasis and understanding.',
          practicePrompt:
              'Pause mentally at إِلَّا and continue with controlled contrast pacing.',
          durationMinutes: 13,
          sampleSurahId: 103,
          sampleAyahNumber: 3,
        ),
        LearnQuranLesson(
          id: 'short_surah_8',
          title: 'Integrated short surah salah sequence',
          objective:
              'Combine memorization, tajweed, and fluency into prayer-ready short surah recitation.',
          practicePrompt:
              'Recite a 4-surah sequence in one session and self-check accuracy, pace, and stops.',
          durationMinutes: 15,
          sampleSurahId: 112,
          sampleAyahNumber: 4,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'audio_assisted',
      title: 'Audio-Assisted Lessons',
      subtitle: 'Focused listening, shadowing, and correction loops',
      description:
          'Build strong recitation quality through audio-first drills, imitation practice, structured error detection, and confidence-focused feedback cycles.',
      level: 'All levels',
      estimatedMinutes: 105,
      lessons: [
        LearnQuranLesson(
          id: 'audio_1',
          title: 'Focused listening baseline',
          objective:
              'Train your ear to detect rhythm, articulation, and stop points before speaking.',
          practicePrompt:
              'Run a 3-pass listening cycle and list 3 sound cues from memory.',
          durationMinutes: 12,
          sampleSurahId: 96,
          sampleAyahNumber: 5,
        ),
        LearnQuranLesson(
          id: 'audio_2',
          title: 'Soft shadow imitation',
          objective:
              'Recite quietly under audio guidance while preserving pronunciation accuracy.',
          practicePrompt:
              'Complete two shadow rounds and keep madd/stop timing aligned to audio.',
          durationMinutes: 13,
          sampleSurahId: 97,
          sampleAyahNumber: 5,
        ),
        LearnQuranLesson(
          id: 'audio_3',
          title: 'Aligned shadow and solo transfer',
          objective:
              'Move from guided imitation to independent recitation without losing quality.',
          practicePrompt:
              'Shadow once at medium pace, then do one full solo recitation.',
          durationMinutes: 13,
          sampleSurahId: 108,
          sampleAyahNumber: 3,
        ),
        LearnQuranLesson(
          id: 'audio_4',
          title: 'Error-spot challenge',
          objective:
              'Identify and correct at least two recurring pronunciation mistakes.',
          practicePrompt:
              'Record, compare with model audio, and apply one fix per detected error.',
          durationMinutes: 14,
          sampleSurahId: 112,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'audio_5',
          title: 'Breath and pacing control',
          objective:
              'Use planned breathing so recitation stays calm and consistent from start to end.',
          practicePrompt:
              'Mark breath points on one short passage and recite with stable tempo.',
          durationMinutes: 12,
          sampleSurahId: 113,
          sampleAyahNumber: 5,
        ),
        LearnQuranLesson(
          id: 'audio_6',
          title: 'Audio-guided correction loop',
          objective:
              'Use listen-repeat-correct cycles to fix articulation and tajweed drift quickly.',
          practicePrompt:
              'Complete three correction loops and track improvement after each loop.',
          durationMinutes: 14,
          sampleSurahId: 114,
          sampleAyahNumber: 6,
        ),
        LearnQuranLesson(
          id: 'audio_7',
          title: 'Self-record comparison pass',
          objective:
              'Assess your own recitation using audio comparison and focused notes.',
          practicePrompt:
              'Record one passage, compare against model, and write 3 improvement notes.',
          durationMinutes: 13,
          sampleSurahId: 103,
          sampleAyahNumber: 3,
        ),
        LearnQuranLesson(
          id: 'audio_8',
          title: 'Integrated audio mastery round',
          objective:
              'Combine listening, shadowing, correction, and solo recitation in one final session.',
          practicePrompt:
              'Run a full sequence: listen, shadow, solo, compare, then final confidence pass.',
          durationMinutes: 14,
          sampleSurahId: 108,
          sampleAyahNumber: 3,
        ),
      ],
    ),
  ];

  static int get totalLessonCount {
    var total = 0;
    for (final module in modules) {
      total += module.lessons.length;
    }
    return total;
  }

  static Set<String> get allLessonIds {
    final ids = <String>{};
    for (final module in modules) {
      for (final lesson in module.lessons) {
        ids.add(lesson.id);
      }
    }
    return ids;
  }
}
