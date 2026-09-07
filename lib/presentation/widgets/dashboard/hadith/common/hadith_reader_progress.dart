import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';

class HadithReaderProgress extends StatelessWidget {
  const HadithReaderProgress({
    super.key,
    required this.current,
    required this.total,
    required this.accent,
  });

  final int current;
  final int total;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 3,
          backgroundColor: accent.withValues(alpha: 0.10),
          valueColor: AlwaysStoppedAnimation(accent),
        ),
      ),
    );
  }
}
