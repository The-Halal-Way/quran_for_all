// hadith_screen.dart
// Forty Hadith of An-Nawawi — Full UI Implementation
// Requires: google_fonts, flutter_screenutil
// Assets: forty_hadith_of_an_nawawi.json in assets/

import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class HadithBook {
  final String title;
  final HadithIntro introduction;
  final List<Hadith> hadiths;

  const HadithBook({
    required this.title,
    required this.introduction,
    required this.hadiths,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) => HadithBook(
    title: json['title'] as String,
    introduction: HadithIntro.fromJson(
      json['introduction'] as Map<String, dynamic>,
    ),
    hadiths: (json['hadiths'] as List)
        .map((e) => Hadith.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class HadithIntro {
  final String english;
  final String bangla;
  const HadithIntro({required this.english, required this.bangla});
  factory HadithIntro.fromJson(Map<String, dynamic> json) => HadithIntro(
    english: json['english'] as String,
    bangla: json['bangla'] as String,
  );
}

class Hadith {
  final int id;
  final String arabic;
  final String bangla;
  final String english;
  const Hadith({
    required this.id,
    required this.arabic,
    required this.bangla,
    required this.english,
  });
  factory Hadith.fromJson(Map<String, dynamic> json) => Hadith(
    id: json['id'] as int,
    arabic: json['arabic'] as String,
    bangla: json['bangla'] as String,
    english: json['english'] as String,
  );
}

class HadithAnNawawiView extends StatefulWidget {
  const HadithAnNawawiView({super.key});
  @override
  State<HadithAnNawawiView> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithAnNawawiView>
    with TickerProviderStateMixin {
  HadithBook? _book;
  bool _loading = true;
  bool _isBangla = false;
  int _currentIndex = -1; // -1 = intro page

  late final PageController _pageController;
  late final AnimationController _fabAnim;
  late final AnimationController _headerAnim;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString(
      'assets/json/forty_hadith_of_an_nawawi.json',
    );
    final book = HadithBook.fromJson(json.decode(raw) as Map<String, dynamic>);
    if (mounted) {
      setState(() {
        _book = book;
        _loading = false;
      });
      _headerAnim.forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnim.dispose();
    _headerAnim.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  ColorScheme get _scheme => Theme.of(context).colorScheme;

  Color get _scaffoldBg => _scheme.surface;
  Color get _cardBg => _scheme.surfaceContainer;
  Color get _textMain => _scheme.onSurface;
  Color get _textSub => _scheme.onSurfaceVariant;
  Color get _textHint => _scheme.onSurfaceVariant.withValues(alpha: 0.78);
  Color get _divider => _scheme.outlineVariant;

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _goToIndex(int index) {
    setState(() => _currentIndex = index);
    // index -1 = intro (page 0); hadith index maps to page index+1
    final page = index + 1;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  // ── Jump sheet ─────────────────────────────────────────────────────────────

  final _jumpController = TextEditingController();

  void _openJumpDialog() {
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
        divider: _divider,
        controller: _jumpController,
        onJump: (idx) => _goToIndex(idx),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: _scaffoldBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _loading ? _buildSplash() : _buildMain(),
      ),
    );
  }

  Widget _buildSplash() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArabicOrnament(color: MyColors.secondary, size: 64),
          const SizedBox(height: 24),
          Text(
            'الأربعون النووية',
            style: GoogleFonts.amiri(
              fontSize: 28,
              color: MyColors.primaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CircularProgressIndicator(color: MyColors.secondary, strokeWidth: 2),
        ],
      ),
    );
  }

  Widget _buildMain() {
    final book = _book!;
    return Stack(
      children: [
        // Background decorative mesh
        _BackgroundMesh(isDark: _isDark),
        // Main paged content
        Column(
          children: [
            _buildHeader(book),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentIndex = page - 1);
                },
                itemCount: book.hadiths.length + 1, // +1 for intro
                itemBuilder: (ctx, page) {
                  if (page == 0) {
                    return _IntroPage(
                      book: book,
                      isBangla: _isBangla,
                      isDark: _isDark,
                      cardBg: _cardBg,
                      textMain: _textMain,
                      textSub: _textSub,
                      textHint: _textHint,
                      divider: _divider,
                    );
                  }
                  final hadith = book.hadiths[page - 1];
                  return _HadithPage(
                    hadith: hadith,
                    isBangla: _isBangla,
                    isDark: _isDark,
                    cardBg: _cardBg,
                    textMain: _textMain,
                    textSub: _textSub,
                    textHint: _textHint,
                    divider: _divider,
                    totalCount: book.hadiths.length,
                  );
                },
              ),
            ),
            _buildBottomNav(book),
          ],
        ),
      ],
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(HadithBook book) {
    final topPad = MediaQuery.of(context).padding.top;
    final label = _currentIndex == -1
        ? (_isBangla ? 'ভূমিকা' : 'Introduction')
        : '${_isBangla ? 'হাদিস' : 'Hadith'} ${book.hadiths[_currentIndex].id}';

    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) => Opacity(opacity: _headerAnim.value, child: child),
      child: Container(
        padding: EdgeInsets.only(top: topPad, bottom: 5, right: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDark
                ? [
                    MyColors.darkScaffold,
                    MyColors.darkSurface.withOpacity(0.95),
                  ]
                : [MyColors.primary, MyColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // backbutton
            _buildBackButton(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '40 Hadith of An-Nawawi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.amiri(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: MyColors.secondaryLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      if (_currentIndex >= 0) ...[
                        Text(
                          '${_currentIndex + 1} / ${book.hadiths.length}',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 12.h),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Top-right controls
            _buildControls(),
          ],
        ),
      ),
    );
  }

  // ── Top-right controls ─────────────────────────────────────────────────────

  Widget _buildControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Language toggle
        _PillToggle(
          leftLabel: 'EN',
          rightLabel: 'বাং',
          isRight: _isBangla,
          isDark: _isDark,
          onChanged: (v) => setState(() => _isBangla = v),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _openJumpDialog,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(9),
            child: Image.asset(MyIcons.searchIcon, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
    );
  }

  // ── Bottom navigation ──────────────────────────────────────────────────────

  Widget _buildBottomNav(HadithBook book) {
    final canPrev = _currentIndex > -1;
    final canNext = _currentIndex < book.hadiths.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: _isDark
            ? MyColors.darkCard.withOpacity(0.95)
            : MyColors.cardFill.withOpacity(0.97),
        border: Border(top: BorderSide(color: _divider, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(_isDark ? 0.30 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Prev button
          _NavButton(
            icon: Icons.arrow_back_ios_new_rounded,
            label: _isBangla ? 'পূর্ববর্তী' : 'Prev',
            enabled: canPrev,
            isDark: _isDark,
            onTap: canPrev ? () => _goToIndex(_currentIndex - 1) : null,
          ),

          // Center: intro button
          Expanded(
            child: GestureDetector(
              onTap: () => _goToIndex(-1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _currentIndex == -1
                          ? const LinearGradient(
                              colors: [
                                MyColors.secondary,
                                MyColors.primaryLight,
                              ],
                            )
                          : null,
                      color: _currentIndex == -1
                          ? null
                          : (_isDark
                                ? MyColors.darkSurface
                                : MyColors.divider.withOpacity(0.5)),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 18,
                      color: _currentIndex == -1 ? Colors.white : _textHint,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isBangla ? 'ভূমিকা' : 'Intro',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: _currentIndex == -1
                          ? MyColors.secondary
                          : _textHint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Next button
          _NavButton(
            icon: Icons.arrow_forward_ios_rounded,
            label: _isBangla ? 'পরবর্তী' : 'Next',
            enabled: canNext,
            isDark: _isDark,
            isRight: true,
            onTap: canNext ? () => _goToIndex(_currentIndex + 1) : null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INTRO PAGE
// ─────────────────────────────────────────────────────────────────────────────

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

class _JumpSheet extends StatefulWidget {
  final HadithBook book;
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

  // Intro is index -1; hadiths are 0-based indices
  // We show intro as the first item, then all hadiths
  List<_JumpItem> get _allItems {
    final intro = _JumpItem(
      index: -1,
      arabic: 'مقدمة',
      label: widget.isBangla ? 'ভূমিকা' : 'Introduction',
      sub: widget.isBangla ? 'গ্রন্থের ভূমিকা' : 'Preface of the book',
    );
    final hadiths = widget.book.hadiths.asMap().entries.map((e) {
      final h = e.value;
      return _JumpItem(
        index: e.key,
        arabic: h.arabic.split('\n').first,
        label: '${widget.isBangla ? 'হাদিস' : 'Hadith'} ${h.id}',
        sub: widget.isBangla
            ? h.bangla.split('\n').first
            : h.english.split('\n').first,
      );
    }).toList();
    return [intro, ...hadiths];
  }

  List<_JumpItem> get _filtered {
    if (_query.isEmpty) return _allItems;
    final q = _query.toLowerCase();
    return _allItems.where((item) {
      return item.label.toLowerCase().contains(q) ||
          item.sub.toLowerCase().contains(q) ||
          item.arabic.contains(q) ||
          (item.index >= 0 &&
              '${widget.book.hadiths[item.index].id}'.contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: MyColors.secondary.withOpacity(0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(0.3),
            blurRadius: 32,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
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
                      colors: [MyColors.secondary, MyColors.primaryLight],
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
                  color: MyColors.secondary,
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
                    color: MyColors.secondary,
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
                final item = _filtered[i];
                return _JumpListTile(
                  item: item,
                  isBangla: widget.isBangla,
                  isDark: widget.isDark,
                  textMain: widget.textMain,
                  textHint: widget.textHint,
                  divider: widget.divider,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onJump(item.index);
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

class _JumpItem {
  final int index; // -1 = intro
  final String arabic;
  final String label;
  final String sub;
  const _JumpItem({
    required this.index,
    required this.arabic,
    required this.label,
    required this.sub,
  });
}

class _JumpListTile extends StatelessWidget {
  final _JumpItem item;
  final bool isBangla, isDark;
  final Color textMain, textHint, divider;
  final VoidCallback onTap;

  const _JumpListTile({
    required this.item,
    required this.isBangla,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIntro = item.index == -1;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: isIntro
                    ? MyColors.secondary.withOpacity(0.1)
                    : MyColors.primaryLight.withOpacity(0.1),
                border: Border.all(
                  color: isIntro
                      ? MyColors.secondary.withOpacity(0.25)
                      : MyColors.primaryLight.withOpacity(0.2),
                  width: 0.8,
                ),
              ),
              alignment: Alignment.center,
              child: isIntro
                  ? Icon(
                      Icons.menu_book_rounded,
                      size: 16,
                      color: MyColors.secondary,
                    )
                  : Text(
                      '${item.index + 1}',
                      style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: MyColors.primaryLight,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.arabic,
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
                    item.sub,
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
// REUSABLE COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

/// Pill-shaped language toggle
class _PillToggle extends StatelessWidget {
  final String leftLabel, rightLabel;
  final bool isRight, isDark;
  final ValueChanged<bool> onChanged;

  const _PillToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.isRight,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isRight),
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
          color: isDark
              ? MyColors.darkCard.withOpacity(0.9)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PillOption(label: leftLabel, active: !isRight),
              _PillOption(label: rightLabel, active: isRight),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String label;
  final bool active;
  const _PillOption({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.white.withOpacity(0.9) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: active ? MyColors.primary : Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}

/// Glass-like card with optional accent bar
class _GlassCard extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color? accentColor;
  final Widget child;

  const _GlassCard({
    required this.isDark,
    required this.cardBg,
    this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : MyColors.divider.withOpacity(0.8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(isDark ? 0.15 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Stat chip
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final bool isDark;
  final Color cardBg, textMain, textHint;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : MyColors.divider.withOpacity(0.7),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.1 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: MyColors.secondary),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textMain,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation button
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled, isDark;
  final bool isRight;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.isDark,
    this.isRight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? MyColors.secondary
        : (isDark ? MyColors.darkTextTertiary : MyColors.textTertiary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isRight) Icon(icon, color: color, size: 16),
          if (!isRight) const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (isRight) const SizedBox(width: 6),
          if (isRight) Icon(icon, color: color, size: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DECORATIVE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// Geometric Islamic-style ornament (pure CustomPaint, no image needed)
class _ArabicOrnament extends StatelessWidget {
  final Color color;
  final double size;
  const _ArabicOrnament({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _OrnamentPainter(color: color),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  final Color color;
  const _OrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Outer octagon
    _drawPolygon(canvas, paint, center, r * 0.95, 8, -math.pi / 8);
    // Inner octagon (rotated)
    _drawPolygon(canvas, paint, center, r * 0.65, 8, math.pi / 8);
    // Star lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) - math.pi / 8;
      final p1 = Offset(
        center.dx + math.cos(angle) * r * 0.65,
        center.dy + math.sin(angle) * r * 0.65,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * r * 0.95,
        center.dy + math.sin(angle) * r * 0.95,
      );
      canvas.drawLine(p1, p2, paint);
    }
    // Center circle
    canvas.drawCircle(center, r * 0.18, paint);
  }

  void _drawPolygon(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius,
    int sides,
    double startAngle,
  ) {
    final path = Path();
    for (int i = 0; i <= sides; i++) {
      final angle = startAngle + (i * math.pi * 2 / sides);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0)
        path.moveTo(point.dx, point.dy);
      else
        path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OrnamentPainter old) => old.color != color;
}

/// Subtle animated background mesh
class _BackgroundMesh extends StatelessWidget {
  final bool isDark;
  const _BackgroundMesh({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _MeshPainter(isDark: isDark)),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final bool isDark;
  const _MeshPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()
    //   ..color = (isDark ? MyColors.primaryLight : MyColors.primary).withOpacity(
    //     isDark ? 0.04 : 0.03,
    //   )
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 0.5;

    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        final ornPaint = Paint()
          ..color = (isDark ? MyColors.secondary : MyColors.primaryLight)
              .withOpacity(isDark ? 0.04 : 0.025)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4;
        final center = Offset(x, y);
        _drawOctagon(canvas, ornPaint, center, 16);
      }
    }
  }

  void _drawOctagon(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    for (int i = 0; i <= 8; i++) {
      final angle = (i * math.pi * 2 / 8) - math.pi / 8;
      final point = Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      );
      if (i == 0)
        path.moveTo(point.dx, point.dy);
      else
        path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshPainter old) => old.isDark != isDark;
}
