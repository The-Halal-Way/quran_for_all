import 'package:flutter/material.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/views/prayer/special_prayer/special_prayer_view.dart';

// MARK: Prayer - Salatul Tasbeeh Route
class SalatulTasbeehView extends StatelessWidget {
  const SalatulTasbeehView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpecialPrayerView(type: SpecialPrayerType.salatulTasbeeh);
  }
}
