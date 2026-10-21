import 'quiz_config.dart';
import 'quiz_json.dart';
import 'quiz_question.dart';
import 'quiz_result.dart';
import 'quiz_saved_attempt_validator.dart';

enum QuizAttemptStatus { inProgress, completed, abandoned }

class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.config,
    required this.startedAtUtc,
    required this.updatedAtUtc,
    required this.language,
    required this.status,
    required this.snapshots,
    required this.questionOrder,
    required this.optionOrders,
    required this.responses,
    required this.currentIndex,
    required this.exposedIds,
    required this.approved,
    required this.reusedCount,
    required this.recentCount,
    this.completedAtUtc,
    this.result,
  });

  final String id, language;
  final QuizConfig config;
  final DateTime startedAtUtc, updatedAtUtc;
  final DateTime? completedAtUtc;
  final QuizAttemptStatus status;
  final Map<String, QuizQuestionSnapshot> snapshots;
  final List<String> questionOrder;
  final Map<String, List<String>> optionOrders;
  final Map<String, QuizResponse> responses;
  final Set<String> exposedIds;
  final int currentIndex, reusedCount, recentCount;
  final bool approved;
  final QuizResult? result;
  String get currentId => questionOrder[currentIndex];
  QuizQuestion get currentQuestion =>
      snapshots[currentId]!.inLanguage(language);
  int get answeredCount => responses.values
      .where((r) => r.status != QuizResponseStatus.unanswered)
      .length;
  int get unansweredCount => questionOrder.length - answeredCount;

  QuizAttempt copyWith({
    DateTime? updatedAtUtc,
    DateTime? completedAtUtc,
    QuizAttemptStatus? status,
    Map<String, QuizResponse>? responses,
    int? currentIndex,
    Set<String>? exposedIds,
    QuizResult? result,
  }) => QuizAttempt(
    id: id,
    config: config,
    startedAtUtc: startedAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    completedAtUtc: completedAtUtc ?? this.completedAtUtc,
    language: language,
    status: status ?? this.status,
    snapshots: snapshots,
    questionOrder: questionOrder,
    optionOrders: optionOrders,
    responses: Map.unmodifiable(responses ?? this.responses),
    currentIndex: currentIndex ?? this.currentIndex,
    exposedIds: Set.unmodifiable(exposedIds ?? this.exposedIds),
    approved: approved,
    reusedCount: reusedCount,
    recentCount: recentCount,
    result: result ?? this.result,
  );

  Map<String, dynamic> toJson() => {
    'schemaVersion': 2,
    'attemptId': id,
    'quizId': config.quizId,
    'configVersion': config.version,
    'settingsSnapshot': config.toJson(),
    'startedAtUtc': startedAtUtc.toIso8601String(),
    'updatedAtUtc': updatedAtUtc.toIso8601String(),
    'completedAtUtc': completedAtUtc?.toIso8601String(),
    'language': language,
    'status': status.name,
    'questionSnapshots': snapshots.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'questionOrder': questionOrder,
    'optionOrderByQuestionId': optionOrders,
    'responsesByQuestionId': responses.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'currentQuestionIndex': currentIndex,
    'exposedIds': exposedIds.toList(),
    'contentApproved': approved,
    'reusedCount': reusedCount,
    'recentCount': recentCount,
    'result': result?.toJson(),
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    quizRequire(
      const {1, 2}.contains(json['schemaVersion']),
      'Unsupported saved attempt schema',
    );
    final config = QuizConfig.fromJson(quizMap(json['settingsSnapshot']));
    final language = quizString(json['language']);
    quizRequire(
      json['quizId'] == config.quizId &&
          json['configVersion'] == config.version,
      'Saved settings identity mismatch',
    );
    final attempt = QuizAttempt(
      id: quizString(json['attemptId']),
      config: config,
      startedAtUtc: DateTime.parse(quizString(json['startedAtUtc'])).toUtc(),
      updatedAtUtc: DateTime.parse(quizString(json['updatedAtUtc'])).toUtc(),
      completedAtUtc: json['completedAtUtc'] == null
          ? null
          : DateTime.parse(quizString(json['completedAtUtc'])).toUtc(),
      language: language,
      status: QuizAttemptStatus.values.byName(quizString(json['status'])),
      snapshots: Map.unmodifiable(
        quizMap(json['questionSnapshots']).map(
          // Older attempts bundled all translations. Retain only the saved
          // language when reading them; question and option IDs stay intact.
          (key, raw) => MapEntry(
            key,
            QuizQuestionSnapshot.fromJson(
              json['schemaVersion'] == 1
                  ? {language: quizMap(raw)[language]}
                  : quizMap(raw),
            ),
          ),
        ),
      ),
      questionOrder: List.unmodifiable(quizStrings(json['questionOrder'])),
      optionOrders: Map.unmodifiable(
        quizMap(json['optionOrderByQuestionId']).map(
          (key, raw) =>
              MapEntry(key, List<String>.unmodifiable(quizStrings(raw))),
        ),
      ),
      responses: Map.unmodifiable(
        quizMap(
          json['responsesByQuestionId'],
        ).map((key, raw) => MapEntry(key, QuizResponse.fromJson(quizMap(raw)))),
      ),
      currentIndex: quizInt(json['currentQuestionIndex']),
      exposedIds: Set.unmodifiable(quizStrings(json['exposedIds'])),
      approved: quizBool(json['contentApproved']),
      reusedCount: quizInt(json['reusedCount']),
      recentCount: quizInt(json['recentCount']),
      result: json['result'] == null
          ? null
          : QuizResult.fromJson(quizMap(json['result'])),
    );
    validateSavedQuizAttempt(attempt);
    return attempt;
  }
}

class QuizAttemptSummary {
  const QuizAttemptSummary({
    required this.id,
    required this.completedAtUtc,
    required this.result,
    required this.language,
    required this.questionIds,
  });
  final String id, language;
  final DateTime completedAtUtc;
  final QuizResult result;
  final List<String> questionIds;
  Map<String, dynamic> toJson() => {
    'attemptId': id,
    'completedAtUtc': completedAtUtc.toIso8601String(),
    'result': result.toJson(),
    'language': language,
    'questionIds': questionIds,
  };
  factory QuizAttemptSummary.fromJson(Map<String, dynamic> json) =>
      QuizAttemptSummary(
        id: quizString(json['attemptId']),
        completedAtUtc: DateTime.parse(
          quizString(json['completedAtUtc']),
        ).toUtc(),
        result: QuizResult.fromJson(quizMap(json['result'])),
        language: quizString(json['language']),
        questionIds: List.unmodifiable(quizStrings(json['questionIds'])),
      );
  factory QuizAttemptSummary.fromAttempt(QuizAttempt attempt) =>
      QuizAttemptSummary(
        id: attempt.id,
        completedAtUtc: attempt.completedAtUtc!,
        result: attempt.result!,
        language: attempt.language,
        questionIds: attempt.questionOrder,
      );
}
