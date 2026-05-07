import 'package:flutter/material.dart';

import 'makharij_applied_phrase_section.dart';
import 'makharij_comparison_section.dart';
import 'makharij_drills_section.dart';
import 'makharij_learning_flow_section.dart';
import 'makharij_revision_section.dart';
import 'makharij_zone_map_section.dart';

class MakharijLearningUnit extends StatelessWidget {
  const MakharijLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Learning flow map for Makharij.
        MakharijLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: Articulation zone map.
        MakharijZoneMapSection(),
        SizedBox(height: 10),

        // Section 3: Confusion pair corrections.
        MakharijComparisonSection(),
        SizedBox(height: 10),

        // Section 4: Guided drills.
        MakharijDrillsSection(),
        SizedBox(height: 10),

        // Section 5: Applied phrase practice.
        MakharijAppliedPhraseSection(),
        SizedBox(height: 10),

        // Section 6: Revision and mastery checklist.
        MakharijRevisionSection(),
      ],
    );
  }
}
