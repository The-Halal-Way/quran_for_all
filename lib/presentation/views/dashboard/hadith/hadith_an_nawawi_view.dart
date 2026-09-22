import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/common/app_premium_page_background.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_collection_palette.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_bottom_bar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_header.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_language_builder.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_loading.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_progress.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_models.dart';

part '../../../widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_pages.dart';
part '../../../widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_jump_sheet.dart';
part '../../../widgets/dashboard/hadith/hadith_an_nawawi/hadith_an_nawawi_shared_widgets.dart';

class HadithAnNawawiView extends StatefulWidget {
  const HadithAnNawawiView({super.key});

  @override
  State<HadithAnNawawiView> createState() => _HadithAnNawawiViewState();
}

class _HadithAnNawawiViewState extends State<HadithAnNawawiView> {
  HadithBook? _book;
  bool _loading = true;
  int _currentIndex = 0;

  late final PageController _pageController;
  final _jumpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString(
      'assets/json/forty_hadith_of_an_nawawi.json',
    );
    final book = HadithBook.fromJson(json.decode(raw) as Map<String, dynamic>);
    if (!mounted) return;
    setState(() {
      _book = book;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  ColorScheme get _scheme => Theme.of(context).colorScheme;
  Color get _cardBackground => _scheme.surfaceContainer;
  Color get _textMain => _scheme.onSurface;
  Color get _textSub => _scheme.onSurfaceVariant;
  Color get _textHint => _scheme.onSurfaceVariant.withValues(alpha: 0.78);
  Color get _divider => _scheme.outlineVariant;

  void _goToIndex(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openJumpSheet() {
    final book = _book;
    if (book == null) return;
    final isBangla = HadithReaderLanguageBuilder.isBanglaOf(context);
    _jumpController.clear();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JumpSheet(
        book: book,
        isDark: _scheme.brightness == Brightness.dark,
        isBangla: isBangla,
        cardBg: _cardBackground,
        textMain: _textMain,
        textHint: _textHint,
        divider: _divider,
        controller: _jumpController,
        onJump: _goToIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HadithReaderLanguageBuilder(
      builder: (context, isBangla, onLanguageChanged) => Scaffold(
        body: AppPremiumPageBackground(
          child: _loading
              ? const HadithReaderLoading(
                  label: 'الأربعون النووية',
                  accent: HadithCollectionPalette.anNawawiAccent,
                )
              : _buildReader(_book!, isBangla, onLanguageChanged),
        ),
      ),
    );
  }

  Widget _buildReader(
    HadithBook book,
    bool isBangla,
    ValueChanged<bool> onLanguageChanged,
  ) {
    final responsive = AppResponsive.of(context);
    final isDark = _scheme.brightness == Brightness.dark;
    final progressLabel =
        '${isBangla ? 'হাদিস' : 'Hadith'} ${book.hadiths[_currentIndex].id}  •  ${_currentIndex + 1}/${book.hadiths.length}';

    return Column(
      children: [
        HadithReaderHeader(
          title: context.l10n.dashboardHadithAnNawawiTitle,
          subtitle: book.title,
          progressLabel: progressLabel,
          accent: HadithCollectionPalette.anNawawiAccent,
          isBangla: isBangla,
          onBack: () => Navigator.maybePop(context),
          onLanguageChanged: onLanguageChanged,
          onSearch: _openJumpSheet,
        ),
        HadithReaderProgress(
          current: _currentIndex + 1,
          total: book.hadiths.length,
          accent: HadithCollectionPalette.anNawawiAccent,
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentIndex = page),
            itemCount: book.hadiths.length,
            itemBuilder: (context, page) {
              final child = _HadithPage(
                hadith: book.hadiths[page],
                isBangla: isBangla,
                isDark: isDark,
                cardBg: isDark ? _cardBackground : Colors.white,
                textMain: _textMain,
                textSub: _textSub,
                textHint: _textHint,
                divider: _divider,
                totalCount: book.hadiths.length,
              );
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: responsive.maxReadingContentWidth,
                  ),
                  child: child,
                ),
              );
            },
          ),
        ),
        HadithReaderBottomBar(
          previousLabel: isBangla ? 'পূর্ববর্তী' : 'Prev',
          nextLabel: isBangla ? 'পরবর্তী' : 'Next',
          centerLabel: '${_currentIndex + 1}/${book.hadiths.length}',
          centerIcon: Icons.auto_stories_rounded,
          accent: HadithCollectionPalette.anNawawiAccent,
          canPrevious: _currentIndex > 0,
          canNext: _currentIndex < book.hadiths.length - 1,
          onPrevious: () => _goToIndex(_currentIndex - 1),
          onNext: () => _goToIndex(_currentIndex + 1),
          onCenter: _openJumpSheet,
        ),
      ],
    );
  }
}
