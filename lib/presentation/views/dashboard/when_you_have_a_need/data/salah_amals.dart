import '../need_amal.dart';
import 'need_references.dart';

const salahAmals = <NeedAmal>[
  NeedAmal(
    id: 'salatul_hajah',
    category: NeedCategory.salah,
    title: NeedText('Salatul Hajah', 'সালাতুল হাজত'),
    description: NeedText(
      'A voluntary prayer offered when bringing a need before Allah.',
      'প্রয়োজন নিয়ে আল্লাহর কাছে যাওয়ার সময় পড়া নফল নামাজ।',
    ),
    steps: [
      NeedText('Make wudu carefully.', 'সুন্দরভাবে ওজু করুন।'),
      NeedText(
        'Pray two voluntary rakʿahs at a permissible time.',
        'নামাজের উপযুক্ত সময়ে দুই রাকাত নফল নামাজ পড়ুন।',
      ),
      NeedText(
        'Praise Allah, send salawat upon the Prophet ﷺ, and ask for a good and lawful need.',
        'আল্লাহর প্রশংসা ও নবী ﷺ-এর ওপর দরুদ পড়ে কল্যাণকর ও বৈধ প্রয়োজন চান।',
      ),
    ],
    arabic:
        'لَا إِلَٰهَ إِلَّا اللَّهُ الْحَلِيمُ الْكَرِيمُ، سُبْحَانَ اللَّهِ رَبِّ الْعَرْشِ الْعَظِيمِ، الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ، أَسْأَلُكَ مُوجِبَاتِ رَحْمَتِكَ وَعَزَائِمَ مَغْفِرَتِكَ وَالْغَنِيمَةَ مِنْ كُلِّ بِرٍّ وَالسَّلَامَةَ مِنْ كُلِّ إِثْمٍ، لَا تَدَعْ لِي ذَنْبًا إِلَّا غَفَرْتَهُ وَلَا هَمًّا إِلَّا فَرَّجْتَهُ وَلَا حَاجَةً هِيَ لَكَ رِضًا إِلَّا قَضَيْتَهَا يَا أَرْحَمَ الرَّاحِمِينَ',
    transliteration:
        'La ilaha illallahul-Halimul-Karim. Subhanallahi Rabbil-ʿArshil-ʿAzim. Alhamdulillahi Rabbil-ʿalamin. As’aluka mujibati rahmatika wa ʿaza’ima maghfiratika, wal-ghanimata min kulli birrin, was-salamata min kulli ithmin. La tadaʿ li dhanban illa ghafartahu, wa la hamman illa farrajtahu, wa la hajatan hiya laka ridan illa qadaitaha, ya Arhamar-rahimin.',
    meaning: NeedText(
      'There is no god but Allah, the Forbearing, the Generous. Glory to the Lord of the great Throne. Praise belongs to Allah, Lord of the worlds. I ask for Your mercy and forgiveness, every good, and safety from sin. Forgive my sins, relieve my worry, and fulfill what pleases You of my needs, Most Merciful.',
      'সহনশীল ও দয়ালু আল্লাহ ছাড়া উপাস্য নেই। মহান আরশের রব পবিত্র; সকল প্রশংসা আল্লাহর। আমি আপনার রহমত, ক্ষমা, কল্যাণ ও পাপ থেকে নিরাপত্তা চাই। আমার পাপ ক্ষমা করুন, দুশ্চিন্তা দূর করুন এবং আপনার সন্তুষ্টির উপযুক্ত প্রয়োজন পূরণ করুন, হে পরম দয়ালু।',
    ),
    duaNote: NeedText(
      'This wording appears in Tirmidhi 479, whose chain is disputed and graded weak by some scholars. You may make a personal du’a without treating this formula as firmly established.',
      'এই বাক্যগুলো তিরমিজি ৪৭৯-এ আছে; সনদ নিয়ে মতভেদ আছে এবং কেউ কেউ দুর্বল বলেছেন। এটিকে নিশ্চিত সুন্নাহ মনে না করে নিজের ভাষাতেও দোয়া করতে পারেন।',
    ),
    authenticity: NeedText(
      'Disputed / weak narration',
      'মতভেদপূর্ণ / দুর্বল বর্ণনা',
    ),
    evidenceNote: NeedText(
      'Tirmidhi called the report hasan gharib but noted criticism of a narrator; a later grading on the same source marks it daʿif. Voluntary prayer and personal du’a remain sound general practices.',
      'তিরমিজি বর্ণনাটিকে হাসান গরিব বললেও একজন বর্ণনাকারীর সমালোচনা উল্লেখ করেছেন; একই উৎসে পরের মূল্যায়নে দাঈফ বলা হয়েছে। সাধারণ নফল নামাজ ও ব্যক্তিগত দোয়া স্বীকৃত আমল।',
    ),
    timing: NeedText(
      'When a need arises; avoid prohibited prayer times',
      'প্রয়োজনের সময়; নামাজের নিষিদ্ধ সময় এড়িয়ে',
    ),
    references: [needSalatulHajah, needDuaEtiquette],
  ),
  NeedAmal(
    id: 'tahajjud',
    category: NeedCategory.salah,
    title: NeedText('Tahajjud', 'তাহাজ্জুদ'),
    description: NeedText(
      'Night prayer when Allah’s mercy is especially sought.',
      'রাতের নামাজ, যখন বিশেষভাবে আল্লাহর রহমত কামনা করা হয়।',
    ),
    steps: [
      NeedText(
        'Rise in the night, ideally in its final third, after sleeping if possible.',
        'সম্ভব হলে ঘুম থেকে উঠে, বিশেষ করে রাতের শেষ তৃতীয়াংশে নামাজে দাঁড়ান।',
      ),
      NeedText(
        'Pray voluntary rakʿahs in a manageable amount, with calm recitation.',
        'সাধ্য অনুযায়ী ধীরস্থিরভাবে নফল রাকাত পড়ুন।',
      ),
      NeedText(
        'After prayer, praise Allah and make personal du’a for forgiveness and your needs.',
        'নামাজের পর আল্লাহর প্রশংসা করে ক্ষমা ও প্রয়োজনের জন্য নিজের ভাষায় দোয়া করুন।',
      ),
    ],
    authenticity: NeedText('Qur’an and sahih hadith', 'কুরআন ও সহিহ হাদিস'),
    evidenceNote: NeedText(
      'Qur’an 17:79 mentions extra night prayer; Bukhari 1145 describes the special invitation to supplicate in the last third of the night. No fixed post-Tahajjud formula is required.',
      'কুরআন ১৭:৭৯-এ অতিরিক্ত রাতের নামাজ এবং বুখারি ১১৪৫-এ রাতের শেষ তৃতীয়াংশে দোয়ার বিশেষ সুযোগ এসেছে। তাহাজ্জুদের পর নির্দিষ্ট বাক্য বাধ্যতামূলক নয়।',
    ),
    timing: NeedText(
      'After ʿIsha and before Fajr; last third is especially valued',
      'ইশার পর থেকে ফজরের আগে; শেষ তৃতীয়াংশ বিশেষ মর্যাদার',
    ),
    duaNote: NeedText(
      'There is no single required du’a after Tahajjud. Ask Allah sincerely in your own words.',
      'তাহাজ্জুদের পর একটিমাত্র নির্ধারিত দোয়া নেই। নিজের ভাষায় আন্তরিকভাবে চান।',
    ),
    references: [needTahajjudVerse, needLastThird],
  ),
  NeedAmal(
    id: 'sujood_dua',
    category: NeedCategory.salah,
    title: NeedText('Dua during Sujood', 'সিজদায় দোয়া'),
    description: NeedText(
      'Prostration is a close moment for asking Allah.',
      'সিজদা আল্লাহর কাছে চাওয়ার ঘনিষ্ঠ মুহূর্ত।',
    ),
    steps: [
      NeedText(
        'Pray with humility and complete your usual prostration remembrance.',
        'বিনয়ের সঙ্গে নামাজ পড়ুন ও সিজদার স্বাভাবিক তাসবিহ পড়ুন।',
      ),
      NeedText(
        'Make du’a while prostrating; follow your school’s guidance on language in salah.',
        'সিজদায় দোয়া করুন; নামাজে কোন ভাষায় দোয়া হবে তা নিয়ে নিজের মাযহাবের নির্দেশনা অনুসরণ করুন।',
      ),
    ],
    authenticity: NeedText('Sahih hadith', 'সহিহ হাদিস'),
    evidenceNote: NeedText(
      'Muslim 482 encourages abundant supplication in prostration. It does not prescribe one specific need or a fixed count.',
      'মুসলিম ৪৮২-এ সিজদায় বেশি দোয়ার উৎসাহ আছে। নির্দিষ্ট প্রয়োজন বা সংখ্যা নির্ধারণ করা হয়নি।',
    ),
    timing: NeedText('During prostration in prayer', 'নামাজের সিজদায়'),
    duaNote: NeedText(
      'No single formula is required for this practice.',
      'এই আমলের জন্য একটিমাত্র নির্দিষ্ট দোয়া নেই।',
    ),
    references: [needSujood],
  ),
];
