import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/pdf_book_document.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../domain/entities/pdf_book_state.dart';

String pdfBookNumber(BuildContext context, int value) =>
    NumberFormat.decimalPattern(context.l10n.localeName).format(value);

String pdfBookLanguageLabel(BuildContext context, PdfBookLanguage language) =>
    switch (language) {
      PdfBookLanguage.english => context.l10n.pdfBookEnglish,
      PdfBookLanguage.bangla => context.l10n.pdfBookBangla,
    };

String pdfBookFileSize(BuildContext context, PdfBookDocument document) {
  final size = document.sizeMegabytes;
  if (size == null) return context.l10n.dashboardBookPdf;
  return context.l10n.pdfBookFileSize(
    NumberFormat('0.0', context.l10n.localeName).format(size),
  );
}

String pdfBookTitle(BuildContext context, PdfBookDefinition book) =>
    book.id == 'science_in_quran'
    ? context.l10n.scienceInQuranTitle
    : book.forLocale(Localizations.localeOf(context)).title!;

String pdfBookDescription(BuildContext context, PdfBookDefinition book) =>
    switch (book.id) {
      'science_in_quran' => context.l10n.scienceInQuranDescription,
      'life_of_muhammad' => context.l10n.lifeOfMuhammadDescription,
      _ => '',
    };

String pdfBookIssueMessage(BuildContext context, PdfBookIssue issue) =>
    switch (issue) {
      PdfBookIssue.network => context.l10n.pdfBookNetworkError,
      PdfBookIssue.invalidPdf => context.l10n.pdfBookInvalidPdf,
      PdfBookIssue.storage => context.l10n.pdfBookStorageError,
      PdfBookIssue.cancelled => '',
    };
