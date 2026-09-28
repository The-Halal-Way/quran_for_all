import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanQuestionsTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.questions,
    title: RamadanText('Illness or travel?', 'অসুস্থতা বা সফর?'),
    summary: RamadanText(
      'The Qur’an gives a concession and speaks of making up missed days later.',
      'কুরআনে ছাড় এবং পরে বাদ যাওয়া দিন পূরণের কথা আছে।',
    ),
    points: [
      RamadanText(
        'Temporary illness and lasting inability may be treated differently; ask your clinician and a qualified scholar.',
        'সাময়িক অসুস্থতা ও স্থায়ী অক্ষমতার বিধান ভিন্ন হতে পারে; চিকিৎসক ও আলেমের পরামর্শ নিন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.questions,
    title: RamadanText('Missed fasts and fidyah?', 'কাজা ও ফিদইয়া?'),
    summary: RamadanText(
      'First record the days and reason. Qada and fidyah are not interchangeable in every case.',
      'প্রথমে দিন ও কারণ লিখে রাখুন। সব ক্ষেত্রে কাজা ও ফিদইয়া একে অপরের বিকল্প নয়।',
    ),
    points: [
      RamadanText(
        'Temporary inability generally points toward making up days; permanent inability may involve fidyah.',
        'সাময়িক অক্ষমতায় সাধারণত কাজা, স্থায়ী অক্ষমতায় ফিদইয়া প্রযোজ্য হতে পারে।',
      ),
      RamadanText(
        'Amounts, timing and delayed qada vary; obtain guidance for your situation.',
        'পরিমাণ, সময় ও বিলম্বিত কাজার বিধানে ভিন্নতা আছে; নিজের অবস্থার জন্য পরামর্শ নিন।',
      ),
    ],
    reference: ramadanIllness,
  ),
  RamadanTopic(
    section: RamadanSection.questions,
    title: RamadanText('Marriage and intimacy?', 'দাম্পত্য জীবন?'),
    summary: RamadanText(
      'Spouses may be intimate during Ramadan nights, from after sunset until the fast begins at dawn.',
      'রমজানে সূর্যাস্তের পর থেকে ফজরে রোজা শুরুর আগ পর্যন্ত স্বামী-স্ত্রীর ঘনিষ্ঠতা বৈধ।',
    ),
    points: [
      RamadanText(
        'Sexual relations during fasting hours are prohibited. Complex cases about a broken fast need individual scholarly guidance.',
        'রোজার সময় যৌন সম্পর্ক নিষিদ্ধ। রোজা ভেঙে গেলে জটিল বিধানে ব্যক্তিগতভাবে আলেমের পরামর্শ নিন।',
      ),
      RamadanText(
        'Respect each other’s health, consent and rest throughout the month.',
        'মাসজুড়ে একে অপরের স্বাস্থ্য, সম্মতি ও বিশ্রামকে গুরুত্ব দিন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
  RamadanTopic(
    section: RamadanSection.questions,
    title: RamadanText(
      'Medication or a medical procedure?',
      'ওষুধ বা চিকিৎসা?',
    ),
    summary: RamadanText(
      'Do not stop prescribed treatment on the basis of a general app guide.',
      'সাধারণ অ্যাপ গাইড দেখে নির্ধারিত চিকিৎসা বন্ধ করবেন না।',
    ),
    points: [
      RamadanText(
        'Ask your clinician about timing and safety, and a qualified scholar about the fasting ruling for the specific treatment.',
        'সময় ও নিরাপত্তা নিয়ে চিকিৎসককে এবং নির্দিষ্ট চিকিৎসার রোজার বিধান নিয়ে আলেমকে জিজ্ঞেস করুন।',
      ),
    ],
    reference: ramadanIllness,
  ),
  RamadanTopic(
    section: RamadanSection.questions,
    title: RamadanText(
      'Can I still participate if I cannot fast?',
      'রোজা রাখতে না পারলেও কী করব?',
    ),
    summary: RamadanText(
      'Yes. Prayer where applicable, du’a, remembrance, learning, charity and caring for others all keep you engaged.',
      'হ্যাঁ। প্রযোজ্য নামাজ, দোয়া, জিকির, শিক্ষা, দান ও মানুষের সেবায় অংশ নিতে পারেন।',
    ),
    points: [
      RamadanText(
        'An exemption is not a personal failure. Keep a record of any days that may need follow-up.',
        'বৈধ ছাড় কোনো ব্যক্তিগত ব্যর্থতা নয়। পরে করণীয় থাকতে পারে এমন দিন লিখে রাখুন।',
      ),
    ],
    reference: ramadanFastingVerses,
  ),
];
