enum QuizFailureCode {
  configuration,
  assets,
  translation,
  insufficientQuestions,
  storage,
  savedAttempt,
  reviewRequired,
  cooldown,
}

class QuizFailure implements Exception {
  const QuizFailure(this.code, [this.detail = '']);

  final QuizFailureCode code;

  /// Developer diagnostics; the UI resolves the code to an app translation.
  final String detail;

  @override
  String toString() => 'QuizFailure(${code.name}): $detail';
}
