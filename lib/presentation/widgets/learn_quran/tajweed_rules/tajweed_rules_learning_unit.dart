import 'package:flutter/material.dart';

import 'tajweed_applied_phrase_section.dart';
import 'tajweed_learning_flow_section.dart';
import 'tajweed_meem_saakin_section.dart';
import 'tajweed_noon_tanween_section.dart';
import 'tajweed_qalqalah_madd_section.dart';
import 'tajweed_revision_section.dart';
import 'tajweed_waqf_section.dart';

class TajweedRulesLearningUnit extends StatelessWidget {
  const TajweedRulesLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Visual learning flow for the Tajweed track.
        TajweedLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: Noon saakin and tanween core rules.
        TajweedNoonTanweenSection(),
        SizedBox(height: 10),

        // Section 3: Meem saakin rule application.
        TajweedMeemSaakinSection(),
        SizedBox(height: 10),

        // Section 4: Qalqalah and madd timing discipline.
        TajweedQalqalahMaddSection(),
        SizedBox(height: 10),

        // Section 5: Waqf and restart stability.
        TajweedWaqfSection(),
        SizedBox(height: 10),

        // Section 6: Applied phrase practice.
        TajweedAppliedPhraseSection(),
        SizedBox(height: 10),

        // Section 7: Final revision and mastery checklist.
        TajweedRevisionSection(),
      ],
    );
  }
}
