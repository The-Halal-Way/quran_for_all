import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';

class SplashStatusPanel extends StatelessWidget {
  const SplashStatusPanel({
    super.key,
    required this.isLoading,
    required this.status,
    required this.hasQuranData,
  });

  final bool isLoading;
  final String status;
  final bool hasQuranData;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final message = _localizedStatus(context, status);
    const accent = MyColors.tertiaryLight;

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
                  key: ValueKey(isLoading),
                  isLoading: isLoading,
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
                    message,
                    key: ValueKey(message),
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
          const SizedBox(height: AppSpacing.lg),
          if (isLoading)
            _LuminousProgress(accent: accent)
          else
            Row(
              children: [
                Icon(Icons.offline_bolt_rounded, size: 16, color: accent),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    hasQuranData
                        ? context.l10n.splashOfflineReady
                        : context.l10n.quranDownloadOtherSectionsReady,
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
      _ => context.l10n.quranDownloadInProgressTitle,
    };
  }
}

class _StatusMark extends StatelessWidget {
  const _StatusMark({super.key, required this.isLoading, required this.accent});

  final bool isLoading;
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
        : Icon(Icons.check_rounded, color: accent, size: 23),
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
