import 'package:flutter/material.dart';

class DailyTrackerCheckmark extends StatelessWidget {
  const DailyTrackerCheckmark({
    super.key,
    required this.checked,
    required this.accent,
  });
  final bool checked;
  final Color accent;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 160),
    width: 25,
    height: 25,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: checked ? accent : Colors.transparent,
      border: Border.all(
        color: checked
            ? accent
            : Theme.of(context).colorScheme.onSurfaceVariant,
        width: 1.5,
      ),
    ),
    child: checked
        ? Icon(
            Icons.check_rounded,
            size: 17,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black87
                : Colors.white,
          )
        : null,
  );
}
