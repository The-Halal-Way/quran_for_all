import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/surah_model.dart';

class SurahMetaCard extends StatelessWidget {
  const SurahMetaCard({
    super.key,
    required this.surah,
    required this.isPlayingFullSurah,
    required this.onTogglePlayback,
  });

  final SurahModel surah;
  final bool isPlayingFullSurah;
  final VoidCallback onTogglePlayback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            surah.nameArabic,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            surah.nameEnglish,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            surah.nameTranslated,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _MetaChip(
                icon: Icons.layers_outlined,
                label: '${surah.totalAyahs} ${context.readQuranText('ayahs')}',
              ),
              _MetaChip(
                icon: Icons.public_rounded,
                label: context.readQuranText(surah.revelationType),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            onPressed: onTogglePlayback,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colorScheme.primary,
            ),
            icon: Icon(
              isPlayingFullSurah
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_fill_rounded,
            ),
            label: Text(
              context.readQuranText(
                isPlayingFullSurah ? 'Stop Surah Audio' : 'Play Full Surah',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
