import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/datasources/tasbeeh_phrases_data.dart';
import '../../../data/models/tasbeeh_state.dart';
import '../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import '../../../domain/repositories/tasbeeh_repository.dart';

export '../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';

class TasbeehViewModel extends ChangeNotifier {
  TasbeehViewModel({required TasbeehRepository repository})
    : _repository = repository;

  static const targets = [33, 99, 100, 500];

  final TasbeehRepository _repository;
  final List<TasbeehPhrase> _customPhrases = [];
  final Map<String, int> _counts = {
    for (final phrase in builtInTasbeehPhrases) phrase.id: 0,
  };
  final Map<String, int> _targets = {
    for (final phrase in builtInTasbeehPhrases) phrase.id: 33,
  };
  String _selectedPhraseId = builtInTasbeehPhrases.first.id;
  bool _isLoaded = false;
  Future<void> _saveQueue = Future<void>.value();

  bool get isLoaded => _isLoaded;
  String get selectedPhraseId => _selectedPhraseId;
  List<TasbeehPhrase> get phrases =>
      List.unmodifiable([...builtInTasbeehPhrases, ..._customPhrases]);
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
        final seenIds = builtInTasbeehPhrases
            .map((phrase) => phrase.id)
            .toSet();
        _customPhrases
          ..clear()
          ..addAll(
            state.customPhrases.where(
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
          final savedCount = state.counts[phrase.id] ?? 0;
          _counts[phrase.id] = savedCount < 0 ? 0 : savedCount;
          final savedTarget = state.targets[phrase.id] ?? targets.first;
          _targets[phrase.id] = TasbeehPhrase.validTarget(savedTarget)
              ? savedTarget
              : targets.first;
        }
        _selectedPhraseId =
            phrases.any((phrase) => phrase.id == state.selectedPhrase)
            ? state.selectedPhrase!
            : builtInTasbeehPhrases.first.id;
      }
    } catch (_) {
      // Retain the existing session if storage cannot be read.
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  void increment() {
    _counts[_selectedPhraseId] = count + 1;
    _commit();
  }

  void decrement() {
    if (count == 0) return;
    _counts[_selectedPhraseId] = count - 1;
    _commit();
  }

  void resetCount() {
    if (count == 0) return;
    _counts[_selectedPhraseId] = 0;
    _commit();
  }

  void resetAll() {
    if (totalCount == 0) return;
    _counts.updateAll((_, _) => 0);
    _commit();
  }

  void selectTarget(int target) {
    if (this.target == target || !TasbeehPhrase.validTarget(target)) return;
    _targets[_selectedPhraseId] = target;
    _commit();
  }

  void selectPhrase(String id) {
    if (_selectedPhraseId == id || !_counts.containsKey(id)) return;
    _selectedPhraseId = id;
    _commit();
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
    _commit();
    return true;
  }

  bool deletePhrase(String id) {
    final index = _customPhrases.indexWhere((phrase) => phrase.id == id);
    if (index < 0) return false;
    _customPhrases.removeAt(index);
    _counts.remove(id);
    _targets.remove(id);
    if (_selectedPhraseId == id) {
      _selectedPhraseId = builtInTasbeehPhrases.first.id;
    }
    _commit();
    return true;
  }

  void _commit() {
    notifyListeners();
    final state = TasbeehSavedState(
      counts: Map.of(_counts),
      targets: Map.of(_targets),
      selectedPhrase: _selectedPhraseId,
      customPhrases: List.of(_customPhrases),
    );
    _saveQueue = _saveQueue
        .then((_) => _repository.saveState(state))
        .catchError((Object _) {});
    unawaited(_saveQueue);
  }
}
