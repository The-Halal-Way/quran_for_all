import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class IslamicDayBadge extends StatelessWidget {
  const IslamicDayBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onDark = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool onDark;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: color.withValues(alpha: onDark ? .15 : .09),
      border: Border.all(color: color.withValues(alpha: .19)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: AppTheme.text(
              context,
            ).labelSmall.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
