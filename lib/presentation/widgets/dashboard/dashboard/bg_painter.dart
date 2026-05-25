part of '../../../views/dashboard/dashboard_view.dart';

class BgPainter extends CustomPainter {
  final bool isDark;
  const BgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.primaryLight : MyColors.primary).withOpacity(
        isDark ? 0.03 : 0.025,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const step = 56.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _drawDiamond(canvas, paint, Offset(x, y), 12);
      }
    }
  }

  void _drawDiamond(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BgPainter old) => old.isDark != isDark;
}
