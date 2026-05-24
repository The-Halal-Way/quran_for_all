part of '../../../views/dashboard/dashboard_view.dart';


extension _DashboardViewStateSections on _DashboardViewState {
  // ── Greeting header ─────────────────────────────────────────────────────────

  Widget _buildGreetingHeader() {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    final dateStr = DateFormat('EEEE, d MMMM').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arabic bismillah strip
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColors.primary.withOpacity(0.2),
                    MyColors.primaryLight.withOpacity(0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.secondary.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.secondary.withOpacity(0.45),
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: _textMain,
                        letterSpacing: 0.2,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.secondary.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.secondary.withOpacity(0.45),
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          greeting,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textHint,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Quran for All',
          style: GoogleFonts.sora(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _textMain,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 12, color: _textHint),
            const SizedBox(width: 5),
            Text(
              dateStr,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: _textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Continue reading / learning cards ───────────────────────────────────────

  Widget _buildContinueCards() {
    final readViewModel = context.watch<ReadQuranViewModel>();
    final learnViewModel = context.watch<LearnQuranViewModel>();

    final hasLastRead =
        readViewModel.lastRead != null && readViewModel.lastReadSurah != null;
    final lastRead = readViewModel.lastRead;
    final lastReadSurah = readViewModel.lastReadSurah;
    final continueReadingSubtitle = hasLastRead
        ? '${lastReadSurah!.nameEnglish} (${lastReadSurah.nameArabic})'
        : 'Start where you left off';
    final continueReadingDetail = hasLastRead
        ? 'Ayah ${lastRead!.ayahNumber} · ${lastReadSurah?.nameTranslated ?? 'Quran'}'
        : 'Open your recent surah and continue';

    final nextLesson = learnViewModel.nextLesson;
    final nextModule = nextLesson != null
        ? learnViewModel.moduleForLesson(nextLesson.id)
        : (learnViewModel.modules.isNotEmpty
              ? learnViewModel.modules.first
              : null);
    final continueLearningSubtitle = nextLesson?.title ?? 'Start Learning';
    final continueLearningDetail = nextModule != null
        ? '${nextModule.title} · ${nextModule.lessons.length} lessons'
        : 'Open learning tracks';

    return Row(
      children: [
        Expanded(
          child: _ContinueCard(
            title: 'Continue Reading',
            subtitle: continueReadingSubtitle,
            detail: continueReadingDetail,
            arabicSnippet: 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ',
            gradientColors: [MyColors.primary, MyColors.primaryLight],
            glowColor: MyColors.primaryLight,
            icon: Icons.auto_stories_rounded,
            isDark: _isDark,
            onTap: hasLastRead
                ? () => unawaited(
                    _openSurah(
                      context,
                      lastReadSurah!,
                      initialAyahNumber: lastRead!.ayahNumber,
                    ),
                  )
                : () => _push(const ReadQuranView()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ContinueCard(
            title: 'Continue Learning',
            subtitle: continueLearningSubtitle,
            detail: continueLearningDetail,
            arabicSnippet: 'ن  ◌ّ  م',
            gradientColors: const [Color(0xFF005C4B), MyColors.tertiary],
            glowColor: MyColors.tertiary,
            icon: Icons.school_rounded,
            isDark: _isDark,
            onTap: () => _openNextLesson(context, learnViewModel),
          ),
        ),
      ],
    );
  }

  // ── Section label ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textMain,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.25), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Prayer card ─────────────────────────────────────────────────────────────

  Widget _buildPrayerCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isDark
              ? Colors.white.withOpacity(0.06)
              : _divider.withOpacity(0.8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(_isDark ? 0.12 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _loadingPrayerTimes
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.secondary,
                  strokeWidth: 2,
                ),
              ),
            )
          : _prayerError.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: MyColors.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _prayerError,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: _textSub,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _loadPrayerTimes,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: MyColors.secondary.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: MyColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Next prayer highlight banner
                if (_nextPrayer != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MyColors.secondary, MyColors.primaryLight],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getPrayerIcon(_nextPrayer!),
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Prayer',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              _nextPrayer!,
                              style: GoogleFonts.sora(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          _prayerTimes?[_nextPrayer!] ?? '',
                          style: GoogleFonts.sora(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Prayer rows
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    children: (_prayerTimes ?? {}).entries.map((entry) {
                      final isNext = entry.key == _nextPrayer;
                      return _PrayerRow(
                        name: entry.key,
                        time: entry.value,
                        icon: _getPrayerIcon(entry.key),
                        isNext: isNext,
                        isDark: _isDark,
                        textMain: _textMain,
                        textHint: _textHint,
                        divider: _divider,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight_rounded;
      case 'Sunrise':
        return Icons.wb_sunny_rounded;
      case 'Dhuhr':
        return Icons.light_mode_rounded;
      case 'Asr':
        return Icons.cloud_rounded;
      case 'Maghrib':
        return Icons.nights_stay_rounded;
      case 'Isha':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  // ── Small 2-col action row ──────────────────────────────────────────────────

  Widget _buildSmallActionRow({required List<_ActionItem> items}) {
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: item == items.last ? 0 : 8),
                child: _ActionTile(
                  item: item,
                  isDark: _isDark,
                  cardBg: _cardBg,
                  textMain: _textMain,
                  textHint: _textHint,
                  divider: _divider,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Hadith cards ────────────────────────────────────────────────────────────

  Widget _buildHadithCards() {
    return Column(
      children: [
        _HadithNavCard(
          number: '40',
          arabicTitle: 'الأربعون النووية',
          englishTitle: 'Forty Hadith An-Nawawi',
          description: 'The classical collection by Imam An-Nawawi',
          accentColors: [MyColors.primary, MyColors.primaryLight],
          glowColor: MyColors.primaryLight,
          isDark: _isDark,
          cardBg: _cardBg,
          textMain: _textMain,
          textSub: _textSub,
          textHint: _textHint,
          divider: _divider,
          onTap: () => _push(const HadithAnNawawiView()),
        ),
        const SizedBox(height: 10),
        _HadithNavCard(
          number: '40',
          arabicTitle: 'الأحاديث القصيرة',
          englishTitle: 'Forty Short Hadith',
          description: 'Short hadith for easy memorization & practice',
          accentColors: [Color(0xFF005C4B), MyColors.tertiary],
          glowColor: MyColors.tertiary,
          isDark: _isDark,
          cardBg: _cardBg,
          textMain: _textMain,
          textSub: _textSub,
          textHint: _textHint,
          divider: _divider,
          onTap: () => _push(const HadithFortyShortView()),
        ),
      ],
    );
  }
}
