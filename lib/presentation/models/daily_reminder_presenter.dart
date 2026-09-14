import 'package:flutter/material.dart';

import '../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../l10n/app_localizations.dart';

String dailyReminderKindLabel(AppLocalizations l10n, String? kind) =>
    switch (kind) {
      null => l10n.dailyRemindersCategoryAll,
      'quranReflection' => l10n.dailyRemindersCategoryQuran,
      'hadithReflection' => l10n.dailyRemindersCategoryHadith,
      'sunnah' => l10n.dailyRemindersCategorySunnah,
      'akhirahReflection' => l10n.dailyRemindersCategoryAkhirah,
      _ => kind,
    };

IconData dailyReminderKindIcon(String kind) => switch (kind) {
  'quranReflection' => Icons.menu_book_rounded,
  'hadithReflection' => Icons.format_quote_rounded,
  'sunnah' => Icons.nights_stay_rounded,
  'akhirahReflection' => Icons.auto_awesome_rounded,
  _ => Icons.lightbulb_rounded,
};

Color dailyReminderKindColor(BuildContext context, String kind) {
  final scheme = Theme.of(context).colorScheme;
  return switch (kind) {
    'quranReflection' => scheme.primary,
    'hadithReflection' => scheme.tertiary,
    'sunnah' => scheme.secondary,
    'akhirahReflection' => const Color(0xFF6C4BC2),
    _ => scheme.primary,
  };
}

String dailyReminderShareText({
  required DailyReminderPack pack,
  required DailyReminderItem item,
  required DailyReminderEdition edition,
  required String originalReflectionLabel,
  required String originalArabicLabel,
  required String suggestedActionLabel,
  required String sourcesLabel,
  required String reviewNote,
}) {
  final reflections = edition.blocks
      .where(
        (block) =>
            block.type == DailyReminderBlockType.paragraph &&
            block.text != null,
      )
      .map((block) => block.text!)
      .join('\n\n');
  final actions = edition.blocks
      .where(
        (block) =>
            (block.type == DailyReminderBlockType.callout ||
                block.type == DailyReminderBlockType.action) &&
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
