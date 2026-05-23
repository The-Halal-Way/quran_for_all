// hadith_forty_short_view.dart
// 40 Short Hadith — Easy to Learn, Memorize & Act Upon
// Requires: google_fonts
// Assets: forty_short_hadith.json in assets/

import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class ShortHadithBook {
  final String titleEnglish;
  final String titleBangla;
  final String compiledByEnglish;
  final String compiledByBangla;
  final List<ShortHadith> hadiths;

  const ShortHadithBook({
    required this.titleEnglish,
    required this.titleBangla,
    required this.compiledByEnglish,
    required this.compiledByBangla,
    required this.hadiths,
  });

  factory ShortHadithBook.fromJson(Map<String, dynamic> json) =>
      ShortHadithBook(
        titleEnglish: json['title_english'] as String,
        titleBangla: json['title_bangla'] as String,
        compiledByEnglish: json['compiled_by_english'] as String,
        compiledByBangla: json['compiled_by_bangla'] as String,
        hadiths: (json['hadiths'] as List)
            .map((e) => ShortHadith.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class ShortHadith {
  final int id;
  final String title;
  final String arabic;
  final String english;
  final String bangla;

  const ShortHadith({
    required this.id,
    required this.title,
    required this.arabic,
    required this.english,
    required this.bangla,
  });

  factory ShortHadith.fromJson(Map<String, dynamic> json) => ShortHadith(
    id: json['id'] as int,
    title: json['title'] as String,
    arabic: json['arabic'] as String,
    english: json['english'] as String,
    bangla: json['bangla'] as String,
  );

  /// First line is the headline; rest are bullet points
  String headlineOf(bool isBangla) {
    final text = isBangla ? bangla : english;
    return text.split('\n').first.trim();
  }

  List<String> bulletsOf(bool isBangla) {
    final text = isBangla ? bangla : english;
    final lines = text.split('\n');
    return lines
        .skip(1)
        .where((l) => l.trim().isNotEmpty)
        .map((l) => l.trim())
        .toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class HadithFortyShortView extends StatefulWidget {
  const HadithFortyShortView({super.key});

  @override
  State<HadithFortyShortView> createState() => _HadithFortyShortViewState();
}

class _HadithFortyShortViewState extends State<HadithFortyShortView>
    with TickerProviderStateMixin {
  ShortHadithBook? _book;
  bool _loading = true;

  bool _isBangla = false;
  int _currentIndex = 0; // 0-based index into hadiths list

  late final PageController _pageController;
  late final AnimationController _fadeIn;

  // For the jump sheet
  final _jumpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString(
      'assets/json/forty_short_hadith.json',
    );
    final book = ShortHadithBook.fromJson(
      json.decode(raw) as Map<String, dynamic>,
    );
    if (mounted) {
      setState(() {
        _book = book;
        _loading = false;
      });
      _fadeIn.forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeIn.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  ColorScheme get _scheme => Theme.of(context).colorScheme;

  Color get _scaffoldBg => _scheme.surface;
  Color get _cardBg => _scheme.surfaceContainer;
  Color get _textMain => _scheme.onSurface;
  Color get _textSub => _scheme.onSurfaceVariant;
  Color get _textHint => _scheme.onSurfaceVariant.withValues(alpha: 0.78);
  Color get _dividerClr => _scheme.outlineVariant;

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showJumpSheet() {
    if (_book == null) return;
    _jumpController.clear();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JumpSheet(
        book: _book!,
        isDark: _isDark,
        isBangla: _isBangla,
        cardBg: _cardBg,
        textMain: _textMain,
        textHint: _textHint,
        divider: _dividerClr,
        controller: _jumpController,
        onJump: (idx) => _goTo(idx),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _scaffoldBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _loading ? _buildSplash() : _buildBody(),
      ),
    );
  }

  Widget _buildSplash() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GeomStar(color: MyColors.tertiary, size: 56),
        const SizedBox(height: 20),
        Text(
          'Loading...',
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: MyColors.darkTextSecondary,
          ),
        ),
      ],
    ),
  );

  Widget _buildBody() {
    final book = _book!;

    return FadeTransition(
      opacity: _fadeIn,
      child: Stack(
        children: [
          _TileBackground(isDark: _isDark),
          Column(
            children: [
              _buildHeader(book),
              _buildProgressBar(book),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemCount: book.hadiths.length,
                  itemBuilder: (_, i) => _ShortHadithPage(
                    hadith: book.hadiths[i],
                    isBangla: _isBangla,
                    isDark: _isDark,
                    cardBg: _cardBg,
                    textMain: _textMain,
                    textSub: _textSub,
                    textHint: _textHint,
                    divider: _dividerClr,
                    totalCount: book.hadiths.length,
                  ),
                ),
              ),
              _buildBottomBar(book),
            ],
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(ShortHadithBook book) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: topPad, bottom: 5, right: 5),
      decoration: BoxDecoration(
        gradient: _isDark
            ? const LinearGradient(
                colors: [Color(0xFF251B52), Color(0xFF0A5C54)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF05645B), Color(0xFF8A2B67)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(_isDark ? 0.38 : 0.16),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBackButton(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isBangla ? book.titleBangla : book.titleEnglish,
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isBangla
                          ? book.compiledByBangla
                          : book.compiledByEnglish,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.76),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildControls(),
            ],
          ),
        ],
      ),
    );
  }

  // ── Progress bar ───────────────────────────────────────────────────────────

  Widget _buildProgressBar(ShortHadithBook book) {
    final progress = (_currentIndex + 1) / book.hadiths.length;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: _isDark ? MyColors.darkSurface : MyColors.cardFill,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 4,
                color: _isDark
                    ? Colors.white.withOpacity(0.1)
                    : MyColors.divider.withOpacity(0.55),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MyColors.tertiary, MyColors.secondaryLight],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${_currentIndex + 1}/${book.hadiths.length}',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _textHint,
            ),
          ),
        ],
      ),
    );
  }

  // ── Controls ───────────────────────────────────────────────────────────────

  Widget _buildControls() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _LangToggle(
        isBangla: _isBangla,
        isDark: _isDark,
        onChanged: (v) => setState(() => _isBangla = v),
      ),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: _showJumpSheet,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.8,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(MyIcons.searchIcon, color: Colors.white),
        ),
      ),
    ],
  );

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
      tooltip: 'Back',
    );
  }

  // ── Bottom bar ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar(ShortHadithBook book) {
    final canPrev = _currentIndex > 0;
    final canNext = _currentIndex < book.hadiths.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: _isDark
            ? MyColors.darkCard.withOpacity(0.97)
            : MyColors.cardFill,
        border: Border(top: BorderSide(color: _dividerClr, width: 0.8)),
      ),
      child: Row(
        children: [
          _BarNavBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            label: _isBangla ? 'পূর্ববর্তী' : 'Prev',
            enabled: canPrev,
            isDark: _isDark,
            textMain: _textMain,
            textHint: _textHint,
            onTap: canPrev ? () => _goTo(_currentIndex - 1) : null,
          ),

          // Dot indicators (max 10 visible, scrolling window)
          Expanded(
            child: _DotRow(
              total: book.hadiths.length,
              current: _currentIndex,
              isDark: _isDark,
            ),
          ),

          _BarNavBtn(
            icon: Icons.arrow_forward_ios_rounded,
            label: _isBangla ? 'পরবর্তী' : 'Next',
            enabled: canNext,
            isDark: _isDark,
            textMain: _textMain,
            textHint: _textHint,
            isRight: true,
            onTap: canNext ? () => _goTo(_currentIndex + 1) : null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HADITH PAGE
// ─────────────────────────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
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
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: MyColors.tertiaryLight,
                            letterSpacing: 1.2,
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
                  style: GoogleFonts.amiri(
                    fontSize: 30,
                    height: 1.8,
                    color: Colors.white.withOpacity(0.97),
                    fontWeight: FontWeight.bold,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MyColors.secondary.withOpacity(isDark ? 0.18 : 0.12),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.secondary.withOpacity(isDark ? 0.08 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
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
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textMain,
                height: 1.4,
                letterSpacing: -0.2,
              ),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : divider.withOpacity(0.8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(isDark ? 0.12 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
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
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: MyColors.tertiary,
                        letterSpacing: 0.8,
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
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _bulletColor(idx),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.manrope(
                        fontSize: isBangla ? 14.5 : 13.5,
                        height: isBangla ? 1.75 : 1.6,
                        color: textSub,
                      ),
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

class _JumpSheet extends StatefulWidget {
  final ShortHadithBook book;
  final bool isDark, isBangla;
  final Color cardBg, textMain, textHint, divider;
  final TextEditingController controller;
  final void Function(int index) onJump;

  const _JumpSheet({
    required this.book,
    required this.isDark,
    required this.isBangla,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
    required this.divider,
    required this.controller,
    required this.onJump,
  });

  @override
  State<_JumpSheet> createState() => _JumpSheetState();
}

class _JumpSheetState extends State<_JumpSheet> {
  String _query = '';

  List<ShortHadith> get _filtered {
    if (_query.isEmpty) return widget.book.hadiths;
    final q = _query.toLowerCase();
    return widget.book.hadiths.where((h) {
      final id = '${h.id}';
      final eng = h.english.toLowerCase();
      final ban = h.bangla;
      return id.contains(q) || eng.contains(q) || ban.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: MyColors.tertiary.withOpacity(0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(0.25),
            blurRadius: 32,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: widget.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [MyColors.tertiary, MyColors.tertiaryLight],
                    ),
                  ),
                  child: const Icon(
                    Icons.format_list_numbered_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.isBangla ? 'হাদিসে যান' : 'Jump to Hadith',
                  style: GoogleFonts.sora(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: widget.textMain,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.book.hadiths.length} hadiths',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: widget.textHint,
                  ),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: widget.controller,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              style: GoogleFonts.manrope(fontSize: 14, color: widget.textMain),
              decoration: InputDecoration(
                hintText: widget.isBangla
                    ? 'নম্বর বা কীওয়ার্ড দিয়ে খুঁজুন...'
                    : 'Search by number or keyword...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 13,
                  color: widget.textHint,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MyColors.tertiary,
                  size: 20,
                ),
                filled: true,
                fillColor: widget.isDark
                    ? MyColors.darkSurface.withOpacity(0.6)
                    : MyColors.divider.withOpacity(0.25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: MyColors.tertiary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          Divider(height: 1, color: widget.divider),

          // List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8, bottom: bottomPad + 16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final h = _filtered[i];
                final idx = widget.book.hadiths.indexOf(h);
                return _JumpListTile(
                  hadith: h,
                  isBangla: widget.isBangla,
                  isDark: widget.isDark,
                  textMain: widget.textMain,
                  textHint: widget.textHint,
                  divider: widget.divider,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onJump(idx);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _JumpListTile extends StatelessWidget {
  final ShortHadith hadith;
  final bool isBangla, isDark;
  final Color textMain, textHint, divider;
  final VoidCallback onTap;

  const _JumpListTile({
    required this.hadith,
    required this.isBangla,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final headline = hadith.headlineOf(isBangla);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.tertiary.withOpacity(0.1),
                border: Border.all(
                  color: MyColors.tertiary.withOpacity(0.25),
                  width: 0.8,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${hadith.id}',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: MyColors.tertiary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hadith.arabic,
                    textDirection: ui.TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 15,
                      color: textMain,
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    headline,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: textHint,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: textHint),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOT ROW INDICATOR
// ─────────────────────────────────────────────────────────────────────────────

class _DotRow extends StatelessWidget {
  final int total, current;
  final bool isDark;

  const _DotRow({
    required this.total,
    required this.current,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Show a sliding window of 7 dots max
    const visible = 7;
    final half = visible ~/ 2;
    int start = (current - half).clamp(0, math.max(0, total - visible));
    final end = (start + visible).clamp(0, total);
    start = (end - visible).clamp(0, total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(end - start, (i) {
        final idx = start + i;
        final isActive = idx == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive
                ? MyColors.tertiary
                : (isDark ? Colors.white.withOpacity(0.15) : MyColors.divider),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE SMALL COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _LangToggle extends StatelessWidget {
  final bool isBangla, isDark;
  final ValueChanged<bool> onChanged;

  const _LangToggle({
    required this.isBangla,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isBangla),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.8),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangOption(label: 'EN', active: !isBangla, isDark: isDark),
            _LangOption(label: 'বাং', active: isBangla, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final bool active, isDark;
  const _LangOption({
    required this.label,
    required this.active,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? MyColors.tertiary : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: active ? Colors.white : Colors.white.withOpacity(0.82),
        ),
      ),
    );
  }
}

class _BarNavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled, isDark, isRight;
  final Color textMain, textHint;
  final VoidCallback? onTap;

  const _BarNavBtn({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    this.isRight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? MyColors.tertiary : textHint;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isRight) Icon(icon, size: 15, color: color),
          if (!isRight) const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (isRight) const SizedBox(width: 5),
          if (isRight) Icon(icon, size: 15, color: color),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DECORATIVE PAINTERS
// ─────────────────────────────────────────────────────────────────────────────

/// 6-pointed star ornament
class _GeomStar extends StatelessWidget {
  final Color color;
  final double size;
  const _GeomStar({required this.color, required this.size});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(size, size),
    painter: _StarPainter(color: color),
  );
}

class _StarPainter extends CustomPainter {
  final Color color;
  const _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.028
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer hexagon
    _polygon(canvas, paint, cx, cy, r * 0.92, 6, -math.pi / 2);
    // Inner hexagon (rotated)
    _polygon(canvas, paint, cx, cy, r * 0.55, 6, math.pi / 6);
    // Star spokes
    for (int i = 0; i < 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      canvas.drawLine(
        Offset(cx + math.cos(a) * r * 0.55, cy + math.sin(a) * r * 0.55),
        Offset(cx + math.cos(a) * r * 0.92, cy + math.sin(a) * r * 0.92),
        paint,
      );
    }
    // Center dot
    canvas.drawCircle(Offset(cx, cy), r * 0.12, paint);
  }

  void _polygon(
    Canvas c,
    Paint p,
    double cx,
    double cy,
    double r,
    int n,
    double start,
  ) {
    final path = Path();
    for (int i = 0; i <= n; i++) {
      final a = start + i * math.pi * 2 / n;
      final pt = Offset(cx + math.cos(a) * r, cy + math.sin(a) * r);
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}

/// Subtle tiling background
class _TileBackground extends StatelessWidget {
  final bool isDark;
  const _TileBackground({required this.isDark});

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: CustomPaint(painter: _TilePainter(isDark: isDark)),
    ),
  );
}

class _TilePainter extends CustomPainter {
  final bool isDark;
  const _TilePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.tertiary : MyColors.primaryLight)
          .withOpacity(isDark ? 0.035 : 0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const step = 52.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _hexagon(canvas, paint, Offset(x, y), 14);
      }
    }
  }

  void _hexagon(Canvas c, Paint p, Offset center, double r) {
    final path = Path();
    for (int i = 0; i <= 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      final pt = Offset(
        center.dx + math.cos(a) * r,
        center.dy + math.sin(a) * r,
      );
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_TilePainter old) => old.isDark != isDark;
}
