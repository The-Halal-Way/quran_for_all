import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanWorshipTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.worship,
    title: RamadanText('Qur’an connection', 'কুরআনের সঙ্গে সম্পর্ক'),
    summary: RamadanText(
      'Ramadan is the month of the Qur’an. Choose a reading or listening plan you can keep.',
      'রমজান কুরআনের মাস। নিয়মিত রাখা সম্ভব এমন পড়া বা শোনার পরিকল্পনা করুন।',
    ),
    points: [
      RamadanText(
        'Read with meaning, revisit a small passage, or listen attentively.',
        'অর্থসহ পড়ুন, ছোট অংশ বারবার পড়ুন অথবা মন দিয়ে শুনুন।',
      ),
      RamadanText(
        'Your Read Qur’an and Learn Qur’an sections can support different starting levels.',
        'অ্যাপের কুরআন পড়ুন ও কুরআন শিখুন অংশ ভিন্ন স্তরের পাঠককে সাহায্য করে।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.worship,
    title: RamadanText('Taraweeh and night prayer', 'তারাবি ও রাতের নামাজ'),
    summary: RamadanText(
      'Night prayer is a treasured Ramadan practice; choose a sustainable amount.',
      'রাতের নামাজ রমজানের মূল্যবান আমল; সাধ্য অনুযায়ী পরিমাণ বেছে নিন।',
    ),
    points: [
      RamadanText(
        'Pray with presence at home or in the mosque according to your circumstances.',
        'পরিস্থিতি অনুযায়ী বাড়িতে বা মসজিদে মনোযোগ দিয়ে নামাজ পড়ুন।',
      ),
      RamadanText(
        'Detailed rak‘ah counts and local arrangements vary; follow trusted guidance.',
        'রাকাতের বিস্তারিত ও স্থানীয় ব্যবস্থায় ভিন্নতা আছে; নির্ভরযোগ্য নির্দেশনা অনুসরণ করুন।',
      ),
    ],
    reference: ramadanNightPrayer,
  ),
  RamadanTopic(
    section: RamadanSection.worship,
    title: RamadanText('Du’a and remembrance', 'দোয়া ও জিকির'),
    summary: RamadanText(
      'Make time to ask Allah sincerely and remember Him through the day.',
      'দিনের বিভিন্ন সময় আন্তরিকভাবে আল্লাহর কাছে চান এবং জিকির করুন।',
    ),
    points: [
      RamadanText(
        'Use your own words alongside authentic supplications; keep a short personal list.',
        'নির্ভরযোগ্য দোয়ার পাশাপাশি নিজের ভাষায় বলুন; ব্যক্তিগত ছোট তালিকা রাখুন।',
      ),
      RamadanText(
        'The app’s du’a and Tasbeeh sections can help you return to familiar phrases.',
        'অ্যাপের দোয়া ও তাসবিহ অংশ পরিচিত বাক্যগুলোর চর্চায় সাহায্য করে।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.worship,
    title: RamadanText('Charity in everyday life', 'প্রতিদিনের দান'),
    summary: RamadanText(
      'Give what you can in money, food, time or service.',
      'সামর্থ্য অনুযায়ী অর্থ, খাবার, সময় বা সেবার মাধ্যমে দান করুন।',
    ),
    points: [
      RamadanText(
        'Choose a realistic giving plan and verify the organization you support.',
        'বাস্তবসম্মত দানের পরিকল্পনা করুন এবং যাকে দিচ্ছেন তার বিশ্বাসযোগ্যতা যাচাই করুন।',
      ),
      RamadanText(
        'Good treatment of family, neighbors and coworkers belongs in the same daily plan.',
        'পরিবার, প্রতিবেশী ও সহকর্মীদের সঙ্গে ভালো আচরণও পরিকল্পনায় রাখুন।',
      ),
    ],
  ),
];
