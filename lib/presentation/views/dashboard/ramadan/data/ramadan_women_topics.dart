import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanWomenTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.women,
    title: RamadanText('Menstruation and fasting', 'মাসিক ও রোজা'),
    summary: RamadanText(
      'Do not fast during menstruation; record the missed days to make up later.',
      'মাসিকের সময় রোজা রাখবেন না; পরে কাজা করার জন্য দিনগুলো লিখে রাখুন।',
    ),
    points: [
      RamadanText(
        'Missed fasts are made up later; missed prayers during menstruation are not made up.',
        'মাসিকের সময় বাদ যাওয়া রোজার কাজা আছে; এ সময়ের নামাজের কাজা নেই।',
      ),
      RamadanText(
        'Your worship can continue through du’a, remembrance, charity and learning.',
        'দোয়া, জিকির, দান ও শেখার মাধ্যমে ইবাদতের সম্পর্ক বজায় রাখতে পারেন।',
      ),
    ],
    reference: ramadanWomenFasts,
  ),
  RamadanTopic(
    section: RamadanSection.women,
    title: RamadanText('After childbirth', 'সন্তান জন্মের পর'),
    summary: RamadanText(
      'Postnatal bleeding is a valid reason not to fast; the missed fasts are made up when able.',
      'প্রসব-পরবর্তী রক্তস্রাবের সময় রোজা রাখা হয় না; সক্ষম হলে বাদ যাওয়া রোজার কাজা হয়।',
    ),
    points: [
      RamadanText(
        'Recovery and medical care deserve attention; note missed days without guilt.',
        'সুস্থ হওয়া ও চিকিৎসাকে গুরুত্ব দিন; অপরাধবোধ ছাড়া বাদ যাওয়া দিন লিখে রাখুন।',
      ),
      RamadanText(
        'Ask a qualified scholar about when bleeding ends and worship resumes in your case.',
        'আপনার ক্ষেত্রে রক্তস্রাব শেষ হওয়া ও ইবাদত শুরু করার সময় নিয়ে আলেমের পরামর্শ নিন।',
      ),
    ],
    reference: ramadanPostnatal,
  ),
  RamadanTopic(
    section: RamadanSection.women,
    title: RamadanText('Pregnancy and breastfeeding', 'গর্ভাবস্থা ও স্তন্যদান'),
    summary: RamadanText(
      'If fasting is difficult or harmful for you or your baby, seek medical advice and use the available concession.',
      'রোজায় আপনার বা শিশুর ক্ষতির আশঙ্কা থাকলে চিকিৎসকের পরামর্শ নিন এবং প্রযোজ্য ছাড় গ্রহণ করুন।',
    ),
    points: [
      RamadanText(
        'Missed days can be made up when you are able; detailed fidyah opinions differ between schools.',
        'সক্ষম হলে বাদ যাওয়া দিন কাজা করা যায়; ফিদইয়ার বিস্তারিত বিধানে মাযহাবভেদে মতপার্থক্য আছে।',
      ),
      RamadanText(
        'Do not use a generic schedule in place of your clinician’s advice.',
        'ব্যক্তিগত চিকিৎসকের পরামর্শের বদলে সাধারণ রুটিন অনুসরণ করবেন না।',
      ),
    ],
    reference: ramadanPregnancy,
  ),
  RamadanTopic(
    section: RamadanSection.women,
    title: RamadanText('Spotting and uncertain bleeding', 'অনিয়মিত রক্তস্রাব'),
    summary: RamadanText(
      'Bleeding patterns can be difficult to classify; the ruling can depend on personal history and school of law.',
      'অনিয়মিত রক্তস্রাবের ধরন নির্ধারণ কঠিন হতে পারে; ব্যক্তিগত অবস্থা ও মাযহাব অনুযায়ী বিধান বদলায়।',
    ),
    points: [
      RamadanText(
        'Track dates and symptoms, then ask a qualified scholar and clinician rather than guessing.',
        'তারিখ ও উপসর্গ লিখে রাখুন; অনুমান না করে আলেম ও চিকিৎসকের পরামর্শ নিন।',
      ),
    ],
    reference: ramadanSpotting,
  ),
  RamadanTopic(
    section: RamadanSection.women,
    title: RamadanText(
      'Worship on non-fasting days',
      'রোজা না রাখার দিনেও ইবাদত',
    ),
    summary: RamadanText(
      'A valid exemption does not remove you from Ramadan’s spiritual life.',
      'বৈধ কারণে রোজা না রাখলেও রমজানের আধ্যাত্মিক জীবন থেকে আপনি বিচ্ছিন্ন নন।',
    ),
    points: [
      RamadanText(
        'Make du’a, listen to Qur’an, learn, give charity and care for others.',
        'দোয়া করুন, কুরআন শুনুন, শিখুন, দান করুন এবং অন্যের যত্ন নিন।',
      ),
      RamadanText(
        'Views on reciting or handling a physical mushaf during menstruation differ; follow your trusted scholar.',
        'মাসিকের সময় কুরআন তিলাওয়াত বা মুসহাফ স্পর্শের বিধানে মতপার্থক্য আছে; নির্ভরযোগ্য আলেমের পরামর্শ নিন।',
      ),
    ],
    reference: ramadanWomenQuran,
  ),
  RamadanTopic(
    section: RamadanSection.women,
    title: RamadanText('Make-up fast planning', 'কাজা রোজার পরিকল্পনা'),
    summary: RamadanText(
      'Write down missed days and plan to make them up when able.',
      'বাদ যাওয়া দিন লিখে রাখুন এবং সক্ষম হলে কাজার পরিকল্পনা করুন।',
    ),
    points: [
      RamadanText(
        'The timing of delayed make-up days and any fidyah can depend on the circumstances and school of law.',
        'কাজায় দেরি বা ফিদইয়ার বিধান পরিস্থিতি ও মাযহাবভেদে ভিন্ন হতে পারে।',
      ),
      RamadanText(
        'Keep a private record; no public explanation of your reason is needed.',
        'ব্যক্তিগত হিসাব রাখুন; কারণ অন্যদের জানানো প্রয়োজন নেই।',
      ),
    ],
    reference: ramadanWomenFasts,
  ),
];
