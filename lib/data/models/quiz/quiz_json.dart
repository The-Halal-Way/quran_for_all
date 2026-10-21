import 'quiz_failure.dart';

Map<String, dynamic> quizMap(Object? value) {
  if (value is! Map<String, dynamic>) {
    throw const FormatException('Expected a JSON object');
  }
  return value;
}

List<dynamic> quizList(Object? value) {
  if (value is! List) throw const FormatException('Expected a JSON list');
  return value;
}

String quizString(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    throw const FormatException('Expected a non-empty string');
  }
  return value;
}

int quizInt(Object? value) {
  if (value is! int) throw const FormatException('Expected an integer');
  return value;
}

bool quizBool(Object? value) {
  if (value is! bool) throw const FormatException('Expected a boolean');
  return value;
}

List<String> quizStrings(Object? value) =>
    quizList(value).map(quizString).toList(growable: false);

void quizRequire(bool condition, String message) {
  if (!condition) throw FormatException(message);
}

QuizFailure quizFailure(Object error, QuizFailureCode fallback) =>
    error is QuizFailure ? error : QuizFailure(fallback, error.toString());
