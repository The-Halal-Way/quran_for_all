import 'package:flutter/material.dart';

import '../../../../core/constants/science_in_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import 'science_in_quran_language_option.dart';

Future<ScienceInQuranDocument?> showScienceInQuranLanguageSheet(
  BuildContext context, {
  ScienceInQuranDocument? initialDocument,
}) => showModalBottomSheet<ScienceInQuranDocument>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => ScienceInQuranLanguageSheet(initialDocument: initialDocument),
);

class ScienceInQuranLanguageSheet extends StatefulWidget {
  const ScienceInQuranLanguageSheet({super.key, this.initialDocument});

  final ScienceInQuranDocument? initialDocument;

  @override
  State<ScienceInQuranLanguageSheet> createState() =>
      _ScienceInQuranLanguageSheetState();
}

class _ScienceInQuranLanguageSheetState
    extends State<ScienceInQuranLanguageSheet> {
  late ScienceInQuranDocument _selected =
      widget.initialDocument ?? ScienceInQuranDocument.english;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      0,
      AppSpacing.xl,
      AppSpacing.xl,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.scienceInQuranChooseLanguage,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.scienceInQuranLanguageDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final document in ScienceInQuranDocument.documents) ...[
            ScienceInQuranLanguageOption(
              document: document,
              selected: document == _selected,
              onTap: () => setState(() => _selected = document),
            ),
            if (document != ScienceInQuranDocument.documents.last)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(_selected),
              icon: const Icon(Icons.download_rounded),
              label: Text(context.l10n.scienceInQuranDownload),
            ),
          ),
        ],
      ),
    ),
  );
}
