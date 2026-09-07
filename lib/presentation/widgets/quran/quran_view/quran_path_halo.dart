import 'package:flutter/material.dart';

class QuranPathHalo extends StatelessWidget {
  const QuranPathHalo({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.2), Colors.transparent],
          stops: const [0, 0.72],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
    );
  }
}
