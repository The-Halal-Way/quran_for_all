import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../viewmodels/pdf_book_reader_controller.dart';
import '../../../viewmodels/pdf_book_viewmodel.dart';
import '../../../widgets/pdf_books/pdf_book_bookmarks_sheet.dart';
import '../../../widgets/pdf_books/pdf_book_download_progress.dart';
import '../../../widgets/pdf_books/pdf_book_jump_dialog.dart';
import '../../../widgets/pdf_books/pdf_book_labels.dart';
import '../../../widgets/pdf_books/pdf_book_language_sheet.dart';
import '../../../widgets/pdf_books/pdf_book_pdf_canvas.dart';
import '../../../widgets/pdf_books/pdf_book_reader_controls.dart';

class PdfBookReaderView extends StatefulWidget {
  const PdfBookReaderView({
    super.key,
    required this.filePath,
    required this.library,
  });

  final String filePath;
  final PdfBookViewModel library;

  @override
  State<PdfBookReaderView> createState() => _PdfBookReaderViewState();
}

class _PdfBookReaderViewState extends State<PdfBookReaderView>
    with WidgetsBindingObserver {
  late final PdfBookViewModel _library;
  late final PdfBookReaderController _reader;

  @override
  void initState() {
    super.initState();
    _library = widget.library;
    _reader = PdfBookReaderController(
      filePath: widget.filePath,
      library: _library,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_library.flushReading());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_library.flushReading());
    _reader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: _library,
    child: ChangeNotifierProvider.value(
      value: _reader,
      child: Consumer<PdfBookReaderController>(
        builder: (context, reader, _) {
          final library = context.watch<PdfBookViewModel>();
          final bookmarked = library.isBookmarked(reader.page);
          final controller = reader.pdfController;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                library.document?.title ?? pdfBookTitle(context, library.book),
              ),
              actions: [
                IconButton(
                  tooltip: bookmarked
                      ? context.l10n.pdfBookBookmarkRemove
                      : context.l10n.pdfBookBookmarkAdd,
                  onPressed: reader.ready ? _toggleBookmark : null,
                  icon: Icon(
                    bookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.pdfBookBookmarks,
                  onPressed: reader.ready ? _openBookmarks : null,
                  icon: const Icon(Icons.bookmarks_outlined),
                ),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: library.downloading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              child: PdfBookDownloadProgress(
                                progress: library.progress,
                                onCancel: library.cancelDownload,
                              ),
                            ),
                          )
                        : reader.loading
                        ? const Center(child: CircularProgressIndicator())
                        : reader.failed || controller == null
                        ? _ReaderError(
                            onRetry: () => unawaited(reader.open()),
                            onDownloadAgain: () => unawaited(_downloadAgain()),
                          )
                        : PdfBookPdfCanvas(
                            controller: controller,
                            onPageChanged: reader.pageChanged,
                            onDocumentLoaded: reader.documentLoaded,
                            onDocumentError: reader.documentFailed,
                          ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: PdfBookReaderControls(
              page: reader.page,
              pageCount: reader.pageCount,
              ready: reader.ready,
              onPrevious: () => unawaited(reader.goToPage(reader.page - 1)),
              onNext: () => unawaited(reader.goToPage(reader.page + 1)),
              onJump: _jumpToPage,
            ),
          );
        },
      ),
    ),
  );

  Future<void> _downloadAgain() async {
    final document = await showPdfBookLanguageSheet(
      context,
      book: _library.book,
      initialDocument: _library.downloadDocument ?? _library.document,
    );
    if (mounted && document != null) await _reader.downloadAgain(document);
  }

  Future<void> _toggleBookmark() async {
    final page = _reader.page;
    final wasBookmarked = _library.isBookmarked(page);
    final saved = await _library.toggleBookmark(page);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            !saved
                ? context.l10n.pdfBookStorageError
                : wasBookmarked
                ? context.l10n.pdfBookBookmarkRemoved(
                    pdfBookNumber(context, page),
                  )
                : context.l10n.pdfBookBookmarkSaved(
                    pdfBookNumber(context, page),
                  ),
          ),
        ),
      );
  }

  Future<void> _openBookmarks() async {
    final page = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: _library,
        child: const PdfBookBookmarksSheet(),
      ),
    );
    if (mounted && page != null) await _reader.goToPage(page);
  }

  Future<void> _jumpToPage() async {
    final page = await showDialog<int>(
      context: context,
      builder: (_) =>
          PdfBookJumpDialog(page: _reader.page, pageCount: _reader.pageCount),
    );
    if (mounted && page != null) await _reader.goToPage(page);
  }
}

class _ReaderError extends StatelessWidget {
  const _ReaderError({required this.onRetry, required this.onDownloadAgain});

  final VoidCallback onRetry;
  final VoidCallback onDownloadAgain;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              context.l10n.pdfBookReaderError,
              textAlign: TextAlign.center,
              style: text.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.pdfBookRetry),
                ),
                FilledButton.icon(
                  onPressed: onDownloadAgain,
                  icon: const Icon(Icons.download_rounded),
                  label: Text(context.l10n.pdfBookDownloadAgain),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
