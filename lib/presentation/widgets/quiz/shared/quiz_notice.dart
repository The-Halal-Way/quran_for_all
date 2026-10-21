import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class QuizNotice extends StatelessWidget {
  const QuizNotice({
    super.key,
    required this.message,
    this.icon = Icons.lightbulb_outline_rounded,
    this.color,
    this.action,
  });
  final String message;
  final IconData icon;
  final Color? color;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = color ?? scheme.primary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: .18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppTheme.text(context).bodySmall.copyWith(height: 1.5),
                ),
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
