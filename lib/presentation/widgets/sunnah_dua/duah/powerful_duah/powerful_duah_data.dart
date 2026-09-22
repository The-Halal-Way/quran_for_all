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
      source: 'Sunan Abi Dawud 1516; sahih (Al-Albani)',
    ),
    PowerfulDuah(
      number: 3,
      title: 'Relief from anxiety & grief',
      titleBn: 'দুশ্চিন্তা ও শোক থেকে মুক্তি',
      arabic:
          'اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ، سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي',
      pronunciation:
          'Allāhumma innī ʿabduka, ibnu ʿabdika, ibnu amatika, nāṣiyatī biyadika, māḍin fiyya ḥukmuka, ʿadlun fiyya qaḍāʾuka, asʾaluka bikulli ismin huwa laka, sammayta bihi nafsaka, aw anzaltahu fī kitābika, aw ʿallamtahu aḥadan min khalqika, aw istaʾtharta bihi fī ʿilmil-ghaybi ʿindaka, an tajʿalal-Qurʾāna rabīʿa qalbī, wa nūra ṣadrī, wa jalāʾa ḥuznī, wa dhahāba hammī',
      pronunciationBn:
          'আল্লাহুম্মা ইন্নি আবদুকা, ইবনু আবদিকা, ইবনু আমাতিকা, নাসিয়াতি বিয়াদিকা, মাদিন ফিয়্যা হুকমুকা, আদলুন ফিয়্যা কাদাউকা, আসআলুকা বিকুল্লি ইসমিন হুয়া লাকা, সাম্মাইতা বিহি নাফসাকা, আও আনযালতাহু ফি কিতাবিকা, আও আল্লামতাহু আহাদাম মিন খালকিকা, আও ইস্তাসারতা বিহি ফি ইলমিল গাইবি ইনদাকা, আন তাজআলাল কুরআনা রবিআ কালবি, ওয়া নুরা সদরি, ওয়া জালাআ হুযনি, ওয়া যাহাবা হাম্মি',
      translation:
          'O Allah, I am Your servant, the son of Your servant and Your female servant. My forelock is in Your hand. Your judgment over me takes effect, and Your decree concerning me is just. I ask You through every name belonging to You: those You have named Yourself with, revealed in Your Book, taught to any of Your creation, or kept with You in the knowledge of the unseen. Make the Quran bring life to my heart, light to my chest, an end to my sorrow, and relief from my worry.',
      translationBn:
          'হে আল্লাহ, আমি আপনার বান্দা, আপনার এক বান্দা ও এক বান্দির সন্তান। আমার কপালের চুল আপনার হাতে। আমার ওপর আপনার সিদ্ধান্ত কার্যকর, আর আমার ব্যাপারে আপনার ফয়সালা ন্যায়সঙ্গত। আপনার প্রতিটি নামের মাধ্যমে আপনার কাছে চাই—যে নাম আপনি নিজের জন্য রেখেছেন, আপনার কিতাবে নাযিল করেছেন, আপনার সৃষ্টির কাউকে শিখিয়েছেন অথবা আপনার অদৃশ্য জ্ঞানে নিজের কাছে রেখেছেন। কুরআনকে আমার হৃদয়ের সজীবতা, বক্ষের আলো, দুঃখের অবসান ও দুশ্চিন্তা থেকে মুক্তির কারণ করুন।',
      situations: [DuahSituation.all, DuahSituation.distress],
      source:
          'Musnad Ahmad 1/391; Hisn al-Muslim 120;',
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
      source: 'Jami at-Tirmidhi 3563; hasan (Darussalam)',
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
      source: 'Jami at-Tirmidhi 2140; hasan (at-Tirmidhi)',
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
      source: 'Sahih Muslim 2725a',
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
          'আল্লাহুম্মা ইন্নি আউযু বিকা মিনাল হাম্মি ওয়াল হাযানি, ওয়াল আজযি ওয়াল কাসালি, ওয়াল জুবনি ওয়াল বুখলি, ওয়া দালাইদ দাইনি ওয়া গালাবাতির রিজাল',
      translation:
          'O Allah, I seek refuge in You from worry and grief, weakness and laziness, cowardice and stinginess, the burden of debt, and being overpowered by people.',
      translationBn:
          'হে আল্লাহ, আমি আপনার কাছে আশ্রয় চাই দুশ্চিন্তা ও দুঃখ, অক্ষমতা ও অলসতা, কাপুরুষতা ও কৃপণতা, ঋণের বোঝা এবং মানুষের প্রভাবাধীন হওয়া থেকে।',
      situations: [
        DuahSituation.all,
        DuahSituation.distress,
        DuahSituation.protection,
      ],
      source: 'Sahih al-Bukhari 6369',
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
      title: 'A righteous family',
      titleBn: 'নেক পরিবারের দোয়া',
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
      situations: [
        DuahSituation.all,
        DuahSituation.distress,
        DuahSituation.knowledge,
      ],
      source: 'Qur\'an 20:25-28',
    ),
    PowerfulDuah(
      number: 14,
      title: 'Trust in Allah',
      titleBn: 'আল্লাহর ওপর ভরসা',
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
          'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa anā ʿabduka, wa anā ʿalā ʿahdika wa waʿdika mastaṭaʿtu, aʿūdhu bika min sharri mā ṣanaʿtu, abūʾu laka biniʿmatika ʿalayya, wa abūʾu bidhanbī, faghfir lī fa-innahu lā yaghfirudh-dhunūba illā anta',
      pronunciationBn:
          'আল্লাহুম্মা আনতা রব্বি লা ইলাহা ইল্লা আনতা, খালাকতানি ওয়া আনা আবদুকা, ওয়া আনা আলা আহদিকা ওয়া ওয়াদিকা মাসতাতাতু, আউযু বিকা মিন শাররি মা সানাতু, আবুউ লাকা বিনিমাতিকা আলাইয়্যা, ওয়া আবুউ বিযানবি, ফাগফির লি ফাইন্নাহু লা ইয়াগফিরুয যুনুবা ইল্লা আনতা',
      translation:
          'O Allah, You are my Lord; none is worthy of worship except You. You created me, and I am Your servant. I hold to my covenant and promise to You as far as I am able. I seek Your protection from the evil of my deeds. I acknowledge Your favour upon me and admit my sin. Forgive me, for only You forgive sins.',
      translationBn:
          'হে আল্লাহ, আপনি আমার রব; আপনি ছাড়া কোনো সত্য উপাস্য নেই। আপনি আমাকে সৃষ্টি করেছেন এবং আমি আপনার বান্দা। আমি সাধ্য অনুযায়ী আপনার সঙ্গে করা অঙ্গীকার ও প্রতিশ্রুতিতে অটল আছি। আমার কাজের অনিষ্ট থেকে আপনার আশ্রয় চাই। আমার ওপর আপনার অনুগ্রহ স্বীকার করছি এবং নিজের গুনাহ স্বীকার করছি। আমাকে ক্ষমা করুন, কারণ আপনি ছাড়া কেউ গুনাহ ক্ষমা করতে পারে না।',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Sahih al-Bukhari 6306',
    ),
    PowerfulDuah(
      number: 17,
      title: 'Mercy and a sound course',
      titleBn: 'রহমত ও সঠিক পথের দোয়া',
      arabic:
          'رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
      pronunciation:
          'Rabbanā ātinā min ladunka raḥmatan wa hayyiʾ lanā min amrinā rashadā',
      pronunciationBn:
          'রব্বানা আতিনা মিল লাদুনকা রাহমাতাও ওয়া হাইয়ি লানা মিন আমরিনা রাশাদা',
      translation:
          'Our Lord, grant us mercy from You and guide our affairs toward what is right.',
      translationBn:
          'হে আমাদের রব, আপনার পক্ষ থেকে আমাদের রহমত দিন এবং আমাদের কাজ সঠিক পথে পরিচালিত করুন।',
      situations: [
        DuahSituation.all,
        DuahSituation.knowledge,
        DuahSituation.guidance,
      ],
      source: 'Quran 18:10',
    ),
    PowerfulDuah(
      number: 18,
      title: 'Mercy for parents',
      titleBn: 'মা-বাবার জন্য রহমতের দোয়া',
      arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      pronunciation: 'Rabbirḥamhumā kamā rabbayānī ṣaghīrā',
      pronunciationBn: 'রব্বিরহামহুমা কামা রব্বাইয়ানি সগিরা',
      translation:
          'My Lord, show mercy to my parents, as they cared for me in childhood.',
      translationBn:
          'হে আমার রব, আমার মা-বাবার প্রতি দয়া করুন, যেমন তাঁরা ছোটবেলায় আমাকে লালন-পালন করেছেন।',
      situations: [DuahSituation.all, DuahSituation.family],
      source: 'Quran 17:24',
    ),
    PowerfulDuah(
      number: 19,
      title: 'Forgiveness for family and believers',
      titleBn: 'পরিবার ও মুমিনদের জন্য ক্ষমার দোয়া',
      arabic:
          'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
      pronunciation:
          'Rabbanaghfir lī wa liwālidayya wa lil-muʾminīna yawma yaqūmul-ḥisāb',
      pronunciationBn:
          'রব্বানাগফির লি ওয়া লিওয়ালিদাইয়্যা ওয়া লিল মুমিনিনা ইয়াওমা ইয়াকুমুল হিসাব',
      translation:
          'Our Lord, forgive me, my parents, and the believers when the Day of Reckoning comes.',
      translationBn:
          'হে আমাদের রব, হিসাবের দিনে আমাকে, আমার মা-বাবাকে এবং মুমিনদের ক্ষমা করুন।',
      situations: [DuahSituation.all, DuahSituation.family],
      source: 'Quran 14:41',
    ),
    PowerfulDuah(
      number: 20,
      title: 'Good offspring',
      titleBn: 'সৎ সন্তানের দোয়া',
      arabic:
          'رَبِّ هَبْ لِي مِنْ لَدُنْكَ ذُرِّيَّةً طَيِّبَةً إِنَّكَ سَمِيعُ الدُّعَاءِ',
      pronunciation:
          'Rabbi hab lī min ladunka dhurriyyatan ṭayyibatan innaka samīʿud-duʿāʾ',
      pronunciationBn:
          'রব্বি হাব লি মিল লাদুনকা যুররিয়্যাতান তাইয়িবাতান ইন্নাকা সামিউদ দুআ',
      translation:
          'My Lord, grant me good offspring from You. You surely hear every prayer.',
      translationBn:
          'হে আমার রব, আপনার পক্ষ থেকে আমাকে সৎ সন্তান দিন। নিশ্চয়ই আপনি দোয়া শোনেন।',
      situations: [DuahSituation.all, DuahSituation.family],
      source: 'Quran 3:38',
    ),
    PowerfulDuah(
      number: 21,
      title: 'Forgiveness and mercy',
      titleBn: 'ক্ষমা ও রহমতের দোয়া',
      arabic: 'رَبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِينَ',
      pronunciation: 'Rabbighfir warḥam wa anta khayrur-rāḥimīn',
      pronunciationBn: 'রব্বিগফির ওয়ারহাম ওয়া আনতা খাইরুর রাহিমিন',
      translation:
          'My Lord, forgive and show mercy; You are the best of those who show mercy.',
      translationBn:
          'হে আমার রব, ক্ষমা করুন ও দয়া করুন; দয়ালুদের মধ্যে আপনিই শ্রেষ্ঠ।',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Quran 23:118',
    ),
    PowerfulDuah(
      number: 22,
      title: 'Repentance of Adam and Hawwa',
      titleBn: 'আদম ও হাওয়া (আ.)-এর তাওবার দোয়া',
      arabic:
          'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
      pronunciation:
          'Rabbanā ẓalamnā anfusanā wa in lam taghfir lanā wa tarḥamnā lanakūnanna minal-khāsirīn',
      pronunciationBn:
          'রব্বানা যলামনা আনফুসানা ওয়া ইল লাম তাগফির লানা ওয়া তারহামনা লানাকুনান্না মিনাল খাসিরিন',
      translation:
          'Our Lord, we have wronged ourselves. Unless You forgive us and show us mercy, we will surely be among the losers.',
      translationBn:
          'হে আমাদের রব, আমরা নিজেদের প্রতি অন্যায় করেছি। আপনি আমাদের ক্ষমা না করলে ও দয়া না করলে আমরা অবশ্যই ক্ষতিগ্রস্ত হব।',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Quran 7:23',
    ),
    PowerfulDuah(
      number: 23,
      title: 'Hope for better guidance',
      titleBn: 'আরও সঠিক পথের আশা',
      arabic: 'عَسَى أَنْ يَهْدِيَنِ رَبِّي لِأَقْرَبَ مِنْ هَذَا رَشَدًا',
      pronunciation: 'ʿAsā an yahdiyani rabbī li-aqraba min hādhā rashadā',
      pronunciationBn: 'আসা আই ইয়াহদিয়ানি রব্বি লিআকরাবা মিন হাযা রাশাদা',
      translation:
          'I hope my Lord will guide me to a course nearer to what is right than this.',
      translationBn:
          'আশা করি আমার রব আমাকে এর চেয়েও সঠিক পথের কাছাকাছি পরিচালিত করবেন।',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Quran 18:24',
    ),
    PowerfulDuah(
      number: 24,
      title: 'In need of goodness',
      titleBn: 'কল্যাণের মুখাপেক্ষী বান্দার দোয়া',
      arabic: 'رَبِّ إِنِّي لِمَا أَنْزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ',
      pronunciation: 'Rabbi innī limā anzalta ilayya min khayrin faqīr',
      pronunciationBn: 'রব্বি ইন্নি লিমা আনযালতা ইলাইয়্যা মিন খাইরিন ফাকির',
      translation: 'My Lord, I am in need of whatever good You send to me.',
      translationBn:
          'হে আমার রব, আপনি আমার জন্য যে কল্যাণই পাঠান, আমি তার মুখাপেক্ষী।',
      situations: [DuahSituation.all, DuahSituation.provision],
      source: 'Quran 28:24',
    ),
    PowerfulDuah(
      number: 25,
      title: 'Consistency in prayer',
      titleBn: 'নিয়মিত সালাতের দোয়া',
      arabic:
          'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
      pronunciation:
          'Rabbijʿalnī muqīmaṣ-ṣalāti wa min dhurriyyatī rabbanā wa taqabbal duʿāʾ',
      pronunciationBn:
          'রব্বিজআলনি মুকিমাস সালাতি ওয়া মিন যুররিয়্যাতি রব্বানা ওয়া তাকাব্বাল দুআ',
      translation:
          'My Lord, make me someone who keeps up prayer, and also my descendants. Our Lord, accept my supplication.',
      translationBn:
          'হে আমার রব, আমাকে ও আমার সন্তানদের সালাত কায়েমকারী করুন। হে আমাদের রব, আমার দোয়া কবুল করুন।',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Quran 14:40',
    ),
    PowerfulDuah(
      number: 26,
      title: 'Patience and firm steps',
      titleBn: 'ধৈর্য ও অবিচলতার দোয়া',
      arabic: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا',
      pronunciation: 'Rabbanā afrigh ʿalaynā ṣabran wa thabbit aqdāmanā',
      pronunciationBn: 'রব্বানা আফরিগ আলাইনা সবরাও ওয়া সাব্বিত আকদামানা',
      translation: 'Our Lord, pour patience upon us and make our steps firm.',
      translationBn:
          'হে আমাদের রব, আমাদের প্রচুর ধৈর্য দিন এবং আমাদের পা অবিচল রাখুন।',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Quran 2:250',
    ),
    PowerfulDuah(
      number: 27,
      title: 'Refuge from evil promptings',
      titleBn: 'শয়তানের প্ররোচনা থেকে আশ্রয়',
      arabic:
          'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَعُوذُ بِكَ رَبِّ أَنْ يَحْضُرُونِ',
      pronunciation:
          'Rabbi aʿūdhu bika min hamazātish-shayāṭīn, wa aʿūdhu bika rabbi an yaḥḍurūn',
      pronunciationBn:
          'রব্বি আউযু বিকা মিন হামাযাতিশ শাইয়াতিন, ওয়া আউযু বিকা রব্বি আই ইয়াহদুরুন',
      translation:
          'My Lord, I seek Your protection from the promptings of devils, and I seek Your protection, my Lord, from their presence.',
      translationBn:
          'হে আমার রব, শয়তানদের প্ররোচনা থেকে আপনার আশ্রয় চাই এবং হে আমার রব, তাদের উপস্থিতি থেকেও আপনার আশ্রয় চাই।',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Quran 23:97-98',
    ),
    PowerfulDuah(
      number: 28,
      title: 'Safety from wrongdoing people',
      titleBn: 'অত্যাচারী লোকদের থেকে নিরাপত্তা',
      arabic: 'رَبِّ نَجِّنِي مِنَ الْقَوْمِ الظَّالِمِينَ',
      pronunciation: 'Rabbi najjinī minal-qawmiẓ-ẓālimīn',
      pronunciationBn: 'রব্বি নাজ্জিনি মিনাল কাওমিয যলিমিন',
      translation: 'My Lord, save me from people who do wrong.',
      translationBn: 'হে আমার রব, আমাকে অত্যাচারী লোকদের থেকে রক্ষা করুন।',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Quran 28:21',
    ),
    PowerfulDuah(
      number: 29,
      title: 'Complete our light',
      titleBn: 'পূর্ণ নূর ও ক্ষমার দোয়া',
      arabic:
          'رَبَّنَا أَتْمِمْ لَنَا نُورَنَا وَاغْفِرْ لَنَا إِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      pronunciation:
          'Rabbanā atmim lanā nūranā waghfir lanā innaka ʿalā kulli shayʾin qadīr',
      pronunciationBn:
          'রব্বানা আতমিম লানা নুরানা ওয়াগফির লানা ইন্নাকা আলা কুল্লি শাইইন কাদির',
      translation:
          'Our Lord, bring our light to completion and forgive us. You have power over everything.',
      translationBn:
          'হে আমাদের রব, আমাদের নূর পূর্ণ করুন এবং আমাদের ক্ষমা করুন। নিশ্চয়ই আপনি সবকিছুর ওপর ক্ষমতাবান।',
      situations: [
        DuahSituation.all,
        DuahSituation.protection,
        DuahSituation.forgiveness,
      ],
      source: 'Quran 66:8',
    ),
    PowerfulDuah(
      number: 30,
      title: 'Hope on the Day of Resurrection',
      titleBn: 'কিয়ামতের দিনের কল্যাণের আশা',
      arabic:
          'رَبَّنَا وَآتِنَا مَا وَعَدْتَنَا عَلَى رُسُلِكَ وَلَا تُخْزِنَا يَوْمَ الْقِيَامَةِ إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ',
      pronunciation:
          'Rabbanā wa ātinā mā waʿadtanā ʿalā rusulika wa lā tukhzinā yawmal-qiyāmati innaka lā tukhliful-mīʿād',
      pronunciationBn:
          'রব্বানা ওয়া আতিনা মা ওয়াআদতানা আলা রুসুলিকা ওয়া লা তুখযিনা ইয়াওমাল কিয়ামাতি ইন্নাকা লা তুখলিফুল মিআদ',
      translation:
          'Our Lord, grant us what You promised through Your messengers, and do not disgrace us on the Day of Resurrection. You never break Your promise.',
      translationBn:
          'হে আমাদের রব, আপনার রাসূলদের মাধ্যমে যা প্রতিশ্রুতি দিয়েছেন তা আমাদের দিন এবং কিয়ামতের দিনে আমাদের অপমানিত করবেন না। নিশ্চয়ই আপনি প্রতিশ্রুতি ভঙ্গ করেন না।',
      situations: [
        DuahSituation.all,
        DuahSituation.protection,
        DuahSituation.forgiveness,
      ],
      source: 'Quran 3:194',
    ),
    PowerfulDuah(
      number: 31,
      title: 'Supplication of Ayyub',
      titleBn: 'আইয়ুব (আ.)-এর দোয়া',
      arabic: 'أَنِّي مَسَّنِيَ الضُّرُّ وَأَنْتَ أَرْحَمُ الرَّاحِمِينَ',
      pronunciation: 'Annī massaniyaḍ-ḍurru wa anta arḥamur-rāḥimīn',
      pronunciationBn: 'আন্নি মাসসানিয়াদ দুররু ওয়া আনতা আরহামুর রাহিমিন',
      translation:
          'Hardship has touched me, and You are the most merciful of those who show mercy.',
      translationBn:
          'আমাকে কষ্ট স্পর্শ করেছে, আর দয়ালুদের মধ্যে আপনিই সর্বাধিক দয়ালু।',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Quran 21:83',
    ),
    PowerfulDuah(
      number: 32,
      title: 'A heart free of resentment',
      titleBn: 'বিদ্বেষমুক্ত অন্তরের দোয়া',
      arabic:
          'رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ وَلَا تَجْعَلْ فِي قُلُوبِنَا غِلًّا لِلَّذِينَ آمَنُوا رَبَّنَا إِنَّكَ رَءُوفٌ رَحِيمٌ',
      pronunciation:
          'Rabbanaghfir lanā wa li-ikhwāninalladhīna sabaqūnā bil-īmāni wa lā tajʿal fī qulūbinā ghillan lilladhīna āmanū rabbanā innaka raʾūfun raḥīm',
      pronunciationBn:
          'রব্বানাগফির লানা ওয়া লিইখওয়ানিনাল্লাযিনা সাবাকুনা বিল ইমানি ওয়া লা তাজআল ফি কুলুবিনা গিল্লাল লিল্লাযিনা আমানু রব্বানা ইন্নাকা রাউফুর রাহিম',
      translation:
          'Our Lord, forgive us and our fellow believers who preceded us in faith. Leave no resentment in our hearts toward believers. Our Lord, You are full of kindness and mercy.',
      translationBn:
          'হে আমাদের রব, আমাদের ও আমাদের আগে ঈমান আনা ভাইদের ক্ষমা করুন। মুমিনদের প্রতি আমাদের অন্তরে কোনো বিদ্বেষ রাখবেন না। হে আমাদের রব, নিশ্চয়ই আপনি অতি স্নেহশীল ও দয়ালু।',
      situations: [
        DuahSituation.all,
        DuahSituation.forgiveness,
        DuahSituation.family,
      ],
      source: 'Quran 59:10',
    ),
    PowerfulDuah(
      number: 33,
      title: 'Guidance and contentment',
      titleBn: 'হিদায়াত ও অমুখাপেক্ষিতার দোয়া',
      arabic:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
      pronunciation:
          'Allāhumma innī asʾalukal-hudā wat-tuqā wal-ʿafāfa wal-ghinā',
      pronunciationBn:
          'আল্লাহুম্মা ইন্নি আসআলুকাল হুদা ওয়াত তুকা ওয়াল আফাফা ওয়াল গিনা',
      translation:
          'O Allah, I ask You for guidance, mindfulness of You, chastity, and freedom from need.',
      translationBn:
          'হে আল্লাহ, আমি আপনার কাছে হিদায়াত, তাকওয়া, চারিত্রিক পবিত্রতা ও অমুখাপেক্ষিতা চাই।',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Riyad as-Salihin 1468 (reported by Muslim)',
    ),
    PowerfulDuah(
      number: 34,
      title: 'Pardon on Laylat al-Qadr',
      titleBn: 'লাইলাতুল কদরে ক্ষমার দোয়া',
      arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      pronunciation: 'Allāhumma innaka ʿafuwwun tuḥibbul-ʿafwa faʿfu ʿannī',
      pronunciationBn: 'আল্লাহুম্মা ইন্নাকা আফুউউন তুহিব্বুল আফওয়া ফাফু আন্নি',
      translation: 'O Allah, You pardon and love to pardon, so pardon me.',
      translationBn:
          'হে আল্লাহ, আপনি ক্ষমাকারী এবং ক্ষমা করতে ভালোবাসেন, তাই আমাকে ক্ষমা করুন।',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Sunan Ibn Majah 3850; graded sahih by Darussalam',
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
