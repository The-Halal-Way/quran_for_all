import 'package:flutter/widgets.dart';

import '../../domain/repositories/quran_repository.dart';

/// Checks local Quran storage when a Quran page (or the optional splash) opens.
/// Quran content downloads only after an explicit request.
class SplashViewModel extends ChangeNotifier {
  SplashViewModel({required QuranRepository quranRepository})
    : _quranRepository = quranRepository;

  final QuranRepository _quranRepository;

  bool _isLoading = true;
  bool _hasQuranData = false;
  bool _isDownloading = false;
  bool _disposed = false;
  String _status = 'Preparing local Quran database...';
  Future<void>? _startupTask;
  Future<void>? _downloadTask;

  bool get isLoading => _isLoading;
  bool get hasQuranData => _hasQuranData;
  bool get isDownloading => _isDownloading;
  String get status => _status;

  Future<void> initialize() => _startupTask ??= _prepare();

  Future<void> _prepare() async {
    try {
      _hasQuranData = await _quranRepository.hasCompleteLocalData();
    } catch (_) {
      // A database failure should not keep Prayer, Du'a, or Settings behind
      // the splash screen. The Quran panel offers another attempt.
      _hasQuranData = false;
    }

    _isLoading = false;
    _status = _hasQuranData ? 'Ready' : 'Quran download available on demand';
    _notify();
  }

  Future<void> retryDownload() {
    final active = _downloadTask;
    if (active != null) return active;

    final task = _import();
    _downloadTask = task;
    return task.whenComplete(() => _downloadTask = null);
  }

  Future<void> _import() async {
    _isDownloading = true;
    _notify();

    try {
      await _quranRepository.importDataIfNeeded(
        onProgress: (status) {
          _status = status;
          _notify();
        },
        onCoreDataReady: () {
          _status = 'Quran text ready; finishing library...';
          _notify();
        },
      );
      _hasQuranData = await _quranRepository.hasCompleteLocalData();
      _status = _hasQuranData ? 'Ready' : 'Quran download unavailable';
    } catch (_) {
      try {
        _hasQuranData = await _quranRepository.hasCompleteLocalData();
      } catch (_) {
        _hasQuranData = false;
      }
      _status = _hasQuranData ? 'Ready' : 'Quran download unavailable';
    } finally {
      _isDownloading = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
