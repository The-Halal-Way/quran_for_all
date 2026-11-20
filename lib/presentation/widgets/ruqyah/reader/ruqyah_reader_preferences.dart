import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/ruqyah/ruqyah_progress.dart';
import '../../../viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';

Future<void> showRuqyahReaderPreferences(
  BuildContext context,
  RuqyahReaderViewModel model,
) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final preferences = model.preferences;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.ruqyahReadingSettings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.ruqyahPronunciation),
                value: preferences.pronunciation,
                onChanged: (value) => model.setPreferences(
                  RuqyahReaderPreferences(
                    pronunciation: value,
                    meaning: preferences.meaning,
                    fontSize: preferences.fontSize,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.ruqyahMeaning),
                value: preferences.meaning,
                onChanged: (value) => model.setPreferences(
                  RuqyahReaderPreferences(
                    pronunciation: preferences.pronunciation,
                    meaning: value,
                    fontSize: preferences.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(context.l10n.ruqyahArabicSize),
              Slider(
                min: 24,
                max: 40,
                divisions: 8,
                value: preferences.fontSize,
                onChanged: (value) => model.setPreferences(
                  RuqyahReaderPreferences(
                    pronunciation: preferences.pronunciation,
                    meaning: preferences.meaning,
                    fontSize: value,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  ),
);
