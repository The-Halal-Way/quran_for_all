import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/dashboard/dashboard_action_item.dart';
import 'sunnah_dua_shortcut_card.dart';

class SunnahDuaShortcutCarousel extends StatelessWidget {
  const SunnahDuaShortcutCarousel({super.key, required this.items});

  final List<DashboardActionItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => SizedBox(
          width: 138,
          child: SunnahDuaShortcutCard(item: items[index]),
        ),
      ),
    );
  }
}
