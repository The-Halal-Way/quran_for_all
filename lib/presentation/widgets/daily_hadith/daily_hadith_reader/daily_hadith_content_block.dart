import 'package:flutter/material.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

class DailyHadithContentBlock extends StatelessWidget {
  const DailyHadithContentBlock({
    super.key,
    required this.block,
    required this.pack,
    required this.l10n,
  });

  final DailyHadithBlock block;
  final DailyHadithPack pack;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return switch (block.type) {
      DailyHadithBlockType.paragraph ||
      DailyHadithBlockType.translation ||
      DailyHadithBlockType.transliteration => _TextBlock(
        block: block,
        l10n: l10n,
      ),
      DailyHadithBlockType.heading => _HeadingBlock(block: block),
      DailyHadithBlockType.callout => _CalloutBlock(block: block, l10n: l10n),
      DailyHadithBlockType.list => _ListBlock(block: block),
      DailyHadithBlockType.divider => const Divider(height: AppSpacing.xxxl),
      DailyHadithBlockType.image => _ImageBlock(block: block, pack: pack),
      DailyHadithBlockType.audio => _AudioBlock(block: block),
      DailyHadithBlockType.originalPassage => _ReferencedPassageBlock(
        block: block,
        pack: pack,
      ),
      DailyHadithBlockType.action => const SizedBox.shrink(),
    };
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.block, required this.l10n});

  final DailyHadithBlock block;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: block.direction,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (block.type == DailyHadithBlockType.paragraph &&
            block.role == 'reflection') ...[
          Text(
            l10n.dailyHadithOriginalReflection,
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
  final DailyHadithBlock block;

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
  final DailyHadithBlock block;
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
            block.label ?? l10n.dailyHadithSuggestedAction,
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
  final DailyHadithBlock block;

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
  final DailyHadithBlock block;
  final DailyHadithPack pack;

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
  final DailyHadithBlock block;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.graphic_eq_rounded),
    title: Text(block.transcript ?? block.label ?? 'Audio'),
    enabled: false,
  );
}

class _ReferencedPassageBlock extends StatelessWidget {
  const _ReferencedPassageBlock({required this.block, required this.pack});
  final DailyHadithBlock block;
  final DailyHadithPack pack;

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
