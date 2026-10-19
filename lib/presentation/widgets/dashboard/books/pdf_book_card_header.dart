import 'package:flutter/material.dart';

import '../../../../core/constants/pdf_book_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../pdf_books/pdf_book_labels.dart';
import 'dashboard_book_cover.dart';

class PdfBookCardHeader extends StatelessWidget {
  const PdfBookCardHeader({
    super.key,
    required this.book,
    required this.document,
    required this.accent,
    required this.available,
    required this.onRemove,
    required this.onChangeLanguage,
    this.description,
  });

  final PdfBookDefinition book;
  final PdfBookDocument document;
  final Color accent;
  final bool available;
  final VoidCallback onRemove;
  final VoidCallback onChangeLanguage;
  final String? description;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DashboardBookCover(
        imagePath: document.previewImage,
        accent: accent,
        width: 64,
        height: 96,
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.title ?? pdfBookTitle(context, book),
              style: AppTheme.text(
                context,
              ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
            ),
            if (document.author case final author?) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.pdfBookAuthor(author),
                style: AppTheme.text(context).bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if ((description ?? pdfBookDescription(context, book))
                .isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description ?? pdfBookDescription(context, book),
                style: AppTheme.text(context).bodySmall,
              ),
            ],
          ],
        ),
      ),
      if (available)
        PopupMenuButton<String>(
          onSelected: (value) =>
              value == 'remove' ? onRemove() : onChangeLanguage(),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'language',
              child: Text(context.l10n.pdfBookChooseLanguage),
            ),
            PopupMenuItem(
              value: 'remove',
              child: Text(context.l10n.pdfBookRemoveDownload),
            ),
          ],
        ),
    ],
  );
}
