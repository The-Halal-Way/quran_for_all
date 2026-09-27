import '../eid_prayer_models.dart';

const eidPrayerSections = <EidSection>[
  EidSection(
    title: EidText('Prayer at a glance', 'নামাজ এক নজরে'),
    intro: EidText(
      'Pray two rak\'ahs in congregation. There is no adhan or iqamah. The Eid khutbah follows the prayer.',
      'জামাতে দুই রাকাত নামাজ পড়ুন। এতে আজান বা ইকামত নেই। নামাজের পরে ঈদের খুতবা হয়।',
    ),
    entries: [
      EidEntry(
        title: EidText('No call to prayer', 'আজান বা ইকামত নেই'),
        body: EidText(
          'The Eid prayer is performed without adhan or iqamah.',
          'ঈদের নামাজ আজান বা ইকামত ছাড়াই আদায় করা হয়।',
        ),
        reference: 'Sahih Muslim 885',
      ),
      EidEntry(
        title: EidText('Intention is in the heart', 'নিয়ত অন্তরে'),
        body: EidText(
          'Intend to pray two rak\'ahs of Eid prayer for Allah behind the imam. No fixed spoken formula is required.',
          'ইমামের পেছনে আল্লাহর জন্য দুই রাকাত ঈদের নামাজের নিয়ত করুন। নির্দিষ্ট কোনো বাক্য উচ্চারণ করা জরুরি নয়।',
        ),
      ),
      EidEntry(
        title: EidText('Follow your imam', 'ইমামের অনুসরণ করুন'),
        body: EidText(
          'The sequence below presents one narrated method. Additional takbeer counts and practice differ among scholars and communities; follow your imam.',
          'নিচে বর্ণিত একটি পদ্ধতি দেওয়া হয়েছে। অতিরিক্ত তাকবীরের সংখ্যা ও পদ্ধতিতে আলেমদের মতভেদ রয়েছে; আপনার ইমামের অনুসরণ করুন।',
        ),
        reference: 'Sunan Abu Dawud 1150',
      ),
    ],
  ),
  EidSection(
    title: EidText('First rak\'ah', 'প্রথম রাকাত'),
    entries: [
      EidEntry(
        title: EidText('01  Begin', '০১  শুরু'),
        arabic: 'اللَّهُ أَكْبَرُ',
        pronunciation: EidText('Allāhu akbar', 'আল্লাহু আকবার'),
        meaning: EidText('Allah is the Greatest.', 'আল্লাহ সর্বশ্রেষ্ঠ।'),
        body: EidText(
          'Stand behind the imam and start with the opening takbeer: “Allahu Akbar.”',
          'ইমামের পেছনে দাঁড়িয়ে প্রথম তাকবীর “আল্লাহু আকবার” বলে নামাজ শুরু করুন।',
        ),
      ),
      EidEntry(
        title: EidText('02  Extra takbeers', '০২  অতিরিক্ত তাকবীর'),
        arabic: 'اللَّهُ أَكْبَرُ',
        pronunciation: EidText('Allāhu akbar', 'আল্লাহু আকবার'),
        meaning: EidText('Allah is the Greatest.', 'আল্লাহ সর্বশ্রেষ্ঠ।'),
        body: EidText(
          'Follow the imam for the extra takbeers before recitation. A narration mentions seven takbeers in the first rak\'ah, apart from the bowing takbeer. Counting conventions differ.',
          'কিরাতের আগে অতিরিক্ত তাকবীরে ইমামের অনুসরণ করুন। একটি বর্ণনায় রুকুর তাকবীর ছাড়া প্রথম রাকাতে সাত তাকবীরের কথা আছে। গণনার পদ্ধতিতে মতভেদ রয়েছে।',
        ),
        reference: 'Sunan Abi Dawud 1149–1150',
      ),
      EidEntry(
        title: EidText('03  Recite', '০৩  কিরাত'),
        body: EidText(
          'Recite Al-Fatihah and another surah. Al-A\'la (87) or Qaf (50) are mentioned among the recitations.',
          'সূরা ফাতিহা ও অন্য একটি সূরা পড়ুন। আল-আ’লা (৮৭) অথবা কাফ (৫০) বর্ণিত সূরাগুলোর মধ্যে রয়েছে।',
        ),
      ),
      EidEntry(
        title: EidText('04  Complete', '০৪  সম্পন্ন করুন'),
        body: EidText(
          'Complete ruku and two sujood, then stand for the second rak\'ah.',
          'রুকু ও দুই সিজদা শেষে দ্বিতীয় রাকাতের জন্য দাঁড়ান।',
        ),
      ),
    ],
  ),
  EidSection(
    title: EidText('Second rak\'ah', 'দ্বিতীয় রাকাত'),
    entries: [
      EidEntry(
        title: EidText('05  Extra takbeers', '০৫  অতিরিক্ত তাকবীর'),
        arabic: 'اللَّهُ أَكْبَرُ',
        pronunciation: EidText('Allāhu akbar', 'আল্লাহু আকবার'),
        meaning: EidText('Allah is the Greatest.', 'আল্লাহ সর্বশ্রেষ্ঠ।'),
        body: EidText(
          'After standing, follow the imam for the takbeers before recitation. A narration mentions five in this rak\'ah, apart from the bowing takbeer.',
          'দাঁড়ানোর পরে কিরাতের আগের তাকবীরে ইমামের অনুসরণ করুন। একটি বর্ণনায় রুকুর তাকবীর ছাড়া এ রাকাতে পাঁচ তাকবীরের কথা আছে।',
        ),
        reference: 'Sunan Abi Dawud 1149–1150',
      ),
      EidEntry(
        title: EidText('06  Recite', '০৬  কিরাত'),
        body: EidText(
          'Recite Al-Fatihah and another surah. Al-Ghashiyah (88) or Al-Qamar (54) are mentioned among the recitations.',
          'সূরা ফাতিহা ও অন্য একটি সূরা পড়ুন। আল-গাশিয়াহ (৮৮) অথবা আল-কামার (৫৪) বর্ণিত সূরাগুলোর মধ্যে রয়েছে।',
        ),
      ),
      EidEntry(
        title: EidText('07  Finish', '০৭  শেষ করুন'),
        body: EidText(
          'Complete ruku, two sujood, tashahhud and salam.',
          'রুকু, দুই সিজদা, তাশাহহুদ ও সালাম দিয়ে নামাজ শেষ করুন।',
        ),
      ),
    ],
  ),
  EidSection(
    title: EidText('After the prayer', 'নামাজের পরে'),
    entries: [
      EidEntry(
        title: EidText('Listen to the khutbah', 'খুতবা শুনুন'),
        body: EidText(
          'The imam gives the Eid sermon after prayer. Listening attentively is encouraged; the Prophet ﷺ addressed the people after Eid prayer.',
          'নামাজের পরে ইমাম ঈদের খুতবা দেন। মনোযোগ দিয়ে শোনা উত্তম; রাসূল ﷺ নামাজের পরে মানুষকে নসিহত করতেন।',
        ),
        reference: 'Sahih al-Bukhari 956',
      ),
      EidEntry(
        title: EidText('Surahs reported for Eid', 'ঈদে বর্ণিত সূরা'),
        body: EidText(
          'One pair is Al-A\'la (87) and Al-Ghashiyah (88); another is Qaf (50) and Al-Qamar (54).',
          'এক জোড়া সূরা আল-আ’লা (৮৭) ও আল-গাশিয়াহ (৮৮); অন্য জোড়া কাফ (৫০) ও আল-কামার (৫৪)।',
        ),
        reference: 'Sahih Muslim 878',
      ),
    ],
  ),
  EidSection(
    title: EidText('Fiqh and common mistakes', 'ফিকহ ও সাধারণ ভুল'),
    entries: [
      EidEntry(
        title: EidText('Scholarly rulings differ', 'হুকুমে মতভেদ'),
        body: EidText(
          'Scholars have described Eid prayer as Sunnah Mu\'akkadah, Fard Kifayah, or Wajib (in the Hanafi school). Respect differences in local practice.',
          'ঈদের নামাজকে আলেমরা সুন্নাতে মুয়াক্কাদা, ফরজে কিফায়া অথবা হানাফি মাজহাবে ওয়াজিব বলেছেন। স্থানীয় পদ্ধতির মতভেদকে সম্মান করুন।',
        ),
      ),
      EidEntry(
        title: EidText('Remember the order', 'ধারাটি মনে রাখুন'),
        body: EidText(
          'There is no adhan or iqamah. Attend the prayer when you can, give the khutbah its due attention, and keep worship part of the celebration.',
          'এতে আজান বা ইকামত নেই। সুযোগ থাকলে নামাজে অংশ নিন, খুতবা মন দিয়ে শুনুন এবং ঈদের আনন্দে ইবাদতকে স্থান দিন।',
        ),
      ),
    ],
  ),
];
