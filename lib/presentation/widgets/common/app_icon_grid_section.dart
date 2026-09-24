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
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
    this.phoneColumns = 4,
    this.labelMaxLines = 2,
  });

  final String title;
  final List<AppIconGridItem> items;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final int phoneColumns;
  final int labelMaxLines;

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
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle!, style: AppTheme.text(context).bodySmall),
        ],
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
                : phoneColumns;
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
                    child: _AppIconGridTile(
                      item: item,
                      labelMaxLines: labelMaxLines,
                    ),
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
  const _AppIconGridTile({required this.item, required this.labelMaxLines});

  final AppIconGridItem item;
  final int labelMaxLines;

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
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(
                            isDark
                                ? colors.surfaceContainerHighest
                                : colors.surface,
                            accent,
                            isDark ? 0.16 : 0.09,
                          )!,
                          isDark ? colors.surfaceContainerLow : colors.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: Color.lerp(
                          colors.outlineVariant,
                          accent,
                          isDark ? 0.34 : 0.24,
                        )!,
                        width: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: surfaceSize * 0.68,
                          height: surfaceSize * 0.68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withValues(
                              alpha: isDark ? 0.13 : 0.075,
                            ),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.14),
                            ),
                          ),
                        ),
                        Icon(
                          item.icon,
                          color: accent,
                          size: surfaceSize * 0.39,
                        ),
                        PositionedDirectional(
                          top: 9,
                          end: 10,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.72),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.label,
                    maxLines: scale > 1.4 ? labelMaxLines + 1 : labelMaxLines,
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
