import 'quiz_json.dart';

const quizCategories = {
  'beliefs_foundations',
  'quran_knowledge',
  'seerah',
  'hadith_knowledge',
  'everyday_worship',
  'character_conduct',
};
const quizDifficulties = ['foundation', 'intermediate', 'advanced'];
const quizQuestionStyles = [
  'familiar_fact',
  'broader_basic',
  'everyday_application',
];
const quizSelectionPriorities = {
  'unseen',
  'seen_outside_recent_attempts',
  'seen_in_recent_attempts',
};

/// Reject unsupported policy changes rather than silently substituting rules.
void validateQuizConfig(Map<String, dynamic> json) {
  quizRequire(json['schemaVersion'] == 1, 'Unsupported config schema');
  quizString(json['quizId']);
  quizString(json['configVersion']);
  final languages = quizStrings(json['supportedLanguages']);
  quizRequire(
    languages.isNotEmpty &&
        languages.toSet().length == languages.length &&
        languages.every(
          RegExp(r'^[a-z]{2,3}(?:[-_][a-zA-Z0-9]{2,8})*$').hasMatch,
        ),
    'Unsupported/duplicate languages',
  );
  quizRequire(
    languages.contains(json['defaultLanguage']),
    'Invalid default language',
  );
  if (json['languageNames'] != null) {
    final names = quizMap(json['languageNames']);
    for (final language in languages) {
      quizString(names[language]);
    }
  }
  final categories = quizStrings(json['categories']);
  quizRequire(
    categories.isNotEmpty &&
        categories.toSet().length == categories.length &&
        categories.every(quizCategories.contains),
    'Missing category translations',
  );
  final assets = quizMap(json['assets']);
  final styleBased =
      quizMap(json['assessment'])['quotaDimension'] == 'questionStyle';
  quizRequire(
    assets['requiredBankSchemaVersion'] == (styleBased ? 3 : 1),
    'Unsupported bank schema',
  );
  if (styleBased) {
    quizString(json['audienceId']);
    quizString(json['levelId']);
  }
  final base = quizString(assets['basePath']);
  quizRequire(
    base.startsWith('assets/') && !base.contains('..'),
    'Invalid base path',
  );
  final template = quizString(assets['questionBankPathTemplate']);
  quizRequire(
    ['{basePath}', '{language}', '{categoryId}'].every(template.contains) &&
        !template.contains('..'),
    'Invalid asset template',
  );
  final directories = quizMap(assets['languageDirectories']);
  for (final language in languages) {
    quizRequire(
      RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(quizString(directories[language])),
      'Invalid language directory',
    );
  }
  final assessment = quizMap(json['assessment']);
  quizRequire(
    assessment['quotaDimension'] == null ||
        const {
          'difficulty',
          'questionStyle',
        }.contains(assessment['quotaDimension']),
    'Unsupported quota dimension',
  );
  final groups = styleBased ? quizQuestionStyles : quizDifficulties;
  final quotas = quizMap(assessment['questionsPerCategory']);
  quizRequire(
    quotas.isNotEmpty && quotas.keys.every(groups.contains),
    'Unsupported question quota group',
  );
  var perCategory = 0;
  for (final value in quotas.values) {
    final count = quizInt(value);
    quizRequire(count >= 0, 'Negative quota');
    perCategory += count;
  }
  quizRequire(
    perCategory > 0 &&
        quizInt(assessment['questionCount']) == perCategory * categories.length,
    'Question count and quotas disagree',
  );
  quizRequire(
    assessment['optionsPerQuestion'] == 4 &&
        assessment['questionType'] == 'single_choice',
    'Unsupported question format',
  );
  for (final key in ['shuffleQuestions', 'shuffleOptions']) {
    quizBool(assessment[key]);
  }
  final limit = assessment['timeLimitSeconds'];
  quizRequire(
    limit == null || (limit is int && limit > 0),
    'Invalid time limit',
  );
  _policies(assessment, {
    'preventDuplicateQuestionIds': true,
    'preventDuplicateConceptIds': true,
  });
  // The old policy is accepted only so existing saved settings still decode.
  // The controller locks language for every attempt, including older snapshots.
  quizRequire(
    const {
      'locked_after_start',
      'preserve_question_ids_and_option_order',
    }.contains(assessment['languageChangeDuringAttempt']),
    'Unsupported language policy',
  );
  final selection = quizMap(json['selection']);
  final priorities = quizStrings(selection['priorityOrder']);
  quizRequire(
    priorities.length == 3 &&
        priorities.toSet().containsAll(quizSelectionPriorities),
    'Invalid priority order',
  );
  quizRequire(
    quizInt(selection['recentCompletedAttemptsToAvoid']) >= 0,
    'Invalid recency',
  );
  _policies(selection, {
    'historyScope': 'across_languages_by_question_id',
    'withinPriority': 'least_recently_seen_then_random',
    'unseenTieBreak': 'random',
    'fallbackPolicy': 'relax_recency_only',
    (styleBased
            ? 'preserveCategoryAndQuestionStyleQuotas'
            : 'preserveCategoryAndDifficultyQuotas'):
        true,
    'onInsufficientEligibleQuestions': 'block_start_with_localized_error',
  });
  final answers = quizMap(json['answers']);
  for (final key in [
    'allowChangeBeforeSubmission',
    'allowSkip',
    'allowBackNavigation',
    'unknownActionEnabled',
    'confirmSubmissionWithUnanswered',
  ]) {
    quizBool(answers[key]);
  }
  _policies(answers, {
    'unknownActionLocalizationKey': 'quiz.answer.notSure',
    'unknownIsAnswerOption': false,
    'unansweredOnSubmission': 'count_as_unanswered',
    'showCorrectAnswersDuringAttempt': false,
  });
  final scoring = quizMap(json['scoring']);
  for (final outcome in ['correct', 'incorrect', 'unknown', 'unanswered']) {
    final value = scoring['${outcome}Points'];
    quizRequire(value is num && value.isFinite && value >= 0, 'Invalid score');
  }
  quizRequire(
    quizInt(scoring['roundPercentageToDecimals']) >= 0 &&
        quizInt(scoring['roundPercentageToDecimals']) <= 6,
    'Invalid precision',
  );
  quizBool(scoring['categoryBreakdown']);
  quizBool(
    scoring[styleBased ? 'questionStyleBreakdown' : 'difficultyBreakdown'],
  );
  quizRequire(
    quizStrings(
      scoring['trackCounts'],
    ).toSet().containsAll(['correct', 'incorrect', 'unknown', 'unanswered']),
    'Missing result counts',
  );
  _policies(scoring, {
    'negativeMarking': false,
    'difficultyWeighting': false,
    'percentageFormula': '100 * correctCount / totalQuestionCount',
    'resultInterpretation': 'performance_on_sampled_questions_only',
    'resultLocalizationKey': 'quiz.results.sampledKnowledgeNotice',
  });
  final review = quizMap(json['review']);
  for (final key in [
    'availableAfterSubmission',
    'showSelectedAnswer',
    'showCorrectAnswer',
    'showExplanation',
    'showReferences',
    'showUnknownAndUnanswered',
    'allowReferenceLinks',
  ]) {
    quizBool(review[key]);
  }
  _policies(quizMap(json['persistence']), {
    'storage': 'local',
    'autoSaveAfterEachAction': true,
    'resumeIncompleteAttempt': true,
    'maxIncompleteAttempts': 1,
    'snapshotPolicy':
        'store_full_selected_question_content_and_grading_metadata',
    'contentUpdateDuringAttempt': 'resume_saved_snapshot',
    'questionExposureRecordedOn': 'question_first_displayed',
    'saveCompletedAttemptHistory': true,
  });
  final fields = quizStrings(quizMap(json['persistence'])['saveFields']);
  quizRequire(
    fields.toSet().containsAll([
      'attemptId',
      'quizId',
      'configVersion',
      'startedAtUtc',
      'updatedAtUtc',
      'completedAtUtc',
      'language',
      'status',
      'questionSnapshots',
      'questionOrder',
      'optionOrderByQuestionId',
      'responsesByQuestionId',
      'currentQuestionIndex',
      'result',
    ]),
    'Missing snapshot fields',
  );
  final retake = quizMap(json['retake']);
  quizBool(retake['enabled']);
  quizRequire(
    quizInt(retake['minimumIntervalSeconds']) >= 0,
    'Invalid retake interval',
  );
  _policies(retake, {
    'generateNewSelection': true,
    'reuseCompletedAttempt': false,
  });
  _policies(quizMap(json['localization']), {
    'userFacingStringsSource': 'app_localization',
    'categoryTitleKeyTemplate': 'quiz.categories.{categoryId}.title',
    'missingTranslationPolicy': 'block_start_with_localized_error',
    'preserveIdsAcrossLanguages': true,
  });
  _policies(
    quizMap(
      quizMap(json['localization'])[styleBased
          ? 'questionStyleLabelKeys'
          : 'difficultyLabelKeys'],
    ),
    {
      for (final group in groups)
        group: styleBased
            ? 'quiz.questionStyle.$group'
            : 'quiz.difficulty.$group',
    },
  );
  _policies(quizMap(json['contentReview']), {
    'statusFieldPath': 'review.status',
    'releasePolicy': 'require_editorial_and_scholarly_review_before_production',
  });
  quizString(quizMap(json['contentReview'])['currentBankStatus']);
  quizRequire(
    quizStrings(quizMap(json['contentReview'])['approvedStatuses']).isNotEmpty,
    'Missing approved review statuses',
  );
  final validation = quizMap(json['validation']);
  for (final key in [
    'requireAllCategories',
    'requireExactlyFourUniqueOptions',
    'requireCorrectOptionIdInOptions',
    'requireUniqueQuestionIdsAcrossBanks',
    'requireNonEmptyConceptId',
    'requireExplanations',
    'requireReferences',
    'requireLanguageMatchesSelectedLanguage',
    'requireCategoryMatchesFile',
    'requireBankQuestionCountMatchesActual',
    if (styleBased)
      'requireQuestionStyleCountsMatchActual'
    else
      'requireDifficultyCountsMatchActual',
    if (styleBased) 'requireAudienceMatchesSelectedAudience',
    if (styleBased) 'requireLevelMatchesSelectedLevel',
    'validateQuotasBeforeStarting',
    'neverSilentlyDropInvalidQuestions',
  ]) {
    quizRequire(validation[key] == true, 'Required validation disabled: $key');
  }
}

void _policies(Map<String, dynamic> section, Map<String, dynamic> supported) {
  for (final entry in supported.entries) {
    quizRequire(
      section[entry.key] == entry.value,
      'Unsupported policy: ${entry.key}',
    );
  }
}
