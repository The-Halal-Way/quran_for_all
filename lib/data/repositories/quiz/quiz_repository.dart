import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/constants/quiz_catalog.dart';
import '../../../services/quiz/quiz_selection.dart';
import '../../datasources/local/quiz/quiz_asset_loader.dart';
import '../../datasources/local/quiz/quiz_local_store.dart';
import '../../models/quiz/quiz_attempt.dart';
import '../../models/quiz/quiz_config.dart';
import '../../models/quiz/quiz_failure.dart';

/// Direct data repository: this feature intentionally has no domain layer.
class QuizRepository {
  QuizRepository({
    required QuizAssessmentDefinition assessment,
    QuizAssetLoader? assets,
    QuizLocalStore? store,
  }) : assets = assets ?? QuizAssetLoader(configPath: assessment.configPath),
       store = store ?? QuizLocalStore(databaseName: assessment.databaseName);
  final QuizAssetLoader assets;
  final QuizLocalStore store;

  Future<QuizAttempt> create(QuizConfig config, String language) async {
    if (!config.languages.contains(language)) {
      throw const QuizFailure(QuizFailureCode.translation);
    }
    final history = await store.loadHistory();
    if (history.isNotEmpty &&
        (!config.retakeEnabled ||
            DateTime.now()
                    .toUtc()
                    .difference(history.first.completedAtUtc)
                    .inSeconds <
                config.retakeInterval)) {
      throw const QuizFailure(QuizFailureCode.cooldown);
    }
    final catalog = await assets.loadCatalog(config, language);
    final approved =
        catalog.approved &&
        config.approvedStatuses.contains(
          config.section('contentReview')['currentBankStatus'],
        );
    if (kReleaseMode && !approved) {
      throw const QuizFailure(QuizFailureCode.reviewRequired);
    }
    final seen = await store.loadExposures();
    final recent = history
        .take(config.recentAttempts)
        .expand((attempt) => attempt.questionIds)
        .toSet();
    final selection = await compute(_select, (
      config,
      catalog,
      seen,
      recent,
    ), debugLabel: 'knowledge-assessment-selection');
    final now = DateTime.now().toUtc();
    return QuizAttempt(
      id: '${now.microsecondsSinceEpoch}_${Random.secure().nextInt(0x7fffffff).toRadixString(16)}',
      config: config,
      startedAtUtc: now,
      updatedAtUtc: now,
      language: language,
      status: QuizAttemptStatus.inProgress,
      snapshots: Map.unmodifiable({
        for (final id in selection.questionIds) id: catalog.questions[id]!,
      }),
      questionOrder: selection.questionIds,
      optionOrders: selection.optionOrders,
      responses: const {},
      currentIndex: 0,
      exposedIds: const {},
      approved: approved,
      reusedCount: selection.reusedCount,
      recentCount: selection.recentCount,
    );
  }

  void requireReviewed(QuizAttempt attempt) {
    if (kReleaseMode && !attempt.approved) {
      throw const QuizFailure(QuizFailureCode.reviewRequired);
    }
  }
}

QuizSelection _select(
  (QuizConfig, QuizQuestionCatalog, Map<String, DateTime>, Set<String>) input,
) => selectQuizQuestions(
  config: input.$1,
  questions: input.$2.questions,
  exposures: input.$3,
  recentIds: input.$4,
);
