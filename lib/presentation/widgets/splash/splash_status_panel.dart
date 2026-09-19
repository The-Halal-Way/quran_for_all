import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';
import '../../viewmodels/splash_viewmodel.dart';

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
    final hasError = errorMessage != null;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final message = hasError
        ? _errorBody(context)
        : _localizedStatus(context, status);
    final accent = hasError ? MyColors.secondaryLight : MyColors.tertiaryLight;

    return AnimatedContainer(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.17),
            Colors.white.withValues(alpha: 0.075),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 220),
                child: _StatusMark(
                  key: ValueKey((hasError, isLoading)),
                  isLoading: isLoading,
                  hasError: hasError,
                  accent: accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 220),
                  child: Text(
                    hasError ? _errorTitle(context) : message,
                    key: ValueKey(hasError ? 'error' : message),
                    style: AppTheme.text(context).titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTheme.text(context).bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.splashSetupFailedTip,
              style: AppTheme.text(context).bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.68),
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (isLoading)
            _LuminousProgress(accent: accent)
          else if (hasError)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF251054),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                icon: const Icon(CupertinoIcons.refresh),
                label: Text(context.l10n.splashRetrySetup),
              ),
            )
          else
            Row(
              children: [
                Icon(Icons.offline_bolt_rounded, size: 16, color: accent),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.splashOfflineReady,
                    style: AppTheme.text(context).labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ),
              ],
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

class _StatusMark extends StatelessWidget {
  const _StatusMark({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.accent,
  });

  final bool isLoading;
  final bool hasError;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: accent.withValues(alpha: 0.12),
      border: Border.all(color: accent.withValues(alpha: 0.28)),
    ),
    alignment: Alignment.center,
    child: isLoading
        ? SizedBox.square(
            dimension: 21,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: accent,
              backgroundColor: Colors.white.withValues(alpha: 0.13),
            ),
          )
        : Icon(
            hasError ? Icons.wifi_off_rounded : Icons.check_rounded,
            color: accent,
            size: 23,
          ),
  );
}

class _LuminousProgress extends StatelessWidget {
  const _LuminousProgress({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppRadius.full),
    child: SizedBox(
      height: 5,
      child: LinearProgressIndicator(
        color: accent,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
      ),
    ),
  );
}
