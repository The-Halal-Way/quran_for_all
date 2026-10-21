import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/quiz/quiz_failure.dart';
import '../../../../l10n/app_localizations.dart';

abstract final class QuizLabels {
  static String category(AppLocalizations l10n, String id) => switch (id) {
    'beliefs_foundations' => l10n.quizBeliefs,
    'quran_knowledge' => l10n.quizQuran,
    'seerah' => l10n.quizSeerah,
    'hadith_knowledge' => l10n.quizHadith,
    'everyday_worship' => l10n.quizWorship,
    'character_conduct' => l10n.quizCharacter,
    _ => l10n.quizSubjects,
  };
  static String questionGroup(AppLocalizations l10n, String id) => switch (id) {
    'foundation' => l10n.quizFoundation,
    'intermediate' => l10n.quizIntermediate,
    'familiar_fact' => l10n.quizStyleFamiliarFact,
    'broader_basic' => l10n.quizStyleBroaderBasic,
    'everyday_application' => l10n.quizStyleEverydayApplication,
    _ => l10n.quizAdvanced,
  };
  static String outcome(AppLocalizations l10n, String id) => switch (id) {
    'correct' => l10n.quizCorrect,
    'incorrect' => l10n.quizIncorrect,
    'unknown' => l10n.quizUnknown,
    _ => l10n.quizUnanswered,
  };
  static String failure(AppLocalizations l10n, QuizFailureCode code) =>
      switch (code) {
        QuizFailureCode.configuration => l10n.quizErrorConfig,
        QuizFailureCode.assets => l10n.quizErrorAssets,
        QuizFailureCode.translation => l10n.quizErrorTranslation,
        QuizFailureCode.insufficientQuestions => l10n.quizErrorInsufficient,
        QuizFailureCode.storage => l10n.quizErrorStorage,
        QuizFailureCode.savedAttempt => l10n.quizErrorSaved,
        QuizFailureCode.reviewRequired => l10n.quizErrorReview,
        QuizFailureCode.cooldown => l10n.quizErrorCooldown,
      };
  static Color outcomeColor(ColorScheme scheme, String outcome) =>
      switch (outcome) {
        'correct' => const Color(0xFF159A83),
        'incorrect' => scheme.error,
        'unknown' => const Color(0xFFC38A25),
        _ => scheme.onSurfaceVariant,
      };
  static IconData categoryIcon(String id) => switch (id) {
    'beliefs_foundations' => Icons.wb_sunny_rounded,
    'quran_knowledge' => Icons.menu_book_rounded,
    'seerah' => Icons.travel_explore_rounded,
    'hadith_knowledge' => Icons.auto_stories_rounded,
    'everyday_worship' => Icons.mosque_rounded,
    _ => Icons.volunteer_activism_rounded,
  };
  static String number(AppLocalizations l10n, num number, {int decimals = 0}) =>
      NumberFormat.decimalPatternDigits(
        locale: l10n.localeName,
        decimalDigits: decimals,
      ).format(number);
}
