import 'package:flutter/material.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/my_colors.dart';

/// Lightweight, code-drawn background shared by the primary navigation tabs.
///
/// Keeping the ornament vector-based avoids additional image assets while
/// preserving the app's indigo, fuchsia, and teal visual identity.
class AppPremiumPageBackground extends StatelessWidget {
  const AppPremiumPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark ? AppGradients.darkPageBg : AppGradients.pageBg,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -210,
            right: -170,
            child: _AmbientGlow(
              size: 430,
              color: (isDark ? MyColors.primaryLight : MyColors.secondary)
                  .withValues(alpha: isDark ? 0.11 : 0.075),
            ),
          ),
          Positioned(
            left: -180,
            bottom: -230,
            child: _AmbientGlow(
              size: 460,
              color: MyColors.tertiary.withValues(alpha: isDark ? 0.09 : 0.055),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _PagePattern(isDark: isDark)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    ),
  );
}

class _PagePattern extends CustomPainter {
  const _PagePattern({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.secondaryLight : MyColors.primaryLight)
          .withValues(alpha: isDark ? 0.065 : 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _drawRings(canvas, Offset(size.width + 24, 32), paint, [82, 142, 208]);
    _drawRings(canvas, Offset(-32, size.height - 56), paint, [70, 122, 178]);
  }

  void _drawRings(
    Canvas canvas,
    Offset center,
    Paint paint,
    List<double> radii,
  ) {
    for (final radius in radii) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PagePattern oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
