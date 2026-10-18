import 'package:flutter/material.dart';

import '../../../../core/constants/life_of_muhammad_document.dart';
import '../../../../core/constants/pdf_book_document.dart';
import '../../../../core/constants/science_in_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';

enum DashboardBookKind {
  science,
  prophecies,
  lifeOfMuhammad;

  PdfBookDefinition? get pdfBook => switch (this) {
    science => ScienceInQuranDocument.book,
    lifeOfMuhammad => LifeOfMuhammadDocument.book,
    prophecies => null,
  };

  Color get accent => switch (this) {
    science => AppThemeColors.light.cyan,
    prophecies => AppThemeColors.light.coral,
    lifeOfMuhammad => AppThemeColors.light.violet,
  };

  String title(BuildContext context) => switch (this) {
    science => context.l10n.scienceInQuranTitle,
    prophecies => context.l10n.propheciesBookTitle,
    lifeOfMuhammad =>
      LifeOfMuhammadDocument.book
          .forLocale(Localizations.localeOf(context))
          .title!,
  };

  String metadata(BuildContext context) => switch (this) {
    science => context.l10n.dashboardBookPdf,
    prophecies => context.l10n.propheciesPartsCount('2'),
    lifeOfMuhammad => context.l10n.dashboardBookBiography,
  };
}
