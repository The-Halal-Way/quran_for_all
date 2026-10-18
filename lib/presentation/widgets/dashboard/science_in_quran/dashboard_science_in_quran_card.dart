import 'package:flutter/material.dart';

import '../../../../core/constants/science_in_quran_document.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../books/dashboard_pdf_book_card.dart';

class DashboardScienceInQuranCard extends StatelessWidget {
  const DashboardScienceInQuranCard({super.key});

  @override
  Widget build(BuildContext context) => DashboardPdfBookCard(
    book: ScienceInQuranDocument.book,
    accent: AppThemeColors.light.cyan,
  );
}
