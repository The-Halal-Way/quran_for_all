import '../../../../core/theme/my_images.dart';
import '../../../models/prayer/prayer_movement_seed.dart';

const prayerStandingSteps = <PrayerMovementSeed>[
  PrayerMovementSeed(
    number: 1,
    title: 'Opening Takbir',
    titleBn: 'তাকবিরে তাহরিমা',
    badge: 'Begin',
    badgeBn: 'শুরু',
    body:
        'Stand facing the qibla, raise your hands, and enter salah with a settled heart.',
    bodyBn:
        'কিবলামুখী হয়ে দাঁড়ান, হাত তুলুন, এবং স্থির হৃদয় নিয়ে নামাজে প্রবেশ করুন।',
    imageAsset: MyImages.takbeerh,
    arabic: 'اللّٰهُ أَكْبَرُ',
    pronunciation: 'Allahu Akbar',
    pronunciationBn: 'আল্লাহু আকবার',
    translation: 'Allah is the Greatest.',
    translationBn: 'আল্লাহ সর্বশ্রেষ্ঠ।',
    note: 'Keep the intention in the heart; it does not need to be spoken.',
    noteBn: 'নিয়ত অন্তরে রাখাই যথেষ্ট; মুখে উচ্চারণ করা জরুরি নয়।',
  ),
  PrayerMovementSeed(
    number: 2,
    title: 'Qiyam',
    titleBn: 'কিয়াম',
    badge: 'Recite',
    badgeBn: 'তিলাওয়াত',
    body:
        'Stand calmly, place the hands with humility, and recite Al-Fatihah in each rakah.',
    bodyBn:
        'শান্তভাবে দাঁড়ান, বিনয়ের সঙ্গে হাত রাখুন, এবং প্রতি রাকাতে সূরা ফাতিহা পড়ুন।',
    imageAsset: MyImages.alQiyam,
    arabic:
        'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ\n'
        'ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n'
        'مَٰلِكِ يَوْمِ ٱلدِّينِ\n'
        'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n'
        'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ\n'
        'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ\n'
        'غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ',
    pronunciation:
        "Al-hamdu lillahi rabbil-'alamin. Ar-rahmanir-rahim. "
        "Maliki yawmid-din. Iyyaka na'budu wa iyyaka nasta'in. "
        "Ihdinas-siratal-mustaqim. Siratal-ladhina an'amta "
        "'alayhim, ghayril-maghdubi 'alayhim wa lad-dallin.",
    pronunciationBn:
        'আলহামদু লিল্লাহি রাব্বিল আলামিন। আর-রহমানির রহিম। '
        'মালিকি ইয়াওমিদ্দিন। ইয়্যাকা না’বুদু ওয়া ইয়্যাকা নাস্তা’ইন। '
        'ইহদিনাস সিরাতাল মুস্তাকিম। সিরাতাল্লাজিনা আনআমতা আলাইহিম, '
        'গাইরিল মাগদুবি আলাইহিম ওয়ালাদ্দল্লিন।',
    translation:
        'All praise is for Allah, Lord of all worlds, the Most Merciful, '
        'Master of the Day of Judgment. You alone we worship and You alone '
        'we ask for help. Guide us to the straight path, the path of those '
        'You favored, not of those who earned anger nor of those astray.',
    translationBn:
        'সমস্ত প্রশংসা আল্লাহর জন্য, যিনি সকল জগতের রব, পরম করুণাময়, '
        'বিচার দিনের মালিক। আমরা কেবল আপনারই ইবাদত করি এবং কেবল আপনারই '
        'সাহায্য চাই। আমাদের সরল পথে পরিচালিত করুন, তাদের পথে যাদের আপনি '
        'অনুগ্রহ করেছেন; তাদের পথে নয় যারা ক্রোধের পাত্র, আর পথভ্রষ্টদেরও নয়।',
    note: 'After Al-Fatihah, recite any easy portion of the Quran.',
    noteBn: 'সূরা ফাতিহার পরে কুরআন থেকে সহজ কোনো অংশ তিলাওয়াত করুন।',
  ),
  PrayerMovementSeed(
    number: 3,
    title: 'Ruku',
    titleBn: 'রুকু',
    badge: 'Bow',
    badgeBn: 'ঝুঁকুন',
    body:
        'Bow with your back settled and pause long enough to glorify Allah without rushing.',
    bodyBn:
        'পিঠ স্থির রেখে রুকু করুন এবং তাড়াহুড়া না করে আল্লাহর পবিত্রতা ঘোষণা করুন।',
    imageAsset: MyImages.ruku,
    arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
    pronunciation: 'Subhana Rabbiyal Azim',
    pronunciationBn: 'সুবহানা রাব্বিয়াল আজিম',
    translation: 'Glory be to my Lord, the Magnificent.',
    translationBn: 'মহান আমার রব পবিত্র।',
    note: 'Repeat three times when you can, while keeping the posture calm.',
    noteBn: 'সম্ভব হলে তিনবার পড়ুন, আর অঙ্গভঙ্গি শান্ত রাখুন।',
  ),
  PrayerMovementSeed(
    number: 4,
    title: 'Rise From Ruku',
    titleBn: 'রুকু থেকে ওঠা',
    badge: 'Stand',
    badgeBn: 'দাঁড়ান',
    body:
        'Return upright before going down to sujood. Let the body fully settle.',
    bodyBn: 'সিজদায় যাওয়ার আগে সোজা হয়ে দাঁড়ান। শরীরকে পুরোপুরি স্থির হতে দিন।',
    imageAsset: MyImages.qiyam,
    arabic: 'سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ\nرَبَّنَا وَلَكَ الْحَمْدُ',
    pronunciation: 'Sami Allahu liman hamidah. Rabbana wa lakal hamd.',
    pronunciationBn: 'সামিআল্লাহু লিমান হামিদাহ। রব্বানা ওয়া লাকাল হামদ।',
    translation:
        'Allah hears the one who praises Him. Our Lord, to You belongs all praise.',
    translationBn:
        'যে আল্লাহর প্রশংসা করে, আল্লাহ তার কথা শোনেন। হে আমাদের রব, সমস্ত প্রশংসা আপনারই।',
    note: 'If praying behind an imam, follow the wording you have been taught.',
    noteBn: 'ইমামের পেছনে পড়লে আপনার শেখা পদ্ধতি অনুযায়ী পড়ুন।',
  ),
];
