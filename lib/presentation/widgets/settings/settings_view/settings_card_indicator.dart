import 'package:flutter/material.dart';

class SettingsCardIndicator extends StatelessWidget {
  const SettingsCardIndicator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: IconTheme(
        data: IconThemeData(color: scheme.onSurfaceVariant, size: 21),
        child: child,
      ),
    );
  }
}
