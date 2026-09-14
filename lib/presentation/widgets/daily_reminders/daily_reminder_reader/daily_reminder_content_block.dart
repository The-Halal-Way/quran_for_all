import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../../../l10n/app_localizations.dart';

class DailyReminderContentBlock extends StatelessWidget {
  const DailyReminderContentBlock({
    super.key,
    required this.block,
    required this.pack,
    required this.l10n,
  });

  final DailyReminderBlock block;
  final DailyReminderPack pack;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return switch (block.type) {
      DailyReminderBlockType.paragraph ||
      DailyReminderBlockType.translation ||
      DailyReminderBlockType.transliteration => _TextBlock(
        block: block,
        l10n: l10n,
      ),
      DailyReminderBlockType.heading => _HeadingBlock(block: block),
      DailyReminderBlockType.callout => _CalloutBlock(block: block, l10n: l10n),
      DailyReminderBlockType.list => _ListBlock(block: block),
      DailyReminderBlockType.divider => const Divider(height: AppSpacing.xxxl),
      DailyReminderBlockType.image => _ImageBlock(block: block, pack: pack),
      DailyReminderBlockType.audio => _AudioBlock(block: block),
      DailyReminderBlockType.originalPassage => _ReferencedPassageBlock(
        block: block,
        pack: pack,
      ),
      DailyReminderBlockType.action => const SizedBox.shrink(),
    };
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.block, required this.l10n});

  final DailyReminderBlock block;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: block.direction,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (block.type == DailyReminderBlockType.paragraph &&
            block.role == 'reflection') ...[
          Text(
            l10n.dailyRemindersOriginalReflection,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        SelectableText(
          block.text ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.75),
        ),
      ],
    ),
  );
}

class _HeadingBlock extends StatelessWidget {
  const _HeadingBlock({required this.block});
  final DailyReminderBlock block;

  @override
  Widget build(BuildContext context) => Text(
    block.text ?? '',
    textDirection: block.direction,
    style:
        (block.level == 1
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.titleLarge)
            ?.copyWith(fontWeight: FontWeight.w800),
  );
}

class _CalloutBlock extends StatelessWidget {
  const _CalloutBlock({required this.block, required this.l10n});
  final DailyReminderBlock block;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            block.label ?? l10n.dailyRemindersSuggestedAction,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            block.text ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _ListBlock extends StatelessWidget {
  const _ListBlock({required this.block});
  final DailyReminderBlock block;

  @override
  Widget build(BuildContext context) => Column(
    children: block.items.indexed.map((entry) {
      final marker = block.ordered ? '${entry.$1 + 1}.' : '•';
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 28, child: Text(marker)),
            Expanded(child: Text(entry.$2)),
          ],
        ),
      );
    }).toList(),
  );
}

class _ImageBlock extends StatelessWidget {
  const _ImageBlock({required this.block, required this.pack});
  final DailyReminderBlock block;
  final DailyReminderPack pack;

  @override
  Widget build(BuildContext context) {
    final asset = pack.assets[block.assetId];
    if (asset == null) return const SizedBox.shrink();
    final image = asset.bundledAssetPath != null
        ? Image.asset(asset.bundledAssetPath!, fit: BoxFit.cover)
        : Image.network(
            asset.remoteUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
          );
    return Semantics(
      image: true,
      label: block.altText,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: image,
      ),
    );
  }
}

class _AudioBlock extends StatelessWidget {
  const _AudioBlock({required this.block});
  final DailyReminderBlock block;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.graphic_eq_rounded),
    title: Text(block.transcript ?? block.label ?? 'Audio'),
    enabled: false,
  );
}

class _ReferencedPassageBlock extends StatelessWidget {
  const _ReferencedPassageBlock({required this.block, required this.pack});
  final DailyReminderBlock block;
  final DailyReminderPack pack;

  @override
  Widget build(BuildContext context) {
    final passage = pack.passages[block.passageId];
    if (passage == null) return const SizedBox.shrink();
    return Directionality(
      textDirection: passage.direction,
      child: SelectableText(
        passage.text,
        textAlign: TextAlign.center,
        style: AppTheme.amiri(context, fontSize: 27, height: 1.9),
      ),
    );
  }
}
