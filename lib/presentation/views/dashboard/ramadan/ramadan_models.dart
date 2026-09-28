import 'package:flutter/material.dart';

class RamadanText {
  const RamadanText(this.en, this.bn);

  final String en;
  final String bn;

  String of(bool isBangla) => isBangla ? bn : en;
}

enum RamadanSection {
  essentials,
  dailyLife,
  worship,
  women,
  lastTen,
  giving,
  questions,
}

extension RamadanSectionDetails on RamadanSection {
  RamadanText get title => switch (this) {
    RamadanSection.essentials => const RamadanText('Fasting', 'রোজা'),
    RamadanSection.dailyLife => const RamadanText('Daily life', 'প্রতিদিন'),
    RamadanSection.worship => const RamadanText('Worship', 'ইবাদত'),
    RamadanSection.women => const RamadanText('Women', 'নারীদের জন্য'),
    RamadanSection.lastTen => const RamadanText('Last ten', 'শেষ দশ দিন'),
    RamadanSection.giving => const RamadanText('Giving & Eid', 'দান ও ঈদ'),
    RamadanSection.questions => const RamadanText('Questions', 'জিজ্ঞাসা'),
  };

  IconData get icon => switch (this) {
    RamadanSection.essentials => Icons.wb_twilight_rounded,
    RamadanSection.dailyLife => Icons.wb_sunny_outlined,
    RamadanSection.worship => Icons.menu_book_rounded,
    RamadanSection.women => Icons.favorite_outline_rounded,
    RamadanSection.lastTen => Icons.nights_stay_rounded,
    RamadanSection.giving => Icons.volunteer_activism_outlined,
    RamadanSection.questions => Icons.help_outline_rounded,
  };
}

class RamadanReference {
  const RamadanReference(this.label, this.url);

  final String label;
  final String url;
}

class RamadanTopic {
  const RamadanTopic({
    required this.section,
    required this.title,
    required this.summary,
    required this.points,
    this.reference,
  });

  final RamadanSection section;
  final RamadanText title;
  final RamadanText summary;
  final List<RamadanText> points;
  final RamadanReference? reference;
}


String ramadanLabel(bool bn, String en, String bangla) => bn ? bangla : en;
