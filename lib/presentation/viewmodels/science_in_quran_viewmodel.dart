import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/constants/science_in_quran_document.dart';
import '../../domain/entities/science_in_quran_state.dart';
import '../../domain/repositories/science_in_quran_repository.dart';

class ScienceInQuranViewModel extends ChangeNotifier {
  ScienceInQuranViewModel(this._repository) {
    unawaited(load());
  }

  final ScienceInQuranRepository _repository;
  ScienceInQuranReadingState _reading = ScienceInQuranReadingState();
  ScienceInQuranDocument? _document;
  ScienceInQuranDocument? _downloadDocument;
  ScienceInQuranIssue? _issue;
  Future<void> _pendingWrite = Future.value();
  Future<void>? _loadOperation;
  String? _filePath;
  bool _loading = true;
  bool _downloading = false;
  bool _cancelled = false;
  bool _disposed = false;
  int _receivedBytes = 0;
  int? _totalBytes;

  ScienceInQuranReadingState get reading => _reading;
  ScienceInQuranDocument? get document => _document;
  ScienceInQuranDocument? get downloadDocument => _downloadDocument;
  ScienceInQuranIssue? get issue => _issue;
  String? get filePath => _filePath;
  bool get loading => _loading;
  bool get downloading => _downloading;
  bool get available => _filePath != null;
  double get progress =>
      (_receivedBytes / (_totalBytes ?? _downloadDocument?.expectedBytes ?? 1))
          .clamp(0, 0.99);

  Future<void> load() => _loadOperation ??= _load().whenComplete(() {
    _loadOperation = null;
  });

  Future<void> _load() async {
    _loading = true;
    _notify();
    try {
      await flushReading();
      final library = await _repository.loadLibrary();
      if (_disposed) return;
      _reading = library.reading;
      _document = library.document;
      _filePath = library.filePath;
      _issue = null;
    } catch (_) {
      _issue = ScienceInQuranIssue.storage;
    } finally {
      _loading = false;
      _notify();
    }
  }

  Future<bool> download(ScienceInQuranDocument document) async {
    if (_loading || _downloading || _disposed) return false;
    _downloading = true;
    _cancelled = false;
    _downloadDocument = document;
    _receivedBytes = 0;
    _totalBytes = null;
    _issue = null;
    _notify();
    var downloaded = false;
    var lastPercent = -1;
    try {
      await flushReading();
      if (_cancelled || _disposed) return false;
      final library = await _repository.download(
        document: document,
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
      if (_disposed) return false;
      _reading = library.reading;
      _document = library.document;
      _filePath = library.filePath;
      downloaded = available;
    } on ScienceInQuranException catch (error) {
      if (error.issue != ScienceInQuranIssue.cancelled) _issue = error.issue;
    } catch (_) {
      _issue = ScienceInQuranIssue.network;
    } finally {
      _downloading = false;
      _notify();
    }
    return downloaded;
  }

  void cancelDownload() {
    _cancelled = true;
    _repository.cancelDownload();
  }

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

  Future<bool> _persist(ScienceInQuranReadingState state) {
    final result = Completer<bool>();
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        await _repository.saveReading(state);
        if (_issue == ScienceInQuranIssue.storage) {
          _issue = null;
          _notify();
        }
        result.complete(true);
      } catch (_) {
        _issue = ScienceInQuranIssue.storage;
        _notify();
        result.complete(false);
      }
    });
    return result.future;
  }

  Future<void> flushReading() => _pendingWrite;

  Future<bool> removeDownload() async {
    if (_loading || _downloading || _disposed) return false;
    try {
      await _repository.removeDownload();
      _filePath = null;
      _document = null;
      _downloadDocument = null;
      _issue = null;
      _notify();
      return true;
    } catch (_) {
      _issue = ScienceInQuranIssue.storage;
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
