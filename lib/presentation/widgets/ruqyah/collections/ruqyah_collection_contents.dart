import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';
import '../shared/ruqyah_style.dart';

Future<int?> showRuqyahCollectionContents(
  BuildContext context,
  RuqyahReaderViewModel model,
) => showModalBottomSheet<int>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: .7,
    minChildSize: .3,
    maxChildSize: .9,
    builder: (context, controller) => ListView.builder(
      controller: controller,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: model.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text(
              context.l10n.ruqyahCollectionContents,
              style: AppTheme.text(context).titleLarge,
            ),
          );
        }
        final index = i - 1;
        final reading = model.readingAt(index)!;
        return ListTile(
          selected: model.index == index,
          leading: Text(
            RuqyahStyle.number(context, index + 1),
            style: AppTheme.text(context).titleSmall,
          ),
          title: Text(
            reading.summary.title.inLanguage(context.l10n.localeName),
            style: AppTheme.text(context).bodyMedium,
          ),
          subtitle: Text(
            '${reading.surahNumber}:${reading.verseNumbers.first}–${reading.verseNumbers.last}',
          ),
          trailing: model.completed.contains(index)
              ? const Icon(Icons.check_circle_outline_rounded)
              : null,
          onTap: () => Navigator.pop(context, index),
        );
      },
    ),
  ),
);
