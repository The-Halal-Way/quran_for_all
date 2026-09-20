import 'package:flutter/material.dart';

import '../../../core/theme/my_colors.dart';
import '../../../core/theme/my_images.dart';

class SplashBackdrop extends StatelessWidget {
  const SplashBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryDark,
                  MyColors.primary,
                  MyColors.tertiaryDark,
                ],
                stops: [0, 0.54, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.82,
              child: Image.asset(
                MyImages.background1,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xE8090F20),
                    Color(0xB818223D),
                    Color(0xE0090F20),
                  ],
                  stops: [0, 0.48, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          const Positioned(
            top: -180,
            right: -160,
            child: _GlowOrb(
              size: 430,
              colors: [Color(0x66E5C46F), Color(0x00E5C46F)],
            ),
          ),
          const Positioned(
            left: -210,
            bottom: -190,
            child: _GlowOrb(
              size: 500,
              colors: [Color(0x55177A6B), Color(0x00177A6B)],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.05),
                    radius: 0.85,
                    colors: [
                      Colors.transparent,
                      MyColors.primaryDark.withValues(alpha: 0.34),
                    ],
                    stops: const [0.5, 1],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: colors),
    ),
  );
}
