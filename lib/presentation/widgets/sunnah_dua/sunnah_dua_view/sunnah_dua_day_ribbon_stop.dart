import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SunnahDuaDayRibbonStop extends StatelessWidget {
  const SunnahDuaDayRibbonStop({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 19),
      const SizedBox(height: 6),
      Text(
        label,
        textAlign: TextAlign.center,
        style: AppTheme.text(context).labelSmall.copyWith(
          color: Colors.white,
          fontWeight: AppTheme.weightBold,
        ),
      ),
    ],
  );
}
