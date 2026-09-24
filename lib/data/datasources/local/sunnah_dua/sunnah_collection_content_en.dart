import '../../../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import 'surah_al_kahf_first_ten_arabic.dart';

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
  SunnahDuaContent(
    id: 'ayatul_kursi',
    title: 'Ayatul Kursi',
    subtitle: 'The greatest verse for faith and protection',
    points: [],
    practice:
        'Recite before sleeping. A separate narration also mentions reciting it after each obligatory prayer.',
    source: 'Surah Al-Baqarah 2:255',
    kind: SunnahDuaKind.quranAyah,
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ\nلَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ\nلَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ\nمَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ\nيَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ\nوَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ\nوَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ\nوَلَا يَئُودُهُ حِفْظُهُمَا ۚ\nوَهُوَ الْعَلِيُّ الْعَظِيمُ',
    pronunciation:
        "Allahu la ilaha illa huwa al-hayyul qayyum. La ta'khudhuhu sinatuw wala nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhal-ladhi yashfa'u indahu illa bi idhnih. Ya'lamu ma baina aidihim wa ma khalfahum. Wa la yuhituna bishai'im min ilmihi illa bima sha'. Wasi'a kursiyyuhus-samawati wal-ard. Wa la ya'uduhu hifdhuhuma. Wa huwal aliyyul azeem.",
    translation:
        'Allah—there is no deity except Him, the Ever-Living, the Sustainer of all existence. Neither drowsiness nor sleep overtakes Him. To Him belongs whatever is in the heavens and whatever is on the earth. Who can intercede with Him except by His permission? He knows what is before them and what is behind them. They encompass nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and their preservation does not tire Him. And He is the Most High, the Most Great.',
    benefits: [
      'Considered one of the greatest verses of the Quran.',
      "Contains the declaration of Allah's Tawheed and greatness.",
      "A means of protection by Allah's permission.",
      'Recommended in daily remembrance.',
    ],
    hadithReferences: [
      SunnahHadithReference(
        collection: 'Sahih al-Bukhari',
        reference: '2311',
        text:
            'Regarding recitation before sleep, Abu Hurairah reported that Allah appoints a guardian and Satan does not approach until morning.',
        grade: 'Authentic',
      ),
      SunnahHadithReference(
        collection: 'Sahih Muslim',
        reference: '810',
        text:
            "Ubayy ibn Ka'b reported that the Prophet asked which Quran verse was greatest, and he answered Ayatul Kursi.",
        grade: 'Authentic',
      ),
      SunnahHadithReference(
        collection: 'Bulugh al-Maram',
        reference: 'Book 2, Hadith 220',
        text:
            'A report from Abu Umamah mentions reciting Ayatul Kursi after each obligatory prayer.',
        grade: 'Authenticated by Ibn Hibban',
      ),
    ],
    authenticityNotes:
        'The verse is Quran. The listed virtues are limited to the cited narrations.',
    tags: [
      'ayatul kursi',
      'protection',
      'sleep',
      'morning adhkar',
      'evening adhkar',
      'quran',
      'tawheed',
    ],
  ),
  SunnahDuaContent(
    id: 'last_two_ayah_al_baqarah',
    title: 'Last Two Verses of Surah Al-Baqarah',
    subtitle: 'Faith, forgiveness and mercy before sleep',
    points: [],
    practice: 'Recite during the night.',
    source: 'Surah Al-Baqarah 2:285–286',
    kind: SunnahDuaKind.quranAyah,
    arabic:
        'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۚ\nكُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ ۚ\nلَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ ۚ\nوَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ\nغُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ\n\nلَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ\nلَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ\nرَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ\nرَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ\nرَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ\nوَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ\nأَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
    pronunciation:
        "Āmana r-rasūlu bimā unzila ilayhi mir rabbihi wal-mu'minūn. Kullun āmana billāhi wa malā'ikatihi wa kutubihi wa rusulih. Lā nufarriqu bayna aḥadim mir rusulih. Wa qālū sami'nā wa aṭa'nā; ghufrānaka rabbanā wa ilaykal-maṣīr.\n\nLā yukallifullāhu nafsan illā wus'ahā. Lahā mā kasabat wa 'alayhā maktasabat. Rabbanā lā tu'ākhidhnā in nasīnā aw akhṭa'nā. Rabbanā wa lā taḥmil 'alaynā iṣran kamā ḥamaltahu 'alal-ladhīna min qablinā. Rabbanā wa lā tuḥammilnā mā lā ṭāqata lanā bih. Wa'fu 'annā waghfir lanā warḥamnā. Anta mawlānā fanṣurnā 'alal-qawmil-kāfirīn.",
    translation:
        'The Messenger and the believers believe in what was revealed from his Lord. All believe in Allah, His angels, His books and His messengers. They say, “We hear and obey. Grant us Your forgiveness, our Lord; to You is the final destination.” Allah does not burden a soul beyond what it can bear. Our Lord, do not punish us if we forget or make a mistake. Do not burden us as You burdened those before us, nor with what we cannot bear. Pardon us, forgive us and have mercy upon us. You are our Protector, so help us against the disbelieving people.',
    benefits: [
      'A complete expression of faith and submission.',
      'Contains powerful supplications for forgiveness and mercy.',
      'Recommended for night recitation.',
    ],
    hadithReferences: [
      SunnahHadithReference(
        collection: 'Sahih Muslim',
        reference: '807a',
        text:
            'The Prophet said that whoever recites the last two verses of Surah Al-Baqarah at night, they will suffice him.',
        grade: 'Authentic',
      ),
    ],
    authenticityNotes: 'The recitation is established in Sahih Muslim.',
    tags: ['al baqarah', 'night', 'protection', 'dua', 'forgiveness', 'quran'],
  ),
  SunnahDuaContent(
    id: 'last_three_ayah_al_hashr',
    title: 'Last Three Verses of Surah Al-Hashr',
    subtitle: "Reflect on Allah's beautiful names and greatness",
    points: [],
    practice:
        'Recite for Quranic reflection. Do not attach a guaranteed morning or evening reward to this practice.',
    source: 'Surah Al-Hashr 59:22–24',
    kind: SunnahDuaKind.quranAyah,
    arabic:
        'هُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ ۖ\nعَالِمُ الْغَيْبِ وَالشَّهَادَةِ ۖ\nهُوَ الرَّحْمَٰنُ الرَّحِيمُ\n\nهُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ\nالْمَلِكُ الْقُدُّوسُ السَّلَامُ الْمُؤْمِنُ الْمُهَيْمِنُ الْعَزِيزُ الْجَبَّارُ الْمُتَكَبِّرُ ۚ\nسُبْحَانَ اللَّهِ عَمَّا يُشْرِكُونَ\n\nهُوَ اللَّهُ الْخَالِقُ الْبَارِئُ الْمُصَوِّرُ ۖ\nلَهُ الْأَسْمَاءُ الْحُسْنَىٰ ۚ\nيُسَبِّحُ لَهُ مَا فِي السَّمَاوَاتِ وَالْأَرْضِ ۖ\nوَهُوَ الْعَزِيزُ الْحَكِيمُ',
    pronunciation:
        "Huwa Allāhulladhī lā ilāha illā huwa, 'ālimul-ghaybi wash-shahādah, huwar-raḥmānur-raḥīm.\n\nHuwa Allāhulladhī lā ilāha illā huwa, al-malikul-quddūsus-salāmul-mu'minul-muhayminul-'azīzul-jabbārul-mutakabbir. Subḥānallāhi 'ammā yushrikūn.\n\nHuwa Allāhul-khāliqul-bāri'ul-muṣawwir, lahul-asmā'ul-ḥusnā. Yusabbiḥu lahū mā fis-samāwāti wal-arḍ, wa huwal-'azīzul-ḥakīm.",
    translation:
        'He is Allah, other than whom there is no deity, Knower of the unseen and the witnessed—the Most Merciful, the Most Compassionate. He is the King, the Pure, the Source of Peace, the Bestower of Security, the Overseer, the Almighty, the Compeller and the Supreme. He is the Creator, the Originator and the Fashioner. To Him belong the Most Beautiful Names. Whatever is in the heavens and earth glorifies Him. He is the Almighty, the Wise.',
    benefits: [
      "Contains many of Allah's Most Beautiful Names.",
      "Encourages reflection on Allah's greatness and attributes.",
      'Strengthens awareness of Tawheed.',
    ],
    hadithReferences: [
      SunnahHadithReference(
        collection: 'Jami at-Tirmidhi',
        reference: '2922',
        text:
            'A narration mentions a special morning virtue for these verses, but hadith scholars differ over its authenticity.',
        grade: 'Weak (Da’if)',
      ),
    ],
    authenticityNotes:
        'The Quranic verses are authentic. The commonly circulated narration assigning a special morning reward has been graded weak by a number of scholars.',
    tags: [
      'hashr',
      'Allah names',
      'morning adhkar',
      'evening adhkar',
      'quran',
      'tawheed',
    ],
  ),
  SunnahDuaContent(
    id: 'surah_talaq_ayah_2_3',
    title: 'Surah At-Talaq Ayah 2–3',
    subtitle: 'Taqwa, relief and complete reliance upon Allah',
    points: [],
    practice:
        'Recite for reflection when seeking patience, relief and stronger trust in Allah.',
    source: 'Surah At-Talaq 65:2–3 (excerpt)',
    kind: SunnahDuaKind.quranAyah,
    arabic:
        'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا\n\nوَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ ۚ\nوَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ ۚ\nإِنَّ اللَّهَ بَالِغُ أَمْرِهِ ۚ\nقَدْ جَعَلَ اللَّهُ لِكُلِّ شَيْءٍ قَدْرًا',
    pronunciation:
        "Wa may-yattaqillāha yaj'al lahū makhrajā.\n\nWa yarzuqhu min ḥaythu lā yaḥtasib. Wa may-yatawakkal 'alallāhi fahuwa ḥasbuh. Innallāha bālighu amrih. Qad ja'alallāhu likulli shay'in qadrā.",
    translation:
        'Whoever fears Allah, He will make for him a way out and provide for him from where he does not expect. Whoever relies upon Allah, He is sufficient for him. Allah will accomplish His purpose. Allah has set a measure for everything.',
    benefits: [
      "Teaches the relationship between taqwa and Allah's help.",
      'Encourages complete reliance upon Allah.',
      'Gives hope during difficulty and uncertainty.',
      'Reminds us that Allah controls provision and outcomes.',
    ],
    authenticityNotes:
        'These are Quranic verses. No specific authentic hadith establishes a fixed count or ritual recitation; avoid presenting them as a guaranteed formula.',
    tags: ['tawakkul', 'rizq', 'hardship', 'taqwa', 'quran', 'relief'],
  ),
  SunnahDuaContent(
    id: 'aal_imran_ayah_26_27',
    title: 'Surah Aal-Imran Ayah 26–27',
    subtitle: "A Quranic supplication affirming Allah's sovereignty",
    points: [],
    practice: 'Recite for reflection, gratitude and strengthening faith.',
    source: 'Surah Aal-Imran 3:26–27',
    kind: SunnahDuaKind.quranAyah,
    arabic:
        'قُلِ اللَّهُمَّ مَالِكَ الْمُلْكِ\nتُؤْتِي الْمُلْكَ مَن تَشَاءُ\nوَتَنزِعُ الْمُلْكَ مِمَّن تَشَاءُ\nوَتُعِزُّ مَن تَشَاءُ\nوَتُذِلُّ مَن تَشَاءُ ۖ\nبِيَدِكَ الْخَيْرُ ۖ\nإِنَّكَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ\n\nتُولِجُ اللَّيْلَ فِي النَّهَارِ\nوَتُولِجُ النَّهَارَ فِي اللَّيْلِ ۖ\nوَتُخْرِجُ الْحَيَّ مِنَ الْمَيِّتِ\nوَتُخْرِجُ الْمَيِّتَ مِنَ الْحَيِّ ۖ\nوَتَرْزُقُ مَن تَشَاءُ بِغَيْرِ حِسَابٍ',
    pronunciation:
        "Qulillāhumma mālikal-mulki tu'til-mulka man tashā'u wa tanzi'ul-mulka mimman tashā'u, wa tu'izzu man tashā'u wa tudhillu man tashā'. Biyadikal-khayr. Innaka 'alā kulli shay'in qadīr.\n\nTūlijul-layla fin-nahāri wa tūlijun-nahāra fil-layl. Wa tukhrijul-ḥayya minal-mayyiti wa tukhrijul-mayyita minal-ḥayy. Wa tarzuqu man tashā'u bighayri ḥisāb.",
    translation:
        'Say, “O Allah, Owner of all sovereignty, You give authority to whom You will and take it from whom You will. You honor whom You will and humble whom You will. In Your hand is all good. You are capable of all things. You merge night into day and day into night. You bring the living from the dead and the dead from the living. You provide for whom You will without limit.”',
    benefits: [
      "A powerful declaration of Allah's absolute sovereignty.",
      'Teaches humility and dependence upon Allah.',
      'Reminds believers that honor, power and provision belong to Allah.',
      'A Quranic supplication.',
    ],
    authenticityNotes:
        'These are Quranic verses. No specific authentic hadith establishes a fixed reward or practice for them; present them as Quranic guidance, not a guaranteed formula.',
    tags: ['dua', 'Allah power', 'rizq', 'gratitude', 'quran', 'tawheed'],
  ),
  SunnahDuaContent(
    id: 'surah_al_kahf_first_10_ayah',
    title: 'First 10 Ayahs of Surah Al-Kahf',
    subtitle: 'Faith and protection from the Dajjal’s trial',
    points: [],
    practice:
        'Memorize the first ten verses and reflect on their meanings regularly. Reports about Friday recitation concern the full surah, not only these ten verses.',
    source: 'Surah Al-Kahf 18:1–10',
    kind: SunnahDuaKind.quranAyah,
    arabic: surahAlKahfFirstTenArabic,
    pronunciation:
        "1. Alhamdu lillahil-ladhi anzala 'ala abdihil-kitaba wa lam yaj'al lahu 'iwaja.\n\n"
        "2. Qayyiman liyundhira ba'san shadeedam mil-ladunhu wa yubashshiral-mu'mineenal-ladheena ya'malunas-salihat anna lahum ajran hasana.\n\n"
        '3. Makitheena feehi abada.\n\n'
        "4. Wa yundhiral-ladheena qalut-takhadhallahu walada.\n\n"
        "5. Ma lahum bihi min ilmin wa la li aba'ihim. Kaburat kalimatan takhruju min afwahihim. In yaquluna illa kadhiba.\n\n"
        "6. Fala'allaka bakhi'un nafsaka 'ala atharihim il-lam yu'minu bihadhal-hadeethi asafa.\n\n"
        "7. Inna ja'alna ma 'alal-ardi zeenatal laha linabluwahum ayyuhum ahsanu amala.\n\n"
        "8. Wa inna laja'iluna ma 'alaiha sa'eedan juruza.\n\n"
        "9. Am hasibta anna ashabal-kahfi war-raqeemi kanoo min ayatina 'ajaba.\n\n"
        '10. Idh awal-fityatu ilal-kahfi fa qaloo rabbana atina mil-ladunka rahmatan wa hayyi lana min amrina rashada.',
    translation:
        '1. All praise is for Allah who has sent down upon His servant the Book and has not made in it any crookedness.\n\n'
        '2. A perfectly straight Book, to warn of a severe punishment from Him and to give good news to the believers who do righteous deeds that they will have an excellent reward.\n\n'
        '3. They will remain in it forever.\n\n'
        '4. And to warn those who say, “Allah has taken a son.”\n\n'
        '5. They have no knowledge of it, nor did their forefathers. Terrible is the word that comes out of their mouths. They speak nothing but lies.\n\n'
        '6. Perhaps you would destroy yourself with grief over them if they do not believe in this message.\n\n'
        '7. Indeed, We have made whatever is on the earth as an adornment for it so that We may test them as to which of them is best in deeds.\n\n'
        '8. And indeed, We will make whatever is upon it into barren ground.\n\n'
        '9. Or do you think that the companions of the cave and the inscription were among Our signs a wonder?\n\n'
        '10. When the young men retreated to the cave and said: “Our Lord, grant us mercy from Yourself and provide for us guidance in our affair.”',
    benefits: [
      'Memorizing the first ten verses is reported as protection from the Dajjal’s trial.',
      'Teaches steadfastness of faith during trials.',
      'Contains the cave companions’ supplication for Allah’s mercy and guidance.',
      'Strengthens understanding of Tawheed and reliance upon Allah.',
    ],
    hadithReferences: [
      SunnahHadithReference(
        collection: 'Sahih Muslim',
        reference: '809a',
        text:
            'The Prophet ﷺ said that whoever memorizes the first ten verses of Surah Al-Kahf will be protected from the Dajjal.',
        grade: 'Authentic',
      ),
    ],
    authenticityNotes:
        'These are Quranic verses. Sahih Muslim 809a establishes the virtue of memorizing the first ten verses for protection from the Dajjal; it does not specify a Friday practice for these ten verses.',
    tags: [
      'surah al kahf',
      'dajjal',
      'friday',
      'protection',
      'faith',
      'quran',
      'dua',
      'tawakkul',
    ],
  ),
];
