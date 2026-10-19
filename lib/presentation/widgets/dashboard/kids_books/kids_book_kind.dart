import 'package:flutter/material.dart';

import '../../../../core/constants/kids_books_catalog.dart';
import '../../../../core/constants/pdf_book_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';

enum KidsBookKind {
  sahabah,
  prophets,
  prophetLife,
  fortyHadith;

  PdfBookDefinition get book => switch (this) {
    sahabah => KidsBooksCatalog.sahabah,
    prophets => KidsBooksCatalog.prophets,
    prophetLife => KidsBooksCatalog.prophetLife,
    fortyHadith => KidsBooksCatalog.fortyHadith,
  };

  Color get accent => switch (this) {
    sahabah => AppThemeColors.light.cyan,
    prophets => AppThemeColors.light.violet,
    prophetLife => AppThemeColors.light.success,
    fortyHadith => AppThemeColors.light.coral,
  };

  String title(BuildContext context) =>
      book.forLocale(Localizations.localeOf(context)).title!;

  String description(BuildContext context) => switch (this) {
    sahabah => context.l10n.kidsBooksSahabahDescription,
    prophets => context.l10n.kidsBooksProphetsDescription,
    prophetLife => context.l10n.kidsBooksProphetLifeDescription,
    fortyHadith => context.l10n.kidsBooksHadithDescription,
  };
}
