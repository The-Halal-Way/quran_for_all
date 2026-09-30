import 'package:flutter/material.dart';

class TasbeehFocusGlow extends StatelessWidget {
  const TasbeehFocusGlow({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 360,
    height: 360,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
    ),
  );
}
