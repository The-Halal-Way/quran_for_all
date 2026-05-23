part of '../../../../views/dashboard/duah/daily_duah_view.dart';
enum DuahLevel { beginner, intermediate, advanced }

class DuahItem {
  const DuahItem({
    required this.title,
    required this.arabic,
    required this.pronunciation,
    required this.translation,
    this.note,
    this.subItems = const [],
  });

  final String title;
  final String arabic;
  final String pronunciation;
  final String translation;
  final String? note;
  final List<DuahItem> subItems; // e.g. "if forgotten" variants
}

class DuahCategory {
  const DuahCategory({
    required this.icon,
    required this.label,
    required this.items,
  });

  final IconData icon;
  final String label;
  final List<DuahItem> items;
}

class DuahData {
  // ── BEGINNER ────────────────────────────────────────────────────────────────
  static const List<DuahCategory> beginner = [
    DuahCategory(
      icon: Icons.restaurant_rounded,
      label: 'Eating & Drinking',
      items: [
        DuahItem(
          title: 'Before eating',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
        ),
        DuahItem(
          title: 'After eating',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
        DuahItem(
          title: 'Before drinking',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
        ),
        DuahItem(
          title: 'After drinking',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.home_rounded,
      label: 'Home',
      items: [
        DuahItem(
          title: 'Leaving home',
          arabic: 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ',
          pronunciation: 'Bismillāh, tawakkaltu ʿalallāh',
          translation: 'In the name of Allah, I place my trust in Allah.',
        ),
        DuahItem(
          title: 'Entering home',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
          note: 'You can also say: As-salāmu ʿalaykum — Peace be upon you.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.wc_rounded,
      label: 'Washroom',
      items: [
        DuahItem(
          title: 'Entering the washroom',
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
          pronunciation:
              'Allāhumma innī aʿūdhu bika minal-khubuthi wal-khabāʾith',
          translation: 'O Allah, I seek refuge in You from evil.',
        ),
        DuahItem(
          title: 'Leaving the washroom',
          arabic: 'غُفْرَانَكَ',
          pronunciation: 'Ghufrānaka',
          translation: 'I seek Your forgiveness.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.bedtime_rounded,
      label: 'Sleep',
      items: [
        DuahItem(
          title: 'Before sleeping',
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          pronunciation: 'Bismika Allāhumma amūtu wa aḥyā',
          translation: 'In Your name, O Allah, I die and I live.',
        ),
        DuahItem(
          title: 'After waking up',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.favorite_rounded,
      label: 'Daily Dhikr',
      items: [
        DuahItem(
          title: 'Glory be to Allah',
          arabic: 'سُبْحَانَ اللَّهِ',
          pronunciation: 'Subḥānallāh',
          translation: 'Glory be to Allah.',
        ),
        DuahItem(
          title: 'All praise is for Allah',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
        DuahItem(
          title: 'Allah is the Greatest',
          arabic: 'اللَّهُ أَكْبَرُ',
          pronunciation: 'Allāhu Akbar',
          translation: 'Allah is the Greatest.',
        ),
        DuahItem(
          title: 'There is no god but Allah',
          arabic: 'لَا إِلٰهَ إِلَّا اللَّهُ',
          pronunciation: 'Lā ilāha illallāh',
          translation: 'There is no god but Allah.',
        ),
        DuahItem(
          title: 'Seeking forgiveness',
          arabic: 'أَسْتَغْفِرُ اللَّهَ',
          pronunciation: 'Astaghfirullāh',
          translation: 'I seek forgiveness from Allah.',
        ),
      ],
    ),
  ];

  // ── INTERMEDIATE ────────────────────────────────────────────────────────────
  static const List<DuahCategory> intermediate = [
    DuahCategory(
      icon: Icons.restaurant_rounded,
      label: 'Eating & Drinking',
      items: [
        DuahItem(
          title: 'Before eating',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
          subItems: [
            DuahItem(
              title: 'If forgotten',
              arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
              pronunciation: 'Bismillāhi awwalahu wa ākhirahu',
              translation:
                  'In the name of Allah, at its beginning and its end.',
            ),
          ],
        ),
        DuahItem(
          title: 'After eating',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          pronunciation:
              'Alhamdu lillāhi alladhī aṭʿamanī hādhā wa razaqanīhi min ghayri ḥawlin minnī wa lā quwwah',
          translation:
              'All praise is for Allah who fed me this and provided it for me without any power or strength from myself.',
        ),
        DuahItem(
          title: 'Before drinking',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
        ),
        DuahItem(
          title: 'After drinking',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.home_rounded,
      label: 'Home',
      items: [
        DuahItem(
          title: 'Entering home',
          arabic:
              'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
          pronunciation:
              'Bismillāhi walajnā, wa bismillāhi kharajnā, wa ʿalā rabbinā tawakkalnā',
          translation:
              'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we rely.',
        ),
        DuahItem(
          title: 'Leaving home',
          arabic:
              'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          pronunciation:
              'Bismillāh, tawakkaltu ʿalallāh, wa lā ḥawla wa lā quwwata illā billāh',
          translation:
              'In the name of Allah, I place my trust in Allah, and there is no might and no power except with Allah.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.wc_rounded,
      label: 'Washroom',
      items: [
        DuahItem(
          title: 'Entering washroom',
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
          pronunciation:
              'Allāhumma innī aʿūdhu bika minal-khubuthi wal-khabāʾith',
          translation:
              'O Allah, I seek refuge in You from male and female evil beings.',
        ),
        DuahItem(
          title: 'Leaving washroom',
          arabic: 'غُفْرَانَكَ',
          pronunciation: 'Ghufrānaka',
          translation: 'I seek Your forgiveness.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.bedtime_rounded,
      label: 'Sleep',
      items: [
        DuahItem(
          title: 'Before sleeping',
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          pronunciation: 'Bismika Allāhumma amūtu wa aḥyā',
          translation: 'In Your name, O Allah, I die and I live.',
        ),
        DuahItem(
          title: 'After waking',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          pronunciation:
              'Alhamdu lillāhi alladhī aḥyānā baʿda mā amātanā wa ilayhin-nushūr',
          translation:
              'All praise is for Allah who gave us life after causing us to die, and to Him is the resurrection.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.water_drop_rounded,
      label: 'Wudū\'',
      items: [
        DuahItem(
          title: 'Before wudū\'',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
        ),
        DuahItem(
          title: 'After wudū\'',
          arabic:
              'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
          pronunciation:
              'Ashhadu an lā ilāha illallāhu waḥdahu lā sharīka lah, wa ashhadu anna Muḥammadan ʿabduhu wa rasūluh',
          translation:
              'I bear witness that there is no god but Allah alone without partner, and I bear witness that Muhammad is His servant and messenger.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.mosque_rounded,
      label: 'Masjid',
      items: [
        DuahItem(
          title: 'Entering masjid',
          arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          pronunciation: 'Allāhumma iftaḥ lī abwāba raḥmatik',
          translation: 'O Allah, open for me the doors of Your mercy.',
        ),
        DuahItem(
          title: 'Leaving masjid',
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
          pronunciation: 'Allāhumma innī as\'aluka min faḍlik',
          translation: 'O Allah, I ask You from Your bounty.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.favorite_rounded,
      label: 'Daily Dhikr',
      items: [
        DuahItem(
          title: 'Glory be to Allah',
          arabic: 'سُبْحَانَ اللَّهِ',
          pronunciation: 'Subḥānallāh',
          translation: 'Glory be to Allah.',
        ),
        DuahItem(
          title: 'All praise is for Allah',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
        DuahItem(
          title: 'Allah is the Greatest',
          arabic: 'اللَّهُ أَكْبَرُ',
          pronunciation: 'Allāhu Akbar',
          translation: 'Allah is the Greatest.',
        ),
        DuahItem(
          title: 'There is no god but Allah',
          arabic: 'لَا إِلٰهَ إِلَّا اللَّهُ',
          pronunciation: 'Lā ilāha illallāh',
          translation: 'There is no god but Allah.',
        ),
        DuahItem(
          title: 'Seeking forgiveness',
          arabic: 'أَسْتَغْفِرُ اللَّهَ',
          pronunciation: 'Astaghfirullāh',
          translation: 'I seek forgiveness from Allah.',
        ),
      ],
    ),
  ];

  // ── ADVANCED ────────────────────────────────────────────────────────────────
  static const List<DuahCategory> advanced = [
    DuahCategory(
      icon: Icons.restaurant_rounded,
      label: 'Eating & Drinking',
      items: [
        DuahItem(
          title: 'Before eating',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
          subItems: [
            DuahItem(
              title: 'If forgotten',
              arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
              pronunciation: 'Bismillāhi awwalahu wa ākhirahu',
              translation:
                  'In the name of Allah, at its beginning and its end.',
            ),
          ],
        ),
        DuahItem(
          title: 'After eating',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          pronunciation:
              'Alhamdu lillāhi alladhī aṭʿamanī hādhā wa razaqanīhi min ghayri ḥawlin minnī wa lā quwwah',
          translation:
              'All praise is for Allah who fed me this and provided it for me without any power or strength from myself.',
        ),
        DuahItem(
          title: 'Before drinking',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
        ),
        DuahItem(
          title: 'After drinking',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.home_rounded,
      label: 'Home',
      items: [
        DuahItem(
          title: 'Entering home',
          arabic:
              'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
          pronunciation:
              'Bismillāhi walajnā, wa bismillāhi kharajnā, wa ʿalā rabbinā tawakkalnā',
          translation:
              'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we rely.',
        ),
        DuahItem(
          title: 'Leaving home',
          arabic:
              'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          pronunciation:
              'Bismillāh, tawakkaltu ʿalallāh, wa lā ḥawla wa lā quwwata illā billāh',
          translation:
              'In the name of Allah, I place my trust in Allah, and there is no might and no power except with Allah.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.wc_rounded,
      label: 'Washroom',
      items: [
        DuahItem(
          title: 'Entering washroom',
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
          pronunciation:
              'Allāhumma innī aʿūdhu bika minal-khubuthi wal-khabāʾith',
          translation:
              'O Allah, I seek refuge in You from male and female evil beings.',
        ),
        DuahItem(
          title: 'Leaving washroom',
          arabic: 'غُفْرَانَكَ',
          pronunciation: 'Ghufrānaka',
          translation: 'I seek Your forgiveness.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.bedtime_rounded,
      label: 'Sleep',
      items: [
        DuahItem(
          title: 'Before sleeping',
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          pronunciation: 'Bismika Allāhumma amūtu wa aḥyā',
          translation: 'In Your name, O Allah, I die and I live.',
        ),
        DuahItem(
          title: 'After waking',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          pronunciation:
              'Alhamdu lillāhi alladhī aḥyānā baʿda mā amātanā wa ilayhin-nushūr',
          translation:
              'All praise is for Allah who gave us life after causing us to die, and to Him is the resurrection.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.water_drop_rounded,
      label: 'Wudū\'',
      items: [
        DuahItem(
          title: 'Before wudū\'',
          arabic: 'بِسْمِ اللَّهِ',
          pronunciation: 'Bismillāh',
          translation: 'In the name of Allah.',
        ),
        DuahItem(
          title: 'After wudū\'',
          arabic:
              'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
          pronunciation:
              'Ashhadu an lā ilāha illallāhu waḥdahu lā sharīka lah, wa ashhadu anna Muḥammadan ʿabduhu wa rasūluh',
          translation:
              'I bear witness that there is no god but Allah alone without partner, and I bear witness that Muhammad is His servant and messenger.',
          subItems: [
            DuahItem(
              title: 'Optional addition',
              arabic:
                  'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
              pronunciation:
                  'Allāhummajʿalnī minat-tawwābīn wajʿalnī minal-mutaṭahhirīn',
              translation:
                  'O Allah, make me among those who repent often and make me among those who purify themselves.',
            ),
          ],
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.mosque_rounded,
      label: 'Masjid',
      items: [
        DuahItem(
          title: 'Entering masjid',
          arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          pronunciation: 'Allāhumma iftaḥ lī abwāba raḥmatik',
          translation: 'O Allah, open for me the doors of Your mercy.',
        ),
        DuahItem(
          title: 'Leaving masjid',
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
          pronunciation: 'Allāhumma innī as\'aluka min faḍlik',
          translation: 'O Allah, I ask You from Your bounty.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.air_rounded,
      label: 'Sneezing',
      items: [
        DuahItem(
          title: 'When sneezing',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
        DuahItem(
          title: 'Reply to sneezer',
          arabic: 'يَرْحَمُكَ اللَّهُ',
          pronunciation: 'Yarḥamukallāh',
          translation: 'May Allah have mercy on you.',
        ),
        DuahItem(
          title: 'Sneezer replies back',
          arabic: 'يَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ',
          pronunciation: 'YahdīkumulLāhu wa yuṣliḥu bālakum',
          translation: 'May Allah guide you and correct your condition.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.shield_rounded,
      label: 'Difficulty',
      items: [
        DuahItem(
          title: 'When worried or in difficulty',
          arabic:
              'حَسْبِيَ اللَّهُ لَا إِلٰهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ، وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
          pronunciation:
              'Ḥasbiyallāhu lā ilāha illā huwa, ʿalayhi tawakkaltu, wa huwa rabbul-ʿarshil-ʿaẓīm',
          translation:
              'Allah is sufficient for me. There is no god except Him. Upon Him I rely, and He is the Lord of the Mighty Throne.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.favorite_rounded,
      label: 'Daily Dhikr',
      items: [
        DuahItem(
          title: 'Glory be to Allah',
          arabic: 'سُبْحَانَ اللَّهِ',
          pronunciation: 'Subḥānallāh',
          translation: 'Glory be to Allah.',
        ),
        DuahItem(
          title: 'All praise is for Allah',
          arabic: 'الْحَمْدُ لِلَّهِ',
          pronunciation: 'Alhamdulillāh',
          translation: 'All praise is for Allah.',
        ),
        DuahItem(
          title: 'Allah is the Greatest',
          arabic: 'اللَّهُ أَكْبَرُ',
          pronunciation: 'Allāhu Akbar',
          translation: 'Allah is the Greatest.',
        ),
        DuahItem(
          title: 'There is no god but Allah',
          arabic: 'لَا إِلٰهَ إِلَّا اللَّهُ',
          pronunciation: 'Lā ilāha illallāh',
          translation: 'There is no god but Allah.',
        ),
        DuahItem(
          title: 'Seeking forgiveness',
          arabic: 'أَسْتَغْفِرُ اللَّهَ',
          pronunciation: 'Astaghfirullāh',
          translation: 'I seek forgiveness from Allah.',
        ),
      ],
    ),
  ];

  static List<DuahCategory> forLevel(DuahLevel level) {
    switch (level) {
      case DuahLevel.beginner:
        return beginner;
      case DuahLevel.intermediate:
        return intermediate;
      case DuahLevel.advanced:
        return advanced;
    }
  }
}

