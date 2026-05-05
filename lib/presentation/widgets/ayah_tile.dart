import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/enums/app_language.dart';
import '../../data/models/ayah_model.dart';

class AyahTile extends StatelessWidget {
  const AyahTile({
    super.key,
    required this.ayah,
    required this.showPronunciation,
    required this.showTranslation,
    required this.language,
    required this.onPlay,
    required this.onMarkAsLastRead,
  });

  final AyahModel ayah;
  final bool showPronunciation;
  final bool showTranslation;
  final AppLanguage language;
  final VoidCallback onPlay;
  final VoidCallback onMarkAsLastRead;

  @override
  Widget build(BuildContext context) {
    final transliteration = ayah.transliterationFor(language);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: Colors.white.withValues(alpha: 0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '${ayah.surahId}:${ayah.ayahNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'Juz ${ayah.juzNumber}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onMarkAsLastRead,
                  icon: const Icon(Icons.bookmark_add_outlined),
                  tooltip: 'Mark ayah as last read',
                ),
                IconButton.filledTonal(
                  onPressed: onPlay,
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  tooltip: 'Play ayah audio',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              ayah.arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 32,
                height: 1.8,
                color: const Color(0xFF112A23),
              ),
            ),
            if (showPronunciation && transliteration.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                transliteration,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
            if (showTranslation) ...[
              const SizedBox(height: 12),
              _TranslationLine(label: 'EN', text: ayah.translationEn),
              const SizedBox(height: 8),
              _TranslationLine(label: 'BN', text: ayah.translationBn),
            ],
          ],
        ),
      ),
    );
  }
}

class _TranslationLine extends StatelessWidget {
  const _TranslationLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}
