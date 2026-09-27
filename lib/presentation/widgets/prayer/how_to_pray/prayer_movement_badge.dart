import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class PrayerMovementBadge extends StatelessWidget {
  const PrayerMovementBadge({
    super.key,
    required this.label,
    required this.accent,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isWhite = accent == Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isWhite ? 0.13 : 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.prayerStatusChip.copyWith(color: accent),
      ),
    );
  }
}
