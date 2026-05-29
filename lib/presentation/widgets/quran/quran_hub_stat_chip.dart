import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/quran/quran_hub_models.dart';

class QuranHubStatChip extends StatelessWidget {
  const QuranHubStatChip({super.key, required this.stat});

  final QuranHubStat stat;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(stat.icon, size: 16, color: stat.color),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              Text(
                stat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
