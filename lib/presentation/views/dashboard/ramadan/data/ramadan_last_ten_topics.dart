import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanLastTenTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.lastTen,
    title: RamadanText('The final ten nights', 'শেষ দশ রাত'),
    summary: RamadanText(
      'Give the final ten nights special attention while keeping a pace you can sustain.',
      'সাধ্যের মধ্যে থেকে শেষ দশ রাতে বিশেষ মনোযোগ দিন।',
    ),
    points: [
      RamadanText(
        'Prayer, Qur’an, du’a and generosity can all be part of a simple nightly plan.',
        'নামাজ, কুরআন, দোয়া ও দান নিয়ে সহজ রাতের পরিকল্পনা করুন।',
      ),
      RamadanText(
        'The Prophet ﷺ increased worship and encouraged his family in these nights.',
        'রাসুল ﷺ এ রাতগুলোতে ইবাদত বাড়াতেন ও পরিবারকে উৎসাহ দিতেন।',
      ),
    ],
    reference: ramadanLastTen,
  ),
  RamadanTopic(
    section: RamadanSection.lastTen,
    title: RamadanText('Seek Laylat al-Qadr', 'লাইলাতুল কদর অনুসন্ধান'),
    summary: RamadanText(
      'Seek it in the last ten nights, especially the odd nights; no single date is guaranteed.',
      'শেষ দশ রাতে, বিশেষত বিজোড় রাতগুলোতে অনুসন্ধান করুন; একটি নির্দিষ্ট তারিখ নিশ্চিত নয়।',
    ),
    points: [
      RamadanText(
        'A short act repeated across the nights is better than depending on one date.',
        'শুধু একটি তারিখের ওপর নির্ভর না করে রাতগুলোতে নিয়মিত আমল করুন।',
      ),
      RamadanText(
        'Local moon-sighting affects which nights are counted as odd.',
        'স্থানীয় চাঁদ দেখার কারণে বিজোড় রাতের গণনায় পার্থক্য হতে পারে।',
      ),
    ],
    reference: ramadanQadr,
  ),
  RamadanTopic(
    section: RamadanSection.lastTen,
    title: RamadanText('Du’a for pardon', 'ক্ষমা চাওয়ার দোয়া'),
    summary: RamadanText(
      'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
    ),
    points: [
      RamadanText(
        'Allahumma innaka ‘afuwwun tuhibbul-‘afwa fa‘fu ‘anni.',
        'আল্লাহুম্মা ইন্নাকা আফুউন তুহিব্বুল আফওয়া ফা’ফু আন্নি।',
      ),
      RamadanText(
        'O Allah, You are Pardoning and love pardon, so pardon me.',
        'হে আল্লাহ, আপনি ক্ষমাশীল এবং ক্ষমা ভালোবাসেন; আমাকে ক্ষমা করুন।',
      ),
    ],
    reference: ramadanQadrDua,
  ),
  RamadanTopic(
    section: RamadanSection.lastTen,
    title: RamadanText('I‘tikaf', 'ইতিকাফ'),
    summary: RamadanText(
      'I‘tikaf is dedicated worship in a mosque; both men and women have precedents for it.',
      'ইতিকাফ মসজিদে নিবেদিত ইবাদত; নারী ও পুরুষ উভয়ের জন্য এর নজির আছে।',
    ),
    points: [
      RamadanText(
        'Arrange a safe, suitable place and learn the rules that apply to your circumstances.',
        'নিরাপদ ও উপযুক্ত ব্যবস্থা করুন এবং আপনার পরিস্থিতিতে প্রযোজ্য নিয়ম জেনে নিন।',
      ),
      RamadanText(
        'If formal i‘tikaf is not possible, keep a smaller focused worship routine.',
        'আনুষ্ঠানিক ইতিকাফ সম্ভব না হলে ছোট কিন্তু মনোযোগী ইবাদতের সময় রাখুন।',
      ),
    ],
    reference: ramadanItikaf,
  ),
];
