import 'package:flutter/material.dart';

import '../../../../core/constants/quiz_catalog.dart';
import '../../../../l10n/app_localizations.dart';

class QuizTrackLabels {
  const QuizTrackLabels._();

  static String audience(AppLocalizations l10n, QuizAudience audience) =>
      switch (audience) {
        QuizAudience.kids => l10n.quizAudienceKids,
        QuizAudience.general => l10n.quizAudienceGeneral,
        QuizAudience.islamicallyEducated => l10n.quizAudienceEducated,
      };

  static String description(AppLocalizations l10n, QuizAudience audience) =>
      switch (audience) {
        QuizAudience.kids => l10n.quizAudienceKidsDescription,
        QuizAudience.general => l10n.quizAudienceGeneralDescription,
        QuizAudience.islamicallyEducated =>
          l10n.quizAudienceEducatedDescription,
      };

  static String level(AppLocalizations l10n, QuizLevel level) =>
      switch (level) {
        QuizLevel.beginner => l10n.quizLevelBeginner,
        QuizLevel.intermediate => l10n.quizIntermediate,
        QuizLevel.pro => l10n.quizLevelPro,
      };

  static Color color(QuizAudience audience) => switch (audience) {
    QuizAudience.kids => const Color(0xFF009C9C),
    QuizAudience.general => const Color(0xFFBA7721),
    QuizAudience.islamicallyEducated => const Color(0xFF8860E6),
  };

  static IconData icon(QuizAudience audience) => switch (audience) {
    QuizAudience.kids => Icons.auto_awesome_rounded,
    QuizAudience.general => Icons.explore_rounded,
    QuizAudience.islamicallyEducated => Icons.menu_book_rounded,
  };
}
