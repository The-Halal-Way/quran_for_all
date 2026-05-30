import 'package:flutter/material.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer/special_prayer_view.dart';

class JanazaPrayerView extends StatelessWidget {
  const JanazaPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpecialPrayerView(type: SpecialPrayerType.janaza);
  }
}
