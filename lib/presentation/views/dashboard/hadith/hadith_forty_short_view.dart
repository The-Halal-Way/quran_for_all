import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

part '../../../widgets/dashobard/hadith/hadith_forty_short/hadith_forty_short_models.dart';
part '../../../widgets/dashobard/hadith/hadith_forty_short/hadith_forty_short_pages.dart';
part '../../../widgets/dashobard/hadith/hadith_forty_short/hadith_forty_short_jump_sheet.dart';
part '../../../widgets/dashobard/hadith/hadith_forty_short/hadith_forty_short_shared_widgets.dart';

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
        isDark: _scheme.brightness == Brightness.dark,
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
            color: _textHint,
          ),
        ),
      ],
    ),
  );

  Widget _buildBody() {
    final book = _book!;
    final responsive = AppResponsive.of(context);

    return FadeTransition(
      opacity: _fadeIn,
      child: Stack(
        children: [
          _TileBackground(isDark: _scheme.brightness == Brightness.dark),
          Column(
            children: [
              _buildHeader(book),
              _buildProgressBar(book),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemCount: book.hadiths.length,
                  itemBuilder: (_, i) => Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive.maxReadingContentWidth,
                      ),
                      child: _ShortHadithPage(
                        hadith: book.hadiths[i],
                        isBangla: _isBangla,
                        isDark: _scheme.brightness == Brightness.dark,
                        cardBg: _cardBg,
                        textMain: _textMain,
                        textSub: _textSub,
                        textHint: _textHint,
                        divider: _dividerClr,
                        totalCount: book.hadiths.length,
                      ),
                    ),
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
        gradient: LinearGradient(
          colors: [_scheme.primary, _scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _scheme.primary.withValues(alpha: 0.2),
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
      color: _scheme.surfaceContainer,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 4,
                color: _scheme.outlineVariant.withValues(alpha: 0.55),
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
        isDark: _scheme.brightness == Brightness.dark,
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
        color: _scheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: _dividerClr, width: 0.8)),
      ),
      child: Row(
        children: [
          _BarNavBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            label: _isBangla ? 'পূর্ববর্তী' : 'Prev',
            enabled: canPrev,
            isDark: _scheme.brightness == Brightness.dark,
            textMain: _textMain,
            textHint: _textHint,
            onTap: canPrev ? () => _goTo(_currentIndex - 1) : null,
          ),

          // Dot indicators (max 10 visible, scrolling window)
          Expanded(
            child: _DotRow(
              total: book.hadiths.length,
              current: _currentIndex,
              isDark: _scheme.brightness == Brightness.dark,
            ),
          ),

          _BarNavBtn(
            icon: Icons.arrow_forward_ios_rounded,
            label: _isBangla ? 'পরবর্তী' : 'Next',
            enabled: canNext,
            isDark: _scheme.brightness == Brightness.dark,
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
