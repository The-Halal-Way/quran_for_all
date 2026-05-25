import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class CompassLoadingState extends StatelessWidget {
  const CompassLoadingState({
    super.key,
    required this.isDark,
    required this.error,
    required this.onRetry,
  });

  final bool isDark;
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (error.isEmpty)
            CircularProgressIndicator(
              color: isDark ? const Color(0xFF4B30A1) : const Color(0xFF1E0A3C),
            )
          else
            Icon(
              Icons.explore_off_rounded,
              size: 36,
              color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              error.isEmpty ? 'Initializing compass…' : error,
              style: text.bodyMedium.copyWith(
                color: isDark
                    ? const Color(0xFFB39DDB)
                    : const Color(0xFF4C425C),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (error.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
