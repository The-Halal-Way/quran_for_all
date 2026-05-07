import 'package:flutter/material.dart';

import 'pronunciation_basics_applied_phrase_section.dart';
import 'pronunciation_basics_contrast_section.dart';
import 'pronunciation_basics_flow_drill_section.dart';
import 'pronunciation_basics_learning_flow_section.dart';
import 'pronunciation_basics_madd_section.dart';
import 'pronunciation_basics_posture_section.dart';
import 'pronunciation_basics_revision_section.dart';
import 'pronunciation_basics_stop_restart_section.dart';

class PronunciationBasicsLearningUnit extends StatelessWidget {
  const PronunciationBasicsLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Learning flow map for pronunciation basics.
        PronunciationBasicsLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: Heavy vs light contrast grid.
        PronunciationBasicsContrastSection(),
        SizedBox(height: 10),

        // Section 3: Articulation and posture indicators.
        PronunciationBasicsPostureSection(),
        SizedBox(height: 10),

        // Section 4: Madd timing and vowel length control.
        PronunciationBasicsMaddSection(),
        SizedBox(height: 10),

        // Section 5: Pause and restart guidance.
        PronunciationBasicsStopRestartSection(),
        SizedBox(height: 10),

        // Section 6: Rhythm and flow drills.
        PronunciationBasicsFlowDrillSection(),
        SizedBox(height: 10),

        // Section 7: Applied phrase practice.
        PronunciationBasicsAppliedPhraseSection(),
        SizedBox(height: 10),

        // Section 8: Revision and mastery checklist.
        PronunciationBasicsRevisionSection(),
      ],
    );
  }
}
