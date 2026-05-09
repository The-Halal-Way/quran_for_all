import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// A small pill/tag used for metadata display throughout the app.
///
/// Consolidates the duplicated `_InfoChip`, `_TagPill`, `_MetaChip`,
/// `_InfoPill`, `_Tag`, and `_DataBadge` patterns into one reusable widget.
class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.onLight = true,
  });

  /// Pill on a light surface (default). Text/icon inherit [color] or primary.
  const AppPill.surface({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.borderColor,
  }) : onLight = true;

  /// Pill on a dark/gradient surface. Text/icon are white.
  const AppPill.overlay({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.borderColor,
  }) : onLight = false;

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final Color fg;
    final Color bg;
    final Color? border;

    if (onLight) {
      fg = color ?? AppColors.primary;
      bg = backgroundColor ?? fg.withValues(alpha: 0.10);
      border = borderColor;
    } else {
      fg = color ?? Colors.white;
      bg = backgroundColor ?? Colors.white.withValues(alpha: 0.16);
      border = borderColor ?? Colors.white.withValues(alpha: 0.22);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.xxxl),
        border: border != null ? Border.all(color: border) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
