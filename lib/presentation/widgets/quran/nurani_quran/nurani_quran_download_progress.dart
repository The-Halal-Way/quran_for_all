import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'nurani_quran_labels.dart';

class NuraniQuranDownloadProgress extends StatelessWidget {
  const NuraniQuranDownloadProgress({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  final double progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.nuraniQuranDownloading(
      nuraniNumber(context, (progress * 100).floor()),
    );
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
              child: Text(label, style: AppTheme.text(context).bodySmall),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(context.l10n.nuraniQuranCancel),
            ),
          ],
        ),
      ],
    );
  }
}
