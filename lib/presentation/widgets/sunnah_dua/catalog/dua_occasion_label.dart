import 'package:flutter/widgets.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/dua/dua_catalog.dart';

String duaOccasionLabel(BuildContext context, DuaEntry entry, String occasion) {
  final supplied = entry.practice.occasionLabels[occasion];
  if (supplied != null && !supplied.isEmpty) {
    return supplied.inLanguage(context.l10n.localeName);
  }
  return switch (occasion) {
    'morning' => context.l10n.duaMorning,
    'evening' => context.l10n.duaEvening,
    'arriving_at_lodging' => context.l10n.duaAtLodging,
    'setting_out_on_journey' => context.l10n.duaOutwardJourney,
    'returning_from_journey' => context.l10n.duaReturnJourney,
    'bedtime' => context.l10n.duaOccasionLabel('before_sleep'),
    _ => context.l10n.duaOccasionLabel(occasion),
  };
}
