import 'package:flutter/material.dart';

import '../tasbeeh/tasbeeh_ornament.dart';
import '../tasbeeh/tasbeeh_visuals.dart';
import 'tasbeeh_focus_glow.dart';

class TasbeehFocusBackdrop extends StatelessWidget {
  const TasbeehFocusBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = TasbeehVisuals.heroColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: -140,
            top: -140,
            child: TasbeehFocusGlow(
              color: TasbeehVisuals.rose.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            right: -160,
            bottom: -160,
            child: TasbeehFocusGlow(
              color: TasbeehVisuals.mint.withValues(alpha: 0.12),
            ),
          ),
          const TasbeehOrnament(opacity: 0.16),
        ],
      ),
    );
  }
}
