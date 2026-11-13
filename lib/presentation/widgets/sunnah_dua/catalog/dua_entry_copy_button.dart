import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';

class DuaEntryCopyButton extends StatelessWidget {
  const DuaEntryCopyButton({
    super.key,
    required this.entry,
    this.categoryId,
    this.occasion,
  });

  final DuaEntry entry;
  final String? categoryId, occasion;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: () => _copy(context),
    tooltip: context.l10n.duahCopy,
    icon: const Icon(Icons.copy_rounded),
  );

  Future<void> _copy(BuildContext context) async {
    final language = context.l10n.localeName;
    final copied = context.l10n.duahCopied;
    final content = [
      entry.titleFor(language, categoryId),
      for (final part in entry.passagesFor(occasion)) ...[
        if (!part.label.isEmpty) part.label.inLanguage(language),
        if ((part.repetitions ??
                (entry.segments.isEmpty
                    ? entry.practice.countFor(occasion)
                    : null))
            case final count?)
          context.l10n.duaRepeatCount(duaNumber(context, count)),
        part.arabic,
        part.pronunciation.inLanguage(language),
        part.meaning.inLanguage(language),
      ],
      entry.sourceText.inLanguage(language),
      entry.note.inLanguage(language),
      entry.sourceNote.inLanguage(language),
      for (final report in entry.hadith)
        '${report.collection.inLanguage(language)} ${report.number}'
            '${report.grade.isEmpty ? '' : ' · ${report.grade.inLanguage(language)}'}\n${report.url}',
      for (final reference in entry.quranReferences)
        duaString(reference['url']),
    ].where((text) => text.isNotEmpty).join('\n\n');
    await Clipboard.setData(ClipboardData(text: content));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(copied)));
    }
  }
}
