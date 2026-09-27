import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import '../tasbeeh/tasbeeh_phrase_localizer.dart';

class TasbeehFocusPhrase extends StatelessWidget {
  const TasbeehFocusPhrase({super.key, required this.phrase});
  final TasbeehPhrase phrase;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (phrase.arabic.isNotEmpty) ...[
          Text(
            phrase.arabic,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTheme.amiri(
              context,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          phrase.label(context.l10n),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: (phrase.arabic.isEmpty ? text.titleLarge : text.labelLarge)
              .copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
