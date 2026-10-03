import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';
import '../../viewmodels/splash_viewmodel.dart';

class QuranDownloadPanel extends StatelessWidget {
  const QuranDownloadPanel({
    super.key,
    required this.model,
    this.compact = false,
  });

  final SplashViewModel model;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final downloading = model.isDownloading;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                downloading
                    ? Icons.downloading_rounded
                    : Icons.cloud_download_outlined,
                color: MyColors.tertiary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  downloading
                      ? context.l10n.quranDownloadInProgressTitle
                      : context.l10n.quranDownloadTitle,
                  style: AppTheme.text(context).titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            downloading
                ? context.l10n.quranDownloadInProgressBody
                : context.l10n.quranDownloadBody,
            style: AppTheme.text(context).bodyMedium,
          ),
          if (downloading) ...[
            const SizedBox(height: AppSpacing.md),
            const LinearProgressIndicator(),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () => unawaited(model.retryDownload()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.quranDownloadRetry),
            ),
          ],
          if (!compact) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.quranDownloadOtherSectionsReady,
              style: AppTheme.text(context).bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
