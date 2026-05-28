import 'package:flutter/foundation.dart';
import 'package:quran_for_all/core/theme/my_images.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';

class PrayerMovementGuideViewModel extends ChangeNotifier {
  List<PrayerMovementStep> steps(AppLocalizations l10n) {
    final isBangla = _isBangla(l10n);

    return _steps
        .map((step) {
          return PrayerMovementStep(
            number: step.number,
            title: _pick(isBangla, step.title, step.titleBn),
            badge: _pick(isBangla, step.badge, step.badgeBn),
            body: _pick(isBangla, step.body, step.bodyBn),
            imageAsset: step.imageAsset,
            arabic: step.arabic,
            pronunciation: _pick(
              isBangla,
              step.pronunciation,
              step.pronunciationBn,
            ),
            translation: _pick(isBangla, step.translation, step.translationBn),
            note: _pick(isBangla, step.note, step.noteBn),
          );
        })
        .toList(growable: false);
  }

  List<PrayerHadithReference> hadiths(AppLocalizations l10n) {
    final isBangla = _isBangla(l10n);

    return _hadiths
        .map((hadith) {
          return PrayerHadithReference(
            source: hadith.source,
            body: _pick(isBangla, hadith.body, hadith.bodyBn),
          );
        })
        .toList(growable: false);
  }

  bool _isBangla(AppLocalizations l10n) => l10n.localeName.startsWith('bn');

  String _pick(bool isBangla, String english, String bangla) {
    return isBangla ? bangla : english;
  }

  static const List<_PrayerMovementSeed> _steps = [
    _PrayerMovementSeed(
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
    _PrayerMovementSeed(
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
          'الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ\n'
          'الرَّحْمٰنِ الرَّحِيمِ\n'
          'مَالِكِ يَوْمِ الدِّينِ\n'
          'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n'
          'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\n'
          'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ\n'
          'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
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
    _PrayerMovementSeed(
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
    _PrayerMovementSeed(
      number: 4,
      title: 'Rise From Ruku',
      titleBn: 'রুকু থেকে ওঠা',
      badge: 'Stand',
      badgeBn: 'দাঁড়ান',
      body:
          'Return upright before going down to sujood. Let the body fully settle.',
      bodyBn:
          'সিজদায় যাওয়ার আগে সোজা হয়ে দাঁড়ান। শরীরকে পুরোপুরি স্থির হতে দিন।',
      imageAsset: MyImages.qiyam,
      arabic: 'سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ\nرَبَّنَا وَلَكَ الْحَمْدُ',
      pronunciation: 'Sami Allahu liman hamidah. Rabbana wa lakal hamd.',
      pronunciationBn: 'সামিআল্লাহু লিমান হামিদাহ। রব্বানা ওয়া লাকাল হামদ।',
      translation:
          'Allah hears the one who praises Him. Our Lord, to You belongs all praise.',
      translationBn:
          'যে আল্লাহর প্রশংসা করে, আল্লাহ তার কথা শোনেন। হে আমাদের রব, সমস্ত প্রশংসা আপনারই।',
      note:
          'If praying behind an imam, follow the wording you have been taught.',
      noteBn: 'ইমামের পেছনে পড়লে আপনার শেখা পদ্ধতি অনুযায়ী পড়ুন।',
    ),
    _PrayerMovementSeed(
      number: 5,
      title: 'Sujood',
      titleBn: 'সিজদা',
      badge: 'Nearest',
      badgeBn: 'নিকটতম',
      body:
          'Go down with humility and place the forehead, nose, hands, knees, and toes with care.',
      bodyBn:
          'বিনয়ের সঙ্গে সিজদায় যান এবং কপাল, নাক, হাত, হাঁটু ও পায়ের আঙুল যত্নসহ রাখুন।',
      imageAsset: MyImages.sajjadah,
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      pronunciation: 'Subhana Rabbiyal Aala',
      pronunciationBn: 'সুবহানা রাব্বিয়াল আ’লা',
      translation: 'Glory be to my Lord, the Most High.',
      translationBn: 'সর্বোচ্চ আমার রব পবিত্র।',
      note:
          'This is a special place for dua. Keep the fard prayer wording dignified and focused.',
      noteBn:
          'এটি দু’আর বিশেষ স্থান। ফরজ নামাজে শব্দচয়ন মর্যাদাপূর্ণ ও মনোযোগী রাখুন।',
    ),
    _PrayerMovementSeed(
      number: 6,
      title: 'Sitting Between Sujoods',
      titleBn: 'দুই সিজদার মাঝের বৈঠক',
      badge: 'Pause',
      badgeBn: 'বিরতি',
      body:
          'Sit briefly and calmly before the second sujood. Do not bounce between postures.',
      bodyBn:
          'দ্বিতীয় সিজদার আগে অল্প সময় শান্তভাবে বসুন। অঙ্গভঙ্গির মাঝে লাফিয়ে যাবেন না।',
      imageAsset: MyImages.tashahhud,
      arabic: 'رَبِّ اغْفِرْ لِي',
      pronunciation: 'Rabbighfir li',
      pronunciationBn: 'রব্বিগফির লি',
      translation: 'My Lord, forgive me.',
      translationBn: 'হে আমার রব, আমাকে ক্ষমা করুন।',
      note: 'Then complete the second sujood with the same calm presence.',
      noteBn: 'এরপর একই শান্ত মনোযোগে দ্বিতীয় সিজদা সম্পন্ন করুন।',
    ),
    _PrayerMovementSeed(
      number: 7,
      title: 'Tashahhud',
      titleBn: 'তাশাহহুদ',
      badge: 'Witness',
      badgeBn: 'সাক্ষ্য',
      body:
          'In the sitting, recite the testimony with reverence and raise the finger according to what you have learned.',
      bodyBn:
          'বৈঠকে শ্রদ্ধার সঙ্গে তাশাহহুদ পড়ুন এবং আপনার শেখা পদ্ধতি অনুযায়ী আঙুল উঠান।',
      imageAsset: MyImages.tashahhudFingerLift,
      arabic:
          'التَّحِيَّاتُ لِلّٰهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ\n'
          'السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ\n'
          'السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللّٰهِ الصَّالِحِينَ\n'
          'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ\n'
          'وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      pronunciation:
          "At-tahiyyatu lillahi was-salawatu wat-tayyibat. "
          "As-salamu 'alayka ayyuhan-nabiyyu wa rahmatullahi wa barakatuh. "
          "As-salamu 'alayna wa 'ala 'ibadillahis-salihin. "
          "Ashhadu an la ilaha illallah, wa ashhadu anna Muhammadan "
          "'abduhu wa rasuluh.",
      pronunciationBn:
          'আত্তাহিয়্যাতু লিল্লাহি ওয়াস-সালাওয়াতু ওয়াত-তাইয়্যিবাত। '
          'আসসালামু আলাইকা আইয়্যুহান নাবিয়্যু ওয়া রহমাতুল্লাহি ওয়া বারাকাতুহ। '
          'আসসালামু আলাইনা ওয়া আলা ইবাদিল্লাহিস সালিহিন। '
          'আশহাদু আল্লা ইলাহা ইল্লাল্লাহ, ওয়া আশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাসুলুহ।',
      translation:
          'All greetings, prayers, and pure words are for Allah. Peace be upon you, O Prophet, and the mercy and blessings of Allah. Peace be upon us and upon the righteous servants of Allah. I bear witness that there is no god but Allah, and I bear witness that Muhammad is His servant and messenger.',
      translationBn:
          'সব অভিবাদন, নামাজ ও পবিত্র বাক্য আল্লাহর জন্য। হে নবী, আপনার ওপর শান্তি, আল্লাহর রহমত ও বরকত বর্ষিত হোক। আমাদের ওপর এবং আল্লাহর নেক বান্দাদের ওপর শান্তি বর্ষিত হোক। আমি সাক্ষ্য দিচ্ছি আল্লাহ ছাড়া কোনো উপাস্য নেই, এবং মুহাম্মাদ তাঁর বান্দা ও রাসূল।',
      note:
          'In the final sitting, continue with salawat upon the Prophet, peace be upon him.',
      noteBn:
          'শেষ বৈঠকে এরপর নবীজির ওপর দরুদ পাঠ করুন, তাঁর ওপর শান্তি বর্ষিত হোক।',
    ),
    _PrayerMovementSeed(
      number: 8,
      title: 'Salawat',
      titleBn: 'দরুদ',
      badge: 'Final sitting',
      badgeBn: 'শেষ বৈঠক',
      body:
          'Before ending salah, send salawat upon the Prophet in the final sitting.',
      bodyBn: 'নামাজ শেষ করার আগে শেষ বৈঠকে নবীজির ওপর দরুদ পাঠ করুন।',
      imageAsset: MyImages.tashahhud,
      arabic:
          'اللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ\n'
          'كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ\n'
          'إِنَّكَ حَمِيدٌ مَجِيدٌ\n'
          'اللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ\n'
          'كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ\n'
          'إِنَّكَ حَمِيدٌ مَجِيدٌ',
      pronunciation:
          "Allahumma salli 'ala Muhammadin wa 'ala ali Muhammad, kama "
          "sallayta 'ala Ibrahima wa 'ala ali Ibrahim, innaka hamidun majid. "
          "Allahumma barik 'ala Muhammadin wa 'ala ali Muhammad, kama "
          "barakta 'ala Ibrahima wa 'ala ali Ibrahim, innaka hamidun majid.",
      pronunciationBn:
          'আল্লাহুম্মা সাল্লি আলা মুহাম্মাদিন ওয়া আলা আলে মুহাম্মাদ, কামা সাল্লাইতা আলা ইবরাহিমা ওয়া আলা আলে ইবরাহিম, ইন্নাকা হামিদুম মাজিদ। আল্লাহুম্মা বারিক আলা মুহাম্মাদিন ওয়া আলা আলে মুহাম্মাদ, কামা বারাকতা আলা ইবরাহিমা ওয়া আলা আলে ইবরাহিম, ইন্নাকা হামিদুম মাজিদ।',
      translation:
          'O Allah, send prayers upon Muhammad and the family of Muhammad, as You sent prayers upon Ibrahim and the family of Ibrahim. You are Praiseworthy, Glorious. O Allah, bless Muhammad and the family of Muhammad, as You blessed Ibrahim and the family of Ibrahim. You are Praiseworthy, Glorious.',
      translationBn:
          'হে আল্লাহ, মুহাম্মাদ ও তাঁর পরিবারের ওপর রহমত বর্ষণ করুন, যেমন আপনি ইবরাহিম ও তাঁর পরিবারের ওপর রহমত বর্ষণ করেছেন। নিশ্চয়ই আপনি প্রশংসিত, মহিমান্বিত। হে আল্লাহ, মুহাম্মাদ ও তাঁর পরিবারের ওপর বরকত দিন, যেমন আপনি ইবরাহিম ও তাঁর পরিবারের ওপর বরকত দিয়েছেন। নিশ্চয়ই আপনি প্রশংসিত, মহিমান্বিত।',
      note: 'You may make dua before salam, especially in the final sitting.',
      noteBn: 'সালামের আগে, বিশেষ করে শেষ বৈঠকে, আপনি দু’আ করতে পারেন।',
    ),
    _PrayerMovementSeed(
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
    _PrayerMovementSeed(
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
    _PrayerMovementSeed(
      number: 11,
      title: 'Post-Prayer Dhikr',
      titleBn: 'নামাজের পরের জিকির',
      badge: 'Remain',
      badgeBn: 'থাকুন',
      body: 'Remain seated briefly for forgiveness, dhikr, and personal dua.',
      bodyBn:
          'ক্ষমা প্রার্থনা, জিকির ও ব্যক্তিগত দু’আর জন্য অল্প সময় বসে থাকুন।',
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

  static const List<_PrayerMovementHadithSeed> _hadiths = [
    _PrayerMovementHadithSeed(
      source: 'Sahih al-Bukhari 631',
      body:
          'The Prophet taught his companions to pray by following his own prayer.',
      bodyBn: 'নবীজি তাঁর সাহাবিদের নিজের নামাজ অনুসরণ করে নামাজ শিখিয়েছেন।',
    ),
    _PrayerMovementHadithSeed(
      source: 'Sahih al-Bukhari 757; Sahih Muslim 397',
      body:
          'A companion was corrected until he prayed with calmness in each posture.',
      bodyBn:
          'এক সাহাবিকে প্রতিটি অঙ্গভঙ্গিতে স্থিরতা রেখে নামাজ পড়া পর্যন্ত সংশোধন করা হয়েছিল।',
    ),
    _PrayerMovementHadithSeed(
      source: 'Sahih Muslim 482',
      body:
          'Sujood is a moment of nearness to Allah, so it is a beautiful place for dua.',
      bodyBn:
          'সিজদা আল্লাহর নৈকট্যের মুহূর্ত, তাই এটি দু’আর জন্য সুন্দর স্থান।',
    ),
  ];
}

class _PrayerMovementSeed {
  const _PrayerMovementSeed({
    required this.number,
    required this.title,
    required this.titleBn,
    required this.badge,
    required this.badgeBn,
    required this.body,
    required this.bodyBn,
    required this.imageAsset,
    required this.arabic,
    required this.pronunciation,
    required this.pronunciationBn,
    required this.translation,
    required this.translationBn,
    required this.note,
    required this.noteBn,
  });

  final int number;
  final String title;
  final String titleBn;
  final String badge;
  final String badgeBn;
  final String body;
  final String bodyBn;
  final String imageAsset;
  final String arabic;
  final String pronunciation;
  final String pronunciationBn;
  final String translation;
  final String translationBn;
  final String note;
  final String noteBn;
}

class _PrayerMovementHadithSeed {
  const _PrayerMovementHadithSeed({
    required this.source,
    required this.body,
    required this.bodyBn,
  });

  final String source;
  final String body;
  final String bodyBn;
}
