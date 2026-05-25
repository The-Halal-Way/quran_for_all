import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class TasbeehBackground extends StatelessWidget {
  const TasbeehBackground({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final baseColors = isDark
        ? const [MyColors.darkScaffold, Color(0xFF180B3B), Color(0xFF031C1A)]
        : const [Color(0xFFF8F3FF), Color(0xFFFFF1F7), Color(0xFFE8FFF9)];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: baseColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(painter: _TasbeehPatternPainter(isDark)),
    );
  }
}

class _TasbeehPatternPainter extends CustomPainter {
  const _TasbeehPatternPainter(this.isDark);

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = (isDark ? Colors.white : MyColors.primary).withValues(
        alpha: isDark ? 0.055 : 0.045,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const step = 44.0;
    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        final diamond = Path()
          ..moveTo(x + step / 2, y)
          ..lineTo(x + step, y + step / 2)
          ..lineTo(x + step / 2, y + step)
          ..lineTo(x, y + step / 2)
          ..close();
        canvas.drawPath(diamond, linePaint);
      }
    }

    final accentPaint = Paint()
      ..color = MyColors.tertiary.withValues(alpha: isDark ? 0.08 : 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double y = 88; y < size.height; y += 176) {
      final path = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(size.width * 0.32, y - 38, size.width * 0.62, y)
        ..quadraticBezierTo(size.width * 0.82, y + 28, size.width, y - 8);
      canvas.drawPath(path, accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TasbeehPatternPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
