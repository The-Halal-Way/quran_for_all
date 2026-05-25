part of '../../../../views/dashboard/hadith/hadith_an_nawawi_view.dart';
class _IntroPage extends StatelessWidget {
  final HadithBook book;
  final bool isBangla;
  final bool isDark;
  final Color cardBg, textMain, textSub, textHint, divider;

  const _IntroPage({
    required this.book,
    required this.isBangla,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final text = isBangla
        ? book.introduction.bangla
        : book.introduction.english;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  MyColors.primary,
                  MyColors.primaryLight,
                  MyColors.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: MyColors.secondary.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _ArabicOrnament(color: Colors.white.withOpacity(0.9), size: 48),
                const SizedBox(height: 16),
                Text(
                  'الأربعون النووية',
                  style: GoogleFonts.amiri(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  book.title,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: 60,
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isBangla ? 'ইমাম আন-নওয়াওয়ী (রহ.)' : 'Imam An-Nawawi (RA)',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.65),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.format_list_numbered_rounded,
                value: '42',
                label: isBangla ? 'হাদিস' : 'Hadiths',
                isDark: isDark,
                cardBg: cardBg,
                textMain: textMain,
                textHint: textHint,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.translate_rounded,
                value: isBangla ? '২' : '2',
                label: isBangla ? 'ভাষা' : 'Languages',
                isDark: isDark,
                cardBg: cardBg,
                textMain: textMain,
                textHint: textHint,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.auto_stories_rounded,
                value: '٦٣١',
                label: isBangla ? 'হিজরি' : 'Hijri',
                isDark: isDark,
                cardBg: cardBg,
                textMain: textMain,
                textHint: textHint,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Introduction text card
          _GlassCard(
            isDark: isDark,
            cardBg: cardBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: MyColors.tertiary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isBangla ? 'ভূমিকা' : 'Introduction',
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  text,
                  style: GoogleFonts.manrope(
                    fontSize: isBangla ? 15 : 14,
                    height: isBangla ? 1.9 : 1.7,
                    color: textSub,
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
    final translationText = isBangla ? hadith.bangla : hadith.english;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MyColors.tertiary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  translationText,
                  style: GoogleFonts.manrope(
                    fontSize: isBangla ? 15 : 14,
                    height: isBangla ? 1.9 : 1.7,
                    color: textSub,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            color: MyColors.primaryLight.withOpacity(isDark ? 0.25 : 0.35),
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
              color: Colors.white.withOpacity(0.04),
              size: 120,
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: _ArabicOrnament(
              color: Colors.white.withOpacity(0.03),
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
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        'النص العربي',
                        style: GoogleFonts.amiri(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.secondary.withOpacity(0.2),
                        border: Border.all(
                          color: MyColors.secondary.withOpacity(0.4),
                          width: 0.8,
                        ),
                      ),
                      child: const Icon(
                        Icons.format_quote_rounded,
                        size: 14,
                        color: MyColors.secondaryLight,
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
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    height: 1.9,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.normal,
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
                        MyColors.secondary.withOpacity(0.6),
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

