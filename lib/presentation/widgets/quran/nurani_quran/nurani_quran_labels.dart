import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../domain/entities/quran/nurani_quran_state.dart';

String nuraniNumber(BuildContext context, int value) =>
    NumberFormat.decimalPattern(context.l10n.localeName).format(value);

String nuraniIssueMessage(BuildContext context, NuraniQuranIssue issue) =>
    switch (issue) {
      NuraniQuranIssue.storage => context.l10n.nuraniQuranStorageError,
      NuraniQuranIssue.invalidPdf => context.l10n.nuraniQuranInvalidPdf,
      NuraniQuranIssue.network => context.l10n.nuraniQuranNetworkError,
      NuraniQuranIssue.cancelled => '',
    };
