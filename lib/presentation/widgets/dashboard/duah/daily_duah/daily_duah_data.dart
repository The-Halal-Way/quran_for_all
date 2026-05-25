import 'package:flutter/material.dart';

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

extension DuahItemLocalization on DuahItem {
  bool _isBangla(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'bn';

  String localizedTitle(BuildContext context) {
    if (!_isBangla(context)) return title;
    return _titleBnMap[title] ?? title;
  }

  String localizedPronunciation(BuildContext context) {
    if (!_isBangla(context)) return pronunciation;
    return _pronunciationBnMap[pronunciation] ?? pronunciation;
  }

  String localizedTranslation(BuildContext context) {
    if (!_isBangla(context)) return translation;
    return _translationBnMap[translation] ?? translation;
  }

  static const Map<String, String> _titleBnMap = {
    'Before eating': 'খাওয়ার আগে',
    'After eating': 'খাওয়ার পরে',
    'Before drinking': 'পান করার আগে',
    'After drinking': 'পান করার পরে',
    'Leaving home': 'বাড়ি থেকে বের হওয়ার সময়',
    'Entering home': 'বাড়িতে প্রবেশের সময়',
    'Entering the washroom': 'ওয়াশরুমে প্রবেশের সময়',
    'Leaving the washroom': 'ওয়াশরুম থেকে বের হওয়ার সময়',
    'Entering washroom': 'ওয়াশরুমে প্রবেশের সময়',
    'Leaving washroom': 'ওয়াশরুম থেকে বের হওয়ার সময়',
    'Before sleeping': 'ঘুমানোর আগে',
    'After waking up': 'ঘুম থেকে ওঠার পরে',
    'After waking': 'ঘুম থেকে ওঠার পরে',
    'Glory be to Allah': 'সুবহানাল্লাহ',
    'All praise is for Allah': 'আলহামদুলিল্লাহ',
    'Allah is the Greatest': 'আল্লাহু আকবার',
    'There is no god but Allah': 'লা ইলাহা ইল্লাল্লাহ',
    'Seeking forgiveness': 'ক্ষমা প্রার্থনা',
    'If forgotten': 'ভুলে গেলে',
    'Before wudū\'': 'ওজুর আগে',
    'After wudū\'': 'ওজুর পরে',
    'Entering masjid': 'মসজিদে প্রবেশের সময়',
    'Leaving masjid': 'মসজিদ থেকে বের হওয়ার সময়',
    'Optional addition': 'অতিরিক্ত পাঠ',
    'When sneezing': 'হাঁচি দিলে',
    'Reply to sneezer': 'হাঁচিদাতাকে জবাব',
    'Sneezer replies back': 'হাঁচিদাতার পাল্টা জবাব',
    'When worried or in difficulty': 'দুশ্চিন্তা বা বিপদে',
  };

  static const Map<String, String> _pronunciationBnMap = {
    'Bismillāh': 'বিসমিল্লাহ',
    'Alhamdulillāh': 'আলহামদুলিল্লাহ',
    'Bismillāh, tawakkaltu ʿalallāh': 'বিসমিল্লাহ, তাওয়াক্কালতু আলাল্লাহ',
    'Allāhumma innī aʿūdhu bika minal-khubuthi wal-khabāʾith':
        'আল্লাহুম্মা ইন্নি আউযু বিকা মিনাল-খুবুসি ওয়াল-খাবাইস',
    'Ghufrānaka': 'গুফরানাকা',
    'Bismika Allāhumma amūtu wa aḥyā': 'বিসমিকা আল্লাহুম্মা আমুতু ওয়া আহইয়া',
    'Subḥānallāh': 'সুবহানাল্লাহ',
    'Allāhu Akbar': 'আল্লাহু আকবার',
    'Lā ilāha illallāh': 'লা ইলাহা ইল্লাল্লাহ',
    'Astaghfirullāh': 'আস্তাগফিরুল্লাহ',
    'Bismillāhi awwalahu wa ākhirahu': 'বিসমিল্লাহি আওয়ালাহু ওয়া আখিরাহু',
    'Alhamdu lillāhi alladhī aṭʿamanī hādhā wa razaqanīhi min ghayri ḥawlin minnī wa lā quwwah':
        'আলহামদু লিল্লাহিল্লাযি আতআমানি হাযা ওয়া রাযাকানিহি মিন গাইরি হাওলিন মিননি ওয়ালা কুওয়াহ',
    'Bismillāhi walajnā, wa bismillāhi kharajnā, wa ʿalā rabbinā tawakkalnā':
        'বিসমিল্লাহি ওয়ালাজনা, ওয়া বিসমিল্লাহি খারাজনা, ওয়া আলা রব্বিনা তাওয়াক্কালনা',
    'Bismillāh, tawakkaltu ʿalallāh, wa lā ḥawla wa lā quwwata illā billāh':
        'বিসমিল্লাহ, তাওয়াক্কালতু আলাল্লাহ, ওয়ালা হাওলা ওয়ালা কুওয়াতা ইল্লা বিল্লাহ',
    'Alhamdu lillāhi alladhī aḥyānā baʿda mā amātanā wa ilayhin-nushūr':
        'আলহামদু লিল্লাহিল্লাযি আহইয়ানা বাদা মা আমাতানা ওয়া ইলাইহিন নুশুর',
    'Ashhadu an lā ilāha illallāhu waḥdahu lā sharīka lah, wa ashhadu anna Muḥammadan ʿabduhu wa rasūluh':
        'আশহাদু আল্লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারিকা লাহ, ওয়া আশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাসুলুহ',
    'Allāhumma iftaḥ lī abwāba raḥmatik':
        'আল্লাহুম্মা ইফতাহ লি আবওয়াবা রাহমাতিক',
    'Allāhumma innī as\'aluka min faḍlik':
        'আল্লাহুম্মা ইন্নি আসআলুকা মিন ফাদলিক',
    'Allāhummajʿalnī minat-tawwābīn wajʿalnī minal-mutaṭahhirīn':
        'আল্লাহুম্মাজআলনি মিনাত তাওয়াবিন ওয়াজআলনি মিনাল মুতাতাহহিরিন',
    'Yarḥamukallāh': 'ইয়ারহামুকাল্লাহ',
    'YahdīkumulLāhu wa yuṣliḥu bālakum':
        'ইয়াহদিকুমুল্লাহু ওয়া ইউসলিহু বালাকুম',
    'Ḥasbiyallāhu lā ilāha illā huwa, ʿalayhi tawakkaltu, wa huwa rabbul-ʿarshil-ʿaẓīm':
        'হাসবিয়াল্লাহু লা ইলাহা ইল্লা হুয়া, আলাইহি তাওয়াক্কালতু, ওয়া হুয়া রব্বুল আরশিল আযিম',
  };

  static const Map<String, String> _translationBnMap = {
    'In the name of Allah.': 'আল্লাহর নামে।',
    'All praise is for Allah.': 'সমস্ত প্রশংসা আল্লাহর জন্য।',
    'In the name of Allah, I place my trust in Allah.':
        'আল্লাহর নামে, আমি আল্লাহর উপর ভরসা করি।',
    'O Allah, I seek refuge in You from evil.':
        'হে আল্লাহ, আমি আপনার কাছে অকল্যাণ থেকে আশ্রয় চাই।',
    'I seek Your forgiveness.': 'আমি আপনার ক্ষমা প্রার্থনা করি।',
    'In Your name, O Allah, I die and I live.':
        'হে আল্লাহ, আপনার নামেই আমি মৃত্যু বরণ করি এবং বেঁচে উঠি।',
    'Glory be to Allah.': 'আল্লাহ পবিত্র।',
    'Allah is the Greatest.': 'আল্লাহ সর্বশ্রেষ্ঠ।',
    'There is no god but Allah.': 'আল্লাহ ছাড়া কোনো উপাস্য নেই।',
    'I seek forgiveness from Allah.': 'আমি আল্লাহর কাছে ক্ষমা চাই।',
    'In the name of Allah, at its beginning and its end.':
        'শুরুও আল্লাহর নামে, শেষও আল্লাহর নামে।',
    'All praise is for Allah who fed me this and provided it for me without any power or strength from myself.':
        'সমস্ত প্রশংসা আল্লাহর, যিনি আমাকে এটি খাইয়েছেন এবং আমার নিজের কোনো শক্তি ছাড়াই এটি দিয়েছেন।',
    'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we rely.':
        'আল্লাহর নামে আমরা প্রবেশ করি, আল্লাহর নামেই বের হই এবং আমাদের রবের ওপর ভরসা করি।',
    'In the name of Allah, I place my trust in Allah, and there is no might and no power except with Allah.':
        'আল্লাহর নামে, আমি আল্লাহর ওপর ভরসা করি; আল্লাহ ছাড়া কোনো শক্তি ও ক্ষমতা নেই।',
    'O Allah, I seek refuge in You from male and female evil beings.':
        'হে আল্লাহ, আমি আপনার কাছে পুরুষ ও নারী শয়তানের অনিষ্ট থেকে আশ্রয় চাই।',
    'All praise is for Allah who gave us life after causing us to die, and to Him is the resurrection.':
        'সমস্ত প্রশংসা আল্লাহর, যিনি মৃত্যুর পর আবার জীবন দান করেছেন; আর তাঁর কাছেই পুনরুত্থান।',
    'I bear witness that there is no god but Allah alone without partner, and I bear witness that Muhammad is His servant and messenger.':
        'আমি সাক্ষ্য দিচ্ছি যে আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি একক, তাঁর কোনো শরিক নেই; এবং মুহাম্মদ তাঁর বান্দা ও রাসূল।',
    'O Allah, open for me the doors of Your mercy.':
        'হে আল্লাহ, আমার জন্য আপনার রহমতের দরজাগুলো খুলে দিন।',
    'O Allah, I ask You from Your bounty.':
        'হে আল্লাহ, আমি আপনার অনুগ্রহ প্রার্থনা করি।',
    'O Allah, make me among those who repent often and make me among those who purify themselves.':
        'হে আল্লাহ, আমাকে বেশি তাওবাকারীদের অন্তর্ভুক্ত করুন এবং আমাকে পবিত্রতা অর্জনকারীদের অন্তর্ভুক্ত করুন।',
    'May Allah have mercy on you.': 'আল্লাহ আপনার প্রতি দয়া করুন।',
    'May Allah guide you and correct your condition.':
        'আল্লাহ আপনাকে হিদায়াত দিন এবং আপনার অবস্থা সংশোধন করুন।',
    'Allah is sufficient for me. There is no god except Him. Upon Him I rely, and He is the Lord of the Mighty Throne.':
        'আল্লাহই আমার জন্য যথেষ্ট। তিনি ছাড়া কোনো উপাস্য নেই। আমি তাঁরই ওপর ভরসা করি, আর তিনি মহান আরশের রব।',
  };
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
