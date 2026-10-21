import 'dart:convert';

import 'quiz_attempt.dart';
import 'quiz_json.dart';
import 'quiz_result.dart';

void validateSavedQuizAttempt(QuizAttempt attempt) {
  final ids = attempt.questionOrder.toSet();
  quizRequire(
    ids.length == attempt.config.questionCount &&
        ids.length == attempt.questionOrder.length &&
        ids.length == attempt.snapshots.length &&
        ids.containsAll(attempt.snapshots.keys),
    'Saved question set mismatch',
  );
  quizRequire(
    attempt.config.languages.contains(attempt.language) &&
        attempt.currentIndex >= 0 &&
        attempt.currentIndex < ids.length,
    'Invalid saved position/language',
  );
  quizRequire(
    ids.containsAll(attempt.responses.keys) &&
        ids.containsAll(attempt.exposedIds) &&
        attempt.optionOrders.length == ids.length &&
        ids.containsAll(attempt.optionOrders.keys),
    'Saved response/order references unknown question',
  );
  final concepts = <String>{};
  final quotas = <String, int>{};
  for (final id in ids) {
    final snapshot = attempt.snapshots[id]!;
    quizRequire(
      snapshot.translations.length == 1 &&
          snapshot.translations.containsKey(attempt.language),
      'Saved content does not match the locked language',
    );
    final canonical = snapshot.canonical;
    quizRequire(
      canonical.id == id &&
          snapshot.translations.values.every(canonical.matches),
      'Saved translation metadata differs',
    );
    quizRequire(concepts.add(canonical.conceptId), 'Duplicate saved concept');
    final slot =
        '${canonical.categoryId}/${canonical.quotaGroup(attempt.config)}';
    quotas[slot] = (quotas[slot] ?? 0) + 1;
    final options = attempt.optionOrders[id]!;
    quizRequire(
      options.length == canonical.options.length &&
          options.toSet().length == options.length &&
          options.toSet().containsAll(canonical.options.map((o) => o.id)),
      'Saved option order differs',
    );
    final response = attempt.responses[id];
    quizRequire(
      response?.status != QuizResponseStatus.unknown ||
          attempt.config.allowUnknown,
      'Unknown response is disabled in saved settings',
    );
    if (response?.status == QuizResponseStatus.answered) {
      quizRequire(
        options.contains(response!.selectedOptionId),
        'Saved answer refers to unknown option',
      );
    }
  }
  var expectedSlots = 0;
  for (final category in attempt.config.categories) {
    for (final quota in attempt.config.quotas.entries) {
      quizRequire(
        (quotas['$category/${quota.key}'] ?? 0) == quota.value,
        'Saved quotas differ',
      );
      if (quota.value > 0) expectedSlots++;
    }
  }
  quizRequire(quotas.length == expectedSlots, 'Unknown saved quota group');
  if (attempt.status == QuizAttemptStatus.completed) {
    quizRequire(
      attempt.completedAtUtc != null && attempt.result != null,
      'Missing completion metadata',
    );
    final expected = gradeQuiz(
      attempt.config,
      attempt.questionOrder.map((id) => attempt.snapshots[id]!),
      attempt.responses,
    );
    quizRequire(
      jsonEncode(expected.toJson()) == jsonEncode(attempt.result!.toJson()),
      'Saved result does not match answers',
    );
  } else {
    quizRequire(
      attempt.result == null && attempt.completedAtUtc == null,
      'Unfinished attempt has result',
    );
  }
}
