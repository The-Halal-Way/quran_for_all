import '../eid_prayer_models.dart';

const eidMorningSection = EidSection(
  title: EidText('Your Eid morning', 'ঈদের সকাল'),
  entries: [
    EidEntry(
      title: EidText('Before Fajr', 'ফজরের আগে'),
      body: EidText(
        'Wake and prepare spiritually; pray tahajjud if possible.',
        'ঘুম থেকে উঠে ইবাদতের প্রস্তুতি নিন; সম্ভব হলে তাহাজ্জুদ পড়ুন।',
      ),
    ),
    EidEntry(
      title: EidText('After Fajr', 'ফজরের পরে'),
      body: EidText(
        'Pray Fajr and recite morning adhkar.',
        'ফজরের নামাজ আদায় করুন এবং সকালের যিকির পড়ুন।',
      ),
    ),
    EidEntry(
      title: EidText('Before Eid prayer', 'ঈদের নামাজের আগে'),
      body: EidText(
        'Perform ghusl, wear good clean clothes and recite takbeer on the way to the congregation.',
        'গোসল করুন, পরিষ্কার সুন্দর পোশাক পরুন এবং জামাতে যাওয়ার পথে তাকবীর পড়ুন।',
      ),
    ),
  ],
);

const eidFitrDaySection = EidSection(
  title: EidText('Eid al-Fitr checklist', 'ঈদুল ফিতরের তালিকা'),
  entries: [
    EidEntry(
      title: EidText('Give before prayer', 'নামাজের আগে দান'),
      body: EidText(
        'Give Sadaqat al-Fitr before the Eid prayer.',
        'ঈদের নামাজের আগে সদকাতুল ফিতর আদায় করুন।',
      ),
    ),
    EidEntry(
      title: EidText('Eat before leaving', 'বের হওয়ার আগে খান'),
      body: EidText(
        'Eat something before prayer. The Prophet ﷺ ate an odd number of dates before leaving.',
        'নামাজের আগে কিছু খান। রাসূল ﷺ বের হওয়ার আগে বিজোড় সংখ্যক খেজুর খেতেন।',
      ),
      reference: 'Sahih al-Bukhari 953',
    ),
  ],
);

const eidAdhaDaySection = EidSection(
  title: EidText('Eid al-Adha checklist', 'ঈদুল আযহার তালিকা'),
  entries: [
    EidEntry(
      title: EidText('Wait until after prayer to eat', 'খাবার নামাজের পরে'),
      body: EidText(
        'It is recommended to eat after the prayer, preferably from the sacrifice.',
        'নামাজের পরে, সম্ভব হলে কুরবানির গোশত থেকে খাওয়া উত্তম।',
      ),
      reference: 'Musnad Ahmad 22984',
    ),
    EidEntry(
      title: EidText('Offer the sacrifice', 'কুরবানি করুন'),
      arabic: 'بِسْمِ اللَّهِ، اللَّهُ أَكْبَرُ',
      pronunciation: EidText(
        'Bismillāh, Allāhu akbar.',
        'বিসমিল্লাহ, আল্লাহু আকবার।',
      ),
      meaning: EidText(
        'In the name of Allah. Allah is the Greatest.',
        'আল্লাহর নামে। আল্লাহ সর্বশ্রেষ্ঠ।',
      ),
      body: EidText(
        'Perform the sacrifice after Eid prayer. Say Bismillah and Allahu Akbar when slaughtering.',
        'ঈদের নামাজের পরে কুরবানি করুন। জবাইয়ের সময় বিসমিল্লাহ ও আল্লাহু আকবার বলুন।',
      ),
      reference: 'Sahih al-Bukhari 5565',
    ),
    EidEntry(
      title: EidText('Share the meat', 'গোশত ভাগ করুন'),
      body: EidText(
        'Eat from the sacrifice and share with family, relatives and people in need.',
        'কুরবানির গোশত নিজে খান এবং পরিবার, আত্মীয় ও অভাবীদের মাঝে ভাগ করুন।',
      ),
    ),
  ],
);

const eidAfterSection = EidSection(
  title: EidText('Once prayer ends', 'নামাজ শেষে'),
  entries: [
    EidEntry(
      title: EidText('Worship and connection', 'ইবাদত ও সম্পর্ক'),
      body: EidText(
        'Listen to the khutbah, remember Allah, make dua, visit family and relatives, and share happiness while maintaining good relationships.',
        'খুতবা শুনুন, আল্লাহকে স্মরণ ও দোয়া করুন, পরিবার ও আত্মীয়দের সঙ্গে দেখা করুন এবং সুন্দর সম্পর্ক বজায় রেখে আনন্দ ভাগ করুন।',
      ),
    ),
  ],
);
