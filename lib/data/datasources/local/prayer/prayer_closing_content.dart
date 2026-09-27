import '../../../../core/theme/my_images.dart';
import '../../../models/prayer/prayer_movement_seed.dart';

const prayerClosingSteps = <PrayerMovementSeed>[
  PrayerMovementSeed(
    number: 9,
    title: 'Salam Right',
    titleBn: 'ডান দিকে সালাম',
    badge: 'Close',
    badgeBn: 'সমাপ্তি',
    body: 'Turn to the right and give salam to end the prayer.',
    bodyBn: 'ডান দিকে মুখ ফিরিয়ে সালাম দিন এবং নামাজ শেষ করুন।',
    imageAsset: MyImages.salamRight,
    arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
    pronunciation: 'Assalamu alaykum wa rahmatullah',
    pronunciationBn: 'আসসালামু আলাইকুম ওয়া রহমাতুল্লাহ',
    translation: 'Peace and the mercy of Allah be upon you.',
    translationBn: 'আপনাদের ওপর শান্তি ও আল্লাহর রহমত বর্ষিত হোক।',
    note: 'Move with dignity; avoid turning the whole body sharply.',
    noteBn: 'মর্যাদার সঙ্গে ঘুরুন; পুরো শরীর তীক্ষ্ণভাবে ঘোরাবেন না।',
  ),
  PrayerMovementSeed(
    number: 10,
    title: 'Salam Left',
    titleBn: 'বাম দিকে সালাম',
    badge: 'Complete',
    badgeBn: 'সম্পন্ন',
    body: 'Turn left with salam and complete the prayer with composure.',
    bodyBn: 'বাম দিকে সালাম দিন এবং স্থিরতার সঙ্গে নামাজ সম্পন্ন করুন।',
    imageAsset: MyImages.salamLeft,
    arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
    pronunciation: 'Assalamu alaykum wa rahmatullah',
    pronunciationBn: 'আসসালামু আলাইকুম ওয়া রহমাতুল্লাহ',
    translation: 'Peace and the mercy of Allah be upon you.',
    translationBn: 'আপনাদের ওপর শান্তি ও আল্লাহর রহমত বর্ষিত হোক।',
    note: 'After both salams, stay present before moving into the next task.',
    noteBn: 'দুই সালামের পর পরবর্তী কাজে যাওয়ার আগে মনোযোগ ধরে রাখুন।',
  ),
  PrayerMovementSeed(
    number: 11,
    title: 'Post-Prayer Dhikr',
    titleBn: 'নামাজের পরের জিকির',
    badge: 'Remain',
    badgeBn: 'থাকুন',
    body: 'Remain seated briefly for forgiveness, dhikr, and personal dua.',
    bodyBn: 'ক্ষমা প্রার্থনা, জিকির ও ব্যক্তিগত দু’আর জন্য অল্প সময় বসে থাকুন।',
    imageAsset: MyImages.afterPrayer,
    arabic:
        'أَسْتَغْفِرُ اللّٰهَ\n'
        'اللّٰهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ',
    pronunciation: 'Astaghfirullah. Allahumma Antas-Salam wa minkas-salam.',
    pronunciationBn:
        'আস্তাগফিরুল্লাহ। আল্লাহুম্মা আনতাস সালামু ওয়া মিনকাস সালাম।',
    translation:
        'I seek forgiveness from Allah. O Allah, You are Peace and from You comes peace.',
    translationBn:
        'আমি আল্লাহর কাছে ক্ষমা চাই। হে আল্লাহ, আপনিই শান্তি এবং আপনার থেকেই শান্তি আসে।',
    note: 'A common sunnah is to say Astaghfirullah three times after salah.',
    noteBn: 'নামাজের পরে তিনবার আস্তাগফিরুল্লাহ বলা একটি প্রচলিত সুন্নাহ।',
  ),
];
