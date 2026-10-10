import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../domain/entities/quran/nurani_quran_state.dart';
import '../../../viewmodels/quran/nurani_quran_reader_controller.dart';
import '../../../viewmodels/quran/nurani_quran_viewmodel.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_bookmarks_sheet.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_download_progress.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_edition_sheet.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_jump_dialog.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_labels.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_pdf_canvas.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_reader_controls.dart';
import '../../../widgets/quran/nurani_quran/nurani_quran_reader_error.dart';

class NuraniQuranReaderView extends StatefulWidget {
  const NuraniQuranReaderView({super.key, required this.filePath});

  final String filePath;

  @override
  State<NuraniQuranReaderView> createState() => _NuraniQuranReaderViewState();
}

class _NuraniQuranReaderViewState extends State<NuraniQuranReaderView>
    with WidgetsBindingObserver {
  late final NuraniQuranViewModel _library;
  late final NuraniQuranReaderController _reader;

  @override
  void initState() {
    super.initState();
    _library = context.read<NuraniQuranViewModel>();
    _reader = NuraniQuranReaderController(
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _reader,
      child: Consumer<NuraniQuranReaderController>(
        builder: (context, reader, _) {
          final library = context.watch<NuraniQuranViewModel>();
          final bookmarked = library.isBookmarked(reader.page);
          final controller = reader.pdfController;
          return Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.nuraniQuranTitle),
              actions: [
                IconButton(
                  tooltip: bookmarked
                      ? context.l10n.nuraniQuranBookmarkRemove
                      : context.l10n.nuraniQuranBookmarkAdd,
                  onPressed: reader.ready ? _toggleBookmark : null,
                  icon: Icon(
                    bookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.nuraniQuranBookmarks,
                  onPressed: reader.ready ? _openBookmarks : null,
                  icon: const Icon(Icons.bookmarks_outlined),
                ),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  if (library.issue == NuraniQuranIssue.storage)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        context.l10n.nuraniQuranStorageError,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  Expanded(
                    child: library.downloading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: NuraniQuranDownloadProgress(
                                progress: library.progress,
                                onCancel: library.cancelDownload,
                              ),
                            ),
                          )
                        : reader.loading
                        ? const Center(child: CircularProgressIndicator())
                        : reader.failed || controller == null
                        ? NuraniQuranReaderError(
                            onRetry: () => unawaited(reader.open()),
                            onDownloadAgain: () => unawaited(_downloadAgain()),
                          )
                        : NuraniQuranPdfCanvas(
                            controller: controller,
                            onPageChanged: reader.pageChanged,
                            onDocumentLoaded: reader.documentLoaded,
                            onDocumentError: reader.documentFailed,
                          ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: NuraniQuranReaderControls(
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
    );
  }

  Future<void> _downloadAgain() async {
    final document = await showNuraniQuranEditionSheet(
      context,
      initialDocument: _library.downloadDocument ?? _library.document,
    );
    if (mounted && document != null) {
      await _reader.downloadAgain(document);
    }
  }

  Future<void> _toggleBookmark() async {
    final page = _reader.page;
    final wasBookmarked = _library.isBookmarked(page);
    final saved = await _library.toggleBookmark(page);
    if (!mounted) return;
    final l10n = context.l10n;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            !saved
                ? l10n.nuraniQuranStorageError
                : wasBookmarked
                ? l10n.nuraniQuranBookmarkRemoved(nuraniNumber(context, page))
                : l10n.nuraniQuranBookmarkSaved(nuraniNumber(context, page)),
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
      builder: (_) =>
          const SafeArea(top: false, child: NuraniQuranBookmarksSheet()),
    );
    if (mounted && page != null) await _reader.goToPage(page);
  }

  Future<void> _jumpToPage() async {
    final page = await showDialog<int>(
      context: context,
      builder: (_) => NuraniQuranJumpDialog(
        page: _reader.page,
        pageCount: _reader.pageCount,
      ),
    );
    if (mounted && page != null) await _reader.goToPage(page);
  }
}
