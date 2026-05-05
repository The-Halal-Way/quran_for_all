import 'package:flutter/foundation.dart';

import '../../domain/repositories/quran_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({required QuranRepository quranRepository})
    : _quranRepository = quranRepository;

  final QuranRepository _quranRepository;

  bool _isLoading = true;
  String _status = 'Preparing local Quran database...';
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String get status => _status;
  String? get errorMessage => _errorMessage;

  Future<bool> initialize() async {
    try {
      _isLoading = true;
      _errorMessage = null;
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
      _isLoading = false;
      _errorMessage = 'Failed to initialize local Quran data.';
      notifyListeners();
      return false;
    }
  }
}
