import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/constants/pdf_book_document.dart';
import '../../domain/entities/pdf_book_state.dart';
import '../../domain/repositories/pdf_book_repository.dart';

class PdfBookViewModel extends ChangeNotifier {
  PdfBookViewModel(this._repository, {required this.book}) {
    unawaited(load());
  }

  final PdfBookRepository _repository;
  final PdfBookDefinition book;
  PdfBookReadingState _reading = PdfBookReadingState();
  PdfBookDocument? _document;
  PdfBookDocument? _downloadDocument;
  PdfBookIssue? _issue;
  Future<void> _pendingWrite = Future.value();
  Future<void>? _loadOperation;
  String? _filePath;
  bool _loading = true;
  bool _downloading = false;
  bool _cancelled = false;
  bool _disposed = false;
  int _receivedBytes = 0;
  int? _totalBytes;

  PdfBookReadingState get reading => _reading;
  PdfBookDocument? get document => _document;
  PdfBookDocument? get downloadDocument => _downloadDocument;
  PdfBookIssue? get issue => _issue;
  String? get filePath => _filePath;
  bool get loading => _loading;
  bool get downloading => _downloading;
  bool get available => _filePath != null;
  double? get progress {
    final total = _totalBytes ?? _downloadDocument?.expectedBytes;
    return total != null && total > 0
        ? (_receivedBytes / total).clamp(0, 0.99)
        : null;
  }

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
      _issue = PdfBookIssue.storage;
    } finally {
      _loading = false;
      _notify();
    }
  }

  Future<bool> download(PdfBookDocument document) async {
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
          final percent = progress == null
              ? bytes ~/ (256 * 1024)
              : (progress! * 100).floor();
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
    } on PdfBookException catch (error) {
      if (error.issue != PdfBookIssue.cancelled) _issue = error.issue;
    } catch (_) {
      _issue = PdfBookIssue.network;
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
      bookmarks: _reading.bookmarks.where(
        (value) => value >= 1 && value <= pageCount,
      ),
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

  Future<bool> _persist(PdfBookReadingState state) {
    final result = Completer<bool>();
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        await _repository.saveReading(state);
        if (_issue == PdfBookIssue.storage) {
          _issue = null;
          _notify();
        }
        result.complete(true);
      } catch (_) {
        _issue = PdfBookIssue.storage;
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
      await flushReading();
      await _repository.removeDownload();
      _filePath = null;
      _document = null;
      _downloadDocument = null;
      _issue = null;
      _notify();
      return true;
    } catch (_) {
      _issue = PdfBookIssue.storage;
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
