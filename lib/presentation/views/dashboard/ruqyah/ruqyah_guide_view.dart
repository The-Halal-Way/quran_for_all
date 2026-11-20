import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/ruqyah/ruqyah_guide.dart';
import '../../../../data/models/ruqyah/ruqyah_index.dart';
import '../../../../data/repositories/ruqyah_repository.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/ruqyah/guides/ruqyah_article_content.dart';
import '../../../widgets/ruqyah/shared/ruqyah_loading_state.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';
import 'ruqyah_reader_view.dart';

typedef _Article = ({RuqyahGuide guide, RuqyahIndex index});

class RuqyahGuideView extends StatefulWidget {
  const RuqyahGuideView({
    super.key,
    required this.repository,
    required this.guideId,
  });
  final RuqyahRepository repository;
  final String guideId;
  @override
  State<RuqyahGuideView> createState() => _RuqyahGuideViewState();
}

class _RuqyahGuideViewState extends State<RuqyahGuideView> {
  String? _language;
  late Future<_Article> _article;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = context.l10n.localeName;
    if (_language == language) return;
    _language = language;
    _article = _load(language);
  }

  Future<_Article> _load(String language) async {
    final index = await widget.repository.assets.loadIndex();
    final guides = await widget.repository.assets.loadGuides(language);
    final guide = guides.where((g) => g.id == widget.guideId).firstOrNull;
    if (guide == null) throw const FormatException('Missing Ruqyah article.');
    return (guide: guide, index: index);
  }

  void _read({String? routine, String? reading}) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RuqyahReaderView(
          repository: widget.repository,
          routineId: routine,
          readingIds: reading == null ? const [] : [reading],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n.ruqyahLearn),
      actions: const [DuaLanguageButton()],
    ),
    body: AppPremiumPageBackground(
      child: SafeArea(
        top: false,
        child: FutureBuilder<_Article>(
          future: _article,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                !snapshot.hasData) {
              return RuqyahLoadingState(
                failed: snapshot.hasError,
                onRetry: () => setState(() => _article = _load(_language!)),
              );
            }
            final article = snapshot.requireData;
            return AppPageScrollbar(
              builder: (context, controller) => SingleChildScrollView(
                key: PageStorageKey('ruqyah-article-${widget.guideId}'),
                controller: controller,
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.of(context).padding,
                  8,
                  AppResponsive.of(context).padding,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: RuqyahArticleContent(
                      guide: article.guide,
                      index: article.index,
                      onRoutine: (id) => _read(routine: id),
                      onReading: (id) => _read(reading: id),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
