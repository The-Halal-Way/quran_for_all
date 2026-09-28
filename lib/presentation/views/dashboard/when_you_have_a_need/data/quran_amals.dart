import '../need_amal.dart';
import 'need_references.dart';

const quranAmals = <NeedAmal>[
  NeedAmal(
    id: 'quran_khatm',
    category: NeedCategory.quran,
    title: NeedText('Quran Khatm', 'কুরআন খতম'),
    description: NeedText(
      'Complete the Qur’an with reflection, then ask Allah for mercy in your own words.',
      'অর্থ বোঝার চেষ্টা করে কুরআন শেষ করুন, তারপর নিজের ভাষায় আল্লাহর রহমত চান।',
    ),
    steps: [
      NeedText(
        'Set a sustainable reading plan and keep the intention sincere.',
        'সাধ্যের মধ্যে পড়ার পরিকল্পনা করুন ও নিয়ত আন্তরিক রাখুন।',
      ),
      NeedText(
        'Read attentively and respectfully; reflection matters more than a rushed finish.',
        'মনোযোগ ও আদবের সঙ্গে পড়ুন; তাড়াহুড়ার চেয়ে চিন্তা করে পড়া গুরুত্বপূর্ণ।',
      ),
      NeedText(
        'After completion, praise Allah and make personal du’a for mercy, guidance and others.',
        'শেষে আল্লাহর প্রশংসা করে নিজের, অন্যদের, রহমত ও হিদায়াতের জন্য দোয়া করুন।',
      ),
    ],
    authenticity: NeedText(
      'Early practice · scholarly discussion',
      'প্রাথমিক যুগের আমল · আলেমদের আলোচনা',
    ),
    evidenceNote: NeedText(
      'Reports describe Anas gathering his family for du’a after completion. Scholars discuss its form; no particular Khatm wording or guaranteed outcome is established here.',
      'আনাস (রা.) খতমের পর পরিবার নিয়ে দোয়া করতেন বলে বর্ণনা আছে। এর পদ্ধতি নিয়ে আলেমদের আলোচনা আছে; এখানে নির্দিষ্ট দোয়া বা ফল নিশ্চিত বলা হচ্ছে না।',
    ),
    timing: NeedText(
      'After completing the Qur’an; at your own pace',
      'কুরআন শেষ করার পর; নিজের গতিতে',
    ),
    duaNote: NeedText(
      'No fixed Arabic “Khatm du’a” is required. Ask Allah sincerely in any language.',
      'খতমের জন্য নির্দিষ্ট আরবি দোয়া বাধ্যতামূলক নয়। যেকোনো ভাষায় আন্তরিকভাবে চান।',
    ),
    references: [needQuranMercy, needQuranKhatm, needKhatmDiscussion],
    progressKind: NeedProgressKind.juz,
  ),
];
