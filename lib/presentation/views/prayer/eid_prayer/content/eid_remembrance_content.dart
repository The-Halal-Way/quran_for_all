import '../eid_prayer_models.dart';

const eidTakbeer =
    'اللَّهُ أَكْبَرُ\nاللَّهُ أَكْبَرُ\nلَآ إِلَهَ إِلَّا اللَّهُ\nوَاللَّهُ أَكْبَرُ\nاللَّهُ أَكْبَرُ\nوَلِلَّهِ الْحَمْدُ';

List<EidSection> remembranceSectionsFor(EidKind eid) => [
  EidSection(
    title: const EidText('Takbeer of Eid', 'ঈদের তাকবীর'),
    intro: const EidText(
      'Remember Allah with takbeer and gratitude throughout the Eid period.',
      'ঈদের সময়ে তাকবীর ও কৃতজ্ঞতার সঙ্গে আল্লাহকে স্মরণ করুন।',
    ),
    entries: [
      eidTakbeerEntry,
      eid == EidKind.fitr ? eidFitrTakbeerTime : eidAdhaTakbeerTime,
    ],
  ),
  eidDailyDhikrSection,
  eidDuasSection,
];

const eidTakbeerEntry = EidEntry(
  title: EidText('A common wording', 'প্রচলিত একটি পাঠ'),
  arabic: eidTakbeer,
  pronunciation: EidText(
    'Allāhu akbar, Allāhu akbar.\nLā ilāha illallāh.\nWallāhu akbar, Allāhu akbar.\nWa lillāhil-ḥamd.',
    'আল্লাহু আকবার, আল্লাহু আকবার।\nলা ইলাহা ইল্লাল্লাহ।\nওয়াল্লাহু আকবার, আল্লাহু আকবার।\nওয়া লিল্লাহিল হামদ।',
  ),
  meaning: EidText(
    'Allah is the Greatest. There is no deity except Allah. All praise belongs to Allah.',
    'আল্লাহ সর্বশ্রেষ্ঠ। আল্লাহ ছাড়া কোনো উপাস্য নেই। সমস্ত প্রশংসা আল্লাহর।',
  ),
  body: EidText(
    'Recite this form of takbeer frequently; other established wordings are also used.',
    'এভাবে বেশি বেশি তাকবীর পড়ুন; প্রচলিত অন্য পাঠও আছে।',
  ),
);

const eidFitrTakbeerTime = EidEntry(
  title: EidText('When to recite for Fitr', 'ফিতরে কখন পাঠ করবেন'),
  body: EidText(
    'From sunset on the night before Eid until the imam comes for Eid prayer, according to the guide’s scholarly summary.',
    'গাইডে দেওয়া আলেমদের সারসংক্ষেপ অনুযায়ী ঈদের আগের রাতের সূর্যাস্ত থেকে ইমাম নামাজে আসা পর্যন্ত।',
  ),
);

const eidAdhaTakbeerTime = EidEntry(
  title: EidText('When to recite for Adha', 'আযহায় কখন পাঠ করবেন'),
  body: EidText(
    'Recite from the beginning of Dhul Hijjah through the days of Tashreeq, according to scholarly opinions. Follow your local community for the prayer-related takbeer schedule.',
    'আলেমদের মতানুযায়ী জিলহজের শুরু থেকে তাশরীকের দিনগুলোতে তাকবীর পড়ুন। নামাজ-সংশ্লিষ্ট তাকবীরের সময়সূচিতে স্থানীয় আলেমদের অনুসরণ করুন।',
  ),
);

const eidDailyDhikrSection = EidSection(
  title: EidText('Dhikr through the day', 'দিনভর যিকির'),
  entries: [
    EidEntry(
      title: EidText('Tasbih and praise', 'তাসবিহ ও প্রশংসা'),
      arabic: 'سُبْحَانَ اللَّهِ\nالْحَمْدُ لِلَّهِ\nاللَّهُ أَكْبَرُ',
      pronunciation: EidText(
        'Subḥānallāh. Alḥamdulillāh. Allāhu akbar.',
        'সুবহানাল্লাহ। আলহামদুলিল্লাহ। আল্লাহু আকবার।',
      ),
      meaning: EidText(
        'Glory be to Allah. All praise belongs to Allah. Allah is the Greatest.',
        'আল্লাহ পবিত্র। সমস্ত প্রশংসা আল্লাহর। আল্লাহ সর্বশ্রেষ্ঠ।',
      ),
      body: EidText(
        'Continue remembering Allah during the celebration.',
        'ঈদের আনন্দের মধ্যেও আল্লাহকে স্মরণ করুন।',
      ),
    ),
    EidEntry(
      title: EidText('Seek forgiveness', 'ক্ষমা প্রার্থনা'),
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      pronunciation: EidText('Astaghfirullāh', 'আস্তাগফিরুল্লাহ'),
      meaning: EidText(
        'I seek forgiveness from Allah.',
        'আমি আল্লাহর কাছে ক্ষমা প্রার্থনা করছি।',
      ),
      body: EidText(
        'Make space for sincere repentance and forgiveness on Eid.',
        'ঈদের দিন আন্তরিক তওবা ও ক্ষমা প্রার্থনায় সময় দিন।',
      ),
    ),
  ],
);

const eidDuasSection = EidSection(
  title: EidText('Duas and greetings', 'দোয়া ও শুভেচ্ছা'),
  entries: [
    EidEntry(
      title: EidText('Ask for acceptance', 'কবুলের দোয়া'),
      arabic: 'رَبَّنَا تَقَبَّلْ مِنَّآ إِنَّكَ أَنتَ ٱلسَّمِيعُ ٱلْعَلِيمُ',
      pronunciation: EidText(
        'Rabbanā taqabbal minnā, innaka antas-samīʿul-ʿalīm.',
        'রব্বানা তাকাব্বাল মিন্না, ইন্নাকা আনতাস-সামীউল আলীম।',
      ),
      meaning: EidText(
        'Our Lord, accept from us. You are the All-Hearing, the All-Knowing.',
        'হে আমাদের রব, আমাদের থেকে কবুল করুন। আপনি সর্বশ্রোতা, সর্বজ্ঞ।',
      ),
      body: EidText(
        'A Quranic supplication to ask Allah to accept good deeds.',
        'আমল কবুলের জন্য কুরআনের এই দোয়া পড়ুন।',
      ),
      reference: 'Surah Al-Baqarah 2:127',
    ),
    EidEntry(
      title: EidText('Give thanks', 'কৃতজ্ঞতার দোয়া'),
      arabic: 'رَبِّ أَوْزِعْنِىٓ أَنْ أَشْكُرَ نِعْمَتَكَ',
      pronunciation: EidText(
        'Rabbi awziʿnī an ashkura niʿmataka.',
        'রব্বি আওযিইনী আন আশকুরা নিইমাতাকা।',
      ),
      meaning: EidText(
        'My Lord, enable me to be grateful for Your favor.',
        'হে আমার রব, আমাকে আপনার নিয়ামতের শুকরিয়া আদায়ের তাওফিক দিন।',
      ),
      body: EidText(
        'A Quranic supplication for gratitude.',
        'কৃতজ্ঞতার জন্য কুরআনের এই দোয়া পড়ুন।',
      ),
      reference: 'Surah An-Naml 27:19',
    ),
    EidEntry(
      title: EidText('Greet one another', 'পরস্পরকে শুভেচ্ছা'),
      arabic: 'تَقَبَّلَ اللَّهُ مِنَّا وَمِنْكُمْ',
      pronunciation: EidText(
        'Taqabbalallāhu minnā wa minkum.',
        'তাকাব্বালাল্লাহু মিন্না ওয়া মিনকুম।',
      ),
      meaning: EidText(
        'May Allah accept from us and from you.',
        'আল্লাহ আমাদের ও আপনাদের পক্ষ থেকে কবুল করুন।',
      ),
      body: EidText(
        'A customary Eid greeting. Its exact wording is not mandatory.',
        'এটি প্রচলিত ঈদের শুভেচ্ছা; নির্দিষ্ট বাক্য বলা বাধ্যতামূলক নয়।',
      ),
    ),
  ],
);
