import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';

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

  /// Localizes optional source / usage notes while preserving null.
  String? localizedNote(BuildContext context) {
    final value = note;
    if (value == null || !_isBangla(context)) return value;
    return _noteBnMap[value] ?? value;
  }

  static const Map<String, String> _noteBnMap = {
    'Source: Quran 20:114. Supplication from the cited passage.':
        'সূত্র: কুরআন 20:114। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 20:25-28. Supplication from the cited passage. The prayer of Musa; no exam-specific ritual or count is implied.':
        'সূত্র: কুরআন 20:25-28। উল্লিখিত আয়াত থেকে দোয়ার অংশ। এটি মূসা (আ.)-এর দোয়া; পরীক্ষার জন্য নির্দিষ্ট কোনো রীতি বা সংখ্যা বোঝানো হয়নি।',
    'Source: Quran 18:10. Supplication from the cited passage.':
        'সূত্র: কুরআন 18:10। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 17:24. Supplication from the cited passage.':
        'সূত্র: কুরআন 17:24। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 14:41. Supplication from the cited passage.':
        'সূত্র: কুরআন 14:41। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 25:74. Supplication from the cited passage.':
        'সূত্র: কুরআন 25:74। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 3:38. Supplication from the cited passage.':
        'সূত্র: কুরআন 3:38। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 23:118. Supplication from the cited passage.':
        'সূত্র: কুরআন 23:118। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 7:23. Supplication from the cited passage.':
        'সূত্র: কুরআন 7:23। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 21:87. Supplication from the cited passage.':
        'সূত্র: কুরআন 21:87। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 3:8. Supplication from the cited passage.':
        'সূত্র: কুরআন 3:8। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 18:24. Supplication from the cited passage.':
        'সূত্র: কুরআন 18:24। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 28:24. Supplication from the cited passage.':
        'সূত্র: কুরআন 28:24। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 2:201. Supplication from the cited passage.':
        'সূত্র: কুরআন 2:201। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 2:127. Supplication from the cited passage.':
        'সূত্র: কুরআন 2:127। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 14:40. Supplication from the cited passage.':
        'সূত্র: কুরআন 14:40। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 2:250. Supplication from the cited passage. This is the opening portion of the supplication, not the whole verse.':
        'সূত্র: কুরআন 2:250। উল্লিখিত আয়াত থেকে দোয়ার অংশ। এটি দোয়ার শুরুর অংশ, সম্পূর্ণ আয়াত নয়।',
    'Source: Quran 7:126. Supplication from the cited passage. A prayer to remain faithful throughout life.':
        'সূত্র: কুরআন 7:126। উল্লিখিত আয়াত থেকে দোয়ার অংশ। সারা জীবন ঈমানের ওপর অবিচল থাকার দোয়া।',
    'Source: Quran 23:97-98. Supplication from the cited passage.':
        'সূত্র: কুরআন 23:97-98। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 28:21. Supplication from the cited passage.':
        'সূত্র: কুরআন 28:21। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 66:8. Supplication from the cited passage.':
        'সূত্র: কুরআন 66:8। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 3:194. Supplication from the cited passage.':
        'সূত্র: কুরআন 3:194। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 21:83. Supplication from the cited passage.':
        'সূত্র: কুরআন 21:83। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Quran 59:10. Supplication from the cited passage.':
        'সূত্র: কুরআন 59:10। উল্লিখিত আয়াত থেকে দোয়ার অংশ।',
    'Source: Riyad as-Salihin 1468 (reported by Muslim).':
        'সূত্র: রিয়াদুস সালিহিন 1468 (মুসলিম বর্ণিত)।',
    'Source: Sahih al-Bukhari 1032. The wording shown follows the Arabic text of this narration.':
        'সূত্র: সহিহ আল-বুখারি 1032। এখানে এই বর্ণনার আরবি পাঠ অনুসরণ করা হয়েছে।',
    'Source: Sahih al-Bukhari 846.': 'সূত্র: সহিহ আল-বুখারি 846।',
    'Source: Sahih Muslim 2042a. A supplication for those who have hosted you.':
        'সূত্র: সহিহ মুসলিম 2042a। যাঁরা আপনাকে আপ্যায়ন করেছেন, তাঁদের জন্য দোয়া।',
    'Source: Sahih al-Bukhari 5743. The Arabic follows this narration and uses the masculine singular pronoun.':
        'সূত্র: সহিহ আল-বুখারি 5743। আরবি পাঠে এই বর্ণনা অনুসারে পুরুষবাচক একবচন সর্বনাম ব্যবহৃত হয়েছে।',
    'Source: Sahih al-Bukhari 3616.': 'সূত্র: সহিহ আল-বুখারি 3616।',
    'Source: Sahih Muslim 2708a. Recite when settling at a stopping place.':
        'সূত্র: সহিহ মুসলিম 2708a। কোনো স্থানে অবস্থান নেওয়ার সময় পড়ুন।',
    'Source: Sunan Ibn Majah 3850; graded sahih by Darussalam. Taught to Aishah for Laylat al-Qadr; no repetition count is added here.':
        'সূত্র: সুনান ইবন মাজাহ 3850; দারুসসালামের মূল্যায়নে সহিহ। লাইলাতুল কদরের জন্য আয়িশা (রা.)-কে শেখানো দোয়া; এখানে পড়ার কোনো সংখ্যা যোগ করা হয়নি।',
    'You can also say: As-salāmu ʿalaykum — Peace be upon you.':
        'আরও বলতে পারেন: আসসালামু আলাইকুম — আপনার ওপর শান্তি বর্ষিত হোক।',
  };

  static const Map<String, String> _titleBnMap = {
    // Additional daily duas.
    'Increase in knowledge': 'জ্ঞান বৃদ্ধির দোয়া',
    'Ease and clarity in speech': 'কাজ সহজ হওয়া ও স্পষ্ট কথার দোয়া',
    'Mercy and a sound course': 'রহমত ও সঠিক পথের দোয়া',
    'Mercy for parents': 'মা-বাবার জন্য রহমতের দোয়া',
    'Forgiveness for family and believers':
        'পরিবার ও মুমিনদের জন্য ক্ষমার দোয়া',
    'A righteous family': 'নেক পরিবারের দোয়া',
    'Good offspring': 'সৎ সন্তানের দোয়া',
    'Forgiveness and mercy': 'ক্ষমা ও রহমতের দোয়া',
    'Repentance of Adam and Hawwa': 'আদম ও হাওয়া (আ.)-এর তাওবার দোয়া',
    'Supplication of Yunus': 'ইউনুস (আ.)-এর দোয়া',
    'Steadfast hearts': 'অন্তরকে সঠিক পথে রাখার দোয়া',
    'Hope for better guidance': 'আরও সঠিক পথের আশা',
    'In need of goodness': 'কল্যাণের মুখাপেক্ষী বান্দার দোয়া',
    'Goodness in this life and the next': 'দুনিয়া ও আখিরাতের কল্যাণ',
    'Acceptance of good deeds': 'নেক কাজ কবুলের দোয়া',
    'Consistency in prayer': 'নিয়মিত সালাতের দোয়া',
    'Patience and firm steps': 'ধৈর্য ও অবিচলতার দোয়া',
    'Patience and a faithful end': 'ধৈর্য ও ঈমানের সঙ্গে শেষ পরিণতি',
    'Refuge from evil promptings': 'শয়তানের প্ররোচনা থেকে আশ্রয়',
    'Safety from wrongdoing people': 'অত্যাচারী লোকদের থেকে নিরাপত্তা',
    'Complete our light': 'পূর্ণ নূর ও ক্ষমার দোয়া',
    'Hope on the Day of Resurrection': 'কিয়ামতের দিনের কল্যাণের আশা',
    'Supplication of Ayyub': 'আইয়ুব (আ.)-এর দোয়া',
    'A heart free of resentment': 'বিদ্বেষমুক্ত অন্তরের দোয়া',
    'Guidance and contentment': 'হিদায়াত ও অমুখাপেক্ষিতার দোয়া',
    'When rain falls': 'বৃষ্টি নামলে',
    'After rainfall': 'বৃষ্টির পরে',
    'Prayer for a host': 'আপ্যায়নকারীর জন্য দোয়া',
    'Asking Allah for healing': 'আরোগ্যের জন্য দোয়া',
    'Reassuring someone who is ill': 'অসুস্থ ব্যক্তিকে সান্ত্বনা',
    'When stopping at a place': 'কোনো স্থানে অবস্থান করলে',
    'Pardon on Laylat al-Qadr': 'লাইলাতুল কদরে ক্ষমার দোয়া',

    // Original entries.
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
    // Additional daily duas.
    'Rabbi zidnī ʿilmā': 'রব্বি যিদনি ইলমা',
    'Rabbishraḥ lī ṣadrī, wa yassir lī amrī, waḥlul ʿuqdatan min lisānī, yafqahū qawlī':
        'রব্বিশরাহ লি সদরি, ওয়া ইয়াসসির লি আমরি, ওয়াহলুল উকদাতাম মিল লিসানি, ইয়াফকাহু কাওলি',
    'Rabbanā ātinā min ladunka raḥmatan wa hayyiʾ lanā min amrinā rashadā':
        'রব্বানা আতিনা মিল লাদুনকা রাহমাতাও ওয়া হাইয়ি লানা মিন আমরিনা রাশাদা',
    'Rabbirḥamhumā kamā rabbayānī ṣaghīrā':
        'রব্বিরহামহুমা কামা রব্বাইয়ানি সগিরা',
    'Rabbanaghfir lī wa liwālidayya wa lil-muʾminīna yawma yaqūmul-ḥisāb':
        'রব্বানাগফির লি ওয়া লিওয়ালিদাইয়্যা ওয়া লিল মুমিনিনা ইয়াওমা ইয়াকুমুল হিসাব',
    'Rabbanā hab lanā min azwājinā wa dhurriyyātinā qurrata aʿyunin wajʿalnā lil-muttaqīna imāmā':
        'রব্বানা হাব লানা মিন আযওয়াজিনা ওয়া যুররিয়্যাতিনা কুররাতা আইয়ুনিও ওয়াজআলনা লিল মুত্তাকিনা ইমামা',
    'Rabbi hab lī min ladunka dhurriyyatan ṭayyibatan innaka samīʿud-duʿāʾ':
        'রব্বি হাব লি মিল লাদুনকা যুররিয়্যাতান তাইয়িবাতান ইন্নাকা সামিউদ দুআ',
    'Rabbighfir warḥam wa anta khayrur-rāḥimīn':
        'রব্বিগফির ওয়ারহাম ওয়া আনতা খাইরুর রাহিমিন',
    'Rabbanā ẓalamnā anfusanā wa in lam taghfir lanā wa tarḥamnā lanakūnanna minal-khāsirīn':
        'রব্বানা যলামনা আনফুসানা ওয়া ইল লাম তাগফির লানা ওয়া তারহামনা লানাকুনান্না মিনাল খাসিরিন',
    'Lā ilāha illā anta subḥānaka innī kuntu minaẓ-ẓālimīn':
        'লা ইলাহা ইল্লা আনতা সুবহানাকা ইন্নি কুনতু মিনায যলিমিন',
    'Rabbanā lā tuzigh qulūbanā baʿda idh hadaytanā wa hab lanā min ladunka raḥmatan innaka antal-Wahhāb':
        'রব্বানা লা তুযিগ কুলুবানা বাদা ইয হাদাইতানা ওয়া হাব লানা মিল লাদুনকা রাহমাতান ইন্নাকা আনতাল ওয়াহহাব',
    'ʿAsā an yahdiyani rabbī li-aqraba min hādhā rashadā':
        'আসা আই ইয়াহদিয়ানি রব্বি লিআকরাবা মিন হাযা রাশাদা',
    'Rabbi innī limā anzalta ilayya min khayrin faqīr':
        'রব্বি ইন্নি লিমা আনযালতা ইলাইয়্যা মিন খাইরিন ফাকির',
    'Rabbanā ātinā fid-dunyā ḥasanatan wa fil-ākhirati ḥasanatan wa qinā ʿadhāban-nār':
        'রব্বানা আতিনা ফিদ দুনইয়া হাসানাতাও ওয়া ফিল আখিরাতি হাসানাতাও ওয়া কিনা আযাবান নার',
    'Rabbanā taqabbal minnā innaka antas-Samīʿul-ʿAlīm':
        'রব্বানা তাকাব্বাল মিন্না ইন্নাকা আনতাস সামিউল আলিম',
    'Rabbijʿalnī muqīmaṣ-ṣalāti wa min dhurriyyatī rabbanā wa taqabbal duʿāʾ':
        'রব্বিজআলনি মুকিমাস সালাতি ওয়া মিন যুররিয়্যাতি রব্বানা ওয়া তাকাব্বাল দুআ',
    'Rabbanā afrigh ʿalaynā ṣabran wa thabbit aqdāmanā':
        'রব্বানা আফরিগ আলাইনা সবরাও ওয়া সাব্বিত আকদামানা',
    'Rabbanā afrigh ʿalaynā ṣabran wa tawaffanā muslimīn':
        'রব্বানা আফরিগ আলাইনা সবরাও ওয়া তাওয়াফফানা মুসলিমিন',
    'Rabbi aʿūdhu bika min hamazātish-shayāṭīn, wa aʿūdhu bika rabbi an yaḥḍurūn':
        'রব্বি আউযু বিকা মিন হামাযাতিশ শাইয়াতিন, ওয়া আউযু বিকা রব্বি আই ইয়াহদুরুন',
    'Rabbi najjinī minal-qawmiẓ-ẓālimīn': 'রব্বি নাজ্জিনি মিনাল কাওমিয যলিমিন',
    'Rabbanā atmim lanā nūranā waghfir lanā innaka ʿalā kulli shayʾin qadīr':
        'রব্বানা আতমিম লানা নুরানা ওয়াগফির লানা ইন্নাকা আলা কুল্লি শাইইন কাদির',
    'Rabbanā wa ātinā mā waʿadtanā ʿalā rusulika wa lā tukhzinā yawmal-qiyāmati innaka lā tukhliful-mīʿād':
        'রব্বানা ওয়া আতিনা মা ওয়াআদতানা আলা রুসুলিকা ওয়া লা তুখযিনা ইয়াওমাল কিয়ামাতি ইন্নাকা লা তুখলিফুল মিআদ',
    'Annī massaniyaḍ-ḍurru wa anta arḥamur-rāḥimīn':
        'আন্নি মাসসানিয়াদ দুররু ওয়া আনতা আরহামুর রাহিমিন',
    'Rabbanaghfir lanā wa li-ikhwāninalladhīna sabaqūnā bil-īmāni wa lā tajʿal fī qulūbinā ghillan lilladhīna āmanū rabbanā innaka raʾūfun raḥīm':
        'রব্বানাগফির লানা ওয়া লিইখওয়ানিনাল্লাযিনা সাবাকুনা বিল ইমানি ওয়া লা তাজআল ফি কুলুবিনা গিল্লাল লিল্লাযিনা আমানু রব্বানা ইন্নাকা রাউফুর রাহিম',
    'Allāhumma innī asʾalukal-hudā wat-tuqā wal-ʿafāfa wal-ghinā':
        'আল্লাহুম্মা ইন্নি আসআলুকাল হুদা ওয়াত তুকা ওয়াল আফাফা ওয়াল গিনা',
    'Ṣayyiban nāfiʿā': 'সাইয়িবান নাফিআ',
    'Muṭirnā bifaḍlillāhi wa raḥmatih': 'মুতিরনা বিফাদলিল্লাহি ওয়া রাহমাতিহ',
    'Allāhumma bārik lahum fīmā razaqtahum waghfir lahum warḥamhum':
        'আল্লাহুম্মা বারিক লাহুম ফিমা রাযাকতাহুম ওয়াগফির লাহুম ওয়ারহামহুম',
    'Allāhumma rabban-nāsi adh-hibil-baʾsa, ishfihi wa antash-Shāfī, lā shifāʾa illā shifāʾuka, shifāʾan lā yughādiru saqamā':
        'আল্লাহুম্মা রব্বান নাসি আযহিবিল বাসা, ইশফিহি ওয়া আনতাশ শাফি, লা শিফাআ ইল্লা শিফাউকা, শিফাআল লা ইউগাদিরু সাকামা',
    'Lā baʾsa, ṭahūrun in shāʾallāh': 'লা বাসা, তাহুরুন ইন শাআল্লাহ',
    'Aʿūdhu bikalimātillāhit-tāmmāti min sharri mā khalaq':
        'আউযু বিকালিমাতিল্লাহিত তাম্মাতি মিন শাররি মা খালাক',
    'Allāhumma innaka ʿafuwwun tuḥibbul-ʿafwa faʿfu ʿannī':
        'আল্লাহুম্মা ইন্নাকা আফুউউন তুহিব্বুল আফওয়া ফাফু আন্নি',

    // Original entries.
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
    // Additional daily duas.
    'My Lord, increase my knowledge.': 'হে আমার রব, আমার জ্ঞান বাড়িয়ে দিন।',
    'My Lord, open my heart, make my task easy, and loosen the knot in my tongue so that they understand my words.':
        'হে আমার রব, আমার অন্তর প্রশস্ত করুন, আমার কাজ সহজ করুন এবং আমার জিহ্বার জড়তা দূর করুন, যেন তারা আমার কথা বুঝতে পারে।',
    'Our Lord, grant us mercy from You and guide our affairs toward what is right.':
        'হে আমাদের রব, আপনার পক্ষ থেকে আমাদের রহমত দিন এবং আমাদের কাজ সঠিক পথে পরিচালিত করুন।',
    'My Lord, show mercy to my parents, as they cared for me in childhood.':
        'হে আমার রব, আমার মা-বাবার প্রতি দয়া করুন, যেমন তাঁরা ছোটবেলায় আমাকে লালন-পালন করেছেন।',
    'Our Lord, forgive me, my parents, and the believers when the Day of Reckoning comes.':
        'হে আমাদের রব, হিসাবের দিনে আমাকে, আমার মা-বাবাকে এবং মুমিনদের ক্ষমা করুন।',
    'Our Lord, make our spouses and descendants a comfort to our eyes, and make us examples for those mindful of You.':
        'হে আমাদের রব, আমাদের জীবনসঙ্গী ও সন্তানদের আমাদের চোখের প্রশান্তি করুন এবং আমাদের মুত্তাকিদের জন্য আদর্শ করুন।',
    'My Lord, grant me good offspring from You. You surely hear every prayer.':
        'হে আমার রব, আপনার পক্ষ থেকে আমাকে সৎ সন্তান দিন। নিশ্চয়ই আপনি দোয়া শোনেন।',
    'My Lord, forgive and show mercy; You are the best of those who show mercy.':
        'হে আমার রব, ক্ষমা করুন ও দয়া করুন; দয়ালুদের মধ্যে আপনিই শ্রেষ্ঠ।',
    'Our Lord, we have wronged ourselves. Unless You forgive us and show us mercy, we will surely be among the losers.':
        'হে আমাদের রব, আমরা নিজেদের প্রতি অন্যায় করেছি। আপনি আমাদের ক্ষমা না করলে ও দয়া না করলে আমরা অবশ্যই ক্ষতিগ্রস্ত হব।',
    'No deity is worthy of worship except You. You are free from imperfection. I have indeed been among the wrongdoers.':
        'আপনি ছাড়া কোনো সত্য উপাস্য নেই। আপনি সকল ত্রুটি থেকে পবিত্র। নিশ্চয়ই আমি অন্যায়কারীদের অন্তর্ভুক্ত ছিলাম।',
    'Our Lord, do not let our hearts stray after You have guided us. Grant us mercy from You; You are the generous Giver.':
        'হে আমাদের রব, হিদায়াত দেওয়ার পর আমাদের অন্তরকে বিপথে যেতে দেবেন না। আপনার পক্ষ থেকে আমাদের রহমত দিন; নিশ্চয়ই আপনিই মহাদাতা।',
    'I hope my Lord will guide me to a course nearer to what is right than this.':
        'আশা করি আমার রব আমাকে এর চেয়েও সঠিক পথের কাছাকাছি পরিচালিত করবেন।',
    'My Lord, I am in need of whatever good You send to me.':
        'হে আমার রব, আপনি আমার জন্য যে কল্যাণই পাঠান, আমি তার মুখাপেক্ষী।',
    'Our Lord, grant us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.':
        'হে আমাদের রব, আমাদের দুনিয়ায় কল্যাণ দিন, আখিরাতে কল্যাণ দিন এবং আগুনের শাস্তি থেকে রক্ষা করুন।',
    'Our Lord, accept this from us. You are the One who hears and knows all.':
        'হে আমাদের রব, আমাদের পক্ষ থেকে কবুল করুন। নিশ্চয়ই আপনি সব শোনেন ও সব জানেন।',
    'My Lord, make me someone who keeps up prayer, and also my descendants. Our Lord, accept my supplication.':
        'হে আমার রব, আমাকে ও আমার সন্তানদের সালাত কায়েমকারী করুন। হে আমাদের রব, আমার দোয়া কবুল করুন।',
    'Our Lord, pour patience upon us and make our steps firm.':
        'হে আমাদের রব, আমাদের প্রচুর ধৈর্য দিন এবং আমাদের পা অবিচল রাখুন।',
    'Our Lord, pour patience upon us and let us die in submission to You.':
        'হে আমাদের রব, আমাদের প্রচুর ধৈর্য দিন এবং আপনার অনুগত অবস্থায় আমাদের মৃত্যু দিন।',
    'My Lord, I seek Your protection from the promptings of devils, and I seek Your protection, my Lord, from their presence.':
        'হে আমার রব, শয়তানদের প্ররোচনা থেকে আপনার আশ্রয় চাই এবং হে আমার রব, তাদের উপস্থিতি থেকেও আপনার আশ্রয় চাই।',
    'My Lord, save me from people who do wrong.':
        'হে আমার রব, আমাকে অত্যাচারী লোকদের থেকে রক্ষা করুন।',
    'Our Lord, bring our light to completion and forgive us. You have power over everything.':
        'হে আমাদের রব, আমাদের নূর পূর্ণ করুন এবং আমাদের ক্ষমা করুন। নিশ্চয়ই আপনি সবকিছুর ওপর ক্ষমতাবান।',
    'Our Lord, grant us what You promised through Your messengers, and do not disgrace us on the Day of Resurrection. You never break Your promise.':
        'হে আমাদের রব, আপনার রাসূলদের মাধ্যমে যা প্রতিশ্রুতি দিয়েছেন তা আমাদের দিন এবং কিয়ামতের দিনে আমাদের অপমানিত করবেন না। নিশ্চয়ই আপনি প্রতিশ্রুতি ভঙ্গ করেন না।',
    'Hardship has touched me, and You are the most merciful of those who show mercy.':
        'আমাকে কষ্ট স্পর্শ করেছে, আর দয়ালুদের মধ্যে আপনিই সর্বাধিক দয়ালু।',
    'Our Lord, forgive us and our fellow believers who preceded us in faith. Leave no resentment in our hearts toward believers. Our Lord, You are full of kindness and mercy.':
        'হে আমাদের রব, আমাদের ও আমাদের আগে ঈমান আনা ভাইদের ক্ষমা করুন। মুমিনদের প্রতি আমাদের অন্তরে কোনো বিদ্বেষ রাখবেন না। হে আমাদের রব, নিশ্চয়ই আপনি অতি স্নেহশীল ও দয়ালু।',
    'O Allah, I ask You for guidance, mindfulness of You, chastity, and freedom from need.':
        'হে আল্লাহ, আমি আপনার কাছে হিদায়াত, তাকওয়া, চারিত্রিক পবিত্রতা ও অমুখাপেক্ষিতা চাই।',
    'May it be abundant, beneficial rain.': 'এটি প্রচুর ও উপকারী বৃষ্টি হোক।',
    'We have received rain through the grace and mercy of Allah.':
        'আল্লাহর অনুগ্রহ ও রহমতে আমরা বৃষ্টি পেয়েছি।',
    'O Allah, bless the provision You have given them, forgive them, and show them mercy.':
        'হে আল্লাহ, তাদের দেওয়া রিযিকে বরকত দিন, তাদের ক্ষমা করুন এবং তাদের প্রতি দয়া করুন।',
    'O Allah, Lord of humankind, remove the suffering and heal him. You are the Healer. There is no cure except Your cure, a cure leaving no illness behind.':
        'হে আল্লাহ, মানুষের রব, কষ্ট দূর করুন ও তাকে সুস্থ করুন। আপনিই আরোগ্যদাতা। আপনার আরোগ্য ছাড়া কোনো আরোগ্য নেই; এমন আরোগ্য দিন যা কোনো রোগ অবশিষ্ট রাখে না।',
    'Do not be troubled; may this be a purification, if Allah wills.':
        'দুশ্চিন্তা করবেন না; আল্লাহ চাইলে এটি পবিত্রতার কারণ হবে।',
    'I seek shelter in the perfect words of Allah from the evil of what He has created.':
        'আল্লাহর পরিপূর্ণ বাণীর মাধ্যমে তাঁর সৃষ্টির অনিষ্ট থেকে আশ্রয় চাই।',
    'O Allah, You pardon and love to pardon, so pardon me.':
        'হে আল্লাহ, আপনি ক্ষমাকারী এবং ক্ষমা করতে ভালোবাসেন, তাই আমাকে ক্ষমা করুন।',

    // Original entries.
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

extension DuahCategoryLocalization on DuahCategory {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;

    return switch (label) {
      'Eating & Drinking' => l10n.duahCategoryEatingDrinking,
      'Home' => l10n.duahCategoryHome,
      'Washroom' => l10n.duahCategoryWashroom,
      'Sleep' => l10n.duahCategorySleep,
      'Daily Dhikr' => l10n.duahCategoryDailyDhikr,
      'Wudū\'' => l10n.duahCategoryWudu,
      'Masjid' => l10n.duahCategoryMasjid,
      'Sneezing' => l10n.duahCategorySneezing,
      'Difficulty' => l10n.duahCategoryDifficulty,
      'Learning & Understanding' => l10n.duahCategoryLearningUnderstanding,
      'Parents & Family' => l10n.duahCategoryParentsFamily,
      'Repentance & Mercy' => l10n.duahCategoryRepentanceMercy,
      'Guidance & Faith' => l10n.duahCategoryGuidanceFaith,
      'Provision & Goodness' => l10n.duahCategoryProvisionGoodness,
      'Worship & Acceptance' => l10n.duahCategoryWorshipAcceptance,
      'Patience & Steadfastness' => l10n.duahCategoryPatienceSteadfastness,
      'Protection & Safety' => l10n.duahCategoryProtectionSafety,
      'The Hereafter' => l10n.duahCategoryHereafter,
      'Illness & Visiting' => l10n.duahCategoryIllnessVisiting,
      'Community & Kindness' => l10n.duahCategoryCommunityKindness,
      'Rain & Weather' => l10n.duahCategoryRainWeather,
      'Laylat al-Qadr' => l10n.duahCategoryLaylatAlQadr,
      _ => label,
    };
  }
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
    DuahCategory(
      icon: Icons.water_drop_rounded,
      label: 'Rain & Weather',
      items: [
        DuahItem(
          title: 'When rain falls',
          arabic: 'صَيِّبًا نَافِعًا',
          pronunciation: 'Ṣayyiban nāfiʿā',
          translation: 'May it be abundant, beneficial rain.',
          note:
              'Source: Sahih al-Bukhari 1032. The wording shown follows the Arabic text of this narration.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.favorite_rounded,
      label: 'Illness & Visiting',
      items: [
        DuahItem(
          title: 'Reassuring someone who is ill',
          arabic: 'لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ',
          pronunciation: 'Lā baʾsa, ṭahūrun in shāʾallāh',
          translation:
              'Do not be troubled; may this be a purification, if Allah wills.',
          note: 'Source: Sahih al-Bukhari 3616.',
        ),
      ],
    ),
  ];

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
    DuahCategory(
      icon: Icons.water_drop_rounded,
      label: 'Rain & Weather',
      items: [
        DuahItem(
          title: 'When rain falls',
          arabic: 'صَيِّبًا نَافِعًا',
          pronunciation: 'Ṣayyiban nāfiʿā',
          translation: 'May it be abundant, beneficial rain.',
          note:
              'Source: Sahih al-Bukhari 1032. The wording shown follows the Arabic text of this narration.',
        ),
        DuahItem(
          title: 'After rainfall',
          arabic: 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ',
          pronunciation: 'Muṭirnā bifaḍlillāhi wa raḥmatih',
          translation:
              'We have received rain through the grace and mercy of Allah.',
          note: 'Source: Sahih al-Bukhari 846.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.people_rounded,
      label: 'Community & Kindness',
      items: [
        DuahItem(
          title: 'Prayer for a host',
          arabic:
              'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ وَاغْفِرْ لَهُمْ وَارْحَمْهُمْ',
          pronunciation:
              'Allāhumma bārik lahum fīmā razaqtahum waghfir lahum warḥamhum',
          translation:
              'O Allah, bless the provision You have given them, forgive them, and show them mercy.',
          note:
              'Source: Sahih Muslim 2042a. A supplication for those who have hosted you.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.favorite_rounded,
      label: 'Illness & Visiting',
      items: [
        DuahItem(
          title: 'Reassuring someone who is ill',
          arabic: 'لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ',
          pronunciation: 'Lā baʾsa, ṭahūrun in shāʾallāh',
          translation:
              'Do not be troubled; may this be a purification, if Allah wills.',
          note: 'Source: Sahih al-Bukhari 3616.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.shield_rounded,
      label: 'Protection & Safety',
      items: [
        DuahItem(
          title: 'When stopping at a place',
          arabic:
              'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          pronunciation: 'Aʿūdhu bikalimātillāhit-tāmmāti min sharri mā khalaq',
          translation:
              'I seek shelter in the perfect words of Allah from the evil of what He has created.',
          note:
              'Source: Sahih Muslim 2708a. Recite when settling at a stopping place.',
        ),
      ],
    ),
  ];

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
    DuahCategory(
      icon: Icons.water_drop_rounded,
      label: 'Rain & Weather',
      items: [
        DuahItem(
          title: 'When rain falls',
          arabic: 'صَيِّبًا نَافِعًا',
          pronunciation: 'Ṣayyiban nāfiʿā',
          translation: 'May it be abundant, beneficial rain.',
          note:
              'Source: Sahih al-Bukhari 1032. The wording shown follows the Arabic text of this narration.',
        ),
        DuahItem(
          title: 'After rainfall',
          arabic: 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ',
          pronunciation: 'Muṭirnā bifaḍlillāhi wa raḥmatih',
          translation:
              'We have received rain through the grace and mercy of Allah.',
          note: 'Source: Sahih al-Bukhari 846.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.people_rounded,
      label: 'Community & Kindness',
      items: [
        DuahItem(
          title: 'Prayer for a host',
          arabic:
              'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ وَاغْفِرْ لَهُمْ وَارْحَمْهُمْ',
          pronunciation:
              'Allāhumma bārik lahum fīmā razaqtahum waghfir lahum warḥamhum',
          translation:
              'O Allah, bless the provision You have given them, forgive them, and show them mercy.',
          note:
              'Source: Sahih Muslim 2042a. A supplication for those who have hosted you.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.favorite_rounded,
      label: 'Illness & Visiting',
      items: [
        DuahItem(
          title: 'Asking Allah for healing',
          arabic:
              'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَاسَ، اشْفِهِ وَأَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا',
          pronunciation:
              'Allāhumma rabban-nāsi adh-hibil-baʾsa, ishfihi wa antash-Shāfī, lā shifāʾa illā shifāʾuka, shifāʾan lā yughādiru saqamā',
          translation:
              'O Allah, Lord of humankind, remove the suffering and heal him. You are the Healer. There is no cure except Your cure, a cure leaving no illness behind.',
          note:
              'Source: Sahih al-Bukhari 5743. The Arabic follows this narration and uses the masculine singular pronoun.',
        ),
        DuahItem(
          title: 'Reassuring someone who is ill',
          arabic: 'لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ',
          pronunciation: 'Lā baʾsa, ṭahūrun in shāʾallāh',
          translation:
              'Do not be troubled; may this be a purification, if Allah wills.',
          note: 'Source: Sahih al-Bukhari 3616.',
        ),
      ],
    ),
    DuahCategory(
      icon: Icons.shield_rounded,
      label: 'Protection & Safety',
      items: [
        DuahItem(
          title: 'When stopping at a place',
          arabic:
              'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          pronunciation: 'Aʿūdhu bikalimātillāhit-tāmmāti min sharri mā khalaq',
          translation:
              'I seek shelter in the perfect words of Allah from the evil of what He has created.',
          note:
              'Source: Sahih Muslim 2708a. Recite when settling at a stopping place.',
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
