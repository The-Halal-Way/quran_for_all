import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

class HadithReaderNavigationButton extends StatelessWidget {
  const HadithReaderNavigationButton({
    super.key,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.accent,
    required this.onTap,
    this.iconAfter = false,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final Color accent;
  final VoidCallback? onTap;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? accent
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24);
    final children = [
      Icon(icon, size: 15, color: color),
      const SizedBox(width: 5),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.text(
            context,
          ).labelSmall.copyWith(color: color, fontWeight: AppTheme.weightBold),
        ),
      ),
    ];

    return SizedBox(
      width: 88,
      child: TextButton(
        onPressed: enabled ? onTap : null,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconAfter ? children.reversed.toList() : children,
        ),
      ),
    );
  }
}
