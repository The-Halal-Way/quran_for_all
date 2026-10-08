import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

import '../../l10n/app_localizations.dart';

String dailyHadithKindLabel(AppLocalizations l10n, String? kind) =>
    switch (kind) {
      null => l10n.dailyHadithCategoryAll,
      'quranReflection' => l10n.dailyHadithCategoryQuran,
      'hadithReflection' => l10n.dailyHadithCategoryHadith,
      'sunnah' => l10n.dailyHadithCategorySunnah,
      'akhirahReflection' => l10n.dailyHadithCategoryAkhirah,
      _ => kind,
    };

IconData dailyHadithKindIcon(String kind) => switch (kind) {
  'quranReflection' => CupertinoIcons.book,
  'hadithReflection' => CupertinoIcons.quote_bubble,
  'sunnah' => CupertinoIcons.moon_stars,
  'akhirahReflection' => CupertinoIcons.sparkles,
  _ => CupertinoIcons.lightbulb,
};

Color dailyHadithKindColor(BuildContext context, String kind) {
  final scheme = Theme.of(context).colorScheme;
  return switch (kind) {
    'quranReflection' => scheme.primary,
    'hadithReflection' => scheme.tertiary,
    'sunnah' => scheme.secondary,
    'akhirahReflection' => const Color(0xFF6C4BC2),
    _ => scheme.primary,
  };
}

String dailyHadithShareText({
  required DailyHadithPack pack,
  required DailyHadithItem item,
  required DailyHadithEdition edition,
  required String originalReflectionLabel,
  required String originalArabicLabel,
  required String suggestedActionLabel,
  required String sourcesLabel,
  required String reviewNote,
}) {
  final reflections = edition.blocks
      .where(
        (block) =>
            block.type == DailyHadithBlockType.paragraph && block.text != null,
      )
      .map((block) => block.text!)
      .join('\n\n');
  final actions = edition.blocks
      .where(
        (block) =>
            (block.type == DailyHadithBlockType.callout ||
                block.type == DailyHadithBlockType.action) &&
            (block.text ?? block.value) != null,
      )
      .map((block) => block.text ?? block.value!)
      .toSet()
      .join('\n');
  final originals = item.originalPassageIds
      .map((id) => pack.passages[id]?.text)
      .whereType<String>()
      .join('\n\n');
  final sources = item.sourceIds
      .map((id) => pack.sources[id]?.displayName)
      .whereType<String>()
      .join(', ');
  return [
    edition.title,
    if (originals.isNotEmpty) '$originalArabicLabel\n$originals',
    if (reflections.isNotEmpty) '$originalReflectionLabel\n$reflections',
    if (actions.isNotEmpty) '$suggestedActionLabel\n$actions',
    if (sources.isNotEmpty) '$sourcesLabel: $sources',
    reviewNote,
  ].join('\n\n');
}
