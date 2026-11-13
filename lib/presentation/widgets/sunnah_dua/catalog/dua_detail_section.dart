import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DuaDetailSection extends StatelessWidget {
  const DuaDetailSection({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTheme.text(
            context,
          ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    ),
  );
}
