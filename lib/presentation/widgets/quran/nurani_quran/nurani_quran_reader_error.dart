import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/quran/nurani_quran_viewmodel.dart';
import 'nurani_quran_download_progress.dart';
import 'nurani_quran_labels.dart';

class NuraniQuranReaderError extends StatelessWidget {
  const NuraniQuranReaderError({
    super.key,
    required this.onRetry,
    required this.onDownloadAgain,
  });

  final VoidCallback onRetry;
  final VoidCallback onDownloadAgain;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NuraniQuranViewModel>();
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_rounded, size: 56, color: scheme.primary),
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.l10n.nuraniQuranReaderError,
                textAlign: TextAlign.center,
                style: AppTheme.text(context).titleMedium,
              ),
              if (model.issue != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  nuraniIssueMessage(context, model.issue!),
                  textAlign: TextAlign.center,
                  style: AppTheme.text(
                    context,
                  ).bodySmall.copyWith(color: scheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              if (model.downloading)
                NuraniQuranDownloadProgress(
                  progress: model.progress,
                  onCancel: model.cancelDownload,
                )
              else ...[
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.nuraniQuranRetry),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: onDownloadAgain,
                  icon: const Icon(Icons.download_rounded),
                  label: Text(context.l10n.nuraniQuranDownloadAgain),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
