import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import 'pdf_book_labels.dart';

class PdfBookDownloadProgress extends StatelessWidget {
  const PdfBookDownloadProgress({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  final double? progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(value: progress, minHeight: 6),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text(
                progress == null
                    ? context.l10n.pdfBookDownloadingUnknown
                    : context.l10n.pdfBookDownloading(
                        pdfBookNumber(context, (progress! * 100).floor()),
                      ),
                style: AppTheme.text(context).bodySmall,
              ),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(context.l10n.pdfBookCancel),
            ),
          ],
        ),
      ],
    );
  }
}
