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
import 'package:quran_for_all/presentation/widgets/common/app_premium_page_background.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_collection_palette.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_bottom_bar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_header.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_language_builder.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_loading.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_progress.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/hadith_forty_short/hadith_forty_short_models.dart';

part '../../../widgets/dashboard/hadith/hadith_forty_short/hadith_forty_short_pages.dart';
part '../../../widgets/dashboard/hadith/hadith_forty_short/hadith_forty_short_jump_sheet.dart';
part '../../../widgets/dashboard/hadith/hadith_forty_short/hadith_forty_short_shared_widgets.dart';

class HadithFortyShortView extends StatefulWidget {
  const HadithFortyShortView({super.key});

  @override
  State<HadithFortyShortView> createState() => _HadithFortyShortViewState();
}

class _HadithFortyShortViewState extends State<HadithFortyShortView> {
  ShortHadithBook? _book;
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
      'assets/json/forty_short_hadith.json',
    );
    final book = ShortHadithBook.fromJson(
      json.decode(raw) as Map<String, dynamic>,
    );
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

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showJumpSheet() {
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
        onJump: _goTo,
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
                  label: 'الأحاديث القصيرة',
                  accent: HadithCollectionPalette.fortyShortAccent,
                )
              : _buildReader(_book!, isBangla, onLanguageChanged),
        ),
      ),
    );
  }

  Widget _buildReader(
    ShortHadithBook book,
    bool isBangla,
    ValueChanged<bool> onLanguageChanged,
  ) {
    final responsive = AppResponsive.of(context);
    final isDark = _scheme.brightness == Brightness.dark;
    final subtitle = isBangla ? book.compiledByBangla : book.compiledByEnglish;

    return Column(
      children: [
        HadithReaderHeader(
          title: context.l10n.dashboardHadithShortTitle,
          subtitle: subtitle,
          progressLabel:
              '${isBangla ? 'হাদিস' : 'Hadith'} ${_currentIndex + 1}  •  ${_currentIndex + 1}/${book.hadiths.length}',
          accent: HadithCollectionPalette.fortyShortAccent,
          isBangla: isBangla,
          onBack: () => Navigator.maybePop(context),
          onLanguageChanged: onLanguageChanged,
          onSearch: _showJumpSheet,
        ),
        HadithReaderProgress(
          current: _currentIndex + 1,
          total: book.hadiths.length,
          accent: HadithCollectionPalette.fortyShortAccent,
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: book.hadiths.length,
            itemBuilder: (context, index) => Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: responsive.maxReadingContentWidth,
                ),
                child: _ShortHadithPage(
                  hadith: book.hadiths[index],
                  isBangla: isBangla,
                  isDark: isDark,
                  cardBg: isDark ? _cardBackground : Colors.white,
                  textMain: _textMain,
                  textSub: _textSub,
                  textHint: _textHint,
                  divider: _divider,
                  totalCount: book.hadiths.length,
                ),
              ),
            ),
          ),
        ),
        HadithReaderBottomBar(
          previousLabel: isBangla ? 'পূর্ববর্তী' : 'Prev',
          nextLabel: isBangla ? 'পরবর্তী' : 'Next',
          centerLabel: '${_currentIndex + 1}/${book.hadiths.length}',
          centerIcon: Icons.auto_stories_rounded,
          accent: HadithCollectionPalette.fortyShortAccent,
          canPrevious: _currentIndex > 0,
          canNext: _currentIndex < book.hadiths.length - 1,
          onPrevious: () => _goTo(_currentIndex - 1),
          onNext: () => _goTo(_currentIndex + 1),
          onCenter: _showJumpSheet,
        ),
      ],
    );
  }
}
