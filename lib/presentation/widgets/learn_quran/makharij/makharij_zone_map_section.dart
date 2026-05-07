import 'package:flutter/material.dart';

import 'makharij_learning_data.dart';
import 'makharij_section_card.dart';

class MakharijZoneMapSection extends StatelessWidget {
  const MakharijZoneMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const MakharijSectionCard(
      title: '1) Articulation Zone Map',
      subtitle:
          'Learn each makhraj zone with its letters, physical cue, and a quick corrective drill.',
      child: _ZoneList(),
    );
  }
}

class _ZoneList extends StatelessWidget {
  const _ZoneList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final zone in MakharijLearningData.zones)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ZoneCard(zone: zone),
          ),
      ],
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({required this.zone});

  final MakharijZoneGuide zone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            zone.zone,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            zone.letters,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _Line(label: 'Location', value: zone.locationCue),
          const SizedBox(height: 4),
          _Line(label: 'Sound cue', value: zone.soundCue),
          const SizedBox(height: 4),
          _Line(label: 'Common mistake', value: zone.commonMistake),
          const SizedBox(height: 4),
          _Line(label: 'Drill', value: zone.drill),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
