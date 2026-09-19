import 'package:flutter/material.dart';

class TasbeehBackground extends StatelessWidget {
  const TasbeehBackground({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [scheme.surface, scheme.surfaceContainerLow]
              : [scheme.surface, scheme.surfaceContainerLowest],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
