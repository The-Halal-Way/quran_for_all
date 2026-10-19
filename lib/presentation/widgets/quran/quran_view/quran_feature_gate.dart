import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/splash_viewmodel.dart';

class QuranFeatureGate extends StatelessWidget {
  const QuranFeatureGate({super.key, required this.model, required this.child});

  final SplashViewModel? model;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final setup = model;
    if (setup == null || setup.hasQuranData) {
      return child;
    }

    final colors = Theme.of(context).colorScheme;
    final downloading = setup.isDownloading;
    return Stack(
      children: [
        IgnorePointer(child: Opacity(opacity: 0.12, child: child)),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: MyColors.tertiary.withValues(alpha: 0.32),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.09),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.tertiary.withValues(alpha: 0.12),
                        border: Border.all(
                          color: MyColors.tertiary.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Icon(
                        downloading
                            ? Icons.downloading_rounded
                            : Icons.lock_outline_rounded,
                        color: MyColors.tertiary,
                        size: 29,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      downloading
                          ? context.l10n.quranDownloadInProgressTitle
                          : context.l10n.quranDownloadGateTitle,
                      textAlign: TextAlign.center,
                      style: AppTheme.text(context).titleLarge.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      downloading
                          ? context.l10n.quranDownloadInProgressBody
                          : context.l10n.quranDownloadGateBody,
                      textAlign: TextAlign.center,
                      style: AppTheme.text(context).bodyMedium.copyWith(
                        height: 1.5,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (downloading || setup.isLoading)
                      const SizedBox(
                        width: double.infinity,
                        child: LinearProgressIndicator(),
                      )
                    else
                      FilledButton.icon(
                        onPressed: () => unawaited(setup.retryDownload()),
                        icon: const Icon(Icons.cloud_download_rounded),
                        label: Text(context.l10n.quranDownloadGateButton),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
