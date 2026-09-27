import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

class PrayerMovementFramePainter extends CustomPainter {
  const PrayerMovementFramePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    final accentPaint = Paint()
      ..color = accent.withValues(alpha: 0.20)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 4; i++) {
      final top = size.height * (0.18 + i * 0.17);
      canvas.drawLine(
        Offset(size.width * 0.08, top),
        Offset(size.width * 0.92, top + 28),
        paint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.10,
          size.height * 0.13,
          size.width * 0.76,
          size.height * 0.68,
        ),
        const Radius.circular(AppRadius.lg),
      ),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PrayerMovementFramePainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
