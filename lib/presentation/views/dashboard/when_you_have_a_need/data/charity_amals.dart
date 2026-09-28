import '../need_amal.dart';
import 'need_references.dart';

const charityAmals = <NeedAmal>[
  NeedAmal(
    id: 'sadaqah',
    category: NeedCategory.charity,
    title: NeedText('Sadaqah before Dua', 'দোয়ার আগে সদকা'),
    description: NeedText(
      'Give sincerely as a means of seeking Allah’s mercy, then make du’a.',
      'আল্লাহর রহমত পাওয়ার আশায় আন্তরিকভাবে দান করুন, তারপর দোয়া করুন।',
    ),
    steps: [
      NeedText(
        'Choose a lawful gift that is within your means.',
        'সামর্থ্য অনুযায়ী হালাল সম্পদ থেকে দান বেছে নিন।',
      ),
      NeedText(
        'Give to someone in need, privately when appropriate, without expecting a transaction in return.',
        'প্রয়োজনে কাউকে দিন; উপযুক্ত হলে গোপনে দিন, বিনিময়ের আশা করবেন না।',
      ),
      NeedText(
        'Thank Allah and ask for mercy and a good outcome.',
        'আল্লাহর শুকরিয়া আদায় করে রহমত ও কল্যাণকর ফল চান।',
      ),
    ],
    authenticity: NeedText(
      'Qur’anic charity; no fixed “before dua” formula',
      'কুরআনে দানের ফজিলত; “দোয়ার আগে” নির্দিষ্ট পদ্ধতি নয়',
    ),
    evidenceNote: NeedText(
      'Qur’an 2:271 praises charity and mentions expiation; Tirmidhi 2616 links charity with forgiveness. These sources do not make charity immediately before du’a a required sequence or guarantee a particular request.',
      'কুরআন ২:২৭১-এ দান ও পাপ মোচনের কথা আছে; তিরমিজি ২৬১৬-এ দানের ফজিলত এসেছে। তবে দোয়ার ঠিক আগে দান করা বাধ্যতামূলক ক্রম বা নির্দিষ্ট চাওয়া পূরণের নিশ্চয়তা নয়।',
    ),
    timing: NeedText(
      'Any time; no prescribed amount or sequence',
      'যেকোনো সময়; নির্দিষ্ট পরিমাণ বা ক্রম নেই',
    ),
    duaNote: NeedText(
      'No fixed Arabic wording is required after giving.',
      'দান করার পর নির্দিষ্ট আরবি বাক্য বাধ্যতামূলক নয়।',
    ),
    references: [needCharityVerse, needCharityHadith],
  ),
];
