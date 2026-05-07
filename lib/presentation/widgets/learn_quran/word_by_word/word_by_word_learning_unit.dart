import 'package:flutter/material.dart';

import 'word_by_word_ayah_map_section.dart';
import 'word_by_word_connector_section.dart';
import 'word_by_word_learning_flow_section.dart';
import 'word_by_word_phrase_breakdown_section.dart';
import 'word_by_word_revision_section.dart';
import 'word_by_word_root_family_section.dart';
import 'word_by_word_vocabulary_section.dart';

class WordByWordLearningUnit extends StatelessWidget {
  const WordByWordLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Learning flow map for the Word-by-Word track.
        WordByWordLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: High-frequency vocabulary foundation.
        WordByWordVocabularySection(),
        SizedBox(height: 10),

        // Section 3: Root-family meaning recognition.
        WordByWordRootFamilySection(),
        SizedBox(height: 10),

        // Section 4: Connector words and particle cues.
        WordByWordConnectorSection(),
        SizedBox(height: 10),

        // Section 5: Phrase breakdown lab.
        WordByWordPhraseBreakdownSection(),
        SizedBox(height: 10),

        // Section 6: Ayah-level word map practice.
        WordByWordAyahMapSection(),
        SizedBox(height: 10),

        // Section 7: Revision and mastery checklist.
        WordByWordRevisionSection(),
      ],
    );
  }
}
