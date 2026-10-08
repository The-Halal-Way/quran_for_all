import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class IslamicDaysEmptyState extends StatelessWidget {
  const IslamicDaysEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.nightlight_round,
  });
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: .1),
            ),
            child: Icon(icon, color: scheme.primary, size: 32),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.text(context).titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.text(
              context,
            ).bodyMedium.copyWith(color: scheme.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}
