import '../need_amal.dart';
import 'need_references.dart';

const duaAmals = <NeedAmal>[
  NeedAmal(
    id: 'yunus_dua',
    category: NeedCategory.dua,
    title: NeedText('Dua of Prophet Yunus', 'নবী ইউনুস (আ.)-এর দোয়া'),
    description: NeedText(
      'A Quranic prayer of tawhid, praise and repentance during hardship.',
      'কষ্টের সময় তাওহিদ, পবিত্রতা ঘোষণা ও অনুতাপের কুরআনি দোয়া।',
    ),
    steps: [
      NeedText(
        'Recall Yunus عليه السلام calling upon Allah in the darkness.',
        'অন্ধকারে ইউনুস (আ.)-এর আল্লাহকে ডাকার ঘটনা স্মরণ করুন।',
      ),
      NeedText(
        'Recite the verse attentively and reflect on its meaning.',
        'মনোযোগ দিয়ে আয়াতটি পড়ুন ও অর্থ ভাবুন।',
      ),
      NeedText(
        'Ask Allah for relief, forgiveness and what is best.',
        'স্বস্তি, ক্ষমা ও কল্যাণের জন্য আল্লাহর কাছে চান।',
      ),
    ],
    arabic:
        'لَا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
    transliteration: 'La ilaha illa anta, subhanaka, inni kuntu minaz-zalimin.',
    meaning: NeedText(
      'There is no god but You. Glory be to You. I was indeed among the wrongdoers.',
      'আপনি ছাড়া কোনো উপাস্য নেই। আপনি পবিত্র। নিশ্চয়ই আমি অন্যায়কারীদের অন্তর্ভুক্ত ছিলাম।',
    ),
    authenticity: NeedText(
      'Qur’an and sahih-graded hadith',
      'কুরআন ও সহিহ মূল্যায়িত হাদিস',
    ),
    evidenceNote: NeedText(
      'The supplication is in Qur’an 21:87, followed by Allah’s response in 21:88. Tirmidhi 3505 reports its virtue. The 100 count shown here is a personal tracking target, not a prescribed number.',
      'দোয়াটি কুরআন ২১:৮৭-এ এবং আল্লাহর সাড়া ২১:৮৮-এ এসেছে। তিরমিজি ৩৫০৫-এ এর ফজিলত আছে। এখানে ১০০ সংখ্যা ব্যক্তিগত হিসাবের লক্ষ্য, শরিয়ত নির্ধারিত সংখ্যা নয়।',
    ),
    timing: NeedText(
      'Any time, especially in hardship',
      'যেকোনো সময়, বিশেষত কষ্টে',
    ),
    references: [needYunusVerse, needYunusHadith],
    progressKind: NeedProgressKind.count,
  ),
  NeedAmal(
    id: 'qadr_dua',
    category: NeedCategory.dua,
    title: NeedText('Laylatul Qadr Dua', 'লাইলাতুল কদরের দোয়া'),
    description: NeedText(
      'Ask Allah for pardon in the nights of Ramadan.',
      'রমজানের রাতগুলোতে আল্লাহর কাছে ক্ষমা চান।',
    ),
    steps: [
      NeedText(
        'Seek Laylatul Qadr during the last ten nights.',
        'শেষ দশ রাতে লাইলাতুল কদর অনুসন্ধান করুন।',
      ),
      NeedText(
        'Recite the supplication taught to ʿA’ishah رضي الله عنها.',
        'আয়িশা (রা.)-কে শেখানো দোয়াটি পড়ুন।',
      ),
      NeedText(
        'Add your personal requests and worship without treating one date as certain.',
        'একটি নির্দিষ্ট রাত নিশ্চিত না ধরে নিজের চাওয়া ও ইবাদত যোগ করুন।',
      ),
    ],
    arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
    transliteration: 'Allahumma innaka ʿafuwwun tuhibbul-ʿafwa faʿfu ʿanni.',
    meaning: NeedText(
      'O Allah, You are Pardoning and love pardon, so pardon me.',
      'হে আল্লাহ, আপনি ক্ষমাশীল এবং ক্ষমা ভালোবাসেন; আমাকে ক্ষমা করুন।',
    ),
    authenticity: NeedText('Sahih-graded hadith', 'সহিহ মূল্যায়িত হাদিস'),
    evidenceNote: NeedText(
      'Tirmidhi 3513 reports this supplication from ʿA’ishah. It is a practice connected with seeking Allah’s pardon.',
      'তিরমিজি ৩৫১৩-এ আয়িশা (রা.) থেকে এই দোয়া বর্ণিত হয়েছে। এটি আল্লাহর ক্ষমা চাওয়ার আমল।',
    ),
    timing: NeedText(
      'Last ten nights of Ramadan, especially odd nights',
      'রমজানের শেষ দশ রাত, বিশেষত বিজোড় রাত',
    ),
    references: [needQadr],
  ),
];
