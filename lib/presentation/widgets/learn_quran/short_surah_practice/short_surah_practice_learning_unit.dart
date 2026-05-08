import 'package:flutter/material.dart';

import 'short_surah_focus_section.dart';
import 'short_surah_learning_flow_section.dart';
import 'short_surah_meaning_link_section.dart';
import 'short_surah_memorization_cycle_section.dart';
import 'short_surah_revision_section.dart';
import 'short_surah_salah_readiness_section.dart';
import 'short_surah_tajweed_focus_section.dart';

class ShortSurahPracticeLearningUnit extends StatelessWidget {
  const ShortSurahPracticeLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    // Section cards and data models localize visible copy through context.learnText.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Learning flow map for the Short Surah track.
        ShortSurahLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: Surah objective and focus map.
        ShortSurahFocusSection(),
        SizedBox(height: 10),

        // Section 3: Tajweed focus targets.
        ShortSurahTajweedFocusSection(),
        SizedBox(height: 10),

        // Section 4: Memorization cycle routine.
        ShortSurahMemorizationCycleSection(),
        SizedBox(height: 10),

        // Section 5: Salah readiness checks.
        ShortSurahSalahReadinessSection(),
        SizedBox(height: 10),

        // Section 6: Meaning-linked recitation.
        ShortSurahMeaningLinkSection(),
        SizedBox(height: 10),

        // Section 7: Final revision and mastery checklist.
        ShortSurahRevisionSection(),
      ],
    );
  }
}
