import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class CompassLoadingState extends StatelessWidget {
  const CompassLoadingState({
    super.key,
    required this.isDark,
    required this.title,
    this.message,
    this.isLoading = false,
    this.icon = Icons.explore_off_rounded,
    this.actionLabel,
    this.onRetry,
  });

  final bool isDark;
  final String title;
  final String? message;
  final bool isLoading;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            CircularProgressIndicator(
              color: isDark ? const Color(0xFF4B30A1) : const Color(0xFF1E0A3C),
            )
          else
            Icon(
              icon,
              size: 36,
              color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: text.titleSmall.copyWith(
                color: isDark
                    ? const Color(0xFFB39DDB)
                    : const Color(0xFF4C425C),
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
                  color: isDark
                      ? const Color(0xFFB39DDB).withValues(alpha: 0.86)
                      : const Color(0xFF4C425C).withValues(alpha: 0.86),
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
    );
  }
}
