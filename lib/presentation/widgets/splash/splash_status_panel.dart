import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/viewmodels/splash_viewmodel.dart';

class SplashStatusPanel extends StatelessWidget {
  const SplashStatusPanel({
    super.key,
    required this.isLoading,
    required this.status,
    required this.errorMessage,
    required this.failureReason,
    required this.onRetry,
  });

  final bool isLoading;
  final String status;
  final String? errorMessage;
  final SplashFailureReason failureReason;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorMessage != null;
    final message = hasError
        ? _errorBody(context)
        : _localizedStatus(context, status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                hasError
                    ? Icons.error_outline_rounded
                    : isLoading
                    ? Icons.hourglass_bottom_rounded
                    : Icons.check_circle_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasError ? _errorTitle(context) : message,
                  style: AppTheme.text(context).titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTheme.text(context).bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.94),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.splashSetupFailedTip,
              style: AppTheme.text(
                context,
              ).bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.82)),
            ),
          ],
          const SizedBox(height: 14),
          if (isLoading)
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: const LinearProgressIndicator(minHeight: 7),
            )
          else if (errorMessage != null)
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorScheme.primary,
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.splashRetrySetup),
            ),
        ],
      ),
    );
  }

  String _localizedStatus(BuildContext context, String rawStatus) {
    return switch (rawStatus) {
      'Preparing local Quran database...' => context.l10n.splashStatusPreparing,
      'Ready' => context.l10n.splashStatusReady,
      'Ready with saved Quran data. Some newer content may sync later.' =>
        context.l10n.splashStatusOfflineFallback,
      _ => rawStatus,
    };
  }

  String _errorTitle(BuildContext context) {
    return switch (failureReason) {
      SplashFailureReason.firstSetupNeedsNetwork =>
        context.l10n.splashSetupFailedTitle,
      SplashFailureReason.none => context.l10n.splashSetupFailedTitle,
    };
  }

  String _errorBody(BuildContext context) {
    return switch (failureReason) {
      SplashFailureReason.firstSetupNeedsNetwork =>
        context.l10n.splashSetupFailedBody,
      SplashFailureReason.none => context.l10n.splashSetupFailedBody,
    };
  }
}
