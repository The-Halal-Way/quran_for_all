import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import 'daily_duah_card.dart';
import 'daily_duah_data.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.category,
    required this.isDark,
    required this.isLast,
  });

  final DuahCategory category;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, isLast ? 32 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.6 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    size: 16,
                    color: isDark
                        ? const Color(0xFFB39DDB)
                        : const Color(0xFF1E0A3C),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category.label,
                  style: text.titleMedium.copyWith(
                    color: isDark
                        ? const Color(0xFFEDE7F6)
                        : const Color(0xFF120B24),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF382E54)
                        : const Color(0xFFEEE8FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${category.items.length}',
                    style: text.duahSectionCount.copyWith(
                      color: isDark
                          ? const Color(0xFFB39DDB)
                          : const Color(0xFF4C425C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...category.items.map((item) => DuahCard(item: item, isDark: isDark)),
        ],
      ),
    );
  }
}
