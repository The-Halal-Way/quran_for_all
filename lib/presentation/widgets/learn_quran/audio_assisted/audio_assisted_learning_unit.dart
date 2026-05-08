import 'package:flutter/material.dart';

import 'audio_assisted_error_spot_section.dart';
import 'audio_assisted_learning_flow_section.dart';
import 'audio_assisted_listening_section.dart';
import 'audio_assisted_revision_section.dart';
import 'audio_assisted_sample_section.dart';
import 'audio_assisted_session_plan_section.dart';
import 'audio_assisted_shadow_section.dart';

class AudioAssistedLearningUnit extends StatelessWidget {
  const AudioAssistedLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    // Section cards and data models localize visible copy through context.learnText.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Learning flow map for audio-assisted training.
        AudioAssistedLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: Focused listening drills.
        AudioAssistedListeningSection(),
        SizedBox(height: 10),

        // Section 3: Shadow recitation rounds.
        AudioAssistedShadowSection(),
        SizedBox(height: 10),

        // Section 4: Error spotting and correction map.
        AudioAssistedErrorSpotSection(),
        SizedBox(height: 10),

        // Section 5: Guided session plan.
        AudioAssistedSessionPlanSection(),
        SizedBox(height: 10),

        // Section 6: Targeted sample practice.
        AudioAssistedSampleSection(),
        SizedBox(height: 10),

        // Section 7: Revision and mastery checklist.
        AudioAssistedRevisionSection(),
      ],
    );
  }
}
