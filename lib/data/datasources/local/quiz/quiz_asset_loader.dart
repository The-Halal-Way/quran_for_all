import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../models/quiz/quiz_config.dart';
import '../../../models/quiz/quiz_bank.dart';
import '../../../models/quiz/quiz_failure.dart';
import '../../../models/quiz/quiz_json.dart';
import '../../../models/quiz/quiz_question.dart';

class QuizQuestionCatalog {
  const QuizQuestionCatalog({required this.questions, required this.approved});
  final Map<String, QuizQuestionSnapshot> questions;
  final bool approved;
}

class QuizAssetLoader {
  QuizAssetLoader({required this.configPath, AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;
  final String configPath;
  final AssetBundle _bundle;
  QuizConfig? _config;
  final _catalogs = <String, Future<QuizQuestionCatalog>>{};

  Future<QuizConfig> loadConfig() async {
    try {
      return _config ??= QuizConfig.fromJson(
        quizMap(jsonDecode(await _bundle.loadString(configPath))),
      );
    } catch (error) {
      throw quizFailure(error, QuizFailureCode.configuration);
    }
  }

  Future<QuizQuestionCatalog> loadCatalog(QuizConfig config, String language) {
    if (!config.languages.contains(language)) {
      throw const QuizFailure(QuizFailureCode.translation);
    }
    final key = '${config.quizId}/${config.version}/$language';
    return _catalogs[key] ??= _loadCatalog(config, language).catchError((
      Object error,
    ) {
      _catalogs.remove(key);
      throw quizFailure(error, QuizFailureCode.assets);
    });
  }

  Future<QuizQuestionCatalog> _loadCatalog(
    QuizConfig config,
    String language,
  ) async {
    final raw = <String, String>{};
    await Future.wait([
      for (final category in config.categories)
        _bundle
            .loadString(config.bankPath(language, category))
            .then((value) => raw['$language/$category'] = value),
    ]);
    return compute(_parseCatalog, (
      config.toJson(),
      language,
      raw,
    ), debugLabel: 'knowledge-assessment-banks');
  }
}

QuizQuestionCatalog _parseCatalog(
  (Map<String, dynamic>, String, Map<String, String>) input,
) {
  final config = QuizConfig.fromJson(input.$1);
  final language = input.$2;
  final questions = <String, QuizQuestionSnapshot>{};
  var approved = true;
  for (final category in config.categories) {
    final bank = QuizBank.fromJson(
      quizMap(jsonDecode(input.$3['$language/$category']!)),
      config,
      language,
      category,
    );
    approved &= config.approvedStatuses.contains(bank.reviewStatus);
    for (final question in bank.questions) {
      quizRequire(!questions.containsKey(question.id), 'Duplicate question ID');
      questions[question.id] = QuizQuestionSnapshot({language: question});
    }
  }
  return QuizQuestionCatalog(
    questions: Map.unmodifiable(questions),
    approved: approved,
  );
}
