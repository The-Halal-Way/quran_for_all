import 'quiz_config_validator.dart';
import 'quiz_json.dart';

/// Immutable settings snapshot, also stored with each attempt. A later config
/// update must not change an interrupted attempt's rules or grading.
class QuizConfig {
  QuizConfig.fromJson(Map<String, dynamic> json)
    : _json = Map.unmodifiable(json) {
    validateQuizConfig(json);
  }

  final Map<String, dynamic> _json;
  Map<String, dynamic> section(String name) => quizMap(_json[name]);
  Map<String, dynamic> toJson() => _json;

  String get quizId => quizString(_json['quizId']);
  String get version => quizString(_json['configVersion']);
  List<String> get languages => quizStrings(_json['supportedLanguages']);
  String languageName(String language) {
    final names = _json['languageNames'];
    return names is Map && names[language] is String
        ? names[language] as String
        : switch (language) {
            'en' => 'English',
            'bn' => 'বাংলা',
            _ => language,
          };
  }

  String get defaultLanguage => quizString(_json['defaultLanguage']);
  List<String> get categories => quizStrings(_json['categories']);
  bool get usesQuestionStyles =>
      section('assessment')['quotaDimension'] == 'questionStyle';
  String? get audienceId => _json['audienceId'] as String?;
  String? get levelId => _json['levelId'] as String?;
  int get questionCount => quizInt(section('assessment')['questionCount']);
  Map<String, int> get quotas => quizMap(
    section('assessment')['questionsPerCategory'],
  ).map((key, value) => MapEntry(key, quizInt(value)));
  int get optionsPerQuestion =>
      quizInt(section('assessment')['optionsPerQuestion']);
  int? get timeLimitSeconds =>
      section('assessment')['timeLimitSeconds'] as int?;
  bool get shuffleQuestions =>
      quizBool(section('assessment')['shuffleQuestions']);
  bool get shuffleOptions => quizBool(section('assessment')['shuffleOptions']);
  int get recentAttempts =>
      quizInt(section('selection')['recentCompletedAttemptsToAvoid']);
  List<String> get priorityOrder =>
      quizStrings(section('selection')['priorityOrder']);
  bool get allowChange =>
      quizBool(section('answers')['allowChangeBeforeSubmission']);
  bool get allowSkip => quizBool(section('answers')['allowSkip']);
  bool get allowBack => quizBool(section('answers')['allowBackNavigation']);
  bool get allowUnknown => quizBool(section('answers')['unknownActionEnabled']);
  bool get confirmUnanswered =>
      quizBool(section('answers')['confirmSubmissionWithUnanswered']);
  bool get categoryBreakdown =>
      quizBool(section('scoring')['categoryBreakdown']);
  bool get groupBreakdown => quizBool(
    section('scoring')[usesQuestionStyles
        ? 'questionStyleBreakdown'
        : 'difficultyBreakdown'],
  );
  int get percentageDecimals =>
      quizInt(section('scoring')['roundPercentageToDecimals']);
  bool reviewFlag(String name) => quizBool(section('review')[name]);
  bool get retakeEnabled => quizBool(section('retake')['enabled']);
  int get retakeInterval =>
      quizInt(section('retake')['minimumIntervalSeconds']);
  List<String> get approvedStatuses =>
      quizStrings(section('contentReview')['approvedStatuses']);

  num pointsFor(String outcome) =>
      section('scoring')['${outcome}Points'] as num;

  String bankPath(String language, String category) {
    final assets = section('assets');
    final directories = quizMap(assets['languageDirectories']);
    return quizString(assets['questionBankPathTemplate'])
        .replaceAll('{basePath}', quizString(assets['basePath']))
        .replaceAll('{language}', quizString(directories[language]))
        .replaceAll('{categoryId}', category);
  }
}
