import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/ruqyah/ruqyah_progress.dart';
import '../../../../data/repositories/ruqyah_repository.dart';
import '../../../viewmodels/ruqyah/ruqyah_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/ruqyah/guides/ruqyah_guides.dart';
import '../../../widgets/ruqyah/library/ruqyah_library.dart';
import '../../../widgets/ruqyah/overview/ruqyah_overview.dart';
import '../../../widgets/ruqyah/shared/ruqyah_loading_state.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';
import 'ruqyah_reader_view.dart';
import 'ruqyah_guide_view.dart';

class RuqyahView extends StatefulWidget {
  const RuqyahView({super.key, this.repository});
  final RuqyahRepository? repository;
  @override
  State<RuqyahView> createState() => _RuqyahViewState();
}

class _RuqyahViewState extends State<RuqyahView> {
  late final RuqyahViewModel _model;
  String? _language;
  @override
  void initState() {
    super.initState();
    _model = RuqyahViewModel(widget.repository ?? RuqyahRepository());
    _model.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = context.l10n.localeName;
    if (_language == code) return;
    _language = code;
    _model.selectTab(_model.tab, code);
  }

  Future<void> _open({
    String? routine,
    List<String> ids = const [],
    int index = 0,
    RuqyahProgress? resume,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RuqyahReaderView(
          repository: _model.repository,
          routineId: routine,
          readingIds: ids,
          initialIndex: index,
          resume: resume,
        ),
      ),
    );
    if (mounted) _model.refreshProgress();
  }

  Future<void> _openGuide(String id) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) =>
            RuqyahGuideView(repository: _model.repository, guideId: id),
      ),
    );
    if (mounted) _model.refreshProgress();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n.ruqyahTitle),
      actions: const [DuaLanguageButton()],
    ),
    body: AppPremiumPageBackground(
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: _model,
          builder: (context, _) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: 0,
                      label: Text(context.l10n.ruqyahGuided),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text(context.l10n.ruqyahLibrary),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text(context.l10n.ruqyahLearn),
                    ),
                  ],
                  selected: {_model.tab},
                  onSelectionChanged: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _model.selectTab(value.single, context.l10n.localeName);
                  },
                ),
              ),
              Expanded(
                child: _model.loading || _model.failed
                    ? RuqyahLoadingState(
                        failed: _model.failed,
                        onRetry: _model.initialize,
                      )
                    : AppPageScrollbar(
                        builder: (context, controller) => SingleChildScrollView(
                          key: PageStorageKey('ruqyah-tab-${_model.tab}'),
                          controller: controller,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: EdgeInsets.fromLTRB(
                            AppResponsive.of(context).padding,
                            8,
                            AppResponsive.of(context).padding,
                            32,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child:
                                  _model.contentLoading || _model.contentFailed
                                  ? RuqyahLoadingState(
                                      failed: _model.contentFailed,
                                      onRetry: () => _model.selectTab(
                                        _model.tab,
                                        context.l10n.localeName,
                                      ),
                                    )
                                  : switch (_model.tab) {
                                      0 => RuqyahOverview(
                                        model: _model,
                                        onGuide: _openGuide,
                                        onOpen: (id) => _open(routine: id),
                                        onResume: () {
                                          final old = _model.progress!;
                                          _open(
                                            routine: old.routineId,
                                            ids: old.readingIds,
                                            resume: old,
                                          );
                                        },
                                      ),
                                      1 => RuqyahLibrary(
                                        model: _model,
                                        onOpen: (ids, i) =>
                                            _open(ids: ids, index: i),
                                      ),
                                      _ => RuqyahGuides(
                                        guides: _model.guides ?? [],
                                        groups: _model.index!.guideGroups,
                                        onOpen: _openGuide,
                                      ),
                                    },
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}
