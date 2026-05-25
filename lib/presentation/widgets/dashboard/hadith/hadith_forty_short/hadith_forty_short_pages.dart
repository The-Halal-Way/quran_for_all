part of '../../../../views/dashboard/hadith/hadith_forty_short_view.dart';

class _ShortHadithPage extends StatelessWidget {
  final ShortHadith hadith;
  final bool isBangla, isDark;
  final Color cardBg, textMain, textSub, textHint, divider;
  final int totalCount;

  const _ShortHadithPage({
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
    final headline = hadith.headlineOf(isBangla);
    final bullets = hadith.bulletsOf(isBangla);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Arabic memorization card ───────────────────────────────────
          _MemorizationCard(arabic: hadith.arabic, isDark: isDark),

          const SizedBox(height: 16),

          // ── Headline translation card ──────────────────────────────────
          _HeadlineCard(
            headline: headline,
            isDark: isDark,
            cardBg: cardBg,
            textMain: textMain,
          ),

          const SizedBox(height: 14),

          // ── Lessons / bullets ──────────────────────────────────────────
          if (bullets.isNotEmpty)
            _LessonsCard(
              bullets: bullets,
              isBangla: isBangla,
              isDark: isDark,
              cardBg: cardBg,
              textMain: textMain,
              textSub: textSub,
              textHint: textHint,
              divider: divider,
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MEMORIZATION CARD  (Arabic showcase — the star)
// ─────────────────────────────────────────────────────────────────────────────

class _MemorizationCard extends StatelessWidget {
  final String arabic;
  final bool isDark;

  const _MemorizationCard({required this.arabic, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0E0826), Color(0xFF1D1147)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF0B5E54), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: MyColors.tertiary.withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative star top-right
          Positioned(
            right: 12,
            top: 12,
            child: _GeomStar(color: Colors.white.withOpacity(0.05), size: 80),
          ),
          // Decorative star bottom-left
          Positioned(
            left: -8,
            bottom: -8,
            child: _GeomStar(color: Colors.white.withOpacity(0.03), size: 50),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // "Memorize" badge
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.tertiary.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: MyColors.tertiary.withOpacity(0.35),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_fix_high_rounded,
                          size: 11,
                          color: MyColors.tertiaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'MEMORIZE',
                          style: text.hadithShortMemorizeBadge.copyWith(
                            color: MyColors.tertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Arabic text — large & centered
                Text(
                  arabic,
                  textAlign: TextAlign.center,
                  textDirection: ui.TextDirection.rtl,
                  style: text.hadithShortArabicShowcase.copyWith(
                    color: Colors.white.withOpacity(0.97),
                  ),
                ),

                const SizedBox(height: 24),

                // Bottom accent divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        MyColors.tertiaryLight.withOpacity(0.5),
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
// HEADLINE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _HeadlineCard extends StatelessWidget {
  final String headline;
  final bool isDark;
  final Color cardBg, textMain;

  const _HeadlineCard({
    required this.headline,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left fuchsia bar
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyColors.secondary, MyColors.secondaryLight],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              headline,
              style: text.hadithShortHeadline.copyWith(color: textMain),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LESSONS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _LessonsCard extends StatelessWidget {
  final List<String> bullets;
  final bool isBangla, isDark;
  final Color cardBg, textMain, textSub, textHint, divider;

  const _LessonsCard({
    required this.bullets,
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
    final appText = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: MyColors.tertiary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lightbulb_rounded,
                      size: 12,
                      color: MyColors.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBangla ? 'শিক্ষা' : 'LESSONS',
                      style: appText.hadithShortLessonLabel.copyWith(
                        color: MyColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bullets
          ...bullets.asMap().entries.map((entry) {
            final idx = entry.key;
            final text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number dot
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _bulletColor(idx).withOpacity(0.12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${idx + 1}',
                      style: appText.hadithShortLessonIndex.copyWith(
                        color: _bulletColor(idx),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: appText
                          .hadithShortLessonBody(isBangla: isBangla)
                          .copyWith(color: textSub),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _bulletColor(int idx) {
    const colors = [
      MyColors.tertiary,
      MyColors.secondary,
      MyColors.primaryLight,
      MyColors.tertiaryLight,
      MyColors.secondaryLight,
    ];
    return colors[idx % colors.length];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JUMP BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
