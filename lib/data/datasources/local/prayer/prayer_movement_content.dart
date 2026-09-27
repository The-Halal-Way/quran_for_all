import '../../../models/prayer/prayer_movement_seed.dart';
import 'prayer_closing_content.dart';
import 'prayer_seated_content.dart';
import 'prayer_standing_content.dart';

const prayerMovementSteps = <PrayerMovementSeed>[
  ...prayerStandingSteps,
  ...prayerSeatedSteps,
  ...prayerClosingSteps,
];

const prayerMovementHadiths = <PrayerMovementHadithSeed>[
  PrayerMovementHadithSeed(
    source: 'Sahih al-Bukhari 631',
    body:
        'The Prophet taught his companions to pray by following his own prayer.',
    bodyBn: 'নবীজি তাঁর সাহাবিদের নিজের নামাজ অনুসরণ করে নামাজ শিখিয়েছেন।',
  ),
  PrayerMovementHadithSeed(
    source: 'Sahih al-Bukhari 757; Sahih Muslim 397',
    body:
        'A companion was corrected until he prayed with calmness in each posture.',
    bodyBn:
        'এক সাহাবিকে প্রতিটি অঙ্গভঙ্গিতে স্থিরতা রেখে নামাজ পড়া পর্যন্ত সংশোধন করা হয়েছিল।',
  ),
  PrayerMovementHadithSeed(
    source: 'Sahih Muslim 482',
    body:
        'Sujood is a moment of nearness to Allah, so it is a beautiful place for dua.',
    bodyBn: 'সিজদা আল্লাহর নৈকট্যের মুহূর্ত, তাই এটি দু’আর জন্য সুন্দর স্থান।',
  ),
];
