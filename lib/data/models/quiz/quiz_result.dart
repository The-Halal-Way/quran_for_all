import 'quiz_config.dart';
import 'quiz_json.dart';
import 'quiz_question.dart';

enum QuizResponseStatus { answered, unknown, unanswered }

class QuizResponse {
  const QuizResponse(this.status, [this.selectedOptionId]);
  final QuizResponseStatus status;
  final String? selectedOptionId;
  Map<String, dynamic> toJson() => {
    'status': status.name,
    if (selectedOptionId != null) 'selectedOptionId': selectedOptionId,
  };
  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    final status = QuizResponseStatus.values.byName(quizString(json['status']));
    final id = json['selectedOptionId'];
    quizRequire(
      status == QuizResponseStatus.answered ? id is String : id == null,
      'Invalid response status/option',
    );
    return QuizResponse(status, id as String?);
  }
}

class QuizCounts {
  const QuizCounts({
    this.correct = 0,
    this.incorrect = 0,
    this.unknown = 0,
    this.unanswered = 0,
  });
  final int correct, incorrect, unknown, unanswered;
  int get total => correct + incorrect + unknown + unanswered;
  QuizCounts add(String outcome) => QuizCounts(
    correct: correct + (outcome == 'correct' ? 1 : 0),
    incorrect: incorrect + (outcome == 'incorrect' ? 1 : 0),
    unknown: unknown + (outcome == 'unknown' ? 1 : 0),
    unanswered: unanswered + (outcome == 'unanswered' ? 1 : 0),
  );
  Map<String, dynamic> toJson() => {
    'correct': correct,
    'incorrect': incorrect,
    'unknown': unknown,
    'unanswered': unanswered,
  };
  factory QuizCounts.fromJson(Map<String, dynamic> json) {
    final values = [
      'correct',
      'incorrect',
      'unknown',
      'unanswered',
    ].map((key) => quizInt(json[key])).toList();
    quizRequire(values.every((value) => value >= 0), 'Negative result count');
    return QuizCounts(
      correct: values[0],
      incorrect: values[1],
      unknown: values[2],
      unanswered: values[3],
    );
  }
}

class QuizResult {
  const QuizResult({
    required this.counts,
    required this.percentage,
    required this.points,
    required this.categories,
    required this.groupCounts,
    this.usesQuestionStyles = false,
  });
  final QuizCounts counts;
  final double percentage;
  final num points;
  final Map<String, QuizCounts> categories, groupCounts;
  final bool usesQuestionStyles;
  Map<String, dynamic> toJson() => {
    'counts': counts.toJson(),
    'percentage': percentage,
    'points': points,
    'categories': categories.map((key, value) => MapEntry(key, value.toJson())),
    (usesQuestionStyles ? 'questionStyles' : 'difficulties'): groupCounts.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
  };
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final percentage = (json['percentage'] as num).toDouble();
    final points = json['points'] as num;
    final counts = QuizCounts.fromJson(quizMap(json['counts']));
    quizRequire(
      percentage.isFinite &&
          percentage >= 0 &&
          percentage <= 100 &&
          points.isFinite &&
          points >= 0 &&
          counts.total > 0,
      'Invalid saved result',
    );
    return QuizResult(
      counts: counts,
      percentage: percentage,
      points: points,
      categories: Map.unmodifiable(
        quizMap(
          json['categories'],
        ).map((key, raw) => MapEntry(key, QuizCounts.fromJson(quizMap(raw)))),
      ),
      usesQuestionStyles: json.containsKey('questionStyles'),
      groupCounts: Map.unmodifiable(
        quizMap(
          json[json.containsKey('questionStyles')
              ? 'questionStyles'
              : 'difficulties'],
        ).map((key, raw) => MapEntry(key, QuizCounts.fromJson(quizMap(raw)))),
      ),
    );
  }
}

String quizOutcome(QuizQuestion question, QuizResponse? response) {
  if (response == null || response.status == QuizResponseStatus.unanswered) {
    return 'unanswered';
  }
  if (response.status == QuizResponseStatus.unknown) return 'unknown';
  return response.selectedOptionId == question.correctOptionId
      ? 'correct'
      : 'incorrect';
}

QuizResult gradeQuiz(
  QuizConfig config,
  Iterable<QuizQuestionSnapshot> snapshots,
  Map<String, QuizResponse> responses,
) {
  var counts = const QuizCounts();
  num points = 0;
  final categories = <String, QuizCounts>{
    for (final category in config.categories) category: const QuizCounts(),
  };
  final groups = <String, QuizCounts>{
    for (final quota in config.quotas.entries)
      if (quota.value > 0) quota.key: const QuizCounts(),
  };
  for (final snapshot in snapshots) {
    final question = snapshot.canonical;
    final outcome = quizOutcome(question, responses[question.id]);
    counts = counts.add(outcome);
    points += config.pointsFor(outcome);
    categories[question.categoryId] =
        (categories[question.categoryId] ?? const QuizCounts()).add(outcome);
    final group = question.quotaGroup(config);
    groups[group] = (groups[group] ?? const QuizCounts()).add(outcome);
  }
  return QuizResult(
    counts: counts,
    percentage: double.parse(
      (100 * counts.correct / counts.total).toStringAsFixed(
        config.percentageDecimals,
      ),
    ),
    points: points,
    categories: Map.unmodifiable(categories),
    groupCounts: Map.unmodifiable(groups),
    usesQuestionStyles: config.usesQuestionStyles,
  );
}
