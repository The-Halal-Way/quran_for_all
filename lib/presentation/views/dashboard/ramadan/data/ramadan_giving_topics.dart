import '../ramadan_models.dart';
import 'ramadan_references.dart';

const ramadanGivingTopics = <RamadanTopic>[
  RamadanTopic(
    section: RamadanSection.giving,
    title: RamadanText('Zakat al-Fitr', 'সাদাকাতুল ফিতর'),
    summary: RamadanText(
      'Plan this separately from annual Zakat al-Mal and arrange delivery before the Eid prayer.',
      'বার্ষিক যাকাত থেকে আলাদা করে ফিতরার পরিকল্পনা করুন এবং ঈদের নামাজের আগে পৌঁছানোর ব্যবস্থা করুন।',
    ),
    points: [
      RamadanText(
        'Amount, food-versus-cash practice and collection deadlines vary locally; check a trusted local authority.',
        'পরিমাণ, খাদ্য না নগদ দেওয়ার পদ্ধতি ও জমার শেষ সময় স্থানীয়ভাবে ভিন্ন; নির্ভরযোগ্য কর্তৃপক্ষকে জিজ্ঞেস করুন।',
      ),
      RamadanText(
        'Include those you are responsible for according to your school of law.',
        'আপনার মাযহাব অনুযায়ী যাদের পক্ষ থেকে দেওয়ার দায়িত্ব আছে তাদের হিসাব করুন।',
      ),
    ],
    reference: ramadanFitr,
  ),
  RamadanTopic(
    section: RamadanSection.giving,
    title: RamadanText('Zakat al-Mal', 'সম্পদের যাকাত'),
    summary: RamadanText(
      'If your zakat year falls in Ramadan, use the Zakat Calculator to organize an estimate.',
      'আপনার যাকাতের বছর রমজানে পূর্ণ হলে হিসাব সাজাতে যাকাত ক্যালকুলেটর ব্যবহার করুন।',
    ),
    points: [
      RamadanText(
        'Zakat al-Mal has its own nisab and lunar-year rules; Ramadan itself is not a required due date for everyone.',
        'সম্পদের যাকাতের নিজস্ব নিসাব ও চান্দ্র বছরের নিয়ম আছে; সবার জন্য রমজান নির্ধারিত সময় নয়।',
      ),
      RamadanText(
        'Ask a qualified adviser about complex assets and liabilities.',
        'জটিল সম্পদ ও ঋণের ক্ষেত্রে যোগ্য পরামর্শ নিন।',
      ),
    ],
  ),
  RamadanTopic(
    section: RamadanSection.giving,
    title: RamadanText('Prepare for Eid', 'ঈদের প্রস্তুতি'),
    summary: RamadanText(
      'Confirm Eid through local moon-sighting and prepare charity, prayer and family plans.',
      'স্থানীয় চাঁদ দেখার সিদ্ধান্তে ঈদ নিশ্চিত করুন; দান, নামাজ ও পরিবারের পরিকল্পনা করুন।',
    ),
    points: [
      RamadanText(
        'Use the Eid Prayer Guide in the app for a practical overview.',
        'ব্যবহারিক ধারণার জন্য অ্যাপের ঈদের নামাজের গাইড দেখুন।',
      ),
      RamadanText(
        'Keep generosity and good habits after Ramadan ends.',
        'রমজানের পরেও দান ও ভালো অভ্যাস চালিয়ে যান।',
      ),
    ],
    reference: ramadanMoon,
  ),
  RamadanTopic(
    section: RamadanSection.giving,
    title: RamadanText('After Ramadan: Shawwal', 'রমজানের পর: শাওয়াল'),
    summary: RamadanText(
      'Six voluntary fasts in Shawwal are encouraged after Ramadan.',
      'রমজানের পর শাওয়ালে ছয়টি নফল রোজার উৎসাহ দেওয়া হয়েছে।',
    ),
    points: [
      RamadanText(
        'Keep track of any Ramadan make-up fasts as a separate obligation.',
        'রমজানের কাজা রোজা আলাদা দায়িত্ব হিসেবে হিসাব করুন।',
      ),
      RamadanText(
        'Ask a trusted scholar about ordering or combining fasts if you have missed days.',
        'কাজা বাকি থাকলে কোনটি আগে বা একসঙ্গে রাখা যাবে কি না, তা নির্ভরযোগ্য আলেমকে জিজ্ঞেস করুন।',
      ),
    ],
    reference: ramadanShawwal,
  ),
];
