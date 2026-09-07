import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

class HadithReaderLoading extends StatelessWidget {
  const HadithReaderLoading({
    super.key,
    required this.label,
    required this.accent,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              color: accent,
              strokeWidth: 2,
              backgroundColor: accent.withValues(alpha: 0.10),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            label,
            textDirection: TextDirection.rtl,
            style: AppTheme.text(context).titleMedium.copyWith(
              color: accent,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ],
      ),
    );
  }
}
