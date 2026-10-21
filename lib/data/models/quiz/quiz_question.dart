import 'quiz_config.dart';
import 'quiz_config_validator.dart';
import 'quiz_json.dart';

class QuizOption {
  const QuizOption({required this.id, required this.text});
  final String id;
  final String text;
  factory QuizOption.fromJson(Map<String, dynamic> json) =>
      QuizOption(id: quizString(json['id']), text: quizString(json['text']));
  Map<String, dynamic> toJson() => {'id': id, 'text': text};
}

class QuizReference {
  const QuizReference({
    required this.label,
    this.url,
    this.metadata = const {},
  });
  final String label;
  final String? url;
  final Map<String, dynamic> metadata;
  factory QuizReference.fromJson(Map<String, dynamic> json) {
    final url = json['url'];
    if (url != null) {
      final uri = Uri.tryParse(quizString(url));
      quizRequire(
        uri != null &&
            uri.hasAuthority &&
            {'https', 'http'}.contains(uri.scheme),
        'Invalid reference URL',
      );
    }
    return QuizReference(
      label: quizString(json['label']),
      url: url as String?,
      metadata: Map.unmodifiable(json),
    );
  }
  Map<String, dynamic> toJson() => {
    ...metadata,
    'label': label,
    if (url != null) 'url': url,
  };
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.conceptId,
    required this.categoryId,
    this.difficulty,
    this.questionStyle,
    this.levelId,
    required this.question,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    required this.references,
  });

  final String id,
      conceptId,
      categoryId,
      question,
      correctOptionId,
      explanation;
  final String? difficulty, questionStyle, levelId;
  final List<QuizOption> options;
  final List<QuizReference> references;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    quizRequire(
      json['questionType'] == 'single_choice',
      'Unsupported question type',
    );
    final options = quizList(
      json['options'],
    ).map((raw) => QuizOption.fromJson(quizMap(raw))).toList(growable: false);
    final optionIds = options.map((option) => option.id).toSet();
    quizRequire(
      options.length == 4 &&
          optionIds.length == 4 &&
          options
                  .map((option) => option.text.trim().toLowerCase())
                  .toSet()
                  .length ==
              4,
      'Question needs four distinct options',
    );
    final correct = quizString(json['correctOptionId']);
    quizRequire(optionIds.contains(correct), 'Correct option is missing');
    final difficulty = json['difficulty'] as String?;
    final style = json['questionStyle'] as String?;
    final level = json['levelId'] as String?;
    quizRequire(
      (difficulty != null &&
              quizDifficulties.contains(difficulty) &&
              style == null &&
              level == null) ||
          (difficulty == null &&
              quizQuestionStyles.contains(style) &&
              level != null &&
              level.trim().isNotEmpty),
      'Question needs either a difficulty or a question style and level',
    );
    final references = quizList(json['references'])
        .map((raw) => QuizReference.fromJson(quizMap(raw)))
        .toList(growable: false);
    quizRequire(references.isNotEmpty, 'Missing question references');
    return QuizQuestion(
      id: quizString(json['id']),
      conceptId: quizString(json['conceptId']),
      categoryId: quizString(json['categoryId']),
      difficulty: difficulty,
      questionStyle: style,
      levelId: level,
      question: quizString(json['question']),
      options: List.unmodifiable(options),
      correctOptionId: correct,
      explanation: quizString(json['explanation']),
      references: List.unmodifiable(references),
    );
  }

  String optionText(String id) =>
      options.firstWhere((option) => option.id == id).text;
  String quotaGroup(QuizConfig config) {
    quizRequire(
      config.usesQuestionStyles
          ? questionStyle != null &&
                levelId == config.levelId &&
                difficulty == null
          : difficulty != null && questionStyle == null,
      'Question grouping or level does not match assessment settings',
    );
    return config.usesQuestionStyles ? questionStyle! : difficulty!;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conceptId': conceptId,
    'categoryId': categoryId,
    if (difficulty != null) 'difficulty': difficulty,
    if (questionStyle != null) 'questionStyle': questionStyle,
    if (levelId != null) 'levelId': levelId,
    'questionType': 'single_choice',
    'question': question,
    'options': options.map((option) => option.toJson()).toList(),
    'correctOptionId': correctOptionId,
    'explanation': explanation,
    'references': references.map((reference) => reference.toJson()).toList(),
  };

  bool matches(QuizQuestion other) =>
      id == other.id &&
      conceptId == other.conceptId &&
      categoryId == other.categoryId &&
      difficulty == other.difficulty &&
      questionStyle == other.questionStyle &&
      levelId == other.levelId &&
      correctOptionId == other.correctOptionId &&
      options
          .map((o) => o.id)
          .toSet()
          .containsAll(other.options.map((o) => o.id));
}

/// Only the selected language travels with each question. The keyed format
/// remains compatible with legacy multilingual snapshots, which are reduced
/// to their saved language when the attempt is read.
class QuizQuestionSnapshot {
  QuizQuestionSnapshot(Map<String, QuizQuestion> translations)
    : translations = Map.unmodifiable(translations);
  final Map<String, QuizQuestion> translations;
  QuizQuestion get canonical => translations.values.first;
  QuizQuestion inLanguage(String language) => translations[language]!;
  Map<String, dynamic> toJson() => translations.map(
    (language, question) => MapEntry(language, question.toJson()),
  );
  factory QuizQuestionSnapshot.fromJson(Map<String, dynamic> json) =>
      QuizQuestionSnapshot(
        json.map(
          (language, raw) =>
              MapEntry(language, QuizQuestion.fromJson(quizMap(raw))),
        ),
      );
}
