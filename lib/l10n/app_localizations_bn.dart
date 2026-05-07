// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'কুরআন ফর অল';

  @override
  String get homeReadQuranTab => 'কুরআন পড়ুন';

  @override
  String get homeLearnQuranTab => 'কুরআন শিখুন';

  @override
  String get languageEnglish => 'ইংরেজি';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get learnQuranPageTitle => 'কুরআন শিখুন';

  @override
  String get learnQuranTracksTitle => 'লার্নিং ট্র্যাকস';

  @override
  String get learnQuranTracksSubtitle => 'ধাপে ধাপে এই সেকশনগুলো অনুসরণ করুন, অথবা আজ যেটি উন্নত করতে চান সেটি বেছে নিন।';

  @override
  String get learnHeaderTitle => 'কুরআন শিখুন';

  @override
  String get learnHeaderSubtitle => 'হরফ, তাজবিদ ও সাবলীল তিলাওয়াতের জন্য কাঠামোবদ্ধ পাঠ।';

  @override
  String learnHeaderLessonProgress(int completed, int total) {
    return '$completed / $total টি লেসন সম্পন্ন';
  }

  @override
  String get learnHeaderModulesLabel => 'মডিউল';

  @override
  String get learnHeaderStreakLabel => 'স্ট্রিক';

  @override
  String learnHeaderStreakDays(int days) {
    return '$days দিন';
  }

  @override
  String get learnModuleStatusCompleted => 'সম্পন্ন';

  @override
  String get learnModuleStatusNotStarted => 'শুরু হয়নি';

  @override
  String get learnModuleStatusInProgress => 'চলমান';

  @override
  String learnMinutesShort(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String learnCompletedFraction(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get learnNextContinuePathTitle => 'আপনার যাত্রা চালিয়ে যান';

  @override
  String get learnNextAllLessonsCompletedTitle => 'সব লেসন সম্পন্ন';

  @override
  String get learnNextAllLessonsCompletedBody => 'দারুণ কাজ। শেখা মজবুত করতে যেকোনো মডিউল আবার দেখুন।';

  @override
  String get learnNextStartLessonButton => 'পরের লেসন শুরু করুন';

  @override
  String get learnNextReviewModulesButton => 'মডিউল রিভিউ করুন';

  @override
  String get learnLessonTooltipPauseAudio => 'লেসনের অডিও থামান';

  @override
  String get learnLessonTooltipPlayAudio => 'লেসনের অডিও চালান';

  @override
  String get learnLessonAudioGuided => 'অডিও গাইডেড';

  @override
  String get learnLessonDone => 'সম্পন্ন';

  @override
  String learnLessonDurationMinutes(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String learnModuleLessonsCompleted(int completed, int total) {
    return '$completed / $total টি লেসন সম্পন্ন';
  }

  @override
  String get learnVmErrorLoadProgress => 'এই মুহূর্তে শেখার অগ্রগতি লোড করা যাচ্ছে না।';

  @override
  String get learnVmErrorSaveProgress => 'অগ্রগতি সংরক্ষণ করা যাচ্ছে না। আবার চেষ্টা করুন।';

  @override
  String get learnVmAudioMissingSample => 'এই লেসনের জন্য এখনো কোনো অডিও স্যাম্পল যুক্ত নেই।';

  @override
  String get learnVmAudioSampleNotFound => 'এই লেসনের অডিও স্যাম্পল আয়াত খুঁজে পাওয়া যায়নি।';

  @override
  String get learnVmAudioPlayFailed => 'এই মুহূর্তে লেসনের অডিও চালানো যাচ্ছে না।';

  @override
  String get learnQuranTextMapRaw => 'Arabic Letters=আরবি বর্ণমালা||Pronunciation Basics=উচ্চারণের ভিত্তি||Makharij=মাখারিজ||Tajweed Rules=তাজবিদের নিয়ম||Word-by-Word Understanding=শব্দে-শব্দে বুঝে পড়া||Short Surah Practice=ছোট সূরা অনুশীলন||Audio Assisted Practice=অডিও সহায়তায় অনুশীলন||Beginner=শুরুর স্তর||Beginner to Intermediate=শুরুর স্তর থেকে মধ্যম||Intermediate=মধ্যম||Track Flow=শেখার ধারা||Word map=শব্দ মানচিত্র||Meaning=অর্থ||Family=পরিবার||Core meaning=মূল অর্থ||Examples=উদাহরণ||Tip=টিপস||Focus=ফোকাস||Function=কার্য||Sample=নমুনা||Reading cue=পাঠ নির্দেশনা||Distinction=পার্থক্য||Practice=অনুশীলন||Watch for=খেয়াল রাখুন||Location=অবস্থান||Sound cue=ধ্বনি নির্দেশনা||Common mistake=সাধারণ ভুল||Drill=ড্রিল||Goal=লক্ষ্য||Success marker=সফলতার সূচক||Listen for=শুনে ধরুন||Repeat target=পুনরাবৃত্তির লক্ষ্য||Pacing=গতি||Action=করণীয়||Check prompt=পরীক্ষা নির্দেশনা||Common signs=সাধারণ লক্ষণ||Fix=সংশোধন||Pause=বিরতি||Restart=পুনরারম্ভ||Example=উদাহরণ||Base letter=মূল বর্ণ||Fatha=ফাতহা||Kasra=কাসরা||Damma=দাম্মা||Sukoon=সুকুন||Sound=ধ্বনি||Count=গণনা||Note=নোট||Qalqalah Focus=কালকালাহ ফোকাস||Madd Focus=মাদ্দ ফোকাস||Trigger=ট্রিগার||Delivery=প্রয়োগ পদ্ধতি||How to read=কীভাবে পড়বেন||Coach note=শিক্ষকের নোট||Objective=উদ্দেশ্য||Key theme=মূল বিষয়||Recitation target=তিলাওয়াতের লক্ষ্য||Practice prompt=অনুশীলনের নির্দেশনা||Light sample=হালকা নমুনা||Heavy sample=ভারী নমুনা||Coach tip=শিক্ষকের টিপস||Do this=এভাবে করুন||Message=বার্তা||Recitation cue=তিলাওয়াত নির্দেশনা||Rule=নিয়ম||Correction=সংশোধন||When=কখন||I can recognize at least 20 high-frequency Quran words quickly.=আমি দ্রুত কমপক্ষে ২০টি বহুল ব্যবহৃত কুরআনের শব্দ চিনতে পারি।||I can infer general meaning from common root families.=আমি প্রচলিত মূল-পরিবার থেকে সাধারণ অর্থ অনুমান করতে পারি।||I can identify connector particles and their phrase role.=আমি সংযোজক কণাগুলো এবং বাক্যে তাদের ভূমিকা শনাক্ত করতে পারি।||I can break a short ayah into word groups with translation awareness.=আমি অনুবাদ-বোঝাপড়াসহ একটি ছোট আয়াতকে শব্দগুচ্ছে ভাগ করতে পারি।||I can summarize one short surah in simple meaning-based notes.=আমি সহজ অর্থভিত্তিক নোটে একটি ছোট সূরার সারসংক্ষেপ দিতে পারি।';
}
