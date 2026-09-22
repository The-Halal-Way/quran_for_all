part of '../../../../views/dashboard/hadith/hadith_an_nawawi_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HADITH PAGE
// ─────────────────────────────────────────────────────────────────────────────

class _HadithPage extends StatelessWidget {
  final Hadith hadith;
  final bool isBangla;
  final bool isDark;
  final Color cardBg, textMain, textSub, textHint, divider;
  final int totalCount;

  const _HadithPage({
    required this.hadith,
    required this.isBangla,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.textHint,
    required this.divider,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final appText = AppTheme.text(context);
    final translationText = isBangla ? hadith.bangla : hadith.english;

    return AppPageScrollbar(
      thumbVisibility: true,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Arabic text card — the star of the show
            _ArabicCard(arabic: hadith.arabic, isDark: isDark, cardBg: cardBg),

            const SizedBox(height: 16),

            // Translation card
            _GlassCard(
              isDark: isDark,
              cardBg: cardBg,
              accentColor: MyColors.tertiary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        size: 14,
                        color: MyColors.tertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isBangla ? 'অনুবাদ' : 'Translation',
                        style: appText.hadithTranslationLabel.copyWith(
                          color: MyColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    translationText,
                    style: appText
                        .hadithParagraph(isBangla: isBangla)
                        .copyWith(color: textSub),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ARABIC TEXT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ArabicCard extends StatelessWidget {
  final String arabic;
  final bool isDark;
  final Color cardBg;

  const _ArabicCard({
    required this.arabic,
    required this.isDark,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: isDark
            ? LinearGradient(
                colors: [const Color(0xFF1D1238), const Color(0xFF261A45)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [MyColors.primary, const Color(0xFF2D1568)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryLight.withValues(
              alpha: isDark ? 0.25 : 0.35,
            ),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned(
            right: -10,
            top: -10,
            child: _ArabicOrnament(
              color: Colors.white.withValues(alpha: 0.04),
              size: 120,
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: _ArabicOrnament(
              color: Colors.white.withValues(alpha: 0.03),
              size: 80,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        'النص العربي',
                        style: text.hadithArabicBadge.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.primaryLight.withValues(alpha: 0.2),
                        border: Border.all(
                          color: MyColors.primaryLight.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: const Icon(
                        Icons.format_quote_rounded,
                        size: 14,
                        color: MyColors.primaryLight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // The Arabic text
                Text(
                  arabic,
                  textAlign: TextAlign.right,
                  textDirection: ui.TextDirection.rtl,
                  style: text.hadithArabicCardBody.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom accent line
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        MyColors.primaryLight.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JUMP BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
