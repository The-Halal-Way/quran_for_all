import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import '../tasbeeh/tasbeeh_phrase_localizer.dart';
import '../tasbeeh/tasbeeh_visuals.dart';

class TasbeehFocusPhrase extends StatelessWidget {
  const TasbeehFocusPhrase({super.key, required this.phrase});
  final TasbeehPhrase phrase;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final meaning = phrase.localizedMeaning(context.l10n);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.tasbeehPhraseTitle.toUpperCase(),
          style: text.labelSmall.copyWith(
            color: TasbeehVisuals.gold,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        if (phrase.arabic.isNotEmpty) ...[
          Text(
            phrase.arabic,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTheme.amiri(
              context,
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          phrase.label(context.l10n),
          textAlign: TextAlign.center,
          style: (phrase.arabic.isEmpty ? text.titleLarge : text.labelLarge)
              .copyWith(
                color: TasbeehVisuals.gold,
                fontWeight: FontWeight.w800,
              ),
        ),
        if (meaning.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: text.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
            ),
          ),
        ],
      ],
    );
  }
}
