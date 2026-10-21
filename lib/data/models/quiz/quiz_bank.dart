import 'quiz_config.dart';
import 'quiz_config_validator.dart';
import 'quiz_failure.dart';
import 'quiz_json.dart';
import 'quiz_question.dart';

class QuizBank {
  const QuizBank({
    required this.language,
    required this.categoryId,
    required this.version,
    required this.reviewStatus,
    required this.questions,
  });
  final String language, categoryId, version, reviewStatus;
  final List<QuizQuestion> questions;

  factory QuizBank.fromJson(
    Map<String, dynamic> json,
    QuizConfig config,
    String language,
    String category,
  ) {
    quizRequire(
      json['schemaVersion'] ==
          config.section('assets')['requiredBankSchemaVersion'],
      'Bank schema mismatch',
    );
    quizRequire(
      json['language'] == language && json['categoryId'] == category,
      'Bank language/category mismatch',
    );
    if (config.usesQuestionStyles) {
      quizRequire(
        json['audienceId'] == config.audienceId &&
            json['levelId'] == config.levelId,
        'Bank audience/level mismatch',
      );
    }
    // Hints describe the bank; attempt rules always come from quiz_config.
    final questions = quizList(
      json['questions'],
    ).map((raw) => QuizQuestion.fromJson(quizMap(raw))).toList(growable: false);
    quizRequire(
      quizInt(json['questionCount']) == questions.length,
      'Bank question count mismatch',
    );
    final groups = config.usesQuestionStyles
        ? quizQuestionStyles
        : quizDifficulties;
    final counts = quizMap(
      json[config.usesQuestionStyles
          ? 'questionStyleCounts'
          : 'difficultyCounts'],
    );
    quizRequire(
      counts.keys.toSet().containsAll(groups) && counts.length == groups.length,
      'Invalid question group counts',
    );
    for (final group in groups) {
      quizRequire(
        quizInt(counts[group]) ==
            questions
                .where((question) => question.quotaGroup(config) == group)
                .length,
        'Bank question group count mismatch',
      );
      if (quizInt(counts[group]) < (config.quotas[group] ?? 0)) {
        throw const QuizFailure(QuizFailureCode.insufficientQuestions);
      }
    }
    quizRequire(
      questions.every((question) => question.categoryId == category),
      'Question category mismatch',
    );
    return QuizBank(
      language: language,
      categoryId: category,
      version: quizString(json['bankVersion']),
      reviewStatus: quizString(quizMap(json['review'])['status']),
      questions: List.unmodifiable(questions),
    );
  }
}
