import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';

class HadithReaderLanguageToggle extends StatelessWidget {
  const HadithReaderLanguageToggle({
    super.key,
    required this.isBangla,
    required this.accent,
    required this.onChanged,
  });

  final bool isBangla;
  final Color accent;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isBangla ? 'বাংলা' : 'English',
      child: Material(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: InkWell(
          onTap: () => onChanged(!isBangla),
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Text(
              isBangla ? 'বাং' : 'EN',
              style: AppTheme.text(context).labelSmall.copyWith(
                color: accent,
                fontWeight: AppTheme.weightExtraBold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
