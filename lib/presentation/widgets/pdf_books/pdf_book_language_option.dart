import 'package:flutter/material.dart';

import '../../../core/constants/pdf_book_document.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../dashboard/books/dashboard_book_cover.dart';
import 'pdf_book_labels.dart';

class PdfBookLanguageOption extends StatelessWidget {
  const PdfBookLanguageOption({
    super.key,
    required this.coverImage,
    required this.document,
    required this.selected,
    required this.onTap,
  });

  final String coverImage;
  final PdfBookDocument document;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = document.language == PdfBookLanguage.bangla
        ? scheme.tertiary
        : scheme.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: pdfBookLanguageLabel(context, document.language),
      child: Material(
        color: selected
            ? accent.withValues(alpha: 0.11)
            : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: selected ? accent : scheme.outlineVariant,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                DashboardBookCover(
                  imagePath: coverImage,
                  accent: accent,
                  width: 64,
                  height: 94,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pdfBookLanguageLabel(context, document.language),
                        style: AppTheme.text(context).titleMedium.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (document.title case final title?) ...[
                        Text(
                          title,
                          style: AppTheme.text(context).titleSmall.copyWith(
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                      if (document.author case final author?) ...[
                        Text(
                          context.l10n.pdfBookAuthor(author),
                          style: AppTheme.text(context).bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                      Text(
                        pdfBookFileSize(context, document),
                        style: AppTheme.text(context).bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        context.l10n.pdfBookOfflineReady,
                        style: AppTheme.text(
                          context,
                        ).labelSmall.copyWith(color: accent),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: selected ? accent : scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
