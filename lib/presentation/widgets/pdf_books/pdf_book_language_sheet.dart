import 'package:flutter/material.dart';

import '../../../core/constants/pdf_book_document.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import 'pdf_book_language_option.dart';

Future<PdfBookDocument?> showPdfBookLanguageSheet(
  BuildContext context, {
  required PdfBookDefinition book,
  PdfBookDocument? initialDocument,
}) => showModalBottomSheet<PdfBookDocument>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) =>
      PdfBookLanguageSheet(book: book, initialDocument: initialDocument),
);

class PdfBookLanguageSheet extends StatefulWidget {
  const PdfBookLanguageSheet({
    super.key,
    required this.book,
    this.initialDocument,
  });

  final PdfBookDefinition book;
  final PdfBookDocument? initialDocument;

  @override
  State<PdfBookLanguageSheet> createState() => _PdfBookLanguageSheetState();
}

class _PdfBookLanguageSheetState extends State<PdfBookLanguageSheet> {
  late PdfBookDocument _selected =
      widget.initialDocument ?? widget.book.documents.first;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      0,
      AppSpacing.xl,
      AppSpacing.xl,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.pdfBookChooseLanguage,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.pdfBookLanguageDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final document in widget.book.documents) ...[
            PdfBookLanguageOption(
              coverImage: widget.book.coverImage,
              document: document,
              selected: document == _selected,
              onTap: () => setState(() => _selected = document),
            ),
            if (document != widget.book.documents.last)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(_selected),
              icon: const Icon(Icons.download_rounded),
              label: Text(context.l10n.pdfBookDownload),
            ),
          ),
        ],
      ),
    ),
  );
}
