import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_shadows.dart';

class ZakatSection extends StatelessWidget {
  const ZakatSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.subtitle,
    this.accent,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final highlight = accent ?? scheme.secondary;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: AppShadows.card(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: highlight.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: highlight.withValues(alpha: 0.19),
                    ),
                  ),
                  child: Icon(icon, color: highlight, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.text(context).titleMedium.copyWith(
                      fontWeight: AppTheme.weightExtraBold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                subtitle!,
                style: AppTheme.text(context).bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: highlight,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                Expanded(child: Divider(color: scheme.outlineVariant)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            child,
          ],
        ),
      ),
    );
  }
}
