import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/dashboard/dashboard_action_item.dart';
import 'dashboard_action_tile.dart';
import 'dashboard_section_title.dart';

class DashboardShortcutsSection extends StatelessWidget {
  const DashboardShortcutsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.items,
  });
  final String title;
  final IconData icon;
  final Color accent;
  final List<DashboardActionItem> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DashboardSectionTitle(title: title, icon: icon, accent: accent),
      const SizedBox(height: AppSpacing.md),
      LayoutBuilder(
        builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
          final columns = scale > 1.5 || constraints.maxWidth < 280
              ? 1
              : constraints.maxWidth >= 700
              ? items.length
              : 2;
          final width =
              (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (var index = 0; index < items.length; index++)
                SizedBox(
                  width:
                      columns == 2 &&
                          index == items.length - 1 &&
                          items.length.isOdd
                      ? constraints.maxWidth
                      : width,
                  child: DashboardActionTile(item: items[index]),
                ),
            ],
          );
        },
      ),
    ],
  );
}
