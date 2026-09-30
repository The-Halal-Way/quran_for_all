import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

class CompassLoadingState extends StatelessWidget {
  const CompassLoadingState({
    super.key,
    required this.title,
    this.message,
    this.isLoading = false,
    this.icon = Icons.explore_off_rounded,
    this.actionLabel,
    this.onRetry,
  });

  final String title;
  final String? message;
  final bool isLoading;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.xl),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              CircularProgressIndicator(color: scheme.primary)
            else
              Icon(icon, size: 36, color: scheme.primary),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: text.titleSmall.copyWith(
                  color: scheme.onSurface,
                  fontWeight: AppTheme.weightBold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  message!,
                  style: text.bodyMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (onRetry != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
