import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_index.dart';
import 'ruqyah_collection_card.dart';

class RuqyahCollectionsSection extends StatelessWidget {
  const RuqyahCollectionsSection({
    super.key,
    required this.collections,
    required this.onOpen,
    required this.onGuide,
  });
  final List<RuqyahRoutineSummary> collections;
  final ValueChanged<String> onOpen, onGuide;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.ruqyahLongCollections,
        style: AppTheme.text(
          context,
        ).titleLarge.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      Text(
        context.l10n.ruqyahLongCollectionsBody,
        style: AppTheme.text(context).bodyMedium.copyWith(
          height: 1.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 14),
      for (final (i, collection) in collections.indexed)
        RuqyahCollectionCard(
          collection: collection,
          featured: i == 0,
          onOpen: () => onOpen(collection.id),
          onGuide: () => onGuide(collection.guideId),
        ),
    ],
  );
}
