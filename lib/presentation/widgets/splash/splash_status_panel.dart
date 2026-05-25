import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class SplashStatusPanel extends StatelessWidget {
  const SplashStatusPanel({
    super.key,
    required this.isLoading,
    required this.status,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool isLoading;
  final String status;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final message = errorMessage ?? status;

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
                errorMessage == null
                    ? Icons.hourglass_bottom_rounded
                    : Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTheme.text(context).bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.96),
                  ),
                ),
              ),
            ],
          ),
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
              label: const Text('Retry setup'),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, color: colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Ready',
                  style: AppTheme.text(
                    context,
                  ).labelLarge.copyWith(color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
