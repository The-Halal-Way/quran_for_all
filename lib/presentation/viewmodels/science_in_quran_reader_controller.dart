import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../core/constants/science_in_quran_document.dart';
import 'science_in_quran_viewmodel.dart';

class ScienceInQuranReaderController extends ChangeNotifier {
  ScienceInQuranReaderController({
    required String filePath,
    required ScienceInQuranViewModel library,
  }) : _filePath = filePath,
       _library = library {
    unawaited(open());
  }

  String _filePath;
  final ScienceInQuranViewModel _library;
  PdfDocument? _document;
  PdfControllerPinch? _pdfController;
  bool _loading = false;
  bool _ready = false;
  bool _failed = false;
  bool _disposed = false;
  int _page = 1;
  int _pageCount = 0;

  PdfControllerPinch? get pdfController => _pdfController;
  bool get loading => _loading;
  bool get ready => _ready;
  bool get failed => _failed;
  int get page => _page;
  int get pageCount => _pageCount;

  Future<void> open() async {
    if (_loading || _disposed) return;
    _releaseDocument();
    _loading = true;
    _ready = false;
    _failed = false;
    notifyListeners();
    try {
      final document = await PdfDocument.openFile(_filePath);
      if (_disposed) {
        await document.close();
        return;
      }
      if (document.pagesCount < 1) {
        await document.close();
        throw StateError('The PDF has no pages');
      }
      _document = document;
      _pageCount = document.pagesCount;
      _page = _library.reading.lastPage.clamp(1, _pageCount);
      _pdfController = PdfControllerPinch(
        document: Future.value(document),
        initialPage: _page,
      );
    } catch (_) {
      _failed = true;
    } finally {
      _loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  void documentLoaded(PdfDocument document) {
    if (_disposed || !identical(document, _document)) return;
    _ready = true;
    _library.documentOpened(_pageCount, _page);
    notifyListeners();
  }

  void documentFailed(Object error) {
    if (_disposed) return;
    _ready = false;
    _failed = true;
    notifyListeners();
  }

  void pageChanged(int page) {
    if (_disposed ||
        !_ready ||
        page < 1 ||
        page > _pageCount ||
        page == _page) {
      return;
    }
    _page = page;
    _library.pageChanged(page);
    notifyListeners();
  }

  Future<void> goToPage(int page) async {
    if (!_ready || _disposed || page < 1 || page > _pageCount) return;
    await _pdfController?.animateToPage(
      pageNumber: page,
      duration: const Duration(milliseconds: 250),
    );
  }

  Future<void> downloadAgain(ScienceInQuranDocument document) async {
    if (_loading || _library.downloading || _disposed) return;
    _releaseDocument();
    final downloaded = await _library.download(document);
    if (!_disposed && downloaded) {
      _filePath = _library.filePath!;
      await open();
    }
  }

  void _releaseDocument() {
    final controller = _pdfController;
    final document = _document;
    _pdfController = null;
    _document = null;
    if (controller == null && document == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller?.dispose();
      if (document != null) unawaited(document.close());
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _releaseDocument();
    super.dispose();
  }
}
