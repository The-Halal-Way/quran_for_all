import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../domain/repositories/quran_repository.dart';

/// Checks local storage for startup, then prepares missing Quran content in
/// the background so the rest of the app remains available without internet.
class SplashViewModel extends ChangeNotifier with WidgetsBindingObserver {
  SplashViewModel({required QuranRepository quranRepository})
    : _quranRepository = quranRepository {
    WidgetsBinding.instance.addObserver(this);
  }

  final QuranRepository _quranRepository;

  bool _isLoading = true;
  bool _hasQuranData = false;
  bool _isDownloading = false;
  bool _disposed = false;
  String _status = 'Preparing local Quran database...';
  Future<void>? _startupTask;
  Future<void>? _downloadTask;
  DateTime? _lastDownloadAttempt;

  bool get isLoading => _isLoading;
  bool get hasQuranData => _hasQuranData;
  bool get isDownloading => _isDownloading;
  String get status => _status;

  Future<void> initialize() => _startupTask ??= _prepare();

  Future<void> _prepare() async {
    try {
      _hasQuranData = await _quranRepository.hasLocalData();
    } catch (_) {
      // A database failure should not keep Prayer, Du'a, or Settings behind
      // the splash screen. The Quran panel offers another attempt.
      _hasQuranData = false;
    }

    _isLoading = false;
    _status = _hasQuranData ? 'Ready' : 'Downloading Quran data...';
    _notify();
    unawaited(retryDownload());
  }

  Future<void> retryDownload() {
    final active = _downloadTask;
    if (active != null) return active;

    final task = _import();
    _downloadTask = task;
    return task.whenComplete(() => _downloadTask = null);
  }

  Future<void> _import() async {
    _lastDownloadAttempt = DateTime.now();
    _isDownloading = true;
    _notify();

    try {
      await _quranRepository.importDataIfNeeded(
        onProgress: (status) {
          _status = status;
          _notify();
        },
        onCoreDataReady: () {
          _hasQuranData = true;
          _status = 'Ready';
          _notify();
        },
      );
      _hasQuranData = await _quranRepository.hasLocalData();
      _status = _hasQuranData ? 'Ready' : 'Quran download unavailable';
    } catch (_) {
      try {
        _hasQuranData = await _quranRepository.hasLocalData();
      } catch (_) {
        _hasQuranData = false;
      }
      if (!_hasQuranData) {
        _status = 'Quran download unavailable';
      } else {
        _status = 'Ready';
      }
    } finally {
      _isDownloading = false;
      _notify();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed ||
        _hasQuranData ||
        _isDownloading ||
        _lastDownloadAttempt == null) {
      return;
    }
    if (DateTime.now().difference(_lastDownloadAttempt!) >=
        const Duration(seconds: 30)) {
      unawaited(retryDownload());
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
