import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';
import 'eid_topic_chip.dart';

class EidTopicSelector extends StatelessWidget {
  const EidTopicSelector({
    super.key,
    required this.selected,
    required this.bangla,
    required this.onSelected,
  });

  final EidGuideTopic selected;
  final bool bangla;
  final ValueChanged<EidGuideTopic> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = <EidGuideTopic, EidText>{
      EidGuideTopic.overview: EidText('Overview', 'পরিচিতি'),
      EidGuideTopic.prayer: EidText('Prayer steps', 'নামাজের নিয়ম'),
      EidGuideTopic.dayPlan: EidText('Day plan', 'দিনের আমল'),
      EidGuideTopic.remembrance: EidText('Dhikr & duas', 'যিকির ও দোয়া'),
    };
    const icons = <EidGuideTopic, IconData>{
      EidGuideTopic.overview: Icons.wb_twilight_rounded,
      EidGuideTopic.prayer: Icons.menu_book_rounded,
      EidGuideTopic.dayPlan: Icons.checklist_rounded,
      EidGuideTopic.remembrance: Icons.auto_awesome_rounded,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final topic in EidGuideTopic.values) ...[
            EidTopicChip(
              label: labels[topic]!.inLanguage(bangla),
              icon: icons[topic]!,
              selected: selected == topic,
              onTap: () => onSelected(topic),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
