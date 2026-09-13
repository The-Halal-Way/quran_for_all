import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class DailyTrackerHeroArtwork extends StatelessWidget {
  const DailyTrackerHeroArtwork({super.key});
  @override
  Widget build(BuildContext context) =>
      const ExcludeSemantics(child: CustomPaint(painter: _HaloPainter()));
}

class _HaloPainter extends CustomPainter {
  const _HaloPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyColors.tertiaryLight.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final center = Offset(size.width - 15, size.height * 0.3);
    for (final radius in [70.0, 95.0, 120.0]) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_HaloPainter oldDelegate) => false;
}
