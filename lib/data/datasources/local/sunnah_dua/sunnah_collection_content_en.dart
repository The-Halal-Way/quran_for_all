import '../../../../domain/entities/sunnah_dua/sunnah_dua_content.dart';

const List<SunnahDuaContent> sunnahCollectionContentEn = [
  SunnahDuaContent(
    id: 'morning_evening',
    title: 'Morning & evening',
    subtitle: 'Remember Allah at both ends of the day',
    points: [
      'Recite Subhanallahi wa bihamdihi 100 times in the morning.',
      'Recite it 100 times in the evening.',
    ],
    practice:
        'These counts are reported in the cited hadith. This card contains one remembrance from the wider morning and evening adhkar.',
    source: 'Sahih Muslim 2692',
    kind: SunnahDuaKind.dhikr,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    pronunciation: 'Subḥānallāhi wa biḥamdih',
    translation:
        'Allah is free from imperfection, and all praise belongs to Him.',
  ),
  SunnahDuaContent(
    id: 'seeking_forgiveness',
    title: 'Seeking forgiveness',
    subtitle: 'Return to Allah throughout your day',
    points: [
      'Seek forgiveness sincerely and regularly.',
      'The Prophet reported seeking forgiveness 100 times a day.',
    ],
    practice:
        'The short wording below means asking Allah for forgiveness. The source establishes the daily practice, rather than prescribing this as its only wording.',
    source: 'Sahih Muslim 2702a',
    kind: SunnahDuaKind.dhikr,
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    pronunciation: 'Astaghfirullāh',
    translation: 'I ask Allah to forgive me.',
  ),
  SunnahDuaContent(
    id: 'difficulty',
    title: 'In difficulty',
    subtitle: 'Turn to Allah when you feel distressed',
    points: [
      'Recite these words in a time of distress.',
      'Reflect on the greatness and forbearance of Allah.',
    ],
    practice:
        'This wording is reported from the Prophet for distress. No repetition count is specified in this narration.',
    source: 'Sahih al-Bukhari 6346',
    kind: SunnahDuaKind.dua,
    arabic:
        'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
    pronunciation:
        'Lā ilāha illallāhul-ʿAẓīmul-Ḥalīm, lā ilāha illallāhu rabbul-ʿarshil-ʿaẓīm, lā ilāha illallāhu rabbus-samāwāti wa rabbul-arḍi wa rabbul-ʿarshil-karīm',
    translation:
        'None deserves worship except Allah, the Magnificent, the Forbearing. None deserves worship except Allah, Lord of the mighty Throne. None deserves worship except Allah, Lord of the heavens, the earth, and the noble Throne.',
  ),
  SunnahDuaContent(
    id: 'gratitude',
    title: 'Gratitude',
    subtitle: 'Ask for a grateful heart and good deeds',
    points: [
      'Ask Allah to help you appreciate His blessings to you and your parents.',
      'Ask for deeds that please Him and the company of His righteous servants.',
    ],
    practice:
        'This is the supplication of Sulayman from Quran 27:19. The Arabic is the supplication portion of the verse.',
    source: 'Quran 27:19',
    kind: SunnahDuaKind.dua,
    arabic:
        'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَى وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ',
    pronunciation:
        'Rabbi awziʿnī an ashkura niʿmatakallatī anʿamta ʿalayya wa ʿalā wālidayya wa an aʿmala ṣāliḥan tarḍāhu wa adkhilnī biraḥmatika fī ʿibādikaṣ-ṣāliḥīn',
    translation:
        'My Lord, enable me to thank You for the favour You have given me and my parents, and to do good that pleases You. By Your mercy, include me among Your righteous servants.',
  ),
  SunnahDuaContent(
    id: 'siyam_sunnahs',
    title: 'Sunnah fasting',
    subtitle: 'Learn the practices of voluntary fasting',
    points: [
      'The Sunnah includes taking suhur and breaking the fast promptly when sunset is confirmed.',
      'Monday fasting and six days of Shawwal are reported voluntary practices.',
      'Fasting also calls for restraint in speech and behaviour.',
    ],
    practice:
        'Voluntary fasting is for those able to undertake it. This is a practice reminder; the Arabic is a hadith statement, not a supplication to recite.',
    source: 'Sahih al-Bukhari 1894, 1923, 1957; Sahih Muslim 1162b, 1164a',
    kind: SunnahDuaKind.sunnah,
    arabic: 'الصِّيَامُ جُنَّةٌ',
    pronunciation: 'Aṣ-ṣiyāmu junnah',
    translation: 'Fasting is a shield.',
  ),
  SunnahDuaContent(
    id: 'after_salah',
    title: 'Dhikr after salah',
    subtitle: 'Remember Allah after completing prayer',
    points: [
      'Say Subhanallah 33 times, Alhamdulillah 33 times, and Allahu Akbar 33 times.',
      'Complete the hundred with the final declaration shown below, once.',
    ],
    practice:
        'This card follows the 33/33/33 plus one form reported in Sahih Muslim 597a.',
    source: 'Sahih Muslim 597a',
    kind: SunnahDuaKind.dhikr,
    arabic:
        'سُبْحَانَ اللَّهِ\nالْحَمْدُ لِلَّهِ\nاللَّهُ أَكْبَرُ\nلَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    pronunciation:
        'Subḥānallāh.\nAlḥamdulillāh.\nAllāhu akbar.\nLā ilāha illallāhu waḥdahu lā sharīka lah, lahul-mulku wa lahul-ḥamdu wa huwa ʿalā kulli shayʾin qadīr.',
    translation:
        'Allah is free from imperfection. All praise belongs to Allah. Allah is greatest. None deserves worship except Allah alone, without partner. Sovereignty and praise belong to Him, and He has power over everything.',
  ),
  SunnahDuaContent(
    id: 'salawat',
    title: 'Salawat upon the Prophet',
    subtitle: 'Send blessings with words taught by the Prophet',
    points: [
      'Recite this reported form of salawat.',
      'Read with attention to its meaning.',
    ],
    practice:
        'The wording follows Sahih al-Bukhari 6357. It is one reported form of salawat.',
    source: 'Sahih al-Bukhari 6357; Sahih Muslim 408',
    kind: SunnahDuaKind.dhikr,
    arabic:
        'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ، اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ',
    pronunciation:
        'Allāhumma ṣalli ʿalā Muḥammadin wa ʿalā āli Muḥammadin, kamā ṣallayta ʿalā āli Ibrāhīma, innaka Ḥamīdun Majīd. Allāhumma bārik ʿalā Muḥammadin wa ʿalā āli Muḥammadin, kamā bārakta ʿalā āli Ibrāhīma, innaka Ḥamīdun Majīd.',
    translation:
        'O Allah, bestow Your favour on Muhammad and his family, as You bestowed it on the family of Ibrahim. You are worthy of praise and full of glory. O Allah, grant blessings to Muhammad and his family, as You blessed the family of Ibrahim. You are worthy of praise and full of glory.',
  ),
  SunnahDuaContent(
    id: 'when_angry',
    title: 'When feeling angry',
    subtitle: 'Seek refuge in Allah',
    points: ['When anger rises, seek refuge in Allah from Satan.'],
    practice: 'The Prophet taught these words when a man became angry.',
    source: 'Sahih al-Bukhari 6115',
    kind: SunnahDuaKind.dua,
    arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
    pronunciation: 'Aʿūdhu billāhi minash-shayṭānir-rajīm',
    translation: 'I seek protection with Allah from Satan, the rejected one.',
  ),
  SunnahDuaContent(
    id: 'during_loss',
    title: 'During loss or hardship',
    subtitle: 'Ask Allah for reward and a better outcome',
    points: [
      'Remember that we belong to Allah and return to Him.',
      'Ask Him to reward you through the hardship and replace it with something better.',
    ],
    practice:
        'This supplication is reported for calamity in the narration of Umm Salamah.',
    source: 'Sahih Muslim 918a',
    kind: SunnahDuaKind.dua,
    arabic:
        'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا',
    pronunciation:
        'Innā lillāhi wa innā ilayhi rājiʿūn. Allāhummaʾjurnī fī muṣībatī wa akhlif lī khayran minhā.',
    translation:
        'We belong to Allah and will return to Him. O Allah, reward me in my hardship and give me something better in its place.',
  ),
  SunnahDuaContent(
    id: 'after_fajr',
    title: 'After Fajr',
    subtitle: 'Ask for a beneficial day',
    points: [
      'After completing Fajr, ask for beneficial knowledge, wholesome provision, and accepted deeds.',
    ],
    practice:
        'The narration places this supplication after the salam of the morning prayer.',
    source: 'Sunan Ibn Majah 925; sahih (Darussalam)',
    kind: SunnahDuaKind.dua,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا طَيِّبًا وَعَمَلًا مُتَقَبَّلًا',
    pronunciation:
        'Allāhumma innī asʾaluka ʿilman nāfiʿan wa rizqan ṭayyiban wa ʿamalan mutaqabbalā',
    translation:
        'O Allah, grant me knowledge that benefits, good provision, and deeds You accept.',
    phase: SunnahDayPhase.morning,
  ),
  SunnahDuaContent(
    id: 'ending_gathering',
    title: 'Ending a gathering',
    subtitle: 'Close your conversation with remembrance',
    points: [
      'Before leaving a gathering, praise Allah and seek His forgiveness.',
    ],
    practice: 'This supplication is reported for the close of a gathering.',
    source: 'Jami at-Tirmidhi 3433; sahih (Darussalam)',
    kind: SunnahDuaKind.dua,
    arabic:
        'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
    pronunciation:
        'Subḥānaka Allāhumma wa biḥamdika, ashhadu an lā ilāha illā anta, astaghfiruka wa atūbu ilayk',
    translation:
        'O Allah, You are free from imperfection and praise belongs to You. I testify that none deserves worship except You. I seek Your forgiveness and turn to You in repentance.',
  ),
  SunnahDuaContent(
    id: 'bedtime_dhikr',
    title: 'Dhikr before sleep',
    subtitle: 'End the day remembering Allah',
    points: [
      'At bedtime, say Subhanallah 33 times.',
      'Say Alhamdulillah 33 times and Allahu Akbar 34 times.',
    ],
    practice: 'This follows the bedtime counts reported in Sahih Muslim 2727a.',
    source: 'Sahih Muslim 2727a',
    kind: SunnahDuaKind.dhikr,
    arabic: 'سُبْحَانَ اللَّهِ\nالْحَمْدُ لِلَّهِ\nاللَّهُ أَكْبَرُ',
    pronunciation: 'Subḥānallāh.\nAlḥamdulillāh.\nAllāhu akbar.',
    translation:
        'Allah is free from imperfection. All praise belongs to Allah. Allah is greatest.',
    phase: SunnahDayPhase.evening,
  ),
];
