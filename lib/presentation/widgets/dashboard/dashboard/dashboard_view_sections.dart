part of '../../../views/dashboard/dashboard_view.dart';

extension _DashboardViewStateSections on _DashboardViewState {
  // ── Greeting header ─────────────────────────────────────────────────────────

  Widget _buildGreetingHeader() {
    final text = AppTheme.text(context);
    final headerInfo = _dashboardViewModel.headerInfo(
      context.l10n,
      DateTime.now(),
    );

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
                      style: text.dashboardBismillah.copyWith(color: _textMain),
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
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: MyColors.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              headerInfo.greeting,
              style: text.dashboardEyebrow.copyWith(color: _textHint),
            ),
            Spacer(),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: MyColors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_rounded, size: 12, color: _textHint),
                const SizedBox(width: 5),
                Text(
                  headerInfo.dateLabel,
                  style: text.dashboardDate.copyWith(color: _textHint),
                ),
              ],
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
    final cardsInfo = _dashboardViewModel.continueCardsInfo(
      l10n: context.l10n,
      readViewModel: readViewModel,
      learnViewModel: learnViewModel,
    );

    return Row(
      children: [
        Expanded(
          child: ContinueCard(
            title: context.l10n.dashboardContinueReadingTitle,
            subtitle: cardsInfo.reading.subtitle,
            detail: cardsInfo.reading.detail,
            arabicSnippet: 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ',
            gradientColors: [MyColors.primary, MyColors.primaryLight],
            glowColor: MyColors.primaryLight,
            icon: Icons.auto_stories_rounded,
            isDark: _isDark,
            onTap: cardsInfo.reading.hasExistingProgress
                ? () => unawaited(
                    _openSurah(
                      context,
                      cardsInfo.reading.surah!,
                      initialAyahNumber: cardsInfo.reading.ayahNumber,
                    ),
                  )
                : () => _push(const ReadQuranView()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ContinueCard(
            title: context.l10n.dashboardContinueLearningTitle,
            subtitle: cardsInfo.learning.subtitle,
            detail: cardsInfo.learning.detail,
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
    final text = AppTheme.text(context);

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
          style: text.dashboardSectionTitle.copyWith(color: _textMain),
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
    final text = AppTheme.text(context);

    return InkWell(
      onTap: () {
        //if (_loadingPrayerTimes || _prayerError.isNotEmpty) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerView()),
        );
      },
      child: Container(
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
                            style: text.bodySmall.copyWith(color: _textSub),
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
                          context.l10n.dashboardRetry,
                          style: text.labelMedium.copyWith(
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
                              _dashboardViewModel.prayerIcon(_nextPrayer!),
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.dashboardNextPrayer,
                                style: text.dashboardCardEyebrow.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                _dashboardViewModel.localizedPrayerName(
                                  context.l10n,
                                  _nextPrayer!,
                                ),
                                style: text.dashboardNextPrayerName.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            _prayerTimes?[_nextPrayer!] ?? '',
                            style: text.dashboardNextPrayerTime.copyWith(
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
                        return PrayerRow(
                          name: _dashboardViewModel.localizedPrayerName(
                            context.l10n,
                            entry.key,
                          ),
                          time: _prayerTimeRanges?[entry.key] ?? entry.value,
                          icon: _dashboardViewModel.prayerIcon(entry.key),
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
      ),
    );
  }

  // ── Small 2-col action row ──────────────────────────────────────────────────

  Widget _buildSmallActionRow({required List<DashboardActionItem> items}) {
    final rows = <Widget>[];

    for (var start = 0; start < items.length; start += 2) {
      final rowItems = items.skip(start).take(2).toList();
      rows.add(
        Row(
          children: List.generate(rowItems.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == rowItems.length - 1 ? 0 : 8,
                ),
                child: ActionTile(
                  item: rowItems[index],
                  isDark: _isDark,
                  cardBg: _cardBg,
                  textMain: _textMain,
                  textHint: _textHint,
                  divider: _divider,
                ),
              ),
            );
          }),
        ),
      );

      if (start + 2 < items.length) {
        rows.add(const SizedBox(height: 8));
      }
    }

    return Column(children: rows);
  }

  // ── Hadith cards ────────────────────────────────────────────────────────────

  Widget _buildHadithCards() {
    final responsive = AppResponsive.of(context);
    final cards = <Widget>[
      HadithNavCard(
        number: '40',
        arabicTitle: 'الأربعون النووية',
        englishTitle: context.l10n.dashboardHadithAnNawawiTitle,
        description: context.l10n.dashboardHadithAnNawawiDescription,
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
      HadithNavCard(
        number: '40',
        arabicTitle: 'الأحاديث القصيرة',
        englishTitle: context.l10n.dashboardHadithShortTitle,
        description: context.l10n.dashboardHadithShortDescription,
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
    ];

    if (responsive.isMobile) {
      return Column(
        children: [
          cards.first,
          SizedBox(height: 10.h),
          cards.last,
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: responsive.isDesktop ? 2.35 : 2.1,
      ),
      itemBuilder: (context, index) => cards[index],
    );
  }
}
