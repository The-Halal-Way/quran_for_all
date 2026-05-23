part of '../../../../views/dashboard/duah/powerful_duah_view.dart';
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
    required this.arabic,
    required this.pronunciation,
    required this.translation,
    required this.situations,
    this.source,
    this.isFeatured = false,
  });

  final int number;
  final String title;
  final String arabic;
  final String pronunciation;
  final String translation;
  final List<DuahSituation> situations;
  final String? source;
  final bool isFeatured; // top-5 "start with these" picks
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

class PowerfulDuahData {
  static const List<PowerfulDuah> all = [
    PowerfulDuah(
      number: 1,
      title: 'Goodness in this life and the next',
      arabic:
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      pronunciation:
          'Rabbanā ātinā fid-dunyā ḥasanah wa fil-ākhirati ḥasanah wa qinā ʿadhāban-nār',
      translation:
          'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Qur\'an 2:201',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 2,
      title: 'Forgiveness of all sins',
      arabic:
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      pronunciation:
          'Rabbi-ghfir lī wa tub ʿalayya innaka antat-Tawwābur-Raḥīm',
      translation:
          'My Lord, forgive me and accept my repentance. Indeed, You are the Acceptor of repentance, the Most Merciful.',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Hadith — Abu Dawud',
    ),
    PowerfulDuah(
      number: 3,
      title: 'Relief from anxiety & grief',
      arabic:
          'اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ، سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي',
      pronunciation:
          'Allāhumma innī ʿabduka, ibnu ʿabdika, ibnu amatika, nāṣiyatī biyadika, māḍin fiyya ḥukmuka, ʿadlun fiyya qaḍā\'uka... an tajʿalal-Qur\'āna rabīʿa qalbī, wa nūra ṣadrī, wa jalā\'a ḥuznī, wa dhahāba hammī',
      translation:
          'O Allah, I am Your servant, son of Your servant, son of Your maidservant. My forelock is in Your hand... make the Qur\'an the spring of my heart, the light of my chest, the remover of my sadness, and the reliever of my distress.',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Hadith — Ahmad',
    ),
    PowerfulDuah(
      number: 4,
      title: 'Relief from debt & poverty',
      arabic:
          'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      pronunciation:
          'Allāhumma-kfinī biḥalālika ʿan ḥarāmika wa aghninī bifaḍlika ʿamman siwāk',
      translation:
          'O Allah, suffice me with what You have made lawful instead of what You have made unlawful, and make me independent by Your bounty from needing anyone besides You.',
      situations: [DuahSituation.all, DuahSituation.provision],
      source: 'Hadith — Tirmidhi',
    ),
    PowerfulDuah(
      number: 5,
      title: 'Increase in knowledge & wisdom',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      pronunciation: 'Rabbi zidnī ʿilmā',
      translation: 'My Lord, increase me in knowledge.',
      situations: [DuahSituation.all, DuahSituation.knowledge],
      source: 'Qur\'an 20:114',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 6,
      title: 'Steadfastness of the heart',
      arabic: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
      pronunciation: 'Yā Muqallibal-qulūb, thabbit qalbī ʿalā dīnik',
      translation:
          'O Turner of the hearts, keep my heart firm upon Your religion.',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Hadith — Tirmidhi',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 7,
      title: 'Guidance and righteousness',
      arabic: 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      pronunciation: 'Allāhumma-hdinī wa saddidnī',
      translation: 'O Allah, guide me and keep me firm and correct.',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Hadith — Muslim',
    ),
    PowerfulDuah(
      number: 8,
      title: 'Protection from worry & laziness',
      arabic:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الهَمِّ وَالحَزَنِ، وَالعَجْزِ وَالكَسَلِ، وَالجُبْنِ وَالبُخْلِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      pronunciation:
          'Allāhumma innī aʿūdhu bika minal-hammi wal-ḥazan, wal-ʿajzi wal-kasal, wal-jubni wal-bukhl, wa ḍalaʿid-dayni wa ghalabatir-rijāl',
      translation:
          'O Allah, I seek refuge in You from worry and grief, weakness and laziness, cowardice and stinginess, the burden of debt, and being overpowered by people.',
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
      arabic: 'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ العَلِيمُ',
      pronunciation: 'Rabbanā taqabbal minnā innaka Antas-Samīʿul-ʿAlīm',
      translation:
          'Our Lord, accept from us. Indeed, You are the All-Hearing, the All-Knowing.',
      situations: [DuahSituation.all],
      source: 'Qur\'an 2:127',
    ),
    PowerfulDuah(
      number: 10,
      title: 'Mercy and right guidance',
      arabic:
          'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً ۚ إِنَّكَ أَنْتَ الْوَهَّابُ',
      pronunciation:
          'Rabbanā lā tuzigh qulūbanā baʿda idh hadaytanā wa hab lanā min ladunka raḥmah, innaka antal-Wahhāb',
      translation:
          'Our Lord, do not let our hearts deviate after You have guided us, and grant us mercy from Yourself. Indeed, You are the Bestower.',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Qur\'an 3:8',
    ),
    PowerfulDuah(
      number: 11,
      title: 'Patience and a good ending',
      arabic: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      pronunciation: 'Rabbanā afrigh ʿalaynā ṣabran wa tawaffanā muslimīn',
      translation: 'Our Lord, pour upon us patience and let us die as Muslims.',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Qur\'an 7:126',
    ),
    PowerfulDuah(
      number: 12,
      title: 'Righteous family & pure heart',
      arabic:
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      pronunciation:
          'Rabbanā hab lanā min azwājinā wa dhurriyyātinā qurrata aʿyunin wajʿalnā lil-muttaqīna imāmā',
      translation:
          'Our Lord, grant us from our spouses and children comfort to our eyes and make us leaders for the righteous.',
      situations: [DuahSituation.all, DuahSituation.family],
      source: 'Qur\'an 25:74',
    ),
    PowerfulDuah(
      number: 13,
      title: 'Ease in difficult tasks',
      arabic:
          'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي ۝ وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي ۝ يَفْقَهُوا قَوْلِي',
      pronunciation:
          'Rabbi-shraḥ lī ṣadrī, wa yassir lī amrī, waḥlul ʿuqdatan min lisānī, yafqahū qawlī',
      translation:
          'My Lord, expand for me my chest, ease for me my task, and untie the knot from my tongue so that they may understand my speech.',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Qur\'an 20:25–28',
    ),
    PowerfulDuah(
      number: 14,
      title: 'Protection from all evil',
      arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الوَكِيلُ',
      pronunciation: 'Ḥasbunallāhu wa niʿmal-wakīl',
      translation:
          'Allah is sufficient for us, and He is the best disposer of affairs.',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Qur\'an 3:173',
    ),
    PowerfulDuah(
      number: 15,
      title: 'Du\'ā of Yunus ﷺ',
      arabic:
          'لَا إِلٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      pronunciation: 'Lā ilāha illā anta subḥānaka innī kuntu minaẓ-ẓālimīn',
      translation:
          'There is no god except You. Glory be to You. Indeed, I was among the wrongdoers.',
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
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      pronunciation:
          'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa anā ʿabduka, wa anā ʿalā ʿahdika wa waʿdika mastaṭaʿtu... faghfir lī fa innahu lā yaghfirudh-dhunūba illā anta',
      translation:
          'O Allah, You are my Lord. There is no god except You. You created me and I am Your servant... so forgive me, for none forgives sins except You.',
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
  String get label {
    switch (this) {
      case DuahSituation.all:
        return 'All';
      case DuahSituation.distress:
        return 'Distress';
      case DuahSituation.forgiveness:
        return 'Forgiveness';
      case DuahSituation.guidance:
        return 'Guidance';
      case DuahSituation.provision:
        return 'Provision';
      case DuahSituation.protection:
        return 'Protection';
      case DuahSituation.family:
        return 'Family';
      case DuahSituation.knowledge:
        return 'Knowledge';
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

