import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YShapePainter extends CustomPainter {
  final Color backgroundColor;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final double bumpWidth;
  final double bumpHeight;

  YShapePainter({
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black12,
    this.shadowBlurRadius = 8.0,
    this.shadowOffset = const Offset(0, 2),
    this.bumpWidth = 100,
    this.bumpHeight = 28,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);

    final double r = 20.0.r;
    final double bw = bumpWidth;
    final double bh = bumpHeight;
    final double br = 14.0.r; // bump corner radius
    final double cx = size.width / 2;

    final path = Path();

    // Start at top-left corner
    path.moveTo(r, 0);
    path.lineTo(size.width - r, 0);
    path.arcToPoint(
      Offset(size.width, r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Right side down to bottom-right
    path.lineTo(size.width, size.height - r);
    path.arcToPoint(
      Offset(size.width - r, size.height),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Bottom edge → right side of bump
    path.lineTo(cx + bw / 2 + br, size.height);

    // Curve into bump (right side)
    path.arcToPoint(
      Offset(cx + bw / 2, size.height + br),
      radius: Radius.circular(br),
      clockwise: false,
    );

    // Bump bottom-right → bottom-left
    path.lineTo(cx + bw / 2, size.height + bh - br);
    path.arcToPoint(
      Offset(cx + bw / 2 - br, size.height + bh),
      radius: Radius.circular(br),
      clockwise: true,
    );
    path.lineTo(cx - bw / 2 + br, size.height + bh);
    path.arcToPoint(
      Offset(cx - bw / 2, size.height + bh - br),
      radius: Radius.circular(br),
      clockwise: true,
    );

    // Bump left side up
    path.lineTo(cx - bw / 2, size.height + br);
    path.arcToPoint(
      Offset(cx - bw / 2 - br, size.height),
      radius: Radius.circular(br),
      clockwise: false,
    );

    // Bottom edge → bottom-left corner
    path.lineTo(r, size.height);
    path.arcToPoint(
      Offset(0, size.height - r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Left side up to top-left
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: true);

    path.close();

    // Draw shadow
    canvas.save();
    canvas.translate(shadowOffset.dx, shadowOffset.dy);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw the main shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// U-Shape Painter: A rounded rectangle with a **notch/cutout**
/// in the **top-center** (for the Supplements card).
/// The notch dips inward so the Day Streak bump can nest into it.
///
/// The notch width & depth are configurable.
class UShapePainter extends CustomPainter {
  final Color backgroundColor;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final double bumpWidth;
  final double bumpHeight;

  UShapePainter({
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black12,
    this.shadowBlurRadius = 8.0,
    this.shadowOffset = const Offset(0, 2),
    this.bumpWidth = 120,
    this.bumpHeight = 28,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);

    final double r = 20.0.r; // outer corner radius
    final double nw = bumpWidth; // notch width
    final double nh = bumpHeight; // notch depth (goes downward into card)
    final double nr = 14.0.r; // notch corner radius
    final double cx = size.width / 2;

    final path = Path();

    // Start at top-left corner
    path.moveTo(r, 0);

    // Top edge → left side of notch
    path.lineTo(cx - nw / 2 - nr, 0);

    // Curve down into notch (left side) — clockwise to go inward
    path.arcToPoint(
      Offset(cx - nw / 2, nr),
      radius: Radius.circular(nr),
      clockwise: true,
    );

    // Notch left side down to bottom of notch
    path.lineTo(cx - nw / 2, nh - nr);

    // Notch bottom-left corner
    path.arcToPoint(
      Offset(cx - nw / 2 + nr, nh),
      radius: Radius.circular(nr),
      clockwise: false,
    );

    // Notch bottom edge
    path.lineTo(cx + nw / 2 - nr, nh);

    // Notch bottom-right corner
    path.arcToPoint(
      Offset(cx + nw / 2, nh - nr),
      radius: Radius.circular(nr),
      clockwise: false,
    );

    // Notch right side up
    path.lineTo(cx + nw / 2, nr);

    // Curve back to top edge (right side of notch) — clockwise to come back out
    path.arcToPoint(
      Offset(cx + nw / 2 + nr, 0),
      radius: Radius.circular(nr),
      clockwise: true,
    );

    // Top edge → top-right corner
    path.lineTo(size.width - r, 0);
    path.arcToPoint(
      Offset(size.width, r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Right side down
    path.lineTo(size.width, size.height - r);
    path.arcToPoint(
      Offset(size.width - r, size.height),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Bottom edge
    path.lineTo(r, size.height);
    path.arcToPoint(
      Offset(0, size.height - r),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Left side up
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: true);

    path.close();

    // Draw shadow
    canvas.save();
    canvas.translate(shadowOffset.dx, shadowOffset.dy);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw the main shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}