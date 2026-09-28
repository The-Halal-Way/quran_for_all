import '../need_amal.dart';
import 'need_references.dart';

const specialTimeAmals = <NeedAmal>[
  NeedAmal(
    id: 'adhan_iqamah',
    category: NeedCategory.specialTimes,
    title: NeedText('Between Adhan and Iqamah', 'আজান ও ইকামতের মাঝে'),
    description: NeedText(
      'Use this interval for a sincere personal du’a.',
      'এই সময়ে আন্তরিকভাবে নিজের দোয়া করুন।',
    ),
    steps: [
      NeedText(
        'Answer the adhan and prepare for prayer.',
        'আজানের জবাব দিন ও নামাজের প্রস্তুতি নিন।',
      ),
      NeedText(
        'Before the iqamah, praise Allah and ask for what is good.',
        'ইকামতের আগে আল্লাহর প্রশংসা করে কল্যাণ চান।',
      ),
    ],
    authenticity: NeedText('Sahih-graded hadith', 'সহিহ মূল্যায়িত হাদিস'),
    evidenceNote: NeedText(
      'Abu Dawud 521 reports that du’a between adhan and iqamah is not rejected. Acceptance remains with Allah and need not mean the exact worldly outcome imagined.',
      'আবু দাউদ ৫২১-এ আজান ও ইকামতের মাঝের দোয়ার ফজিলত আছে। কবুলের রূপ আল্লাহর হাতে; তা কল্পিত নির্দিষ্ট দুনিয়াবি ফলই হতে হবে এমন নয়।',
    ),
    timing: NeedText('After adhan, before iqamah', 'আজানের পর, ইকামতের আগে'),
    duaNote: NeedText(
      'No single fixed du’a is required for this interval.',
      'এই সময়ের জন্য একটিমাত্র নির্ধারিত দোয়া নেই।',
    ),
    references: [needAdhan],
  ),
  NeedAmal(
    id: 'iftar_dua',
    category: NeedCategory.specialTimes,
    title: NeedText('Dua at Iftar', 'ইফতারের সময় দোয়া'),
    description: NeedText(
      'A fasting person’s du’a at the time of breaking fast is especially valued.',
      'রোজাদারের ইফতারের সময়ের দোয়ার বিশেষ ফজিলত আছে।',
    ),
    steps: [
      NeedText(
        'At sunset, prepare to break the fast without needless delay.',
        'সূর্যাস্তে অকারণে দেরি না করে ইফতারের প্রস্তুতি নিন।',
      ),
      NeedText(
        'Make sincere du’a around iftar, especially in Ramadan.',
        'ইফতারের সময় আন্তরিক দোয়া করুন, বিশেষত রমজানে।',
      ),
      NeedText(
        'Ask for forgiveness, wellbeing and good for others.',
        'ক্ষমা, সুস্থতা ও অন্যদের কল্যাণ চান।',
      ),
    ],
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ أَنْ تَغْفِرَ لِي',
    transliteration:
        'Allahumma inni as’aluka birahmatikal-lati wasiʿat kulla shay’in an taghfira li.',
    meaning: NeedText(
      'O Allah, I ask You by Your mercy that encompasses all things to forgive me.',
      'হে আল্লাহ, আপনার সর্বব্যাপী রহমতের মাধ্যমে আমার ক্ষমা চাই।',
    ),
    duaNote: NeedText(
      'This wording is reported from the companion ʿAbdullah ibn ʿAmr alongside the hadith, not presented here as a required prophetic iftar formula.',
      'এই বাক্যটি হাদিসের সঙ্গে আবদুল্লাহ ইবন আমর (রা.) থেকে এসেছে; এখানে এটিকে বাধ্যতামূলক নববী ইফতার দোয়া বলা হচ্ছে না।',
    ),
    authenticity: NeedText(
      'Hasan-graded hadith; companion’s wording',
      'হাসান মূল্যায়িত হাদিস; সাহাবির দোয়া',
    ),
    evidenceNote: NeedText(
      'Ibn Majah 1753 reports the virtue of a fasting person’s du’a at iftar and records the companion’s supplication.',
      'ইবন মাজাহ ১৭৫৩-এ ইফতারের দোয়ার ফজিলত ও সাহাবির দোয়া এসেছে।',
    ),
    timing: NeedText('At the time of breaking a fast', 'রোজা ভাঙার সময়'),
    references: [needIftar],
  ),
  NeedAmal(
    id: 'friday_dua',
    category: NeedCategory.specialTimes,
    title: NeedText('Friday’s Special Dua Time', 'জুমার বিশেষ দোয়ার সময়'),
    description: NeedText(
      'Seek the brief hour of acceptance on Friday while filling the day with worship.',
      'জুমার স্বল্প সময়ের বিশেষ দোয়ার সুযোগ খুঁজুন এবং দিনটিকে ইবাদতে ভরিয়ে দিন।',
    ),
    steps: [
      NeedText(
        'Make du’a throughout Friday; scholars differ on the exact hour.',
        'জুমার দিনজুড়ে দোয়া করুন; নির্দিষ্ট সময় নিয়ে আলেমদের মতভেদ আছে।',
      ),
      NeedText(
        'Read or reflect on Surat al-Kahf and send more salawat.',
        'সূরা কাহফ পড়ুন বা তা নিয়ে ভাবুন, বেশি দরুদ পড়ুন।',
      ),
      NeedText(
        'Ask Allah for good in this life and the next.',
        'দুনিয়া ও আখিরাতের কল্যাণ চান।',
      ),
    ],
    authenticity: NeedText(
      'Sahih hadith; timing discussed',
      'সহিহ হাদিস; নির্দিষ্ট সময় নিয়ে আলোচনা আছে',
    ),
    evidenceNote: NeedText(
      'Bukhari 935 and Muslim 852e describe a brief special time for du’a. Abu Dawud 1047 encourages salawat on Friday. Al-Kahf is recommended through separate reports whose grading is discussed.',
      'বুখারি ৯৩৫ ও মুসলিম ৮৫২ই-তে জুমার সংক্ষিপ্ত বিশেষ সময়ের কথা আছে। আবু দাউদ ১০৪৭-এ দরুদের উৎসাহ। সূরা কাহফের সুপারিশ আলাদা বর্ণনায় এসেছে, যেগুলোর মান নিয়ে আলোচনা আছে।',
    ),
    timing: NeedText(
      'Friday; the exact hour is not certain',
      'জুমার দিন; নির্দিষ্ট সময় নিশ্চিত নয়',
    ),
    duaNote: NeedText(
      'No single Friday du’a text is required.',
      'জুমার জন্য একটিমাত্র নির্ধারিত দোয়া নেই।',
    ),
    references: [
      needFridayBukhari,
      needFridayMuslim,
      needFridaySalawat,
      needFridayKahf,
    ],
  ),
];
