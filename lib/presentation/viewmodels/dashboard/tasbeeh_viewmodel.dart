import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/tasbeeh_state.dart';
import '../../../domain/repositories/tasbeeh_repository.dart';

enum TasbeehPhraseKey {
  subhanAllah,
  alhamdulillah,
  allahuAkbar,
  laIlahaIllallah,
}

class TasbeehPhrase {
  const TasbeehPhrase({required this.key, required this.arabic});

  final TasbeehPhraseKey key;
  final String arabic;
}

class TasbeehViewModel extends ChangeNotifier {
  TasbeehViewModel({required TasbeehRepository repository})
    : _repository = repository;

  static const List<TasbeehPhrase> phrases = [
    TasbeehPhrase(key: TasbeehPhraseKey.subhanAllah, arabic: 'سُبْحَانَ الله'),
    TasbeehPhrase(
      key: TasbeehPhraseKey.alhamdulillah,
      arabic: 'اَلْحَمْدُ لِلّٰه',
    ),
    TasbeehPhrase(key: TasbeehPhraseKey.allahuAkbar, arabic: 'اللهُ أَكْبَر'),
    TasbeehPhrase(
      key: TasbeehPhraseKey.laIlahaIllallah,
      arabic: 'لَا إِلٰهَ إِلَّا الله',
    ),
  ];

  static const List<int> targets = [33, 99, 100, 500];

  final TasbeehRepository _repository;
  final Map<TasbeehPhraseKey, int> _counts = {
    for (final key in TasbeehPhraseKey.values) key: 0,
  };
  final Map<TasbeehPhraseKey, int> _targets = {
    for (final key in TasbeehPhraseKey.values) key: 33,
  };

  TasbeehPhraseKey _selectedPhraseKey = TasbeehPhraseKey.subhanAllah;
  bool _isLoaded = false;
  Future<void> _saveQueue = Future<void>.value();

  bool get isLoaded => _isLoaded;
  int get count => countFor(_selectedPhraseKey);
  int get target => targetFor(_selectedPhraseKey);
  int get totalCount => _counts.values.fold(0, (total, value) => total + value);
  int get completedRounds => TasbeehPhraseKey.values.fold(
    0,
    (total, key) => total + countFor(key) ~/ targetFor(key),
  );
  int get currentCompletedRounds => count ~/ target;
  TasbeehPhraseKey get selectedPhraseKey => _selectedPhraseKey;

  TasbeehPhrase get selectedPhrase =>
      phrases.firstWhere((phrase) => phrase.key == _selectedPhraseKey);

  Map<TasbeehPhraseKey, int> get counts => Map.unmodifiable(_counts);
  Map<TasbeehPhraseKey, int> get selectedTargets => Map.unmodifiable(_targets);

  double get progress {
    if (count == 0) return 0;
    final remainder = count % target;
    return remainder == 0 ? 1 : remainder / target;
  }

  bool get isTargetReached => count > 0 && count % target == 0;

  int countFor(TasbeehPhraseKey key) => _counts[key] ?? 0;

  int targetFor(TasbeehPhraseKey key) => _targets[key] ?? targets.first;

  Future<void> load() async {
    try {
      final state = await _repository.loadState();
      if (state != null) {
        for (final key in TasbeehPhraseKey.values) {
          final savedCount = state.counts[key.name];
          final savedTarget = state.targets[key.name];
          if (savedCount != null && savedCount >= 0) _counts[key] = savedCount;
          if (savedTarget != null && targets.contains(savedTarget)) {
            _targets[key] = savedTarget;
          }
        }

        _selectedPhraseKey = TasbeehPhraseKey.values.firstWhere(
          (key) => key.name == state.selectedPhrase,
          orElse: () => TasbeehPhraseKey.subhanAllah,
        );
      }
    } catch (_) {
      // Keep the in-memory defaults when persisted state cannot be read.
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  void increment() {
    _counts[_selectedPhraseKey] = count + 1;
    _commit();
  }

  void decrement() {
    if (count == 0) return;
    _counts[_selectedPhraseKey] = count - 1;
    _commit();
  }

  void resetCount() {
    if (count == 0) return;
    _counts[_selectedPhraseKey] = 0;
    _commit();
  }

  void resetAll() {
    if (totalCount == 0) return;
    for (final key in TasbeehPhraseKey.values) {
      _counts[key] = 0;
    }
    _commit();
  }

  void selectTarget(int target) {
    if (this.target == target || !targets.contains(target)) return;
    _targets[_selectedPhraseKey] = target;
    _commit();
  }

  void selectPhrase(TasbeehPhraseKey key) {
    if (_selectedPhraseKey == key) return;
    _selectedPhraseKey = key;
    _commit();
  }

  void _commit() {
    notifyListeners();
    final state = _savedState;
    _saveQueue = _saveQueue
        .then((_) => _repository.saveState(state))
        .catchError((Object _) {});
    unawaited(_saveQueue);
  }

  TasbeehSavedState get _savedState => TasbeehSavedState(
    counts: _counts.map((key, value) => MapEntry(key.name, value)),
    targets: _targets.map((key, value) => MapEntry(key.name, value)),
    selectedPhrase: _selectedPhraseKey.name,
  );
}
