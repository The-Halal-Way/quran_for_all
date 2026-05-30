import 'package:flutter/foundation.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';

class SpecialPrayerViewModel extends ChangeNotifier {
  SpecialPrayerViewModel(this.type);

  final SpecialPrayerType type;

  SpecialPrayerContent content(AppLocalizations l10n) {
    final isBangla = l10n.localeName.startsWith('bn');
    return _seedFor(type).resolve(isBangla);
  }

  _SpecialPrayerSeed _seedFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => _janazaSeed,
      SpecialPrayerType.salatulTasbeeh => _salatulTasbeehSeed,
    };
  }

  static const _janazaSeed = _SpecialPrayerSeed(
    type: SpecialPrayerType.janaza,
    title: _LocalizedText('Janaja Prayer', 'জানাজা নামাজ'),
    heroEyebrow: _LocalizedText('Funeral prayer', 'মৃত ব্যক্তির জন্য দোয়া'),
    heroArabic: 'صلاة الجنازة',
    heroBody: _LocalizedText(
      'A calm, standing prayer of mercy for a Muslim who has passed away, centered on takbir, salawat, and sincere du\'a.',
      'মৃত মুসলিমের জন্য রহমতের শান্ত দাঁড়ানো নামাজ, যেখানে তাকবির, দরুদ ও আন্তরিক দু\'আ মূল বিষয়।',
    ),
    heroBadge: _LocalizedText('Fard kifayah', 'ফরজে কিফায়া'),
    quickFactsTitle: _LocalizedText('Before you join', 'শুরু করার আগে'),
    quickFactsSubtitle: _LocalizedText(
      'The essentials that make Janaja Prayer different from the daily salah flow.',
      'দৈনিক নামাজের ধারা থেকে জানাজা নামাজকে আলাদা করে এমন জরুরি বিষয়গুলো।',
    ),
    guideTitle: _LocalizedText('Four-takbir flow', 'চার তাকবিরের ধারা'),
    guideSubtitle: _LocalizedText(
      'Follow the prayer without ruku or sujood, keeping the heart focused on forgiveness and mercy.',
      'রুকু-সিজদা ছাড়া নামাজটি অনুসরণ করুন, আর অন্তরকে ক্ষমা ও রহমতের দু\'আয় রাখুন।',
    ),
    sectionCommentLabel: _LocalizedText('Section comment', 'সেকশন মন্তব্য'),
    hadithTitle: _LocalizedText('Related hadith', 'সম্পর্কিত হাদিস'),
    hadithSubtitle: _LocalizedText(
      'Short reminders about virtue, sincerity, and honoring the deceased.',
      'ফজিলত, আন্তরিকতা ও মৃত ব্যক্তির মর্যাদা সম্পর্কে সংক্ষিপ্ত স্মরণিকা।',
    ),
    note: _PrayerGuidanceSeed(
      title: _LocalizedText('Respectful fiqh note', 'সম্মানজনক ফিকহি নোট'),
      body: _LocalizedText(
        'Janaja wording and hand positions can vary by madhhab. Use this as a friendly guide and follow the imam or trusted local scholar in real prayer.',
        'জানাজার শব্দচয়ন ও হাতের অবস্থানে মাযহাবভেদে পার্থক্য থাকতে পারে। এটিকে বন্ধুসুলভ গাইড হিসেবে নিন এবং বাস্তবে ইমাম বা বিশ্বস্ত স্থানীয় আলেমের অনুসরণ করুন।',
      ),
    ),
    facts: [
      _SpecialPrayerFactSeed(
        label: _LocalizedText('Ruling', 'হুকুম'),
        value: _LocalizedText('Fard kifayah', 'ফরজে কিফায়া'),
        detail: _LocalizedText(
          'A communal obligation fulfilled when enough Muslims perform it.',
          'যথেষ্ট মুসলিম আদায় করলে সামষ্টিক দায়িত্ব পূর্ণ হয়।',
        ),
      ),
      _SpecialPrayerFactSeed(
        label: _LocalizedText('Shape', 'ধরন'),
        value: _LocalizedText('4 takbirs', '৪ তাকবির'),
        detail: _LocalizedText(
          'Standing only, with no ruku, sujood, adhan, or iqamah.',
          'শুধু দাঁড়িয়ে পড়া হয়; রুকু, সিজদা, আজান বা ইকামত নেই।',
        ),
      ),
      _SpecialPrayerFactSeed(
        label: _LocalizedText('Core', 'মূল বিষয়'),
        value: _LocalizedText('Du\'a', 'দু\'আ'),
        detail: _LocalizedText(
          'Ask Allah for forgiveness, mercy, safety, and honor for the deceased.',
          'মৃত ব্যক্তির জন্য আল্লাহর কাছে ক্ষমা, রহমত, নিরাপত্তা ও মর্যাদা চান।',
        ),
      ),
    ],
    sections: [
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('Preparation and intention', 'প্রস্তুতি ও নিয়ত'),
        body: _LocalizedText(
          'Enter the prayer with wudu, qibla direction, and a settled intention to pray for the deceased.',
          'ওজু, কিবলামুখী অবস্থান এবং মৃত ব্যক্তির জন্য নামাজের স্থির নিয়ত নিয়ে শুরু করুন।',
        ),
        comment: _LocalizedText(
          'There is no adhan or iqamah for Janaja Prayer. The intention stays in the heart.',
          'জানাজা নামাজের জন্য আজান বা ইকামত নেই। নিয়ত অন্তরেই থাকে।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Stand with the imam', 'ইমামের সঙ্গে দাঁড়ান'),
            body: _LocalizedText(
              'Line up calmly, face the qibla, and keep the rows dignified.',
              'শান্তভাবে কাতারে দাঁড়ান, কিবলামুখী হন, এবং কাতারকে মর্যাদাপূর্ণ রাখুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Hold the intention', 'নিয়ত স্থির রাখুন'),
            body: _LocalizedText(
              'Intend Janaja Prayer and sincere supplication for the deceased Muslim.',
              'জানাজা নামাজ এবং মৃত মুসলিমের জন্য আন্তরিক দু\'আর নিয়ত করুন।',
            ),
          ),
        ],
      ),
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('The four takbirs', 'চার তাকবির'),
        body: _LocalizedText(
          'Each takbir opens a focused part of the prayer. Keep the body still and the du\'a present.',
          'প্রতিটি তাকবির নামাজের একটি মনোযোগী অংশ খুলে দেয়। শরীর স্থির রাখুন এবং দু\'আকে সামনে রাখুন।',
        ),
        comment: _LocalizedText(
          'Some schools recite Al-Fatihah after the first takbir, while others use opening praise. Follow the imam.',
          'কিছু মাযহাবে প্রথম তাকবিরের পর সূরা ফাতিহা পড়া হয়, আবার কিছুতে সানা। ইমামের অনুসরণ করুন।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('1st', '১ম'),
            title: _LocalizedText('Opening takbir', 'প্রথম তাকবির'),
            body: _LocalizedText(
              'Say Allahu Akbar and begin with the opening praise or Al-Fatihah according to your learned practice.',
              'আল্লাহু আকবার বলে আপনার শেখা পদ্ধতি অনুযায়ী সানা বা সূরা ফাতিহা পড়ুন।',
            ),
            arabic: 'اللّٰهُ أَكْبَرُ',
            pronunciation: _LocalizedText('Allahu Akbar', 'আল্লাহু আকবার'),
            translation: _LocalizedText(
              'Allah is the Greatest.',
              'আল্লাহ সর্বশ্রেষ্ঠ।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('2nd', '২য়'),
            title: _LocalizedText('Salawat', 'দরুদ'),
            body: _LocalizedText(
              'After the second takbir, send salawat upon the Prophet, peace be upon him.',
              'দ্বিতীয় তাকবিরের পর নবীজির ওপর দরুদ পাঠ করুন, তাঁর ওপর শান্তি বর্ষিত হোক।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('3rd', '৩য়'),
            title: _LocalizedText(
              'Du\'a for the deceased',
              'মৃত ব্যক্তির জন্য দু\'আ',
            ),
            body: _LocalizedText(
              'After the third takbir, make the main supplication for forgiveness and mercy. Adjust wording for male, female, or child as taught.',
              'তৃতীয় তাকবিরের পর ক্ষমা ও রহমতের মূল দু\'আ করুন। পুরুষ, নারী বা শিশুর জন্য শেখা অনুযায়ী শব্দচয়ন ঠিক করুন।',
            ),
            arabic: 'اللّٰهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ',
            pronunciation: _LocalizedText(
              'Allahummaghfir lahu warhamhu',
              'আল্লাহুম্মাগফির লাহু ওয়ারহামহু',
            ),
            translation: _LocalizedText(
              'O Allah, forgive him and have mercy on him.',
              'হে আল্লাহ, তাকে ক্ষমা করুন এবং তার ওপর রহম করুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('4th', '৪র্থ'),
            title: _LocalizedText(
              'Final takbir and salam',
              'শেষ তাকবির ও সালাম',
            ),
            body: _LocalizedText(
              'After the fourth takbir, pause briefly, then end with salam according to the imam\'s practice.',
              'চতুর্থ তাকবিরের পর অল্প বিরতি নিয়ে ইমামের পদ্ধতি অনুযায়ী সালাম দিয়ে শেষ করুন।',
            ),
          ),
        ],
      ),
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('Du\'a focus', 'দু\'আর ফোকাস'),
        body: _LocalizedText(
          'The heart of Janaja Prayer is asking Allah to receive the deceased with mercy.',
          'জানাজা নামাজের প্রাণ হলো মৃত ব্যক্তিকে রহমতের সঙ্গে কবুল করার জন্য আল্লাহর কাছে চাওয়া।',
        ),
        comment: _LocalizedText(
          'Keep the du\'a sincere and concise. This is not a place for rushing through memorized words without presence.',
          'দু\'আ আন্তরিক ও সংক্ষিপ্ত রাখুন। মনোযোগ ছাড়া মুখস্থ শব্দ দ্রুত পড়ার জায়গা এটি নয়।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Ask for forgiveness', 'ক্ষমা চান'),
            body: _LocalizedText(
              'Ask Allah to forgive sins, widen the grave, and replace fear with safety.',
              'আল্লাহর কাছে গুনাহ মাফ, কবর প্রশস্ত করা এবং ভয়কে নিরাপত্তায় বদলে দেওয়ার প্রার্থনা করুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Remember the family', 'পরিবারকে স্মরণ করুন'),
            body: _LocalizedText(
              'Pray for patience, reward, and steadiness for the relatives and community.',
              'স্বজন ও সমাজের জন্য ধৈর্য, সওয়াব এবং স্থিরতার দু\'আ করুন।',
            ),
          ),
        ],
      ),
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('After the prayer', 'নামাজের পরে'),
        body: _LocalizedText(
          'Let the prayer continue into adab: dignity, silence, and support for the grieving.',
          'নামাজের পর আদব ধরে রাখুন: মর্যাদা, নীরবতা এবং শোকাহতদের পাশে থাকা।',
        ),
        comment: _LocalizedText(
          'If you follow the burial, keep the gathering free of noise, display, and unnecessary argument.',
          'দাফনে গেলে সমাবেশকে শব্দ, প্রদর্শন এবং অপ্রয়োজনীয় বিতর্ক থেকে মুক্ত রাখুন।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            title: _LocalizedText(
              'Follow with dignity',
              'মর্যাদার সঙ্গে অনুসরণ করুন',
            ),
            body: _LocalizedText(
              'Walk or wait calmly, making quiet du\'a instead of turning the moment into conversation.',
              'শান্তভাবে হাঁটুন বা অপেক্ষা করুন, কথোপকথনের বদলে নীরবে দু\'আ করুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            title: _LocalizedText(
              'Comfort the grieving',
              'শোকাহতদের সান্ত্বনা দিন',
            ),
            body: _LocalizedText(
              'Offer short, kind words and practical support without overwhelming the family.',
              'পরিবারকে ভারী না করে সংক্ষিপ্ত ভালো কথা এবং বাস্তব সহায়তা দিন।',
            ),
          ),
        ],
      ),
    ],
    hadithReferences: [
      _PrayerHadithSeed(
        source: _LocalizedText(
          'Sahih al-Bukhari 1325; Sahih Muslim 945',
          'সহিহ বুখারি ১৩২৫; সহিহ মুসলিম ৯৪৫',
        ),
        body: _LocalizedText(
          'Following the funeral prayer is described with a qirat of reward, and staying until burial with two qirats.',
          'জানাজা পর্যন্ত অনুসরণে এক কিরাত এবং দাফন পর্যন্ত থাকলে দুই কিরাত সওয়াবের বর্ণনা এসেছে।',
        ),
      ),
      _PrayerHadithSeed(
        source: _LocalizedText('Sunan Abi Dawud 3199', 'সুনান আবি দাউদ ৩১৯৯'),
        body: _LocalizedText(
          'When praying over the deceased, the Prophet taught believers to make supplication sincerely.',
          'মৃত ব্যক্তির জানাজা পড়ার সময় নবীজি আন্তরিকভাবে দু\'আ করতে শিক্ষা দিয়েছেন।',
        ),
      ),
    ],
  );

  static const _salatulTasbeehSeed = _SpecialPrayerSeed(
    type: SpecialPrayerType.salatulTasbeeh,
    title: _LocalizedText('Salatul Tasbeeh', 'সালাতুত তাসবিহ'),
    heroEyebrow: _LocalizedText('Tasbih prayer', 'তাসবিহের নামাজ'),
    heroArabic: 'صلاة التسبيح',
    heroBody: _LocalizedText(
      'A voluntary four-rak\'ah prayer built around repeated glorification of Allah, practiced with care and scholarly awareness.',
      'আল্লাহর তাসবিহ বারবার পড়াকে কেন্দ্র করে চার রাকাতের ঐচ্ছিক নামাজ, যা যত্ন ও আলেমদের মতভেদ জেনে করা হয়।',
    ),
    heroBadge: _LocalizedText('Voluntary', 'ঐচ্ছিক'),
    quickFactsTitle: _LocalizedText('Tasbeeh map', 'তাসবিহের মানচিত্র'),
    quickFactsSubtitle: _LocalizedText(
      'The full rhythm at a glance before you begin counting.',
      'গণনা শুরু করার আগে পুরো ধারাটি এক নজরে দেখুন।',
    ),
    guideTitle: _LocalizedText('Counting flow', 'গণনার ধারা'),
    guideSubtitle: _LocalizedText(
      'A gentle structure for completing 300 tasbih across four rak\'ahs without rushing the prayer.',
      'নামাজে তাড়াহুড়া না করে চার রাকাতে ৩০০ তাসবিহ সম্পন্ন করার কোমল কাঠামো।',
    ),
    sectionCommentLabel: _LocalizedText('Section comment', 'সেকশন মন্তব্য'),
    hadithTitle: _LocalizedText('Related hadith', 'সম্পর্কিত হাদিস'),
    hadithSubtitle: _LocalizedText(
      'Narration notes with a clear reminder that scholars differ on grading.',
      'বর্ণনার নোট, সঙ্গে হাদিসের মান নিয়ে আলেমদের মতভেদ আছে এমন পরিষ্কার স্মরণিকা।',
    ),
    note: _PrayerGuidanceSeed(
      title: _LocalizedText(
        'Authenticity and practice note',
        'বিশুদ্ধতা ও আমলের নোট',
      ),
      body: _LocalizedText(
        'Salatul Tasbeeh is reported in hadith collections, but scholars differ about its strength and regular practice. Treat it as voluntary, avoid disliked prayer times, and follow trusted scholarship.',
        'সালাতুত তাসবিহ হাদিস গ্রন্থে বর্ণিত, তবে এর শক্তি ও নিয়মিত আমল নিয়ে আলেমদের মতভেদ আছে। এটিকে ঐচ্ছিক আমল হিসেবে নিন, অপছন্দনীয় নামাজের সময় এড়িয়ে চলুন, এবং বিশ্বস্ত আলেমদের নির্দেশনা অনুসরণ করুন।',
      ),
    ),
    facts: [
      _SpecialPrayerFactSeed(
        label: _LocalizedText('Ruling', 'হুকুম'),
        value: _LocalizedText('Voluntary', 'ঐচ্ছিক'),
        detail: _LocalizedText(
          'Not obligatory; practice it when you have time, focus, and guidance.',
          'ফরজ নয়; সময়, মনোযোগ ও নির্দেশনা থাকলে আমল করুন।',
        ),
      ),
      _SpecialPrayerFactSeed(
        label: _LocalizedText('Total', 'মোট'),
        value: _LocalizedText('300 tasbih', '৩০০ তাসবিহ'),
        detail: _LocalizedText(
          '75 tasbih in each rak\'ah across four rak\'ahs.',
          'চার রাকাতে প্রতি রাকাতে ৭৫টি করে তাসবিহ।',
        ),
      ),
      _SpecialPrayerFactSeed(
        label: _LocalizedText('Shape', 'ধরন'),
        value: _LocalizedText('4 rak\'ahs', '৪ রাকাত'),
        detail: _LocalizedText(
          'Keep all normal pillars of salah calm and complete.',
          'নামাজের স্বাভাবিক সব রুকন শান্ত ও পূর্ণ রাখুন।',
        ),
      ),
    ],
    sections: [
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('Intention and timing', 'নিয়ত ও সময়'),
        body: _LocalizedText(
          'Begin like any voluntary salah: wudu, qibla, quiet intention, and a time where voluntary prayer is allowed.',
          'যেকোনো নফল নামাজের মতো শুরু করুন: ওজু, কিবলা, নীরব নিয়ত, এবং নফল নামাজ বৈধ এমন সময়।',
        ),
        comment: _LocalizedText(
          'Do not place it in the sunrise, zenith, or sunset restriction windows.',
          'সূর্যোদয়, সূর্য মধ্যাকাশে থাকা বা সূর্যাস্তের নিষিদ্ধ সময়ে এটি রাখবেন না।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Choose a calm window', 'শান্ত সময় বেছে নিন'),
            body: _LocalizedText(
              'Pick a time where counting will not make you rush the essentials of salah.',
              'এমন সময় বেছে নিন যেখানে গণনা নামাজের মূল বিষয়গুলোকে তাড়াহুড়ায় ফেলবে না।',
            ),
          ),
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Pray four rak\'ahs', 'চার রাকাত পড়ুন'),
            body: _LocalizedText(
              'Many guides teach it as four rak\'ahs, either together or in pairs according to learned practice.',
              'অনেক গাইডে এটি চার রাকাত হিসেবে শেখানো হয়, শেখা পদ্ধতি অনুযায়ী একসঙ্গে বা দুই রাকাত করে।',
            ),
          ),
        ],
      ),
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('Tasbih formula', 'তাসবিহের বাক্য'),
        body: _LocalizedText(
          'This phrase is repeated throughout the rak\'ah. Learn it first so the count does not distract from meaning.',
          'এই বাক্যটি পুরো রাকাতে বারবার পড়া হয়। আগে এটি শিখুন, যেন গণনা অর্থ থেকে মন সরিয়ে না নেয়।',
        ),
        comment: _LocalizedText(
          'Use the formula gently and clearly. A small counter can help, but the prayer should remain calm.',
          'বাক্যটি নরম ও পরিষ্কারভাবে পড়ুন। ছোট কাউন্টার সাহায্য করতে পারে, তবে নামাজ শান্ত থাকা জরুরি।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('Formula', 'বাক্য'),
            title: _LocalizedText('The repeated tasbih', 'বারবার পড়া তাসবিহ'),
            body: _LocalizedText(
              'Repeat this phrase in the counted places of each rak\'ah.',
              'প্রতি রাকাতের নির্ধারিত গণনার জায়গাগুলোতে এই বাক্যটি পড়ুন।',
            ),
            arabic:
                'سُبْحَانَ اللّٰهِ وَالْحَمْدُ لِلّٰهِ وَلَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ',
            pronunciation: _LocalizedText(
              'Subhanallahi wal hamdu lillahi wa la ilaha illallahu wallahu akbar',
              'সুবহানাল্লাহি ওয়াল হামদু লিল্লাহি ওয়া লা ইলাহা ইল্লাল্লাহু ওয়াল্লাহু আকবার',
            ),
            translation: _LocalizedText(
              'Glory be to Allah, all praise is for Allah, there is no god but Allah, and Allah is the Greatest.',
              'আল্লাহ পবিত্র, সমস্ত প্রশংসা আল্লাহর জন্য, আল্লাহ ছাড়া কোনো উপাস্য নেই, এবং আল্লাহ সর্বশ্রেষ্ঠ।',
            ),
          ),
        ],
      ),
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('One-rak\'ah rhythm', 'এক রাকাতের ছন্দ'),
        body: _LocalizedText(
          'A common teaching places 75 tasbih in each rak\'ah through seven counted moments.',
          'একটি প্রচলিত শিক্ষায় প্রতি রাকাতে সাতটি গণনার স্থানে ৭৫টি তাসবিহ রাখা হয়।',
        ),
        comment: _LocalizedText(
          'Say the normal posture adhkar first, then add the tasbih count for that posture.',
          'প্রথমে অঙ্গভঙ্গির স্বাভাবিক জিকির পড়ুন, তারপর সেই অবস্থানের তাসবিহ গণনা যোগ করুন।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('15', '১৫'),
            title: _LocalizedText('After recitation', 'তিলাওয়াতের পরে'),
            body: _LocalizedText(
              'After Al-Fatihah and a surah, recite the tasbih 15 times while standing.',
              'সূরা ফাতিহা ও একটি সূরার পর দাঁড়িয়ে ১৫ বার তাসবিহ পড়ুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('10', '১০'),
            title: _LocalizedText('In ruku', 'রুকুতে'),
            body: _LocalizedText(
              'After the regular ruku glorification, recite the tasbih 10 times.',
              'রুকুর নিয়মিত তাসবিহের পর ১০ বার এই তাসবিহ পড়ুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('10', '১০'),
            title: _LocalizedText('After rising', 'রুকু থেকে উঠে'),
            body: _LocalizedText(
              'Stand fully after ruku, then recite the tasbih 10 times.',
              'রুকু থেকে পুরোপুরি দাঁড়িয়ে ১০ বার তাসবিহ পড়ুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('10', '১০'),
            title: _LocalizedText('First sujood', 'প্রথম সিজদা'),
            body: _LocalizedText(
              'After the regular sujood glorification, recite the tasbih 10 times.',
              'সিজদার নিয়মিত তাসবিহের পর ১০ বার এই তাসবিহ পড়ুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('10', '১০'),
            title: _LocalizedText('Between sujoods', 'দুই সিজদার মাঝে'),
            body: _LocalizedText(
              'Sit calmly between the two sujoods and recite the tasbih 10 times.',
              'দুই সিজদার মাঝে শান্তভাবে বসে ১০ বার তাসবিহ পড়ুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('10', '১০'),
            title: _LocalizedText('Second sujood', 'দ্বিতীয় সিজদা'),
            body: _LocalizedText(
              'After the regular sujood glorification, recite the tasbih 10 times again.',
              'সিজদার নিয়মিত তাসবিহের পর আবার ১০ বার এই তাসবিহ পড়ুন।',
            ),
          ),
          _SpecialPrayerPointSeed(
            badge: _LocalizedText('10', '১০'),
            title: _LocalizedText(
              'Before standing or sitting',
              'দাঁড়ানো বা বসার আগে',
            ),
            body: _LocalizedText(
              'Before rising for the next rak\'ah, or before tashahhud, recite the tasbih 10 times.',
              'পরের রাকাতের জন্য ওঠার আগে, বা তাশাহহুদের আগে, ১০ বার তাসবিহ পড়ুন।',
            ),
          ),
        ],
      ),
      _SpecialPrayerSectionSeed(
        title: _LocalizedText('Complete the cycle', 'পুরো চক্র সম্পন্ন করুন'),
        body: _LocalizedText(
          'Repeat the 75-count rhythm in each rak\'ah until the four-rak\'ah prayer reaches 300.',
          'প্রতি রাকাতে ৭৫ গণনার ছন্দ পুনরাবৃত্তি করুন, যতক্ষণ চার রাকাতে ৩০০ পূর্ণ হয়।',
        ),
        comment: _LocalizedText(
          'If the count slips, continue calmly from the nearest sure count. Presence matters more than panic.',
          'গণনা ভুলে গেলে নিকটতম নিশ্চিত সংখ্যা থেকে শান্তভাবে চালিয়ে যান। আতঙ্কের চেয়ে মনোযোগ বেশি গুরুত্বপূর্ণ।',
        ),
        points: [
          _SpecialPrayerPointSeed(
            title: _LocalizedText('Protect the pillars', 'রুকনগুলো রক্ষা করুন'),
            body: _LocalizedText(
              'Do not let counting shorten qiyam, ruku, sujood, tashahhud, or salam.',
              'গণনার কারণে কিয়াম, রুকু, সিজদা, তাশাহহুদ বা সালাম ছোট করবেন না।',
            ),
          ),
          _SpecialPrayerPointSeed(
            title: _LocalizedText('End with humility', 'বিনয়ে শেষ করুন'),
            body: _LocalizedText(
              'After salam, ask Allah to accept the glorification and forgive shortcomings.',
              'সালামের পর আল্লাহর কাছে তাসবিহ কবুল করা এবং ত্রুটি ক্ষমার দু\'আ করুন।',
            ),
          ),
        ],
      ),
    ],
    hadithReferences: [
      _PrayerHadithSeed(
        source: _LocalizedText(
          'Sunan Abi Dawud 1297; Jami\' at-Tirmidhi 481',
          'সুনান আবি দাউদ ১২৯৭; জামে আত-তিরমিজি ৪৮১',
        ),
        body: _LocalizedText(
          'The tasbih prayer is reported in narrations that teach this repeated formula through the postures.',
          'অঙ্গভঙ্গির মধ্যে এই পুনরাবৃত্ত তাসবিহ শেখানো হয়েছে এমন বর্ণনায় সালাতুত তাসবিহ এসেছে।',
        ),
      ),
      _PrayerHadithSeed(
        source: _LocalizedText('Scholarly grading note', 'আলেমদের তাহকিক নোট'),
        body: _LocalizedText(
          'Hadith specialists differ on the report\'s strength; some recommend the prayer, while others do not establish it.',
          'হাদিসের মান নিয়ে মুহাদ্দিসদের মতভেদ আছে; কেউ আমলের পরামর্শ দেন, আবার কেউ তা প্রতিষ্ঠিত মনে করেন না।',
        ),
      ),
    ],
  );
}

class _LocalizedText {
  const _LocalizedText(this.english, this.bangla);

  final String english;
  final String bangla;

  String resolve(bool isBangla) => isBangla ? bangla : english;
}

class _SpecialPrayerSeed {
  const _SpecialPrayerSeed({
    required this.type,
    required this.title,
    required this.heroEyebrow,
    required this.heroArabic,
    required this.heroBody,
    required this.heroBadge,
    required this.quickFactsTitle,
    required this.quickFactsSubtitle,
    required this.guideTitle,
    required this.guideSubtitle,
    required this.sectionCommentLabel,
    required this.hadithTitle,
    required this.hadithSubtitle,
    required this.note,
    required this.facts,
    required this.sections,
    required this.hadithReferences,
  });

  final SpecialPrayerType type;
  final _LocalizedText title;
  final _LocalizedText heroEyebrow;
  final String heroArabic;
  final _LocalizedText heroBody;
  final _LocalizedText heroBadge;
  final _LocalizedText quickFactsTitle;
  final _LocalizedText quickFactsSubtitle;
  final _LocalizedText guideTitle;
  final _LocalizedText guideSubtitle;
  final _LocalizedText sectionCommentLabel;
  final _LocalizedText hadithTitle;
  final _LocalizedText hadithSubtitle;
  final _PrayerGuidanceSeed note;
  final List<_SpecialPrayerFactSeed> facts;
  final List<_SpecialPrayerSectionSeed> sections;
  final List<_PrayerHadithSeed> hadithReferences;

  SpecialPrayerContent resolve(bool isBangla) {
    return SpecialPrayerContent(
      type: type,
      title: title.resolve(isBangla),
      heroEyebrow: heroEyebrow.resolve(isBangla),
      heroArabic: heroArabic,
      heroBody: heroBody.resolve(isBangla),
      heroBadge: heroBadge.resolve(isBangla),
      quickFactsTitle: quickFactsTitle.resolve(isBangla),
      quickFactsSubtitle: quickFactsSubtitle.resolve(isBangla),
      guideTitle: guideTitle.resolve(isBangla),
      guideSubtitle: guideSubtitle.resolve(isBangla),
      sectionCommentLabel: sectionCommentLabel.resolve(isBangla),
      hadithTitle: hadithTitle.resolve(isBangla),
      hadithSubtitle: hadithSubtitle.resolve(isBangla),
      note: note.resolve(isBangla),
      facts: facts
          .map((fact) => fact.resolve(isBangla))
          .toList(growable: false),
      sections: sections
          .map((section) => section.resolve(isBangla))
          .toList(growable: false),
      hadithReferences: hadithReferences
          .map((hadith) => hadith.resolve(isBangla))
          .toList(growable: false),
    );
  }
}

class _PrayerGuidanceSeed {
  const _PrayerGuidanceSeed({required this.title, required this.body});

  final _LocalizedText title;
  final _LocalizedText body;

  PrayerGuidanceItem resolve(bool isBangla) {
    return PrayerGuidanceItem(
      title: title.resolve(isBangla),
      body: body.resolve(isBangla),
    );
  }
}

class _SpecialPrayerFactSeed {
  const _SpecialPrayerFactSeed({
    required this.label,
    required this.value,
    required this.detail,
  });

  final _LocalizedText label;
  final _LocalizedText value;
  final _LocalizedText detail;

  SpecialPrayerFact resolve(bool isBangla) {
    return SpecialPrayerFact(
      label: label.resolve(isBangla),
      value: value.resolve(isBangla),
      detail: detail.resolve(isBangla),
    );
  }
}

class _SpecialPrayerSectionSeed {
  const _SpecialPrayerSectionSeed({
    required this.title,
    required this.body,
    required this.comment,
    required this.points,
  });

  final _LocalizedText title;
  final _LocalizedText body;
  final _LocalizedText comment;
  final List<_SpecialPrayerPointSeed> points;

  SpecialPrayerSection resolve(bool isBangla) {
    return SpecialPrayerSection(
      title: title.resolve(isBangla),
      body: body.resolve(isBangla),
      comment: comment.resolve(isBangla),
      points: points
          .map((point) => point.resolve(isBangla))
          .toList(growable: false),
    );
  }
}

class _SpecialPrayerPointSeed {
  const _SpecialPrayerPointSeed({
    required this.title,
    required this.body,
    this.badge,
    this.arabic,
    this.pronunciation,
    this.translation,
  });

  final _LocalizedText title;
  final _LocalizedText body;
  final _LocalizedText? badge;
  final String? arabic;
  final _LocalizedText? pronunciation;
  final _LocalizedText? translation;

  SpecialPrayerPoint resolve(bool isBangla) {
    return SpecialPrayerPoint(
      title: title.resolve(isBangla),
      body: body.resolve(isBangla),
      badge: badge?.resolve(isBangla),
      arabic: arabic,
      pronunciation: pronunciation?.resolve(isBangla),
      translation: translation?.resolve(isBangla),
    );
  }
}

class _PrayerHadithSeed {
  const _PrayerHadithSeed({required this.source, required this.body});

  final _LocalizedText source;
  final _LocalizedText body;

  PrayerHadithReference resolve(bool isBangla) {
    return PrayerHadithReference(
      source: source.resolve(isBangla),
      body: body.resolve(isBangla),
    );
  }
}
