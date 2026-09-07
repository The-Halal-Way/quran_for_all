import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AppDestinationArtwork extends StatelessWidget {
  const AppDestinationArtwork({
    super.key,
    required this.icon,
    required this.accent,
    this.label,
  });

  final IconData icon;
  final String? label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: 86,
        height: 86,
        child: CustomPaint(
          painter: _OrbitPainter(accent),
          child: Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.13),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.32)),
              ),
              child: label == null
                  ? Icon(icon, color: accent, size: 25)
                  : Center(
                      child: Text(
                        label!,
                        textDirection: TextDirection.rtl,
                        style: AppTheme.text(context).titleMedium.copyWith(
                          color: accent,
                          fontWeight: AppTheme.weightBold,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, 39, paint);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.72);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 78, height: 45),
      paint,
    );
    canvas.restore();
    canvas.drawCircle(
      Offset(center.dx + 27, center.dy - 27),
      3,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
