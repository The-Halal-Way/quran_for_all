import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/science_in_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/science_in_quran_viewmodel.dart';
import '../../../views/dashboard/science_in_quran/science_in_quran_reader_view.dart';
import '../../science_in_quran/science_in_quran_download_progress.dart';
import '../../science_in_quran/science_in_quran_labels.dart';
import '../../science_in_quran/science_in_quran_language_sheet.dart';

class DashboardScienceInQuranCard extends StatelessWidget {
  const DashboardScienceInQuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ScienceInQuranViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;
    final text = AppTheme.text(context);
    final document = model.downloading
        ? model.downloadDocument
        : model.document;
    final recommended = ScienceInQuranDocument.forLocale(
      Localizations.localeOf(context),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surface,
            Color.alphaBlend(
              colors.cyan.withValues(alpha: 0.09),
              scheme.surface,
            ),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.cyan.withValues(alpha: 0.28)),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookIcon(color: colors.cyan),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.scienceInQuranTitle,
                      style: text.titleMedium.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.scienceInQuranDescription,
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              if (model.available && !model.downloading && !model.loading)
                PopupMenuButton<String>(
                  tooltip: context.l10n.scienceInQuranRemoveDownload,
                  onSelected: (_) => unawaited(_removeDownload(context, model)),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text(context.l10n.scienceInQuranRemoveDownload),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              if (document != null) ...[
                _MetaChip(
                  icon: Icons.translate_rounded,
                  label: scienceLanguageLabel(context, document.language),
                ),
                _MetaChip(
                  icon: Icons.picture_as_pdf_rounded,
                  label: scienceFileSize(context, document),
                ),
              ] else
                _MetaChip(
                  icon: Icons.auto_awesome_rounded,
                  label: scienceLanguageLabel(context, recommended.language),
                ),
              if (model.available)
                _MetaChip(
                  icon: Icons.cloud_done_rounded,
                  label: context.l10n.scienceInQuranOfflineReady,
                  accent: scheme.tertiary,
                ),
            ],
          ),
          if (model.available && model.reading.pageCount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.scienceInQuranLastPage(
                scienceNumber(context, model.reading.lastPage),
              ),
              style: text.bodyMedium.copyWith(
                fontWeight: AppTheme.weightSemiBold,
              ),
            ),
          ],
          if (model.issue != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              scienceIssueMessage(context, model.issue!),
              style: text.bodySmall.copyWith(color: scheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (model.loading)
            const LinearProgressIndicator()
          else if (model.downloading)
            ScienceInQuranDownloadProgress(
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
                            ? context.l10n.scienceInQuranContinue
                            : context.l10n.scienceInQuranOpen
                      : context.l10n.scienceInQuranDownload,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _chooseDownload(
    BuildContext context,
    ScienceInQuranViewModel model,
  ) async {
    final document = await showScienceInQuranLanguageSheet(
      context,
      initialDocument:
          model.downloadDocument ??
          model.document ??
          ScienceInQuranDocument.forLocale(Localizations.localeOf(context)),
    );
    if (context.mounted && document != null) await model.download(document);
  }

  void _openReader(BuildContext context, ScienceInQuranViewModel model) {
    final filePath = model.filePath;
    if (filePath == null) return;
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ScienceInQuranReaderView(filePath: filePath),
      ),
    );
  }

  Future<void> _removeDownload(
    BuildContext context,
    ScienceInQuranViewModel model,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.scienceInQuranRemoveDownload),
        content: Text(context.l10n.scienceInQuranRemoveDownloadBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.scienceInQuranCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.scienceInQuranRemove),
          ),
        ],
      ),
    );
    if (confirmed == true) await model.removeDownload();
  }
}

class _BookIcon extends StatelessWidget {
  const _BookIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 54,
    height: 62,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color, Color.lerp(color, MyColors.primary, 0.35)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.base),
      boxShadow: [
        BoxShadow(color: color.withValues(alpha: 0.24), blurRadius: 12),
      ],
    ),
    child: const Icon(Icons.science_rounded, color: Colors.white, size: 30),
  );
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.accent});
  final IconData icon;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTheme.text(context).labelSmall),
          ],
        ),
      ),
    );
  }
}
