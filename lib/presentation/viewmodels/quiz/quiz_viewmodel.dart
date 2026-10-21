import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../core/constants/quiz_catalog.dart';
import '../../../data/models/quiz/quiz_attempt.dart';
import '../../../data/models/quiz/quiz_config.dart';
import '../../../data/models/quiz/quiz_failure.dart';
import '../../../data/models/quiz/quiz_result.dart';
import '../../../data/repositories/quiz/quiz_repository.dart';

enum QuizScreen { overview, questions, results, review }

class QuizViewModel extends ChangeNotifier with WidgetsBindingObserver {
  QuizViewModel({required this.assessment, QuizRepository? repository})
    : _repository = repository ?? QuizRepository(assessment: assessment) {
    WidgetsBinding.instance.addObserver(this);
  }
  final QuizRepository _repository;
  final QuizAssessmentDefinition assessment;
  QuizConfig? config;
  QuizAttempt? active, attempt;
  List<QuizAttemptSummary> history = const [];
  QuizScreen screen = QuizScreen.overview;
  QuizFailure? error;
  String language = 'en';
  String _nextLanguage = 'en';
  bool loading = true, busy = false, storageReady = false;
  bool _disposed = false;
  Future<void>? _operation;
  Timer? _timer;

  Future<void> load(String preferredLanguage) async {
    await _perform(() async {
      loading = true;
      language = preferredLanguage;
      storageReady = false;
      try {
        active = await _repository.store.loadActive();
        history = await _repository.store.loadHistory();
        storageReady = true;
      } catch (cause) {
        // A bad archive must not prevent a valid active snapshot resuming.
        // New selections stay disabled until the full history can be read.
        error = quizStorageFailure(cause, QuizFailureCode.savedAttempt);
      } finally {
        loading = false;
      }
      try {
        config = await _repository.assets.loadConfig();
        if (!config!.languages.contains(language)) {
          language = config!.defaultLanguage;
        }
        _nextLanguage = language;
        if (active != null) language = active!.language;
        _setTimer();
      } catch (cause) {
        error = quizStorageFailure(cause, QuizFailureCode.configuration);
      }
    });
  }

  bool get canChooseLanguage =>
      !busy &&
      config != null &&
      screen == QuizScreen.overview &&
      attempt == null &&
      active == null;

  DateTime? get nextAttemptAt {
    if (config == null || history.isEmpty || config!.retakeInterval == 0) {
      return null;
    }
    return history.first.completedAtUtc.add(
      Duration(seconds: config!.retakeInterval),
    );
  }

  bool get canStart =>
      storageReady &&
      config != null &&
      (!kReleaseMode ||
          config!.approvedStatuses.contains(
            config!.section('contentReview')['currentBankStatus'],
          )) &&
      active == null &&
      (history.isEmpty || config!.retakeEnabled) &&
      (nextAttemptAt == null ||
          !DateTime.now().toUtc().isBefore(nextAttemptAt!));
  int? get secondsRemaining {
    final current = attempt;
    final seconds = current?.config.timeLimitSeconds;
    if (current == null ||
        seconds == null ||
        current.status != QuizAttemptStatus.inProgress) {
      return null;
    }
    return seconds -
        DateTime.now().toUtc().difference(current.startedAtUtc).inSeconds;
  }

  Future<void> start() => _perform(() async {
    if (!canStart) throw const QuizFailure(QuizFailureCode.cooldown);
    final created = await _repository.create(config!, language);
    await _repository.store.save(created);
    active = attempt = created;
    screen = QuizScreen.questions;
    _setTimer();
  });

  Future<void> resume() => _perform(() async {
    final saved = active;
    if (saved == null) return;
    _repository.requireReviewed(saved);
    attempt = saved;
    language = saved.language;
    screen = QuizScreen.questions;
    _setTimer();
  });

  Future<void> discard() => _perform(() async {
    final saved = active;
    if (saved == null) return;
    await _repository.store.save(
      saved.copyWith(
        status: QuizAttemptStatus.abandoned,
        updatedAtUtc: DateTime.now().toUtc(),
      ),
    );
    active = null;
    language = _nextLanguage;
  });

  Future<void> recordDisplayed(String id) async {
    final current = attempt;
    if ((secondsRemaining ?? 1) <= 0 ||
        busy ||
        error != null ||
        current == null ||
        current.status != QuizAttemptStatus.inProgress ||
        current.currentId != id ||
        current.exposedIds.contains(id)) {
      return;
    }
    await _perform(() async {
      final now = DateTime.now().toUtc();
      final updated = current.copyWith(
        exposedIds: {...current.exposedIds, id},
        updatedAtUtc: now,
      );
      await _repository.store.save(
        updated,
        displayedQuestionId: id,
        displayedAt: now,
      );
      active = attempt = updated;
    });
  }

  Future<void> answer(QuizResponse response) => _perform(() async {
    final current = attempt!;
    if (current.status != QuizAttemptStatus.inProgress ||
        (secondsRemaining ?? 1) <= 0) {
      return;
    }
    final previous = current.responses[current.currentId];
    if (!current.config.allowChange &&
        previous != null &&
        previous.status != QuizResponseStatus.unanswered) {
      return;
    }
    if (response.status == QuizResponseStatus.unknown &&
        !current.config.allowUnknown) {
      return;
    }
    if (response.status == QuizResponseStatus.answered &&
        !current.optionOrders[current.currentId]!.contains(
          response.selectedOptionId,
        )) {
      return;
    }
    final now = DateTime.now().toUtc();
    final firstExposure = !current.exposedIds.contains(current.currentId);
    final updated = current.copyWith(
      responses: {...current.responses, current.currentId: response},
      exposedIds: {...current.exposedIds, current.currentId},
      updatedAtUtc: now,
    );
    await _repository.store.save(
      updated,
      displayedQuestionId: firstExposure ? current.currentId : null,
      displayedAt: firstExposure ? now : null,
    );
    active = attempt = updated;
  });

  bool canNavigate(int index) {
    final current = attempt;
    if ((secondsRemaining ?? 1) <= 0 ||
        current == null ||
        current.status != QuizAttemptStatus.inProgress ||
        index < 0 ||
        index >= current.questionOrder.length) {
      return false;
    }
    if (index < current.currentIndex && !current.config.allowBack) return false;
    if (!current.config.allowSkip && index > current.currentIndex) {
      for (var i = current.currentIndex; i < index; i++) {
        final response = current.responses[current.questionOrder[i]];
        if (response == null ||
            response.status == QuizResponseStatus.unanswered) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> navigate(int index) => _perform(() async {
    if (!canNavigate(index)) return;
    final updated = attempt!.copyWith(
      currentIndex: index,
      updatedAtUtc: DateTime.now().toUtc(),
    );
    await _repository.store.save(updated);
    active = attempt = updated;
  });

  Future<void> changeLanguage(String selected) async {
    if (!canChooseLanguage) return;
    await _perform(() async {
      if (!config!.languages.contains(selected)) {
        throw const QuizFailure(QuizFailureCode.translation);
      }
      language = _nextLanguage = selected;
    });
  }

  Future<void> submit() => _perform(() async {
    final current = attempt!;
    if (current.status != QuizAttemptStatus.inProgress) return;
    final now = DateTime.now().toUtc();
    final result = gradeQuiz(
      current.config,
      current.questionOrder.map((id) => current.snapshots[id]!),
      current.responses,
    );
    final completed = current.copyWith(
      status: QuizAttemptStatus.completed,
      completedAtUtc: now,
      updatedAtUtc: now,
      result: result,
    );
    // Status and full snapshot are committed together; a failed write leaves
    // the saved incomplete attempt intact and the submit action retryable.
    await _repository.store.save(completed);
    attempt = completed;
    active = null;
    screen = QuizScreen.results;
    _setTimer();
    history = await _repository.store.loadHistory();
  });

  Future<void> openHistory(String id) => _perform(() async {
    final saved = await _repository.store.loadAttempt(id);
    _repository.requireReviewed(saved);
    attempt = saved;
    language = saved.language;
    screen = QuizScreen.results;
  });

  void showReview() {
    if (busy ||
        attempt?.result == null ||
        !attempt!.config.reviewFlag('availableAfterSubmission')) {
      return;
    }
    screen = QuizScreen.review;
    _notify();
  }

  void back() {
    if (busy) return;
    if (screen == QuizScreen.review) {
      screen = QuizScreen.results;
    } else {
      screen = QuizScreen.overview;
      attempt = null;
      language = active?.language ?? _nextLanguage;
      _setTimer();
    }
    error = null;
    _notify();
  }

  void clearError() {
    error = null;
    _notify();
  }

  Future<void> _perform(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    _notify();
    try {
      _operation = action();
      await _operation;
    } catch (cause) {
      error = quizStorageFailure(cause, QuizFailureCode.storage);
      if (kDebugMode) debugPrint(error.toString());
    } finally {
      _operation = null;
      busy = false;
      _notify();
    }
  }

  void _setTimer() {
    _timer?.cancel();
    if (screen == QuizScreen.questions &&
        attempt?.config.timeLimitSeconds != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if ((secondsRemaining ?? 1) <= 0 && !busy && error == null) {
          unawaited(submit());
        } else {
          _notify();
        }
      });
    } else if (screen == QuizScreen.overview &&
        nextAttemptAt != null &&
        !canStart) {
      final delay = nextAttemptAt!.difference(DateTime.now().toUtc());
      if (!delay.isNegative) _timer = Timer(delay, _notify);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (screen == QuizScreen.questions &&
          (secondsRemaining ?? 1) <= 0 &&
          !busy) {
        unawaited(submit());
      }
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(
      (_operation ?? Future<void>.value())
          .catchError((Object _) {})
          .then((_) => _repository.store.close())
          .catchError((Object _) {}),
    );
    super.dispose();
  }
}

QuizFailure quizStorageFailure(Object cause, QuizFailureCode fallback) =>
    cause is QuizFailure ? cause : QuizFailure(fallback, cause.toString());
