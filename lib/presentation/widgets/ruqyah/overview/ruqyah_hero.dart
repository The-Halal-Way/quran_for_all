import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../shared/ruqyah_style.dart';

class RuqyahHero extends StatelessWidget {
  const RuqyahHero({super.key});
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [RuqyahStyle.deep, Color(0xFF177A70), Color(0xFF3F497F)],
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _RuqyahPattern())),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.spa_outlined,
                  color: Color(0xFFB7F3DF),
                  size: 28,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.ruqyahHeroTitle,
                  style: AppTheme.text(context).titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.ruqyahHeroBody,
                  style: AppTheme.text(context).bodyMedium.copyWith(
                    color: const Color(0xFFDEF5EE),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _RuqyahPattern extends CustomPainter {
  const _RuqyahPattern();
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 10, 24);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final r in [55.0, 80.0, 105.0]) {
      canvas.drawCircle(center, r, paint);
    }
    for (var n = 0; n < 12; n++) {
      final angle = n * math.pi / 6;
      canvas.drawCircle(
        center + Offset(math.cos(angle) * 80, math.sin(angle) * 80),
        28,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RuqyahPattern oldDelegate) => false;
}
