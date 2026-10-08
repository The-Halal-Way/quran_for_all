import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

enum IslamicDaysFeed { today, upcoming, saved, guides }

class IslamicDaysFeedSelector extends StatelessWidget {
  const IslamicDaysFeedSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final IslamicDaysFeed selected;
  final ValueChanged<IslamicDaysFeed> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.islamicDaysToday,
      l10n.islamicDaysUpcoming,
      l10n.islamicDaysSaved,
      l10n.islamicDaysAllGuides,
    ];
    final icons = [
      Icons.wb_sunny_outlined,
      Icons.event_outlined,
      Icons.bookmark_border_rounded,
      Icons.auto_stories_outlined,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final feed in IslamicDaysFeed.values)
          ChoiceChip(
            showCheckmark: false,
            avatar: Icon(icons[feed.index], size: 17),
            label: Text(labels[feed.index]),
            selected: selected == feed,
            onSelected: (_) => onChanged(feed),
          ),
      ],
    );
  }
}
