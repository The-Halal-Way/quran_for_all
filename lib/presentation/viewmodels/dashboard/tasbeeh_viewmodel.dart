import 'package:flutter/foundation.dart';

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

  int _count = 0;
  int _totalCount = 0;
  int _completedRounds = 0;
  int _target = 33;
  TasbeehPhraseKey _selectedPhraseKey = TasbeehPhraseKey.subhanAllah;

  int get count => _count;
  int get totalCount => _totalCount;
  int get completedRounds => _completedRounds;
  int get target => _target;
  TasbeehPhraseKey get selectedPhraseKey => _selectedPhraseKey;

  TasbeehPhrase get selectedPhrase =>
      phrases.firstWhere((phrase) => phrase.key == _selectedPhraseKey);

  double get progress =>
      _target == 0 ? 0.0 : (_count / _target).clamp(0.0, 1.0).toDouble();
  bool get isTargetReached => _count == _target;

  void increment() {
    if (_count >= _target) {
      _count = 1;
    } else {
      _count += 1;
    }

    _totalCount += 1;
    if (_count == _target) {
      _completedRounds += 1;
    }

    notifyListeners();
  }

  void decrement() {
    if (_count == 0 && _totalCount == 0) {
      return;
    }

    if (_count == _target && _completedRounds > 0) {
      _completedRounds -= 1;
    }

    if (_count > 0) {
      _count -= 1;
    }
    if (_totalCount > 0) {
      _totalCount -= 1;
    }

    notifyListeners();
  }

  void resetCount() {
    if (_count == 0) {
      return;
    }
    _count = 0;
    notifyListeners();
  }

  void resetAll() {
    if (_count == 0 && _totalCount == 0 && _completedRounds == 0) {
      return;
    }

    _count = 0;
    _totalCount = 0;
    _completedRounds = 0;
    notifyListeners();
  }

  void selectTarget(int target) {
    if (_target == target || !targets.contains(target)) {
      return;
    }

    _target = target;
    _count = _count.clamp(0, _target).toInt();
    notifyListeners();
  }

  void selectPhrase(TasbeehPhraseKey key) {
    if (_selectedPhraseKey == key) {
      return;
    }

    _selectedPhraseKey = key;
    notifyListeners();
  }
}
