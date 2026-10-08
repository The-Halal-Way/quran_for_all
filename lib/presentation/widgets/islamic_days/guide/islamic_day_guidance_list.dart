import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../shared/islamic_days_section.dart';

class IslamicDayGuidanceList extends StatelessWidget {
  const IslamicDayGuidanceList({
    super.key,
    required this.title,
    required this.entries,
    required this.locale,
    this.avoid = false,
  });
  final String title;
  final List<IslamicDayText> entries;
  final String locale;
  final bool avoid;

  @override
  Widget build(BuildContext context) {
    final accent = avoid
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.tertiary;
    return IslamicDaysSection(
      title: title,
      icon: avoid
          ? Icons.do_not_disturb_on_outlined
          : Icons.info_outline_rounded,
      color: accent,
      child: Column(
        children: [
          for (var index = 0; index < entries.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == entries.length - 1 ? 0 : 14,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      avoid ? Icons.remove_circle_outline : Icons.circle,
                      color: accent,
                      size: avoid ? 18 : 7,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entries[index].resolve(locale),
                      style: AppTheme.text(
                        context,
                      ).bodyMedium.copyWith(height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
