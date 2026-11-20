import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_style.dart';

/// Text grows with its content: vertical drags belong to the page scroll view.
class RuqyahTextPanel extends StatelessWidget {
  const RuqyahTextPanel({
    super.key,
    required this.label,
    required this.text,
    this.arabic = false,
    this.fontSize = 28,
  });
  final String label, text;
  final bool arabic;
  final double fontSize;
  @override
  Widget build(BuildContext context) => RuqyahPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.text(context).labelMedium.copyWith(
            color: RuqyahStyle.accent(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textDirection: arabic ? TextDirection.rtl : null,
            textAlign: arabic ? TextAlign.right : TextAlign.start,
            style: arabic
                ? AppTheme.quranArabic(
                    context,
                    fontSize: fontSize,
                  ).copyWith(height: 1.9)
                : AppTheme.text(context).bodyLarge.copyWith(height: 1.75),
          ),
        ),
      ],
    ),
  );
}
