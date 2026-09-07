import 'package:flutter/material.dart';

class SunnahDuaHeroBackButton extends StatelessWidget {
  const SunnahDuaHeroBackButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    style: IconButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.12),
      foregroundColor: Colors.white,
    ),
    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
  );
}
