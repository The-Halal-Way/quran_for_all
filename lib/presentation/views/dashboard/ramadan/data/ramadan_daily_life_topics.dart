import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanDailyLifeTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.dailyLife,
    title: RamadanText('A gentle daily rhythm', 'সহজ দৈনিক রুটিন'),
    summary: RamadanText(
      'Organize the day around suhur, the five prayers, work or study, iftar and rest.',
      'সেহরি, পাঁচ ওয়াক্ত নামাজ, কাজ বা পড়া, ইফতার ও বিশ্রামকে ঘিরে দিন সাজান।',
    ),
    points: [
      RamadanText(
        'Choose one small Qur’an goal and one act of kindness you can repeat.',
        'নিয়মিত করা সম্ভব এমন ছোট কুরআন লক্ষ্য ও একটি সদয় কাজ বেছে নিন।',
      ),
      RamadanText(
        'Protect sleep and hydration outside fasting hours.',
        'রোজার সময়ের বাইরে ঘুম ও পর্যাপ্ত পানি গ্রহণের দিকে নজর দিন।',
      ),
    ],
  ),
  RamadanTopic(
    section: RamadanSection.dailyLife,
    title: RamadanText('Prayer before extras', 'ফরজ নামাজ আগে'),
    summary: RamadanText(
      'Let the five daily prayers anchor your schedule before adding optional routines.',
      'অতিরিক্ত আমল যোগ করার আগে পাঁচ ওয়াক্ত নামাজকে দিনের ভিত্তি করুন।',
    ),
    points: [
      RamadanText(
        'Use your existing prayer-time view to plan work, travel and iftar.',
        'কাজ, যাতায়াত ও ইফতারের পরিকল্পনায় অ্যাপের নামাজের সময় ব্যবহার করুন।',
      ),
      RamadanText(
        'Keep worship realistic; consistency is easier to sustain than an exhausting first week.',
        'আমল সাধ্যের মধ্যে রাখুন; প্রথম সপ্তাহেই অতিরিক্ত চাপের চেয়ে ধারাবাহিকতা ভালো।',
      ),
    ],
  ),
  RamadanTopic(
    section: RamadanSection.dailyLife,
    title: RamadanText('Work, study and travel', 'কাজ, পড়াশোনা ও সফর'),
    summary: RamadanText(
      'Plan demanding tasks, breaks and travel with your health and prayer times in mind.',
      'স্বাস্থ্য ও নামাজের সময় মাথায় রেখে কঠিন কাজ, বিরতি এবং সফরের পরিকল্পনা করুন।',
    ),
    points: [
      RamadanText(
        'A traveler may have a concession to fast later; the Qur’an speaks of making up missed days.',
        'মুসাফির পরে রোজা রাখার ছাড় পেতে পারেন; কুরআনে অন্য দিনে তা পূরণের কথা আছে।',
      ),
      RamadanText(
        'For complex travel schedules, ask a qualified local scholar.',
        'জটিল সফরসূচির ক্ষেত্রে যোগ্য স্থানীয় আলেমের পরামর্শ নিন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.dailyLife,
    title: RamadanText('Meals and wellbeing', 'খাবার ও সুস্থতা'),
    summary: RamadanText(
      'Make suhur and iftar supportive rather than overwhelming.',
      'সেহরি ও ইফতারকে শরীরের সহায়ক রাখুন, অতিভোজনের উপলক্ষ করবেন না।',
    ),
    points: [
      RamadanText(
        'If you have a medical condition or take regular medication, make a plan with your clinician.',
        'রোগ বা নিয়মিত ওষুধ থাকলে চিকিৎসকের সঙ্গে পরিকল্পনা করুন।',
      ),
      RamadanText(
        'Severe symptoms deserve prompt medical care; fasting rules should not delay urgent help.',
        'তীব্র অসুস্থতায় দ্রুত চিকিৎসা নিন; জরুরি সাহায্য নিতে রোজার প্রশ্নে দেরি করবেন না।',
      ),
    ],
    reference: ramadanIllness,
  ),
  RamadanTopic(
    section: RamadanSection.dailyLife,
    title: RamadanText('Family and children', 'পরিবার ও শিশু'),
    summary: RamadanText(
      'Make room for learning, care and shared meals without putting pressure on children.',
      'শিশুদের ওপর চাপ না দিয়ে শেখা, যত্ন ও একসঙ্গে খাওয়ার পরিবেশ তৈরি করুন।',
    ),
    points: [
      RamadanText(
        'Adults can share food preparation and caring work fairly, especially before iftar.',
        'বিশেষ করে ইফতারের আগে বড়রা খাবার ও যত্নের কাজ ন্যায্যভাবে ভাগ করতে পারেন।',
      ),
      RamadanText(
        'Help children learn the meaning of Ramadan through stories, prayer and kindness.',
        'গল্প, নামাজ ও দয়ার কাজ দিয়ে শিশুদের রমজানের অর্থ শেখান।',
      ),
    ],
    reference: ramadanFamily,
  ),
  RamadanTopic(
    section: RamadanSection.dailyLife,
    title: RamadanText(
      'Men and shared responsibilities',
      'পুরুষ ও যৌথ দায়িত্ব',
    ),
    summary: RamadanText(
      'Prayer and fasting can sit alongside serving your family and sharing Ramadan work.',
      'নামাজ ও রোজার পাশাপাশি পরিবারের সেবা এবং রমজানের কাজ ভাগ করে নিন।',
    ),
    points: [
      RamadanText(
        'The Prophet ﷺ helped his family at home. Share suhur, iftar, childcare and errands where you can.',
        'রাসুল ﷺ ঘরে পরিবারের কাজে সাহায্য করতেন। সামর্থ্য অনুযায়ী সেহরি, ইফতার, শিশুদের যত্ন ও বাইরের কাজ ভাগ করুন।',
      ),
      RamadanText(
        'Make time for your own worship while helping others make time for theirs.',
        'নিজের ইবাদতের সময় রাখুন এবং অন্যদের ইবাদতের সময় পাওয়াতেও সাহায্য করুন।',
      ),
    ],
    reference: ramadanFamily,
  ),
];
