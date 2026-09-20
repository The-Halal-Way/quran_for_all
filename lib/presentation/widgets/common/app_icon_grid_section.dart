import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class AppIconGridItem {
  const AppIconGridItem({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
    this.description,
  });

  final IconData icon;
  final String label;
  final String? description;
  final Color accent;
  final VoidCallback onTap;
}

class AppIconGridSection extends StatelessWidget {
  const AppIconGridSection({
    super.key,
    required this.title,
    required this.items,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final List<AppIconGridItem> items;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTheme.text(context).titleMedium.copyWith(
                  fontWeight: AppTheme.weightExtraBold,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (actionLabel != null && onActionTap != null)
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                onPressed: onActionTap,
                child: Text(
                  actionLabel!,
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: AppTheme.weightSemiBold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final maxColumns = scale > 1.5
                ? 2
                : constraints.maxWidth >= 900
                ? 8
                : constraints.maxWidth >= 600
                ? 6
                : 4;
            final columns = items.length < maxColumns
                ? items.length
                : maxColumns;
            final spacing = columns >= 4 ? AppSpacing.md : AppSpacing.lg;
            final itemWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing,
              runSpacing: AppSpacing.lg,
              children: [
                for (final item in items)
                  SizedBox(
                    width: itemWidth,
                    child: _AppIconGridTile(item: item),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AppIconGridTile extends StatelessWidget {
  const _AppIconGridTile({required this.item});

  final AppIconGridItem item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final accent = isDark
        ? Color.lerp(item.accent, Colors.white, 0.42)!
        : item.accent;

    return Semantics(
      button: true,
      onTap: item.onTap,
      excludeSemantics: true,
      label: '${item.label}. ${item.description ?? ''}',
      child: Tooltip(
        message: item.label,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: item.onTap,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final surfaceSize = (constraints.maxWidth - AppSpacing.xs).clamp(
                56.0,
                72.0,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: surfaceSize,
                    height: surfaceSize,
                    decoration: BoxDecoration(
                      color: isDark
                          ? colors.surfaceContainerHighest
                          : colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(
                          alpha: isDark ? 0.34 : 0.28,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(
                            alpha: isDark ? 0.20 : 0.08,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: accent,
                      size: surfaceSize * 0.43,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.label,
                    maxLines: scale > 1.4 ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTheme.text(context).bodySmall.copyWith(
                      color: colors.onSurface,
                      fontWeight: AppTheme.weightSemiBold,
                      height: 1.25,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
