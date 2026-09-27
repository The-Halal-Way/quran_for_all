import '../eid_prayer_models.dart';

const eidFitrOverview = EidSection(
  title: EidText('Eid al-Fitr', 'ঈদুল ফিতর'),
  intro: EidText(
    'The Festival of Breaking the Fast begins on 1 Shawwal after Ramadan. It is a day of gratitude, worship, charity, forgiveness and joy.',
    'রমজানের পর শাওয়ালের ১ তারিখে ঈদুল ফিতর। এটি কৃতজ্ঞতা, ইবাদত, দান, ক্ষমা ও আনন্দের দিন।',
  ),
  entries: [
    EidEntry(
      title: EidText('The prayer', 'ঈদের নামাজ'),
      body: EidText(
        'Pray two rak’ahs with the community. The prayer comes before the khutbah and has no adhan or iqamah.',
        'জামাতের সঙ্গে দুই রাকাত নামাজ আদায় করুন। নামাজের পরে খুতবা হয়; এতে আজান বা ইকামত নেই।',
      ),
      reference: 'Sahih Muslim 885',
      badge: EidText('1 SHAWWAL', '১ শাওয়াল'),
    ),
    EidEntry(
      title: EidText('The Fitr distinction', 'ফিতরের বিশেষ আমল'),
      body: EidText(
        'Give Sadaqat al-Fitr before prayer and eat something before leaving. The Prophet ﷺ ate dates before going out.',
        'নামাজের আগে সদকাতুল ফিতর আদায় করুন এবং বের হওয়ার আগে কিছু খান। রাসূল ﷺ বের হওয়ার আগে খেজুর খেতেন।',
      ),
      reference: 'Sahih al-Bukhari 953',
    ),
  ],
);

const eidAdhaOverview = EidSection(
  title: EidText('Eid al-Adha', 'ঈদুল আযহা'),
  intro: EidText(
    'The Festival of Sacrifice falls on 10 Dhul Hijjah. It recalls Prophet Ibrahim’s obedience to Allah and brings prayer, takbeer, sacrifice and generosity together.',
    'জিলহজের ১০ তারিখে ঈদুল আযহা। এটি আল্লাহর প্রতি ইবরাহিম (আ.)-এর আনুগত্য স্মরণ করায় এবং নামাজ, তাকবীর, কুরবানি ও উদারতার দিন।',
  ),
  entries: [
    EidEntry(
      title: EidText('The prayer', 'ঈদের নামাজ'),
      body: EidText(
        'Pray two rak’ahs with the community. The prayer comes before the khutbah and has no adhan or iqamah.',
        'জামাতের সঙ্গে দুই রাকাত নামাজ আদায় করুন। নামাজের পরে খুতবা হয়; এতে আজান বা ইকামত নেই।',
      ),
      reference: 'Sahih Muslim 885',
      badge: EidText('10 DHUL HIJJAH', '১০ জিলহজ'),
    ),
    EidEntry(
      title: EidText('The Adha distinction', 'আযহার বিশেষ আমল'),
      body: EidText(
        'The sacrifice follows the Eid prayer. Eat from it and share with family, relatives and people in need.',
        'ঈদের নামাজের পরে কুরবানি করুন। কুরবানির গোশত নিজে খান এবং পরিবার, আত্মীয় ও অভাবীদের সঙ্গে ভাগ করুন।',
      ),
      reference: 'Sahih al-Bukhari 5565',
    ),
  ],
);

const eidPreparationSection = EidSection(
  title: EidText('Prepare for the gathering', 'জামাতের প্রস্তুতি'),
  entries: [
    EidEntry(
      title: EidText('Ghusl and good clothes', 'গোসল ও সুন্দর পোশাক'),
      body: EidText(
        'Bathe and wear clean, good clothes as recommended Eid preparations.',
        'ঈদের উত্তম প্রস্তুতি হিসেবে গোসল করুন এবং পরিষ্কার, সুন্দর পোশাক পরুন।',
      ),
    ),
    EidEntry(
      title: EidText('Remember Allah on the way', 'পথে আল্লাহকে স্মরণ'),
      body: EidText(
        'Recite Eid takbeer on the way to the prayer. The words and pronunciation are in Dhikr & duas.',
        'নামাজে যাওয়ার পথে ঈদের তাকবীর পাঠ করুন। যিকির ও দোয়া অংশে আরবি পাঠ ও উচ্চারণ দেওয়া আছে।',
      ),
    ),
    EidEntry(
      title: EidText('Return by another route', 'ফেরার পথে অন্য রাস্তা'),
      body: EidText(
        'The Prophet ﷺ used a different route when returning from Eid prayer.',
        'রাসূল ﷺ ঈদের নামাজ থেকে ফেরার সময় ভিন্ন রাস্তা ব্যবহার করতেন।',
      ),
      reference: 'Sahih al-Bukhari 986',
    ),
  ],
);

const eidAttendanceSection = EidSection(
  title: EidText('Together on Eid', 'ঈদে একসঙ্গে'),
  entries: [
    EidEntry(
      title: EidText('Women and children', 'নারী ও শিশু'),
      body: EidText(
        'The Prophet ﷺ encouraged women, including young women and those usually staying at home, to attend the Eid gathering. Families and children can share in the occasion.',
        'রাসূল ﷺ তরুণী ও সাধারণত ঘরে থাকা নারীদেরও ঈদের সমাবেশে অংশ নিতে উৎসাহ দিয়েছেন। পরিবার ও শিশুরাও এই আনন্দে অংশ নিতে পারে।',
      ),
      reference: 'Sahih al-Bukhari 971, 974',
    ),
  ],
);
