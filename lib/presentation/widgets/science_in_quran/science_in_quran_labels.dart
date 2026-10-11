import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/science_in_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../domain/entities/science_in_quran_state.dart';

String scienceNumber(BuildContext context, int value) =>
    NumberFormat.decimalPattern(context.l10n.localeName).format(value);

String scienceLanguageLabel(
  BuildContext context,
  ScienceInQuranLanguage language,
) => switch (language) {
  ScienceInQuranLanguage.english => context.l10n.scienceInQuranEnglish,
  ScienceInQuranLanguage.bangla => context.l10n.scienceInQuranBangla,
};

String scienceFileSize(BuildContext context, ScienceInQuranDocument document) =>
    context.l10n.scienceInQuranFileSize(
      NumberFormat(
        '0.0',
        context.l10n.localeName,
      ).format(document.sizeMegabytes),
    );

String scienceIssueMessage(BuildContext context, ScienceInQuranIssue issue) =>
    switch (issue) {
      ScienceInQuranIssue.network => context.l10n.scienceInQuranNetworkError,
      ScienceInQuranIssue.invalidPdf => context.l10n.scienceInQuranInvalidPdf,
      ScienceInQuranIssue.storage => context.l10n.scienceInQuranStorageError,
      ScienceInQuranIssue.cancelled => '',
    };
