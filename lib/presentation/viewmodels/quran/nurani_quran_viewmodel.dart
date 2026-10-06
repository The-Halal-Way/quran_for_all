import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/constants/nurani_quran_document.dart';
import '../../../domain/entities/quran/nurani_quran_state.dart';
import '../../../domain/repositories/nurani_quran_repository.dart';

class NuraniQuranViewModel extends ChangeNotifier {
  NuraniQuranViewModel(this._repository) {
    unawaited(load());
  }

  final NuraniQuranRepository _repository;
  NuraniQuranReadingState _reading = NuraniQuranReadingState();
  Future<void> _pendingWrite = Future.value();
  Future<void>? _loadOperation;
  String? _filePath;
  NuraniQuranIssue? _issue;
  bool _loading = true;
  bool _downloading = false;
  bool _disposed = false;
  int _receivedBytes = 0;
  int? _totalBytes;

  NuraniQuranReadingState get reading => _reading;
  String? get filePath => _filePath;
  NuraniQuranIssue? get issue => _issue;
  bool get loading => _loading;
  bool get downloading => _downloading;
  bool get available => _filePath != null;
  int get receivedBytes => _receivedBytes;
  double get progress =>
      (_receivedBytes / (_totalBytes ?? NuraniQuranDocument.expectedBytes))
          .clamp(0, 0.99);

  Future<void> load() {
    if (_downloading) return Future.value();
    return _loadOperation ??= _load().whenComplete(() => _loadOperation = null);
  }

  Future<void> _load() async {
    _loading = true;
    _notify();
    try {
      await flushReading();
      final library = await _repository.loadLibrary();
      if (_disposed) return;
      _reading = library.reading;
      _filePath = library.filePath;
      _issue = null;
    } catch (_) {
      _issue = NuraniQuranIssue.storage;
    } finally {
      _loading = false;
      _notify();
    }
  }

  Future<bool> download() async {
    if (_downloading || _loading || _disposed) return false;
    _downloading = true;
    _receivedBytes = 0;
    _totalBytes = null;
    _issue = null;
    _notify();
    var lastPercent = -1;
    var downloaded = false;
    try {
      _filePath = await _repository.download(
        onProgress: (bytes, total) {
          _receivedBytes = bytes;
          _totalBytes = total != null && total > 0 ? total : null;
          final percent = (progress * 100).floor();
          if (percent != lastPercent) {
            lastPercent = percent;
            _notify();
          }
        },
      );
      downloaded = true;
    } on NuraniQuranException catch (error) {
      if (error.issue != NuraniQuranIssue.cancelled) _issue = error.issue;
    } catch (_) {
      _issue = NuraniQuranIssue.network;
    } finally {
      _downloading = false;
      _notify();
    }
    return downloaded;
  }

  void cancelDownload() => _repository.cancelDownload();

  void documentOpened(int pageCount, int page) {
    if (pageCount < 1) return;
    _reading = _reading.copyWith(
      pageCount: pageCount,
      lastPage: page.clamp(1, pageCount),
      bookmarks: _reading.bookmarks.where((value) => value <= pageCount),
    );
    _notify();
    unawaited(_persist(_reading));
  }

  void pageChanged(int page) {
    if (page < 1 || page > _reading.pageCount || page == _reading.lastPage) {
      return;
    }
    _reading = _reading.copyWith(lastPage: page);
    _notify();
    unawaited(_persist(_reading));
  }

  bool isBookmarked(int page) => _reading.bookmarks.contains(page);

  Future<bool> toggleBookmark(int page) async {
    if (page < 1 || page > _reading.pageCount) return false;
    final previous = _reading;
    final pages = _reading.bookmarks.toSet();
    pages.contains(page) ? pages.remove(page) : pages.add(page);
    final updated = _reading.copyWith(bookmarks: pages);
    _reading = updated;
    _notify();
    final saved = await _persist(updated);
    if (!saved && identical(_reading, updated)) {
      _reading = previous;
      _notify();
    }
    return saved;
  }

  Future<bool> _persist(NuraniQuranReadingState state) {
    final result = Completer<bool>();
    // Serialize writes so quick page changes cannot restore an older position.
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        await _repository.saveReading(state);
        if (_issue == NuraniQuranIssue.storage) {
          _issue = null;
          _notify();
        }
        result.complete(true);
      } catch (_) {
        _issue = NuraniQuranIssue.storage;
        _notify();
        result.complete(false);
      }
    });
    return result.future;
  }

  Future<void> flushReading() => _pendingWrite;

  Future<bool> removeDownload() async {
    if (_downloading) return false;
    try {
      await _repository.removeDownload();
      _filePath = null;
      _issue = null;
      _notify();
      return true;
    } catch (_) {
      _issue = NuraniQuranIssue.storage;
      _notify();
      return false;
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _repository.cancelDownload();
    super.dispose();
  }
}
