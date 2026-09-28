import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanEssentialsTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('Why Ramadan matters', 'রমজানের উদ্দেশ্য'),
    summary: RamadanText(
      'Fasting nurtures mindfulness of Allah; Ramadan is also the month in which the Qur’an was revealed.',
      'রোজা আল্লাহভীতি গড়ে তোলে; রমজানেই কুরআন নাজিল হয়েছে।',
    ),
    points: [
      RamadanText(
        'Begin with sincere intention and a sustainable plan for the month.',
        'আন্তরিক নিয়ত ও সাধ্য অনুযায়ী মাসের পরিকল্পনা নিয়ে শুরু করুন।',
      ),
      RamadanText(
        'The aim includes prayer, character, generosity and reflection—not only abstaining from food.',
        'শুধু পানাহার থেকে বিরত থাকা নয়; নামাজ, চরিত্র, দান ও আত্মসমালোচনাও গুরুত্ব দিন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('When the month begins', 'মাস কখন শুরু হয়'),
    summary: RamadanText(
      'Follow your trusted local moon-sighting announcement for the start and end of Ramadan.',
      'রমজানের শুরু ও শেষের জন্য আপনার এলাকার নির্ভরযোগ্য চাঁদ দেখার ঘোষণা অনুসরণ করুন।',
    ),
    points: [
      RamadanText(
        'Calculated Hijri dates can differ from a local sighting.',
        'গণনাকৃত হিজরি তারিখ স্থানীয় চাঁদ দেখার সিদ্ধান্ত থেকে ভিন্ন হতে পারে।',
      ),
      RamadanText(
        'The month can have 29 or 30 days; confirm Eid locally.',
        'মাস ২৯ বা ৩০ দিনের হতে পারে; ঈদের দিন স্থানীয়ভাবে নিশ্চিত করুন।',
      ),
    ],
    reference: ramadanMoon,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('Intention for fasting', 'রোজার নিয়ত'),
    summary: RamadanText(
      'Know that you are fasting Ramadan for Allah before the fasting day begins.',
      'রোজার দিন শুরুর আগে আল্লাহর জন্য রমজানের রোজা রাখার সংকল্প করুন।',
    ),
    points: [
      RamadanText(
        'A sincere intention is an act of the heart; a special spoken formula is not required here.',
        'আন্তরিক নিয়ত হৃদয়ের কাজ; এখানে বিশেষ কোনো মুখের বাক্য নির্ধারণ করা হচ্ছে না।',
      ),
      RamadanText(
        'Detailed timing questions can vary by school of law; follow trusted local guidance.',
        'নিয়তের সময়সংক্রান্ত বিস্তারিত বিধান মাযহাবভেদে ভিন্ন হতে পারে; নির্ভরযোগ্য আলেমের নির্দেশনা নিন।',
      ),
    ],
    reference: ramadanIntention,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('The fasting window', 'রোজার সময়সীমা'),
    summary: RamadanText(
      'The fast runs from true dawn (Fajr) until sunset (Maghrib).',
      'সুবহে সাদিক (ফজর) থেকে সূর্যাস্ত (মাগরিব) পর্যন্ত রোজা।',
    ),
    points: [
      RamadanText(
        'Finish eating and drinking before Fajr begins; break the fast after sunset.',
        'ফজর শুরু হওয়ার আগে পানাহার শেষ করুন; সূর্যাস্তের পরে ইফতার করুন।',
      ),
      RamadanText(
        'Use the app’s prayer-time settings and check your local mosque’s timetable when needed.',
        'অ্যাপের নামাজের সময় দেখুন এবং প্রয়োজনে স্থানীয় মসজিদের সময়সূচি মিলিয়ে নিন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('Suhur', 'সেহরি'),
    summary: RamadanText(
      'A pre-dawn meal is encouraged, even when simple.',
      'সাধারণ হলেও ফজরের আগের সেহরি গ্রহণে উৎসাহ দেওয়া হয়েছে।',
    ),
    points: [
      RamadanText(
        'Plan food and water before Fajr without rushing the prayer.',
        'ফজরের আগে খাবার ও পানি গ্রহণের পরিকল্পনা করুন, নামাজে তাড়াহুড়া করবেন না।',
      ),
      RamadanText(
        'Choose a meal that supports your health and daily responsibilities.',
        'স্বাস্থ্য ও দিনের কাজের উপযোগী খাবার বেছে নিন।',
      ),
    ],
    reference: ramadanSuhur,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('Iftar', 'ইফতার'),
    summary: RamadanText(
      'Break the fast once sunset is confirmed; do not delay it needlessly.',
      'সূর্যাস্ত নিশ্চিত হলে অকারণে দেরি না করে ইফতার করুন।',
    ),
    points: [
      RamadanText(
        'A simple iftar leaves space for Maghrib prayer and a calm evening.',
        'সাধারণ ইফতার মাগরিবের নামাজ ও শান্ত সন্ধ্যার সুযোগ রাখে।',
      ),
      RamadanText(
        'Remember others: sharing food and kindness matter as much as a full table.',
        'অন্যদের কথা মনে রাখুন: খাবার ভাগ করা ও সদয় আচরণও গুরুত্বপূর্ণ।',
      ),
    ],
    reference: ramadanIftar,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText(
      'What to avoid during the fast',
      'রোজায় যা থেকে বিরত থাকবেন',
    ),
    summary: RamadanText(
      'From dawn to sunset, avoid deliberate eating, drinking and sexual relations.',
      'ফজর থেকে মাগরিব পর্যন্ত ইচ্ছাকৃত পানাহার ও যৌন সম্পর্ক থেকে বিরত থাকুন।',
    ),
    points: [
      RamadanText(
        'Keep the fast in conduct too: guard speech, anger and unfair treatment.',
        'আচরণেও রোজার মর্যাদা রাখুন: কথা, রাগ ও অন্যায় আচরণ থেকে দূরে থাকুন।',
      ),
      RamadanText(
        'Medicines, injections and unusual cases need individual medical and scholarly advice.',
        'ওষুধ, ইনজেকশন ও বিশেষ পরিস্থিতিতে চিকিৎসক এবং আলেমের ব্যক্তিগত পরামর্শ নিন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.essentials,
    title: RamadanText('A genuine mistake', 'ভুলে কিছু খেয়ে ফেললে'),
    summary: RamadanText(
      'If you genuinely forget and eat or drink, stop when you remember and continue the fast.',
      'সত্যিই ভুলে খেয়ে বা পান করে ফেললে মনে পড়ামাত্র থামুন এবং রোজা চালিয়ে যান।',
    ),
    points: [
      RamadanText(
        'Deliberate and accidental acts are different; ask a scholar about a complicated case.',
        'ইচ্ছাকৃত ও অনিচ্ছাকৃত কাজ এক নয়; জটিল ক্ষেত্রে আলেমের পরামর্শ নিন।',
      ),
    ],
    reference: ramadanForgot,
  ),
];
