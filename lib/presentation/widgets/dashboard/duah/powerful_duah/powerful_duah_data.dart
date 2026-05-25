import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';

enum DuahSituation {
  all,
  distress,
  forgiveness,
  guidance,
  provision,
  protection,
  family,
  knowledge,
}

class PowerfulDuah {
  const PowerfulDuah({
    required this.number,
    required this.title,
    this.titleBn,
    required this.arabic,
    required this.pronunciation,
    required this.translation,
    this.pronunciationBn,
    this.translationBn,
    required this.situations,
    this.source,
    this.isFeatured = false,
  });

  final int number;
  final String title;
  final String? titleBn;
  final String arabic;
  final String pronunciation;
  final String translation;
  final String? pronunciationBn;
  final String? translationBn;
  final List<DuahSituation> situations;
  final String? source;
  final bool isFeatured; // top-5 "start with these" picks

  bool _isBangla(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'bn';

  String localizedPronunciation(BuildContext context) =>
      _isBangla(context) ? (pronunciationBn ?? pronunciation) : pronunciation;

  String localizedTranslation(BuildContext context) =>
      _isBangla(context) ? (translationBn ?? translation) : translation;

  String localizedTitle(BuildContext context) =>
      _isBangla(context) ? (titleBn ?? title) : title;
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

class PowerfulDuahData {
  static const List<PowerfulDuah> all = [
    PowerfulDuah(
      number: 1,
      title: 'Goodness in this life and the next',
      titleBn: 'দুনিয়া ও আখিরাতের কল্যাণ',
      arabic:
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      pronunciation:
          'Rabbanā ātinā fid-dunyā ḥasanah wa fil-ākhirati ḥasanah wa qinā ʿadhāban-nār',
      pronunciationBn:
          'রব্বানা আতিনা ফিদ-দুনইয়া হাসানাহ, ওয়া ফিল-আখিরাতি হাসানাহ, ওয়া কিনা আযাবান-নার',
      translation:
          'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
      translationBn:
          'হে আমাদের প্রতিপালক, আমাদেরকে দুনিয়াতে কল্যাণ দিন, আখিরাতে কল্যাণ দিন এবং আগুনের শাস্তি থেকে রক্ষা করুন।',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Qur\'an 2:201',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 2,
      title: 'Forgiveness of all sins',
      titleBn: 'সমস্ত গুনাহর ক্ষমা',
      arabic:
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      pronunciation:
          'Rabbi-ghfir lī wa tub ʿalayya innaka antat-Tawwābur-Raḥīm',
      pronunciationBn:
          'রব্বিগফির লি ওয়া তুব আলাইয়া, ইন্নাকা আনতাত-তাওয়াবুর রাহিম',
      translation:
          'My Lord, forgive me and accept my repentance. Indeed, You are the Acceptor of repentance, the Most Merciful.',
      translationBn:
          'হে আমার রব, আমাকে ক্ষমা করুন এবং আমার তাওবা কবুল করুন। নিশ্চয়ই আপনি তাওবা কবুলকারী, পরম দয়ালু।',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Hadith — Abu Dawud',
    ),
    PowerfulDuah(
      number: 3,
      title: 'Relief from anxiety & grief',
      titleBn: 'দুশ্চিন্তা ও শোক থেকে মুক্তি',
      arabic:
          'اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ، سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي',
      pronunciation:
          'Allāhumma innī ʿabduka, ibnu ʿabdika, ibnu amatika, nāṣiyatī biyadika, māḍin fiyya ḥukmuka, ʿadlun fiyya qaḍā\'uka... an tajʿalal-Qur\'āna rabīʿa qalbī, wa nūra ṣadrī, wa jalā\'a ḥuznī, wa dhahāba hammī',
      pronunciationBn:
          'আল্লাহুম্মা ইন্নি আবদুকা... আন তাজআলাল কুরআনা রাবিআ কালবি, ওয়া নুরা সাদরি, ওয়া জালাআ হুজনি, ওয়া যাহাবা হাম্মি',
      translation:
          'O Allah, I am Your servant, son of Your servant, son of Your maidservant. My forelock is in Your hand... make the Qur\'an the spring of my heart, the light of my chest, the remover of my sadness, and the reliever of my distress.',
      translationBn:
          'হে আল্লাহ, আমি আপনার বান্দা... কুরআনকে আমার হৃদয়ের বসন্ত, অন্তরের আলো, দুঃখের অপসারণকারী এবং চিন্তার মুক্তিদাতা বানিয়ে দিন।',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Hadith — Ahmad',
    ),
    PowerfulDuah(
      number: 4,
      title: 'Relief from debt & poverty',
      titleBn: 'ঋণ ও দারিদ্র্য থেকে মুক্তি',
      arabic:
          'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      pronunciation:
          'Allāhumma-kfinī biḥalālika ʿan ḥarāmika wa aghninī bifaḍlika ʿamman siwāk',
      pronunciationBn:
          'আল্লাহুম্মাকফিনি বিহালালিকা আন হারামিকা, ওয়া আগনিনি বিফাদলিকা আম্মান সিওয়াক',
      translation:
          'O Allah, suffice me with what You have made lawful instead of what You have made unlawful, and make me independent by Your bounty from needing anyone besides You.',
      translationBn:
          'হে আল্লাহ, আপনার হালাল দ্বারা আমাকে হারাম থেকে বাঁচিয়ে দিন এবং আপনার অনুগ্রহে আমাকে আপনার ছাড়া অন্য কারো মুখাপেক্ষীহীন করুন।',
      situations: [DuahSituation.all, DuahSituation.provision],
      source: 'Hadith — Tirmidhi',
    ),
    PowerfulDuah(
      number: 5,
      title: 'Increase in knowledge & wisdom',
      titleBn: 'জ্ঞান ও প্রজ্ঞা বৃদ্ধি',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      pronunciation: 'Rabbi zidnī ʿilmā',
      pronunciationBn: 'রব্বি যিদনি ইলমা',
      translation: 'My Lord, increase me in knowledge.',
      translationBn: 'হে আমার রব, আমাকে জ্ঞানে বৃদ্ধি দিন।',
      situations: [DuahSituation.all, DuahSituation.knowledge],
      source: 'Qur\'an 20:114',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 6,
      title: 'Steadfastness of the heart',
      titleBn: 'হৃদয়ের দৃঢ়তা',
      arabic: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
      pronunciation: 'Yā Muqallibal-qulūb, thabbit qalbī ʿalā dīnik',
      pronunciationBn: 'ইয়া মুকাল্লিবাল-কুলুব, সাব্বিত কালবি আলা দিনিক',
      translation:
          'O Turner of the hearts, keep my heart firm upon Your religion.',
      translationBn:
          'হে হৃদয়সমূহের পরিবর্তনকারী, আমার হৃদয়কে আপনার দ্বীনের ওপর স্থির রাখুন।',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Hadith — Tirmidhi',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 7,
      title: 'Guidance and righteousness',
      titleBn: 'হিদায়াত ও সঠিকতা',
      arabic: 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      pronunciation: 'Allāhumma-hdinī wa saddidnī',
      pronunciationBn: 'আল্লাহুম্মাহদিনি ওয়া সাদ্দিদনি',
      translation: 'O Allah, guide me and keep me firm and correct.',
      translationBn: 'হে আল্লাহ, আমাকে হিদায়াত দিন এবং সঠিক পথে অটল রাখুন।',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Hadith — Muslim',
    ),
    PowerfulDuah(
      number: 8,
      title: 'Protection from worry & laziness',
      titleBn: 'দুশ্চিন্তা ও অলসতা থেকে হিফাজত',
      arabic:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الهَمِّ وَالحَزَنِ، وَالعَجْزِ وَالكَسَلِ، وَالجُبْنِ وَالبُخْلِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      pronunciation:
          'Allāhumma innī aʿūdhu bika minal-hammi wal-ḥazan, wal-ʿajzi wal-kasal, wal-jubni wal-bukhl, wa ḍalaʿid-dayni wa ghalabatir-rijāl',
      pronunciationBn:
          'আল্লাহুম্মা ইন্নি আউযু বিকা মিনাল হাম্মি ওয়াল হাযান, ওয়াল আজজি ওয়াল কাসাল... ওয়া গালাবাতির রিজাল',
      translation:
          'O Allah, I seek refuge in You from worry and grief, weakness and laziness, cowardice and stinginess, the burden of debt, and being overpowered by people.',
      translationBn:
          'হে আল্লাহ, আমি আপনার কাছে আশ্রয় চাই দুশ্চিন্তা ও দুঃখ, অক্ষমতা ও অলসতা, কাপুরুষতা ও কৃপণতা, ঋণের বোঝা এবং মানুষের প্রভাবাধীন হওয়া থেকে।',
      situations: [
        DuahSituation.all,
        DuahSituation.distress,
        DuahSituation.protection,
      ],
      source: 'Hadith — Bukhari',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 9,
      title: 'Acceptance of good deeds',
      titleBn: 'সৎ আমল কবুল হওয়া',
      arabic: 'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ العَلِيمُ',
      pronunciation: 'Rabbanā taqabbal minnā innaka Antas-Samīʿul-ʿAlīm',
      pronunciationBn: 'রব্বানা তাকাব্বাল মিননা ইন্নাকা আনতাস সামিউল আলিম',
      translation:
          'Our Lord, accept from us. Indeed, You are the All-Hearing, the All-Knowing.',
      translationBn:
          'হে আমাদের রব, আমাদের থেকে কবুল করুন। নিশ্চয়ই আপনি সর্বশ্রোতা, সর্বজ্ঞ।',
      situations: [DuahSituation.all],
      source: 'Qur\'an 2:127',
    ),
    PowerfulDuah(
      number: 10,
      title: 'Mercy and right guidance',
      titleBn: 'রহমত ও সঠিক হিদায়াত',
      arabic:
          'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً ۚ إِنَّكَ أَنْتَ الْوَهَّابُ',
      pronunciation:
          'Rabbanā lā tuzigh qulūbanā baʿda idh hadaytanā wa hab lanā min ladunka raḥmah, innaka antal-Wahhāb',
      pronunciationBn:
          'রব্বানা লা তুযিগ কুলুবানা বাদা ইয হাদাইতানা, ওয়া হাব লানা মিল্লাদুনকা রাহমাহ, ইন্নাকা আনতাল ওয়াহহাব',
      translation:
          'Our Lord, do not let our hearts deviate after You have guided us, and grant us mercy from Yourself. Indeed, You are the Bestower.',
      translationBn:
          'হে আমাদের রব, আপনি হিদায়াত দেওয়ার পর আমাদের অন্তরকে বক্র করবেন না এবং আপনার পক্ষ থেকে আমাদের রহমত দান করুন। নিশ্চয়ই আপনি মহাদাতা।',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Qur\'an 3:8',
    ),
    PowerfulDuah(
      number: 11,
      title: 'Patience and a good ending',
      titleBn: 'ধৈর্য ও উত্তম পরিণতি',
      arabic: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      pronunciation: 'Rabbanā afrigh ʿalaynā ṣabran wa tawaffanā muslimīn',
      pronunciationBn: 'রব্বানা আফরিগ আলাইনা সাবরান ওয়া তাওয়াফফানা মুসলিমিন',
      translation: 'Our Lord, pour upon us patience and let us die as Muslims.',
      translationBn:
          'হে আমাদের রব, আমাদের উপর ধৈর্য বর্ষণ করুন এবং মুসলিম অবস্থায় আমাদের মৃত্যু দিন।',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Qur\'an 7:126',
    ),
    PowerfulDuah(
      number: 12,
      title: 'Righteous family & pure heart',
      titleBn: 'নেক পরিবার ও প্রশান্ত হৃদয়',
      arabic:
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      pronunciation:
          'Rabbanā hab lanā min azwājinā wa dhurriyyātinā qurrata aʿyunin wajʿalnā lil-muttaqīna imāmā',
      pronunciationBn:
          'রব্বানা হাব লানা মিন আযওয়াজিনা ওয়া যুররিয়্যাতিনা কুররাতা আইউনিন, ওয়াজআলনা লিল মুত্তাকিনা ইমামা',
      translation:
          'Our Lord, grant us from our spouses and children comfort to our eyes and make us leaders for the righteous.',
      translationBn:
          'হে আমাদের রব, আমাদের স্ত্রী-সন্তানদেরকে আমাদের চোখের শীতলতা দান করুন এবং আমাদেরকে মুত্তাকীদের নেতা বানান।',
      situations: [DuahSituation.all, DuahSituation.family],
      source: 'Qur\'an 25:74',
    ),
    PowerfulDuah(
      number: 13,
      title: 'Ease in difficult tasks',
      titleBn: 'কঠিন কাজে সহজতা',
      arabic:
          'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي ۝ وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي ۝ يَفْقَهُوا قَوْلِي',
      pronunciation:
          'Rabbi-shraḥ lī ṣadrī, wa yassir lī amrī, waḥlul ʿuqdatan min lisānī, yafqahū qawlī',
      pronunciationBn:
          'রব্বিশরাহলি সাদরি, ওয়া ইয়াসসিরলি আমরি, ওয়াহলুল উকদাতাম মিল্লিসানি, ইয়াফকাহু কাওলি',
      translation:
          'My Lord, expand for me my chest, ease for me my task, and untie the knot from my tongue so that they may understand my speech.',
      translationBn:
          'হে আমার রব, আমার বক্ষ প্রশস্ত করুন, আমার কাজ সহজ করুন এবং আমার জিহ্বার জড়তা দূর করুন যাতে তারা আমার কথা বুঝতে পারে।',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Qur\'an 20:25–28',
    ),
    PowerfulDuah(
      number: 14,
      title: 'Protection from all evil',
      titleBn: 'সব অকল্যাণ থেকে হিফাজত',
      arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الوَكِيلُ',
      pronunciation: 'Ḥasbunallāhu wa niʿmal-wakīl',
      pronunciationBn: 'হাসবুনাল্লাহু ওয়া নিইমাল ওয়াকিল',
      translation:
          'Allah is sufficient for us, and He is the best disposer of affairs.',
      translationBn:
          'আল্লাহই আমাদের জন্য যথেষ্ট, আর তিনিই সর্বোত্তম কর্মবিধায়ক।',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Qur\'an 3:173',
    ),
    PowerfulDuah(
      number: 15,
      title: 'Du\'ā of Yunus ﷺ',
      titleBn: 'ইউনুস (আ.)-এর দু\'আ',
      arabic:
          'لَا إِلٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      pronunciation: 'Lā ilāha illā anta subḥānaka innī kuntu minaẓ-ẓālimīn',
      pronunciationBn:
          'লা ইলাহা ইল্লা আনতা সুবহানাকা ইন্নি কুনতু মিনায-যালিমিন',
      translation:
          'There is no god except You. Glory be to You. Indeed, I was among the wrongdoers.',
      translationBn:
          'আপনি ছাড়া কোনো ইলাহ নেই। আপনি পবিত্র। নিশ্চয়ই আমি জালিমদের অন্তর্ভুক্ত ছিলাম।',
      situations: [
        DuahSituation.all,
        DuahSituation.distress,
        DuahSituation.forgiveness,
      ],
      source: 'Qur\'an 21:87',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 16,
      title: 'Sayyidul Istigḥfār',
      titleBn: 'সাইয়্যিদুল ইস্তিগফার',
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      pronunciation:
          'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa anā ʿabduka, wa anā ʿalā ʿahdika wa waʿdika mastaṭaʿtu... faghfir lī fa innahu lā yaghfirudh-dhunūba illā anta',
      pronunciationBn:
          'আল্লাহুম্মা আনতা রব্বি... ফাগফিরলি, ফাইন্নাহু লা ইয়াগফিরুয যুনুবা ইল্লা আনতা',
      translation:
          'O Allah, You are my Lord. There is no god except You. You created me and I am Your servant... so forgive me, for none forgives sins except You.',
      translationBn:
          'হে আল্লাহ, আপনি আমার রব। আপনি ছাড়া কোনো ইলাহ নেই। আপনি আমাকে সৃষ্টি করেছেন, আমি আপনার বান্দা... অতএব আমাকে ক্ষমা করুন, কারণ আপনি ছাড়া কেউ গুনাহ ক্ষমা করতে পারে না।',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Hadith — Bukhari',
    ),
  ];

  static List<PowerfulDuah> filtered(DuahSituation situation) {
    if (situation == DuahSituation.all) return all;
    return all.where((d) => d.situations.contains(situation)).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SITUATION META
// ─────────────────────────────────────────────────────────────────────────────

extension SituationMeta on DuahSituation {
  String label(BuildContext context) {
    switch (this) {
      case DuahSituation.all:
        return context.l10n.duahSituationAll;
      case DuahSituation.distress:
        return context.l10n.duahSituationDistress;
      case DuahSituation.forgiveness:
        return context.l10n.duahSituationForgiveness;
      case DuahSituation.guidance:
        return context.l10n.duahSituationGuidance;
      case DuahSituation.provision:
        return context.l10n.duahSituationProvision;
      case DuahSituation.protection:
        return context.l10n.duahSituationProtection;
      case DuahSituation.family:
        return context.l10n.duahSituationFamily;
      case DuahSituation.knowledge:
        return context.l10n.duahSituationKnowledge;
    }
  }

  IconData get icon {
    switch (this) {
      case DuahSituation.all:
        return Icons.apps_rounded;
      case DuahSituation.distress:
        return Icons.favorite_border_rounded;
      case DuahSituation.forgiveness:
        return Icons.wb_sunny_rounded;
      case DuahSituation.guidance:
        return Icons.explore_rounded;
      case DuahSituation.provision:
        return Icons.spa_rounded;
      case DuahSituation.protection:
        return Icons.shield_rounded;
      case DuahSituation.family:
        return Icons.people_rounded;
      case DuahSituation.knowledge:
        return Icons.auto_stories_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DuahSituation.all:
        return const Color(0xFF4B30A1);
      case DuahSituation.distress:
        return const Color(0xFFD50057);
      case DuahSituation.forgiveness:
        return const Color(0xFF00BFA5);
      case DuahSituation.guidance:
        return const Color(0xFF4B30A1);
      case DuahSituation.provision:
        return const Color(0xFF00897B);
      case DuahSituation.protection:
        return const Color(0xFF8E0033);
      case DuahSituation.family:
        return const Color(0xFFFF4081);
      case DuahSituation.knowledge:
        return const Color(0xFF448AFF);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────
