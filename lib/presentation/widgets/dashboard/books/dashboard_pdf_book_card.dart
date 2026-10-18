import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/pdf_book_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/pdf_book_viewmodel.dart';
import '../../../viewmodels/pdf_books_library.dart';
import 'pdf_book_card_header.dart';
import 'pdf_book_meta_chip.dart';
import '../../../views/dashboard/books/pdf_book_reader_view.dart';
import '../../pdf_books/pdf_book_download_progress.dart';
import '../../pdf_books/pdf_book_labels.dart';
import '../../pdf_books/pdf_book_language_sheet.dart';

class DashboardPdfBookCard extends StatelessWidget {
  const DashboardPdfBookCard({
    super.key,
    required this.book,
    required this.accent,
  });

  final PdfBookDefinition book;
  final Color accent;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: context.read<PdfBooksLibrary>().forBook(book),
    child: _PdfBookCardBody(book: book, accent: accent),
  );
}

class _PdfBookCardBody extends StatelessWidget {
  const _PdfBookCardBody({required this.book, required this.accent});

  final PdfBookDefinition book;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PdfBookViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;
    final text = AppTheme.text(context);
    final document = model.downloading
        ? model.downloadDocument
        : model.document;
    final recommended = book.forLocale(Localizations.localeOf(context));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surface,
            Color.alphaBlend(accent.withValues(alpha: 0.09), scheme.surface),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PdfBookCardHeader(
            book: book,
            document: document ?? recommended,
            accent: accent,
            available: model.available && !model.downloading && !model.loading,
            onRemove: () => unawaited(_removeDownload(context, model)),
            onChangeLanguage: () => unawaited(_chooseDownload(context, model)),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              if (document != null) ...[
                PdfBookMetaChip(
                  icon: Icons.translate_rounded,
                  label: pdfBookLanguageLabel(context, document.language),
                ),
                PdfBookMetaChip(
                  icon: Icons.picture_as_pdf_rounded,
                  label: pdfBookFileSize(context, document),
                ),
              ] else
                PdfBookMetaChip(
                  icon: Icons.auto_awesome_rounded,
                  label: pdfBookLanguageLabel(context, recommended.language),
                ),
              if (model.available)
                PdfBookMetaChip(
                  icon: Icons.cloud_done_rounded,
                  label: context.l10n.pdfBookOfflineReady,
                  accent: scheme.tertiary,
                ),
            ],
          ),
          if (model.available && model.reading.pageCount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.pdfBookLastPage(
                pdfBookNumber(context, model.reading.lastPage),
              ),
              style: text.bodyMedium.copyWith(
                fontWeight: AppTheme.weightSemiBold,
              ),
            ),
          ],
          if (model.issue != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              pdfBookIssueMessage(context, model.issue!),
              style: text.bodySmall.copyWith(color: scheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (model.loading)
            const LinearProgressIndicator()
          else if (model.downloading)
            PdfBookDownloadProgress(
              progress: model.progress,
              onCancel: model.cancelDownload,
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: model.available
                    ? () => _openReader(context, model)
                    : () => unawaited(_chooseDownload(context, model)),
                icon: Icon(
                  model.available
                      ? Icons.auto_stories_outlined
                      : Icons.download_rounded,
                ),
                label: Text(
                  model.available
                      ? model.reading.pageCount > 0
                            ? context.l10n.pdfBookContinue
                            : context.l10n.pdfBookOpen
                      : context.l10n.pdfBookDownload,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _chooseDownload(
    BuildContext context,
    PdfBookViewModel model,
  ) async {
    final document = await showPdfBookLanguageSheet(
      context,
      book: book,
      initialDocument:
          model.downloadDocument ??
          model.document ??
          book.forLocale(Localizations.localeOf(context)),
    );
    if (context.mounted && document != null) await model.download(document);
  }

  void _openReader(BuildContext context, PdfBookViewModel model) {
    final filePath = model.filePath;
    if (filePath == null) return;
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PdfBookReaderView(filePath: filePath, library: model),
      ),
    );
  }

  Future<void> _removeDownload(
    BuildContext context,
    PdfBookViewModel model,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.pdfBookRemoveDownload),
        content: Text(context.l10n.pdfBookRemoveDownloadBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.pdfBookCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.pdfBookRemove),
          ),
        ],
      ),
    );
    if (confirmed == true) await model.removeDownload();
  }
}
