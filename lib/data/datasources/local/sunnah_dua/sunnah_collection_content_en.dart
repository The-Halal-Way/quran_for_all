import '../../../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import 'quran_recitation_arabic.dart';
import 'surah_al_kahf_first_ten_arabic.dart';

const List<SunnahDuaContent> sunnahCollectionContentEn = [
  SunnahDuaContent(
    id: 'ayatul_kursi',
    title: 'Ayatul Kursi',
    subtitle: 'The greatest verse for faith and protection',
    points: [],
    practice:
        'Recite before sleeping. A separate narration also mentions reciting it after each obligatory prayer.',
    source: 'Surah Al-Baqarah 2:255',
    kind: SunnahDuaKind.quranAyah,
    arabic: ayatulKursiArabic,
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
    arabic: lastTwoAyahAlBaqarahArabic,
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
    arabic: lastThreeAyahAlHashrArabic,
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
    arabic: surahTalaqAyahTwoThreeArabic,
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
    arabic: aalImranAyahTwentySixTwentySevenArabic,
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
