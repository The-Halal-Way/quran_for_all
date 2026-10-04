import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class SettingsContentLayout extends StatelessWidget {
  const SettingsContentLayout({
    super.key,
    required this.language,
    required this.theme,
    required this.hijri,
  });

  final Widget language;
  final Widget theme;
  final Widget hijri;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            children: [
              language,
              const SizedBox(height: AppSpacing.md),
              theme,
              const SizedBox(height: AppSpacing.md),
              hijri,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: language),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                children: [
                  theme,
                  const SizedBox(height: AppSpacing.md),
                  hijri,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
