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
      subtitle: 'Alphabet, shapes, and harakat',
      description:
          'Start from the foundation by learning letter names, forms, and basic marks that control sound.',
      level: 'Beginner',
      estimatedMinutes: 45,
      lessons: [
        LearnQuranLesson(
          id: 'arabic_letters_1',
          title: 'Recognize all 29 letters',
          objective:
              'Identify each Arabic letter confidently in isolated form.',
          practicePrompt:
              'Read aloud: alif, baa, taa, thaa... and match with shapes.',
          durationMinutes: 10,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_2',
          title: 'Letter positions in words',
          objective: 'Understand how letters appear at start, middle, and end.',
          practicePrompt:
              'Trace and pronounce 5 sample words with connected letters.',
          durationMinutes: 12,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_3',
          title: 'Short vowels and sukoon',
          objective: 'Read fatha, kasra, damma, and sukoon correctly.',
          practicePrompt:
              'Practice ba, bi, bu, and silent endings with measured pace.',
          durationMinutes: 11,
          sampleSurahId: 1,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'arabic_letters_4',
          title: 'Tanween basics',
          objective: 'Apply double vowel endings in simple recitation words.',
          practicePrompt: 'Read 8 tanween examples and keep endings crisp.',
          durationMinutes: 12,
          sampleSurahId: 112,
          sampleAyahNumber: 1,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'pronunciation_basics',
      title: 'Pronunciation Basics',
      subtitle: 'Clear articulation and flow',
      description:
          'Develop stable, clear pronunciation before moving into advanced tajweed topics.',
      level: 'Beginner',
      estimatedMinutes: 40,
      lessons: [
        LearnQuranLesson(
          id: 'pronunciation_1',
          title: 'Heavy and light sounds',
          objective: 'Differentiate thick and thin letters when reciting.',
          practicePrompt: 'Compare the sound of qaaf with kaaf in short words.',
          durationMinutes: 14,
          sampleSurahId: 97,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_2',
          title: 'Lengthening (madd) basics',
          objective: 'Hold natural madd for two counts consistently.',
          practicePrompt: 'Use finger counting while reading madd letters.',
          durationMinutes: 13,
          sampleSurahId: 108,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'pronunciation_3',
          title: 'Pausing and restarting',
          objective: 'Pause at correct locations without changing meaning.',
          practicePrompt: 'Read 3 verses with deliberate waqf and restart.',
          durationMinutes: 13,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'makharij',
      title: 'Makharij',
      subtitle: 'Letter articulation points',
      description:
          'Learn where each letter originates in the mouth and throat to avoid common mistakes.',
      level: 'Beginner to Intermediate',
      estimatedMinutes: 55,
      lessons: [
        LearnQuranLesson(
          id: 'makharij_1',
          title: 'Throat letters',
          objective: 'Produce hamza, haa, ain, ghain, kha from correct depth.',
          practicePrompt: 'Recite throat pairs slowly and compare resonance.',
          durationMinutes: 18,
          sampleSurahId: 113,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'makharij_2',
          title: 'Tongue-based letters',
          objective:
              'Articulate letters from tip, middle, and sides of tongue.',
          practicePrompt: 'Practice taa/daa, seen/saad, and laam transitions.',
          durationMinutes: 19,
        ),
        LearnQuranLesson(
          id: 'makharij_3',
          title: 'Lip and nasal sounds',
          objective:
              'Use lips and ghunnah correctly for rounded, clear output.',
          practicePrompt: 'Alternate baa, meem, waaw with controlled airflow.',
          durationMinutes: 18,
          sampleSurahId: 114,
          sampleAyahNumber: 4,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'tajweed_rules',
      title: 'Tajweed Rules',
      subtitle: 'Core recitation rules in practice',
      description:
          'Apply essential tajweed rules with practical drills and beginner-safe examples.',
      level: 'Intermediate',
      estimatedMinutes: 60,
      lessons: [
        LearnQuranLesson(
          id: 'tajweed_1',
          title: 'Noon saakin and tanween',
          objective: 'Apply izhar, idgham, iqlab, and ikhfa with confidence.',
          practicePrompt:
              'Classify 12 examples into the correct noon/tanween rule.',
          durationMinutes: 20,
          sampleSurahId: 96,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'tajweed_2',
          title: 'Meem saakin rules',
          objective: 'Differentiate ikhfa shafawi, idgham shafawi, and izhar.',
          practicePrompt: 'Practice meem endings before baa and meem.',
          durationMinutes: 20,
          sampleSurahId: 105,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'tajweed_3',
          title: 'Qalqalah and emphasis',
          objective:
              'Deliver qalqalah letters with clear bounce, not exaggeration.',
          practicePrompt:
              'Read qalqalah examples at stop and continuation points.',
          durationMinutes: 20,
          sampleSurahId: 111,
          sampleAyahNumber: 1,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'word_by_word',
      title: 'Word-by-Word Learning',
      subtitle: 'Understand while you recite',
      description:
          'Build a practical Quran vocabulary by connecting words, roots, and meanings.',
      level: 'Beginner',
      estimatedMinutes: 50,
      lessons: [
        LearnQuranLesson(
          id: 'word_1',
          title: 'High-frequency Quran words',
          objective: 'Memorize common words used across many surahs.',
          practicePrompt: 'Learn 15 words and identify them in sample ayahs.',
          durationMinutes: 16,
        ),
        LearnQuranLesson(
          id: 'word_2',
          title: 'Short phrase breakdown',
          objective: 'Break ayah fragments into meaningful word groups.',
          practicePrompt: 'Translate and recite a 3-word phrase word by word.',
          durationMinutes: 17,
          sampleSurahId: 103,
          sampleAyahNumber: 1,
        ),
        LearnQuranLesson(
          id: 'word_3',
          title: 'Meaning-led revision',
          objective: 'Review recitation with translation awareness.',
          practicePrompt: 'Read one short surah and summarize its message.',
          durationMinutes: 17,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'short_surah_practice',
      title: 'Short Surah Practice',
      subtitle: 'Guided recitation for daily salah',
      description:
          'Practice short surahs with clear goals so memorization and fluency improve together.',
      level: 'Beginner to Intermediate',
      estimatedMinutes: 55,
      lessons: [
        LearnQuranLesson(
          id: 'short_surah_1',
          title: 'Surah Al-Fatihah mastery',
          objective: 'Recite Al-Fatihah with rhythm and tajweed awareness.',
          practicePrompt:
              'Record and compare your recitation with model pacing.',
          durationMinutes: 18,
          sampleSurahId: 1,
          sampleAyahNumber: 7,
        ),
        LearnQuranLesson(
          id: 'short_surah_2',
          title: 'Surah Al-Ikhlas and Al-Falaq',
          objective: 'Practice flow and stopping signs in two short surahs.',
          practicePrompt: 'Read both surahs in one focused practice round.',
          durationMinutes: 18,
          sampleSurahId: 112,
          sampleAyahNumber: 4,
        ),
        LearnQuranLesson(
          id: 'short_surah_3',
          title: 'Surah An-Naas confidence drill',
          objective: 'Strengthen articulation in repeated consonant patterns.',
          practicePrompt: 'Repeat the surah three times with steady breathing.',
          durationMinutes: 19,
          sampleSurahId: 114,
          sampleAyahNumber: 6,
        ),
      ],
    ),
    LearnQuranModule(
      id: 'audio_assisted',
      title: 'Audio-Assisted Lessons',
      subtitle: 'Listen, imitate, and self-correct',
      description:
          'Use guided listening loops and imitation drills to sharpen ear training and confidence.',
      level: 'All levels',
      estimatedMinutes: 35,
      lessons: [
        LearnQuranLesson(
          id: 'audio_1',
          title: 'Focused listening loop',
          objective: 'Catch subtle pronunciation changes in short ayah loops.',
          practicePrompt: 'Listen 3 times, then recite without looking.',
          durationMinutes: 12,
          sampleSurahId: 96,
          sampleAyahNumber: 5,
        ),
        LearnQuranLesson(
          id: 'audio_2',
          title: 'Shadow recitation',
          objective: 'Follow audio in real time and match pace.',
          practicePrompt: 'Recite softly under the audio, then solo.',
          durationMinutes: 11,
          sampleSurahId: 97,
          sampleAyahNumber: 5,
        ),
        LearnQuranLesson(
          id: 'audio_3',
          title: 'Error-spot challenge',
          objective:
              'Identify and fix 3 pronunciation mistakes in your own recitation.',
          practicePrompt: 'Play a sample, repeat it, and note differences.',
          durationMinutes: 12,
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
