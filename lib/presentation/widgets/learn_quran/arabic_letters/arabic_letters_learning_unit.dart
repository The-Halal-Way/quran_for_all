import 'package:flutter/material.dart';

import 'arabic_letters_alphabet_map_section.dart';
import 'arabic_letters_articulation_section.dart';
import 'arabic_letters_harakah_section.dart';
import 'arabic_letters_learning_flow_section.dart';
import 'arabic_letters_reading_examples_section.dart';
import 'arabic_letters_revision_section.dart';
import 'arabic_letters_shape_family_section.dart';
import 'arabic_letters_similar_letters_section.dart';

class ArabicLettersLearningUnit extends StatelessWidget {
  const ArabicLettersLearningUnit({super.key});

  @override
  Widget build(BuildContext context) {
    // Section cards and data models localize visible copy through context.learnText.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Learning flow map for Arabic letters.
        ArabicLettersLearningFlowSection(),
        SizedBox(height: 10),

        // Section 2: Full isolated alphabet map.
        ArabicLettersAlphabetMapSection(),
        SizedBox(height: 10),

        // Section 3: Shape-family grouping.
        ArabicLettersShapeFamilySection(),
        SizedBox(height: 10),

        // Section 4: Similar-letter comparison grid.
        ArabicLettersSimilarLettersSection(),
        SizedBox(height: 10),

        // Section 5: Articulation zone cues.
        ArabicLettersArticulationSection(),
        SizedBox(height: 10),

        // Section 6: Harakah and sukoon pattern training.
        ArabicLettersHarakahSection(),
        SizedBox(height: 10),

        // Section 7: Beginner reading examples.
        ArabicLettersReadingExamplesSection(),
        SizedBox(height: 10),

        // Section 8: Revision and mastery checklist.
        ArabicLettersRevisionSection(),
      ],
    );
  }
}
