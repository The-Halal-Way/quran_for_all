import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/quran/nurani_quran_viewmodel.dart';
import '../../../views/quran/nurani_quran/nurani_quran_reader_view.dart';
import 'nurani_quran_download_progress.dart';
import 'nurani_quran_labels.dart';

class NuraniQuranLibraryCard extends StatelessWidget {
  const NuraniQuranLibraryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NuraniQuranViewModel>();
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.surface,
            Color.alphaBlend(
              colors.tertiary.withValues(alpha: 0.08),
              colors.surface,
            ),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.tertiary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 58,
                decoration: BoxDecoration(
                  color: colors.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.base),
                  border: Border.all(
                    color: colors.tertiary.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colors.tertiary,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.nuraniQuranTitle,
                      style: text.titleMedium.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.nuraniQuranDescription, style: text.bodySmall),
                  ],
                ),
              ),
              if (model.available && !model.downloading)
                PopupMenuButton<String>(
                  tooltip: l10n.nuraniQuranRemoveDownload,
                  onSelected: (_) => unawaited(_removeDownload(context, model)),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text(l10n.nuraniQuranRemoveDownload),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.nuraniQuranFileSize, style: text.labelSmall),
              if (model.available)
                Text(
                  l10n.nuraniQuranOffline,
                  style: text.labelSmall.copyWith(color: colors.tertiary),
                ),
              if (model.reading.bookmarks.isNotEmpty)
                Text(
                  l10n.nuraniQuranBookmarkCount(
                    nuraniNumber(context, model.reading.bookmarks.length),
                  ),
                  style: text.labelSmall,
                ),
            ],
          ),
          if (model.available && model.reading.pageCount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.nuraniQuranLastPage(
                nuraniNumber(context, model.reading.lastPage),
              ),
              style: text.bodyMedium.copyWith(
                fontWeight: AppTheme.weightSemiBold,
              ),
            ),
          ],
          if (model.issue != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              nuraniIssueMessage(context, model.issue!),
              style: text.bodySmall.copyWith(color: colors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (model.loading)
            const LinearProgressIndicator()
          else if (model.downloading)
            NuraniQuranDownloadProgress(
              progress: model.progress,
              onCancel: model.cancelDownload,
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: model.available
                    ? () => _openReader(context, model)
                    : () => unawaited(model.download()),
                icon: Icon(
                  model.available
                      ? Icons.auto_stories_outlined
                      : Icons.download_rounded,
                ),
                label: Text(
                  model.available
                      ? model.reading.pageCount > 0
                            ? l10n.nuraniQuranContinue
                            : l10n.nuraniQuranOpen
                      : l10n.nuraniQuranDownload,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openReader(BuildContext context, NuraniQuranViewModel model) {
    final filePath = model.filePath;
    if (filePath == null) return;
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NuraniQuranReaderView(filePath: filePath),
      ),
    );
  }

  Future<void> _removeDownload(
    BuildContext context,
    NuraniQuranViewModel model,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.nuraniQuranRemoveDownload),
        content: Text(context.l10n.nuraniQuranRemoveDownloadBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.nuraniQuranCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.nuraniQuranRemove),
          ),
        ],
      ),
    );
    if (confirmed == true) await model.removeDownload();
  }
}
