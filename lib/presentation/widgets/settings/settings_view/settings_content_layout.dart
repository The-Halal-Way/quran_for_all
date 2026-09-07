import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class SettingsContentLayout extends StatelessWidget {
  const SettingsContentLayout({
    super.key,
    required this.preferences,
    required this.theme,
    required this.hijri,
    required this.offline,
  });

  final Widget preferences;
  final Widget theme;
  final Widget hijri;
  final Widget offline;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            children: [
              preferences,
              const SizedBox(height: AppSpacing.md),
              theme,
              const SizedBox(height: AppSpacing.md),
              hijri,
              const SizedBox(height: AppSpacing.md),
              offline,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: preferences),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                children: [
                  theme,
                  const SizedBox(height: AppSpacing.md),
                  hijri,
                  const SizedBox(height: AppSpacing.md),
                  offline,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
