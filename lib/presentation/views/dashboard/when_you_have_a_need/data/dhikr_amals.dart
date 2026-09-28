import '../need_amal.dart';
import 'need_references.dart';

const dhikrAmals = <NeedAmal>[
  NeedAmal(
    id: 'istighfar',
    category: NeedCategory.dhikr,
    title: NeedText('Istighfar', 'ইস্তিগফার'),
    description: NeedText(
      'Seek Allah’s forgiveness with honest repentance, including simple istighfar or Sayyidul Istighfar.',
      'সৎ অনুতাপ নিয়ে আল্লাহর ক্ষমা চান; সহজ ইস্তিগফার বা সাইয়্যিদুল ইস্তিগফার পড়ুন।',
    ),
    steps: [
      NeedText(
        'Acknowledge a wrong and turn away from it.',
        'ভুল স্বীকার করে তা থেকে ফিরে আসুন।',
      ),
      NeedText(
        'Say “Astaghfirullah” sincerely, or read Sayyidul Istighfar with meaning.',
        'আন্তরিকভাবে “আস্তাগফিরুল্লাহ” বলুন বা অর্থ বুঝে সাইয়্যিদুল ইস্তিগফার পড়ুন।',
      ),
      NeedText(
        'Ask Allah for forgiveness and make amends where another person was harmed.',
        'আল্লাহর ক্ষমা চান; অন্যের হক নষ্ট হলে তা পূরণের চেষ্টা করুন।',
      ),
    ],
    arabic:
        'أَسْتَغْفِرُ اللَّهَ\n\nاللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي، فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    transliteration:
        'Astaghfirullah.\n\nAllahumma anta Rabbi, la ilaha illa anta, khalaqtani wa ana ʿabduka, wa ana ʿala ʿahdika wa waʿdika mastataʿtu. Aʿudhu bika min sharri ma sanaʿtu. Abu’u laka biniʿmatika ʿalayya, wa abu’u laka bidhanbi, faghfir li, fa innahu la yaghfirudh-dhunuba illa anta.',
    meaning: NeedText(
      'I seek Allah’s forgiveness. O Allah, You are my Lord; there is no god but You. You created me and I am Your servant. I keep Your covenant as best I can. I seek refuge from the evil I have done. I acknowledge Your favor and my sin, so forgive me; none forgives sins but You.',
      'আমি আল্লাহর কাছে ক্ষমা চাই। হে আল্লাহ, আপনি আমার রব; আপনি ছাড়া উপাস্য নেই। আপনি আমাকে সৃষ্টি করেছেন, আমি আপনার বান্দা। সাধ্য অনুযায়ী অঙ্গীকার রক্ষা করি। নিজের কাজের অনিষ্ট থেকে আশ্রয় চাই। আপনার নিয়ামত ও নিজের পাপ স্বীকার করি; আমাকে ক্ষমা করুন, আপনি ছাড়া কেউ পাপ ক্ষমা করতে পারেন না।',
    ),
    authenticity: NeedText('Qur’an and sahih hadith', 'কুরআন ও সহিহ হাদিস'),
    evidenceNote: NeedText(
      'Qur’an 71:10–12 links seeking forgiveness with Allah’s mercy and provision; Bukhari 6306 gives Sayyidul Istighfar. These are not a formula promising a specific worldly outcome.',
      'কুরআন ৭১:১০–১২-এ ক্ষমা প্রার্থনার সঙ্গে আল্লাহর রহমত ও রিজিকের কথা আছে; বুখারি ৬৩০৬-এ সাইয়্যিদুল ইস্তিগফার এসেছে। এগুলো নির্দিষ্ট দুনিয়াবি ফলের নিশ্চয়তা নয়।',
    ),
    timing: NeedText(
      'Any time; morning and evening suit Sayyidul Istighfar',
      'যেকোনো সময়; সাইয়্যিদুল ইস্তিগফার সকাল-সন্ধ্যায়',
    ),
    references: [needIstighfarVerse, needSayyidulIstighfar],
  ),
  NeedAmal(
    id: 'salawat',
    category: NeedCategory.dhikr,
    title: NeedText('Salawat upon the Prophet ﷺ', 'নবী ﷺ-এর ওপর দরুদ'),
    description: NeedText(
      'A powerful act of worship and a recommended part of dua etiquette.',
      'একটি গুরুত্বপূর্ণ ইবাদত এবং দোয়ার আদবের সুপারিশকৃত অংশ।',
    ),
    steps: [
      NeedText('Begin by praising Allah.', 'শুরুতে আল্লাহর প্রশংসা করুন।'),
      NeedText(
        'Send salawat upon the Prophet ﷺ.',
        'নবী ﷺ-এর ওপর দরুদ পাঠ করুন।',
      ),
      NeedText(
        'Then ask Allah for what is good; repeat salawat often without assigning an unsupported count.',
        'এরপর কল্যাণের জন্য আল্লাহর কাছে চান; প্রমাণহীন সংখ্যা নির্ধারণ না করে বেশি দরুদ পড়ুন।',
      ),
    ],
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    transliteration: 'Allahumma salli ʿala Muhammad.',
    meaning: NeedText(
      'O Allah, send blessings upon Muhammad.',
      'হে আল্লাহ, মুহাম্মদের ওপর রহমত বর্ষণ করুন।',
    ),
    authenticity: NeedText('Qur’an and hasan hadith', 'কুরআন ও হাসান হাদিস'),
    evidenceNote: NeedText(
      'Qur’an 33:56 commands believers to send blessings; Tirmidhi 3477 describes praising Allah and sending salawat before du’a.',
      'কুরআন ৩৩:৫৬-এ দরুদের নির্দেশ আছে; তিরমিজি ৩৪৭৭-এ দোয়ার আগে আল্লাহর প্রশংসা ও দরুদের কথা এসেছে।',
    ),
    timing: NeedText(
      'Any time, especially when making du’a',
      'যেকোনো সময়, বিশেষত দোয়ার সময়',
    ),
    references: [needSalawatVerse, needDuaEtiquette],
  ),
];
