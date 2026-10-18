import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/datasources/tasbeeh_phrases_data.dart';
import '../../../data/models/tasbeeh_session.dart';
import '../../../data/models/tasbeeh_state.dart';
import '../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import '../../../domain/repositories/tasbeeh_repository.dart';

export '../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';

class TasbeehViewModel extends ChangeNotifier {
  TasbeehViewModel({required TasbeehRepository repository})
    : _repository = repository;

  static const targets = [33, 99, 100, 500];

  final TasbeehRepository _repository;
  final List<TasbeehSession> _sessions = [
    const TasbeehSession(
      id: TasbeehSession.defaultId,
      name: '',
      progress: TasbeehProgress(counts: {}, targets: {}),
    ),
  ];
  final List<TasbeehPhrase> _customPhrases = [];
  final Map<String, int> _counts = {
    for (final phrase in builtInTasbeehPhrases) phrase.id: 0,
  };
  final Map<String, int> _targets = {
    for (final phrase in builtInTasbeehPhrases) phrase.id: 33,
  };
  String _selectedPhraseId = builtInTasbeehPhrases.first.id;
  String _selectedSessionId = TasbeehSession.defaultId;
  String? _autoAdvanceUndoPhraseId;
  bool _autoNext = false;
  bool _isLoaded = false;
  Future<void> _saveQueue = Future<void>.value();

  bool get isLoaded => _isLoaded;
  List<TasbeehSession> get sessions => List.unmodifiable(_sessions);
  String get selectedSessionId => _selectedSessionId;
  TasbeehSession get currentSession =>
      _sessions.firstWhere((session) => session.id == _selectedSessionId);
  bool get hasPhrases => phrases.isNotEmpty;
  bool get autoNextEnabled => _autoNext;
  bool get canUndo => _autoAdvanceUndoPhraseId != null || count > 0;
  String get selectedPhraseId => _selectedPhraseId;
  List<TasbeehPhrase> get phrases => List.unmodifiable([
    if (currentSession.isDefault) ...builtInTasbeehPhrases,
    ..._customPhrases,
  ]);
  TasbeehPhrase get selectedPhrase =>
      phrases.firstWhere((phrase) => phrase.id == _selectedPhraseId);
  Map<String, int> get counts => Map.unmodifiable(_counts);
  Map<String, int> get selectedTargets => Map.unmodifiable(_targets);
  int get count => countFor(_selectedPhraseId);
  int get target => targetFor(_selectedPhraseId);
  int get totalCount => _counts.values.fold(0, (total, value) => total + value);
  int get completedRounds => phrases.fold(
    0,
    (total, phrase) => total + countFor(phrase.id) ~/ targetFor(phrase.id),
  );
  int get currentCompletedRounds => count ~/ target;
  bool get isTargetReached => count > 0 && count % target == 0;
  Future<void> get pendingSave => _saveQueue;

  double get progress {
    if (count == 0) return 0;
    final remainder = count % target;
    return remainder == 0 ? 1 : remainder / target;
  }

  int countFor(String id) => _counts[id] ?? 0;
  int targetFor(String id) => _targets[id] ?? targets.first;

  Future<void> load() async {
    try {
      final state = await _repository.loadState();
      if (state != null) {
        final seenSessions = <String>{};
        _sessions
          ..clear()
          ..addAll(
            state.sessions.where((session) => seenSessions.add(session.id)),
          );
        // Legacy progress belongs to the default session, including custom dhikrs.
        if (!_sessions.any((session) => session.isDefault)) {
          _sessions.insert(
            0,
            TasbeehSession(
              id: TasbeehSession.defaultId,
              name: '',
              progress: TasbeehProgress(
                counts: state.counts,
                targets: state.targets,
                selectedPhrase: state.selectedPhrase,
                customPhrases: state.customPhrases,
                autoNext: state.autoNext,
              ),
            ),
          );
        }
        _selectedSessionId =
            _sessions.any((session) => session.id == state.selectedSessionId)
            ? state.selectedSessionId
            : TasbeehSession.defaultId;
        _restoreSession(currentSession);
      }
    } catch (_) {
      // Retain the existing session if storage cannot be read.
    } finally {
      _syncActiveSession();
      _isLoaded = true;
      notifyListeners();
    }
  }

  bool increment() {
    if (!hasPhrases) return false;
    _autoAdvanceUndoPhraseId = null;
    final nextCount = count + 1;
    _counts[_selectedPhraseId] = nextCount;
    // Capture completion before changing selection, so haptics use this dhikr's target.
    final targetReached = nextCount % target == 0;
    if (targetReached && _autoNext && phrases.length > 1) {
      final entries = phrases;
      final index = entries.indexWhere(
        (phrase) => phrase.id == _selectedPhraseId,
      );
      _autoAdvanceUndoPhraseId = _selectedPhraseId;
      _selectedPhraseId = entries[(index + 1) % entries.length].id;
    }
    _commit();
    return targetReached;
  }

  void decrement() {
    final previousId = _autoAdvanceUndoPhraseId;
    _autoAdvanceUndoPhraseId = null;
    if (previousId != null && _counts.containsKey(previousId)) {
      _selectedPhraseId = previousId;
    }
    if (count == 0) return;
    _counts[_selectedPhraseId] = count - 1;
    _commit();
  }

  void resetCount() {
    if (count == 0) return;
    _autoAdvanceUndoPhraseId = null;
    _counts[_selectedPhraseId] = 0;
    _commit();
  }

  void resetAll() {
    if (totalCount == 0) return;
    _autoAdvanceUndoPhraseId = null;
    _counts.updateAll((_, _) => 0);
    _commit();
  }

  void selectTarget(int target) {
    if (!hasPhrases ||
        this.target == target ||
        !TasbeehPhrase.validTarget(target)) {
      return;
    }
    _autoAdvanceUndoPhraseId = null;
    _targets[_selectedPhraseId] = target;
    _commit();
  }

  void selectPhrase(String id) {
    if (_selectedPhraseId == id || !_counts.containsKey(id)) return;
    _autoAdvanceUndoPhraseId = null;
    _selectedPhraseId = id;
    _commit();
  }

  void setAutoNext(bool enabled) {
    if (_autoNext == enabled) return;
    _autoNext = enabled;
    _commit();
  }

  String? createSession(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > TasbeehSession.maxNameLength) {
      return null;
    }
    final baseId = 'session_${DateTime.now().microsecondsSinceEpoch}';
    var id = baseId;
    var suffix = 0;
    while (_sessions.any((session) => session.id == id)) {
      id = '${baseId}_${++suffix}';
    }
    final session = TasbeehSession(
      id: id,
      name: trimmed,
      progress: const TasbeehProgress(counts: {}, targets: {}),
    );
    _sessions.add(session);
    _selectedSessionId = id;
    _restoreSession(session);
    _commit();
    return id;
  }

  void selectSession(String id) {
    if (id == _selectedSessionId) return;
    final session = _sessions.where((session) => session.id == id).firstOrNull;
    if (session == null) return;
    _selectedSessionId = id;
    _restoreSession(session);
    _commit();
  }

  bool renameSession(String id, String name) {
    if (id == TasbeehSession.defaultId) return false;
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > TasbeehSession.maxNameLength) {
      return false;
    }
    final index = _sessions.indexWhere((session) => session.id == id);
    if (index < 0) return false;
    final session = _sessions[index];
    if (session.name == trimmed) return true;
    _sessions[index] = TasbeehSession(
      id: session.id,
      name: trimmed,
      progress: session.progress,
    );
    _commit();
    return true;
  }

  bool deleteSession(String id) {
    if (id == TasbeehSession.defaultId) return false;
    final index = _sessions.indexWhere((session) => session.id == id);
    if (index < 0) return false;
    _sessions.removeAt(index);
    if (id == _selectedSessionId) {
      _selectedSessionId = TasbeehSession.defaultId;
      _restoreSession(currentSession);
    }
    _commit();
    return true;
  }

  String? addPhrase({
    required String name,
    String arabic = '',
    String meaning = '',
    int target = 33,
  }) {
    if (!TasbeehPhrase.validContent(name, arabic) ||
        !TasbeehPhrase.validTarget(target)) {
      return null;
    }
    final baseId = 'custom_${DateTime.now().microsecondsSinceEpoch}';
    var id = baseId;
    var suffix = 0;
    while (_counts.containsKey(id)) {
      id = '${baseId}_${++suffix}';
    }
    _customPhrases.add(
      TasbeehPhrase(
        id: id,
        name: name.trim(),
        arabic: arabic.trim(),
        meaning: meaning.trim(),
      ),
    );
    _counts[id] = 0;
    _targets[id] = target;
    _autoAdvanceUndoPhraseId = null;
    _selectedPhraseId = id;
    _commit();
    return id;
  }

  bool editPhrase({
    required String id,
    required String name,
    required String arabic,
    String meaning = '',
    required int target,
  }) {
    final index = _customPhrases.indexWhere((phrase) => phrase.id == id);
    if (index < 0 ||
        !TasbeehPhrase.validContent(name, arabic) ||
        !TasbeehPhrase.validTarget(target)) {
      return false;
    }
    _customPhrases[index] = TasbeehPhrase(
      id: id,
      name: name.trim(),
      arabic: arabic.trim(),
      meaning: meaning.trim(),
    );
    _targets[id] = target;
    _autoAdvanceUndoPhraseId = null;
    _commit();
    return true;
  }

  bool deletePhrase(String id) {
    final index = _customPhrases.indexWhere((phrase) => phrase.id == id);
    if (index < 0) return false;
    _customPhrases.removeAt(index);
    _autoAdvanceUndoPhraseId = null;
    _counts.remove(id);
    _targets.remove(id);
    if (_selectedPhraseId == id) {
      _selectedPhraseId = phrases.firstOrNull?.id ?? '';
    }
    _commit();
    return true;
  }

  void _commit() {
    _syncActiveSession();
    notifyListeners();
    final defaultProgress = _sessions
        .firstWhere((session) => session.isDefault)
        .progress;
    final state = TasbeehSavedState(
      counts: defaultProgress.counts,
      targets: defaultProgress.targets,
      selectedPhrase: defaultProgress.selectedPhrase,
      customPhrases: defaultProgress.customPhrases,
      autoNext: defaultProgress.autoNext,
      sessions: List.unmodifiable(_sessions),
      selectedSessionId: _selectedSessionId,
    );
    _saveQueue = _saveQueue
        .then((_) => _repository.saveState(state))
        .catchError((Object _) {});
    unawaited(_saveQueue);
  }

  void _restoreSession(TasbeehSession session) {
    final progress = session.progress;
    final seenIds = builtInTasbeehPhrases.map((phrase) => phrase.id).toSet();
    _customPhrases
      ..clear()
      ..addAll(
        progress.customPhrases.where(
          (phrase) =>
              !phrase.isBuiltIn &&
              phrase.id.startsWith('custom_') &&
              TasbeehPhrase.validContent(phrase.name, phrase.arabic) &&
              seenIds.add(phrase.id),
        ),
      );
    _counts.clear();
    _targets.clear();
    for (final phrase in phrases) {
      final savedCount = progress.counts[phrase.id] ?? 0;
      _counts[phrase.id] = savedCount < 0 ? 0 : savedCount;
      final savedTarget = progress.targets[phrase.id] ?? targets.first;
      _targets[phrase.id] = TasbeehPhrase.validTarget(savedTarget)
          ? savedTarget
          : targets.first;
    }
    _selectedPhraseId =
        phrases.any((phrase) => phrase.id == progress.selectedPhrase)
        ? progress.selectedPhrase!
        : phrases.firstOrNull?.id ?? '';
    _autoNext = progress.autoNext;
    _autoAdvanceUndoPhraseId = null;
  }

  void _syncActiveSession() {
    final index = _sessions.indexWhere(
      (session) => session.id == _selectedSessionId,
    );
    final previous = _sessions[index];
    _sessions[index] = TasbeehSession(
      id: previous.id,
      name: previous.name,
      progress: TasbeehProgress(
        counts: Map.unmodifiable(_counts),
        targets: Map.unmodifiable(_targets),
        selectedPhrase: _selectedPhraseId.isEmpty ? null : _selectedPhraseId,
        customPhrases: List.unmodifiable(_customPhrases),
        autoNext: _autoNext,
      ),
    );
  }
}
