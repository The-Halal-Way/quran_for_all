import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import '../../../viewmodels/dua/dua_library_viewmodel.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';
import '../../../widgets/sunnah_dua/catalog/dua_library_content.dart';
import '../../../widgets/sunnah_dua/catalog/dua_library_status.dart';
import '../../../widgets/sunnah_dua/catalog/dua_recitation_guide.dart';
import '../../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_section_search.dart';
import 'dua_entry_view.dart';

class DuaLibraryView extends StatefulWidget {
  const DuaLibraryView({super.key, this.initialCategory});
  final String? initialCategory;

  @override
  State<DuaLibraryView> createState() => _DuaLibraryViewState();
}

class _DuaLibraryViewState extends State<DuaLibraryView> {
  late final _model = DuaLibraryViewModel(
    initialCategory: widget.initialCategory,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_model.load());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _back() {
    FocusScope.of(context).unfocus();
    if (_model.showingCategories) {
      Navigator.of(context).maybePop();
    } else {
      _model.selectCategory(null);
    }
  }

  void _open(DuaEntry entry) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DuaEntryView(
          catalog: _model.catalog!,
          entry: entry,
          categoryId: _model.category.id,
          entryIds: _model.referenceOnly
              ? _model.category.referenceIds
              : _model.category.entryIds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _model,
    builder: (context, _) {
      final catalog = _model.catalog;
      final responsive = AppResponsive.of(context);
      return PopScope(
        canPop: _model.showingCategories,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _back();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: _back),
            title: Text(context.l10n.duaLibraryTitle),
            actions: [
              if (catalog != null)
                IconButton(
                  tooltip: context.l10n.duaPronunciationHelp,
                  onPressed: () => showDuaRecitationGuide(context, catalog),
                  icon: const Icon(Icons.record_voice_over_rounded),
                ),
              const DuaLanguageButton(),
            ],
          ),
          body: AppPremiumPageBackground(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    if (catalog != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          responsive.padding,
                          AppSpacing.sm,
                          responsive.padding,
                          AppSpacing.md,
                        ),
                        child: SunnahDuaSectionSearch(
                          hint: context.l10n.duaSearchHint,
                          query: _model.query,
                          onChanged: _model.search,
                        ),
                      ),
                    Expanded(
                      child: _model.loading || _model.failed
                          ? DuaLibraryStatus(
                              loading: _model.loading,
                              failed: _model.failed,
                              onRetry: _model.load,
                            )
                          : DuaLibraryContent(model: _model, onOpen: _open),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
