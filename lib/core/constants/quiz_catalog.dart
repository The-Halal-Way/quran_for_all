enum QuizAudience { kids, general, islamicallyEducated }

enum QuizLevel { beginner, intermediate, pro }

/// Static routing metadata. Browsing audiences never reads question assets.
class QuizAssessmentDefinition {
  const QuizAssessmentDefinition({
    required this.audience,
    required this.level,
    required this.configPath,
    required this.databaseName,
  });

  final QuizAudience audience;
  final QuizLevel level;
  final String configPath;
  final String databaseName;
}

class QuizCatalog {
  const QuizCatalog._();

  static const generalBeginner = QuizAssessmentDefinition(
    audience: QuizAudience.general,
    level: QuizLevel.beginner,
    configPath: 'assets/json/quiz/general/beginner/quiz_config.json',
    databaseName: 'quiz_general_beginner_v1.db',
  );

  static const generalIntermediate = QuizAssessmentDefinition(
    audience: QuizAudience.general,
    level: QuizLevel.intermediate,
    configPath: 'assets/json/quiz/general/intermediate/quiz_config.json',
    databaseName: 'quiz_general_intermediate_v1.db',
  );

  static const generalPro = QuizAssessmentDefinition(
    audience: QuizAudience.general,
    level: QuizLevel.pro,
    configPath: 'assets/json/quiz/general/pro/quiz_config.json',
    databaseName: 'quiz_general_pro_v1.db',
  );

  static const educatedIntermediate = QuizAssessmentDefinition(
    audience: QuizAudience.islamicallyEducated,
    level: QuizLevel.intermediate,
    configPath:
        'assets/json/quiz/islamically_educated/intermediate/quiz_config.json',
    // Keep the existing database so the previous assessment's saved progress
    // and history follow it into this level without copying or deleting data.
    databaseName: 'islamic_knowledge_assessment_v1.db',
  );

  static const assessments = [
    generalBeginner,
    generalIntermediate,
    generalPro,
    educatedIntermediate,
  ];

  static QuizAssessmentDefinition? find(
    QuizAudience audience,
    QuizLevel level,
  ) {
    for (final assessment in assessments) {
      if (assessment.audience == audience && assessment.level == level) {
        return assessment;
      }
    }
    return null;
  }
}
