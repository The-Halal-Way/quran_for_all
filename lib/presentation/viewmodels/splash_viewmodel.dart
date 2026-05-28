import 'package:flutter/foundation.dart';

import '../../domain/repositories/quran_repository.dart';

enum SplashFailureReason { none, firstSetupNeedsNetwork }

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({required QuranRepository quranRepository})
    : _quranRepository = quranRepository;

  final QuranRepository _quranRepository;

  bool _isLoading = true;
  String _status = 'Preparing local Quran database...';
  String? _errorMessage;
  SplashFailureReason _failureReason = SplashFailureReason.none;

  bool get isLoading => _isLoading;
  String get status => _status;
  String? get errorMessage => _errorMessage;
  SplashFailureReason get failureReason => _failureReason;

  Future<bool> initialize() async {
    try {
      _isLoading = true;
      _status = 'Preparing local Quran database...';
      _errorMessage = null;
      _failureReason = SplashFailureReason.none;
      notifyListeners();

      await _quranRepository.importDataIfNeeded(
        onProgress: (status) {
          _status = status;
          notifyListeners();
        },
      );

      _status = 'Ready';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      final hasLocalData = await _quranRepository.hasLocalData();
      if (hasLocalData) {
        _status =
            'Ready with saved Quran data. Some newer content may sync later.';
        _isLoading = false;
        _errorMessage = null;
        _failureReason = SplashFailureReason.none;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      _errorMessage = 'Failed to initialize local Quran data.';
      _failureReason = SplashFailureReason.firstSetupNeedsNetwork;
      notifyListeners();
      return false;
    }
  }
}
