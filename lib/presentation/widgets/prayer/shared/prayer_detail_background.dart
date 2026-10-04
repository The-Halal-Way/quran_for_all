import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

/// Gives prayer detail pages a quiet, layered canvas that works in both themes.
class PrayerDetailBackground extends StatelessWidget {
  const PrayerDetailBackground({
    super.key,
    required this.child,
    required this.accent,
  });

  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: isDark ? AppGradients.darkPageBg : AppGradients.pageBg,
          ),
        ),
        IgnorePointer(
          child: _AmbientOrb(
            alignment: const Alignment(1.16, -0.96),
            size: 250,
            color: accent,
            opacity: isDark ? 0.16 : 0.10,
          ),
        ),
        IgnorePointer(
          child: _AmbientOrb(
            alignment: const Alignment(-1.18, 0.70),
            size: 220,
            color: isDark ? MyColors.tertiaryLight : MyColors.secondaryLight,
            opacity: isDark ? 0.10 : 0.12,
          ),
        ),
        child,
      ],
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({
    required this.alignment,
    required this.size,
    required this.color,
    required this.opacity,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
