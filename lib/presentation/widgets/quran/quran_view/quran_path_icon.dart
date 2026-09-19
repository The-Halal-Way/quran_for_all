import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/quran/quran_hub_models.dart';

class QuranPathIcon extends StatelessWidget {
  const QuranPathIcon({super.key, required this.action});

  final QuranHubAction action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      alignment: Alignment.center,
      child: Icon(action.icon, color: Colors.white, size: 24),
    );
  }
}
