import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/nurani_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../domain/entities/quran/nurani_quran_state.dart';

String nuraniNumber(BuildContext context, int value) =>
    NumberFormat.decimalPattern(context.l10n.localeName).format(value);

String nuraniEditionLabel(BuildContext context, NuraniQuranEdition edition) =>
    switch (edition) {
      NuraniQuranEdition.green => context.l10n.nuraniQuranGreenEdition,
      NuraniQuranEdition.blue => context.l10n.nuraniQuranBlueEdition,
    };

String nuraniFileSize(BuildContext context, NuraniQuranDocument document) =>
    context.l10n.nuraniQuranFileSize(
      NumberFormat(
        '0.0',
        context.l10n.localeName,
      ).format(document.sizeMegabytes),
    );

String nuraniIssueMessage(BuildContext context, NuraniQuranIssue issue) =>
    switch (issue) {
      NuraniQuranIssue.storage => context.l10n.nuraniQuranStorageError,
      NuraniQuranIssue.invalidPdf => context.l10n.nuraniQuranInvalidPdf,
      NuraniQuranIssue.network => context.l10n.nuraniQuranNetworkError,
      NuraniQuranIssue.cancelled => '',
    };
