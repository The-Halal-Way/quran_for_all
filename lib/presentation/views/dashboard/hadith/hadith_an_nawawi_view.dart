import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_models.dart';

part '../../../widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_pages.dart';
part '../../../widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_jump_sheet.dart';
part '../../../widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_shared_widgets.dart';

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

  ColorScheme get _scheme => Theme.of(context).colorScheme;

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
        isDark: _scheme.brightness == Brightness.dark,
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
    return Scaffold(body: _loading ? _buildSplash() : _buildMain());
  }

  Widget _buildSplash() {
    final text = AppTheme.text(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArabicOrnament(color: MyColors.secondary, size: 64),
          const SizedBox(height: 24),
          Text(
            'الأربعون النووية',
            style: text.hadithLoadingArabicTitle.copyWith(
              color: MyColors.primaryLight,
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
    final responsive = AppResponsive.of(context);
    final isDark = _scheme.brightness == Brightness.dark;
    return Stack(
      children: [
        // Background decorative mesh
        _BackgroundMesh(isDark: isDark),
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
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: responsive.maxReadingContentWidth,
                        ),
                        child: _IntroPage(
                          book: book,
                          isBangla: _isBangla,
                          isDark: isDark,
                          cardBg: isDark ? _cardBg : Colors.white,
                          textMain: _textMain,
                          textSub: _textSub,
                          textHint: _textHint,
                          divider: _divider,
                        ),
                      ),
                    );
                  }
                  final hadith = book.hadiths[page - 1];
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive.maxReadingContentWidth,
                      ),
                      child: _HadithPage(
                        hadith: hadith,
                        isBangla: _isBangla,
                        isDark: isDark,
                        cardBg: isDark ? _cardBg : Colors.white,
                        textMain: _textMain,
                        textSub: _textSub,
                        textHint: _textHint,
                        divider: _divider,
                        totalCount: book.hadiths.length,
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomNav(book, isDark),
          ],
        ),
      ],
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(HadithBook book) {
    final text = AppTheme.text(context);
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
            colors: [_scheme.primary, _scheme.tertiary],
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
                    style: text.hadithHeaderArabicTitle.copyWith(
                      color: Colors.white.withOpacity(0.9),
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
                        style: text.hadithHeaderLabel.copyWith(
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      const Spacer(),
                      if (_currentIndex >= 0) ...[
                        Text(
                          '${_currentIndex + 1} / ${book.hadiths.length}',
                          style: text.hadithHeaderProgress.copyWith(
                            color: Colors.white.withOpacity(0.55),
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
          isDark: _scheme.brightness == Brightness.dark,
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

  Widget _buildBottomNav(HadithBook book, bool isDark) {
    final text = AppTheme.text(context);
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
        color: isDark ? _cardBg : Colors.white,
        border: Border(top: BorderSide(color: _divider, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: _scheme.primary.withValues(alpha: 0.16),
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
            isDark: _scheme.brightness == Brightness.dark,
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
                          : _scheme.surfaceContainer,
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
                    style: text.hadithBottomIntro.copyWith(
                      color: _currentIndex == -1
                          ? MyColors.secondary
                          : _textHint,
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
            isDark: _scheme.brightness == Brightness.dark,
            isRight: true,
            onTap: canNext ? () => _goToIndex(_currentIndex + 1) : null,
          ),
        ],
      ),
    );
  }
}
