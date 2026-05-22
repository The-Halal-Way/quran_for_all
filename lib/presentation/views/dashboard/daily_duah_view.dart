import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class DailyDuahView extends StatefulWidget {
  const DailyDuahView({super.key});

  @override
  State<DailyDuahView> createState() => _DailyDuahViewState();
}

class _DailyDuahViewState extends State<DailyDuahView>
    with SingleTickerProviderStateMixin {
  DuahLevel _selectedLevel = DuahLevel.beginner;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switchLevel(DuahLevel level) {
    if (_selectedLevel == level) return;
    _fadeCtrl.reverse().then((_) {
      setState(() => _selectedLevel = level);
      _fadeCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = DuahData.forLevel(_selectedLevel);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DuahAppBar(
            isDark: isDark,
            selectedLevel: _selectedLevel,
            onLevelChanged: _switchLevel,
          ),
          SliverFadeTransition(
            opacity: _fadeAnim,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0) {
                  return _LevelBanner(level: _selectedLevel, isDark: isDark);
                }
                final cat = categories[index - 1];
                return _CategorySection(
                  category: cat,
                  isDark: isDark,
                  isLast: index == categories.length,
                );
              }, childCount: categories.length + 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIVER APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _DuahAppBar extends StatelessWidget {
  const _DuahAppBar({
    required this.isDark,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final bool isDark;
  final DuahLevel selectedLevel;
  final ValueChanged<DuahLevel> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF120A2B) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 148,
      collapsedHeight: 64,
      backgroundColor: isDark
          ? const Color(0xFF060118)
          : const Color(0xFFF5F2FF),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Text(
          'Daily Du\'ā\'',
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
          ),
        ),
        background: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supplications for every moment',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? const Color(0xFF7E57C2)
                      : const Color(0xFF7A7288),
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderC),
          ),
          child: Row(
            children: DuahLevel.values.map((level) {
              return Expanded(
                child: _LevelTab(
                  level: level,
                  isSelected: selectedLevel == level,
                  isDark: isDark,
                  onTap: () => onLevelChanged(level),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEVEL TAB CHIP
// ─────────────────────────────────────────────────────────────────────────────

class _LevelTab extends StatelessWidget {
  const _LevelTab({
    required this.level,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final DuahLevel level;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  String get _label {
    switch (level) {
      case DuahLevel.beginner:
        return 'Beginner';
      case DuahLevel.intermediate:
        return 'Intermediate';
      case DuahLevel.advanced:
        return 'Advanced';
    }
  }

  Color get _activeColor {
    switch (level) {
      case DuahLevel.beginner:
        return const Color(0xFF00BFA5); // teal
      case DuahLevel.intermediate:
        return const Color(0xFF4B30A1); // indigo
      case DuahLevel.advanced:
        return const Color(0xFFD50057); // fuchsia
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _activeColor.withValues(alpha: isDark ? 0.22 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: isSelected
              ? Border.all(color: _activeColor.withValues(alpha: 0.5), width: 1)
              : null,
        ),
        child: Text(
          _label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? _activeColor
                : (isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288)),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEVEL BANNER  (count chip + description)
// ─────────────────────────────────────────────────────────────────────────────

class _LevelBanner extends StatelessWidget {
  const _LevelBanner({required this.level, required this.isDark});

  final DuahLevel level;
  final bool isDark;

  String get _description {
    switch (level) {
      case DuahLevel.beginner:
        return 'Short, easy-to-memorize du\'ās for everyday moments. Perfect to start your journey.';
      case DuahLevel.intermediate:
        return 'Fuller wordings with richer meaning. Ideal once the basics feel natural.';
      case DuahLevel.advanced:
        return 'Complete authentic du\'ās including optional additions and all daily situations.';
    }
  }

  Color get _accentColor {
    switch (level) {
      case DuahLevel.beginner:
        return const Color(0xFF00BFA5);
      case DuahLevel.intermediate:
        return const Color(0xFF4B30A1);
      case DuahLevel.advanced:
        return const Color(0xFFD50057);
    }
  }

  String get _levelLabel {
    switch (level) {
      case DuahLevel.beginner:
        return 'Beginner';
      case DuahLevel.intermediate:
        return 'Intermediate';
      case DuahLevel.advanced:
        return 'Advanced';
    }
  }

  int get _duahCount =>
      DuahData.forLevel(level).fold(0, (sum, cat) => sum + cat.items.length);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF1D1238) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderC),
        gradient: LinearGradient(
          colors: [
            _accentColor.withValues(alpha: isDark ? 0.10 : 0.05),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: _accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _levelLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: _accentColor,
                        fontFamily: 'Sora',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_duahCount du\'ās',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? const Color(0xFFB39DDB)
                        : const Color(0xFF4C425C),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.isDark,
    required this.isLast,
  });

  final DuahCategory category;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, isLast ? 32 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.6 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    size: 16,
                    color: isDark
                        ? const Color(0xFFB39DDB)
                        : const Color(0xFF1E0A3C),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Sora',
                    fontSize: 15,
                    color: isDark
                        ? const Color(0xFFEDE7F6)
                        : const Color(0xFF120B24),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF382E54)
                        : const Color(0xFFEEE8FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${category.items.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? const Color(0xFFB39DDB)
                          : const Color(0xFF4C425C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...category.items.map(
            (item) => _DuahCard(item: item, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DUAH CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DuahCard extends StatefulWidget {
  const _DuahCard({required this.item, required this.isDark});

  final DuahItem item;
  final bool isDark;

  @override
  State<_DuahCard> createState() => _DuahCardState();
}

class _DuahCardState extends State<_DuahCard> {
  bool _expanded = false;
  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(
      ClipboardData(
        text:
            '${widget.item.arabic}\n${widget.item.pronunciation}\n${widget.item.translation}',
      ),
    );
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;
    final item = widget.item;

    final cardBg = isDark ? const Color(0xFF120A2B) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
    final hasExtra = item.subItems.isNotEmpty || item.note != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Main content ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isDark
                              ? const Color(0xFF7E57C2)
                              : const Color(0xFF4C425C),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    // Copy button
                    GestureDetector(
                      onTap: _copyToClipboard,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _copied
                              ? const Color(0xFF00BFA5).withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _copied ? Icons.check_rounded : Icons.copy_rounded,
                          size: 16,
                          color: _copied
                              ? const Color(0xFF00BFA5)
                              : (isDark
                                    ? const Color(0xFF7E57C2)
                                    : const Color(0xFF7A7288)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Arabic text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.40 : 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(
                        0xFF4B30A1,
                      ).withValues(alpha: isDark ? 0.20 : 0.10),
                    ),
                  ),
                  child: Text(
                    item.arabic,
                    textAlign: TextAlign.right,
                    textDirection: ui.TextDirection.rtl,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Scheherazade New', // Arabic font
                      fontSize: 24,
                      height: 1.8,
                      color: isDark
                          ? const Color(0xFFEDE7F6)
                          : const Color(0xFF120B24),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Pronunciation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B30A1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.pronunciation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? const Color(0xFFB39DDB)
                              : const Color(0xFF4C425C),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Translation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.translation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                // Note (if any)
                if (item.note != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF00BFA5).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFF00BFA5),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.note!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? const Color(0xFF64FFDA)
                                  : const Color(0xFF00897B),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Expand toggle for sub-items ───────────────────────────────────
          if (hasExtra) ...[
            Divider(height: 1, color: borderC),
            InkWell(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: isDark
                          ? const Color(0xFF7E57C2)
                          : const Color(0xFF4C425C),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _expanded ? 'Hide variants' : 'Show variants',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? const Color(0xFF7E57C2)
                            : const Color(0xFF4C425C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sub-items (e.g. "If forgotten")
            if (_expanded)
              ...item.subItems.map(
                (sub) => _SubItemTile(item: sub, isDark: isDark),
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUB ITEM  (variant / optional addition)
// ─────────────────────────────────────────────────────────────────────────────

class _SubItemTile extends StatelessWidget {
  const _SubItemTile({required this.item, required this.isDark});

  final DuahItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD50057).withValues(alpha: isDark ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD50057).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFD50057),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.arabic,
            textAlign: TextAlign.right,
            textDirection: ui.TextDirection.rtl,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'Scheherazade New',
              fontSize: 20,
              height: 1.8,
              color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.pronunciation,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.translation,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
            ),
          ),
        ],
      ),
    );
  }
}
