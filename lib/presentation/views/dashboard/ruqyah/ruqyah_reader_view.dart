import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/ruqyah/ruqyah_progress.dart';
import '../../../../data/repositories/ruqyah_repository.dart';
import '../../../../services/audio_service.dart';
import '../../../viewmodels/ruqyah/ruqyah_audio_controller.dart';
import '../../../viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/ruqyah/reader/ruqyah_reading_complete.dart';
import '../../../widgets/ruqyah/reader/ruqyah_reading_content.dart';
import '../../../widgets/ruqyah/reader/ruqyah_reader_controls.dart';
import '../../../widgets/ruqyah/reader/ruqyah_reader_preferences.dart';
import '../../../widgets/ruqyah/shared/ruqyah_loading_state.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';
import '../../../widgets/ruqyah/collections/ruqyah_continuous_reader.dart';

class RuqyahReaderView extends StatefulWidget {
  const RuqyahReaderView({
    super.key,
    required this.repository,
    this.routineId,
    this.readingIds = const [],
    this.initialIndex = 0,
    this.resume,
  });
  final RuqyahRepository repository;
  final String? routineId;
  final List<String> readingIds;
  final int initialIndex;
  final RuqyahProgress? resume;
  @override
  State<RuqyahReaderView> createState() => _RuqyahReaderViewState();
}

class _RuqyahReaderViewState extends State<RuqyahReaderView>
    with WidgetsBindingObserver {
  late final RuqyahReaderViewModel _model;
  late final RuqyahAudioController _audio;
  PageController? _pages;
  String? _language, _audioSelection;
  bool? _continuousOverride;
  bool get _continuous =>
      _model.routine?.summary.collection != null &&
      (_continuousOverride ?? true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = RuqyahReaderViewModel(
      repository: widget.repository,
      routineId: widget.routineId,
      readingIds: widget.readingIds,
      initialIndex: widget.initialIndex,
      resume: widget.resume,
    );
    _audio = RuqyahAudioController(
      beforePlay: () async {
        // The shared Quran player must release playback before this reader starts.
        final shared = Provider.of<AudioService?>(context, listen: false);
        await shared?.stop();
      },
    );
    _model.addListener(_syncReader);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = context.l10n.localeName;
    if (_language == language) return;
    _language = language;
    _model.load(language);
  }

  void _syncReader() {
    if (_model.loading || _model.failed) return;
    if (_model.finished) {
      _audio.stop();
      return;
    }
    _pages ??= PageController(initialPage: _model.index);
    final selection = '${_model.index}:${_model.reading?.id}';
    if (selection != _audioSelection) {
      _audioSelection = selection;
      _audio.select(_model.reading?.verseIds ?? []);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          !_model.loading &&
          !_model.failed &&
          !_model.finished &&
          _pages!.hasClients &&
          _pages!.page?.round() != _model.index) {
        _pages!.jumpToPage(_model.index);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _audio.pause();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        context.l10n.ruqyahTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        ListenableBuilder(
          listenable: _model,
          builder: (context, _) => Row(
            children: [
              if (!_model.loading &&
                  !_model.failed &&
                  _model.routine?.summary.collection != null)
                IconButton(
                  tooltip: _continuous
                      ? context.l10n.ruqyahPageReading
                      : context.l10n.ruqyahReadContinuously,
                  onPressed: () {
                    final continuous = !_continuous;
                    if (!continuous) {
                      _pages?.dispose();
                      _pages = PageController(initialPage: _model.index);
                    }
                    setState(() => _continuousOverride = continuous);
                    _syncReader();
                  },
                  icon: Icon(
                    _continuous
                        ? Icons.view_carousel_outlined
                        : Icons.view_stream_outlined,
                  ),
                ),
              if (!_model.loading &&
                  !_model.failed &&
                  !_model.finished &&
                  !_continuous &&
                  _model.reading != null)
                IconButton(
                  onPressed: _model.toggleBookmark,
                  tooltip: _model.bookmarked
                      ? context.l10n.ruqyahUnsaveReading
                      : context.l10n.ruqyahSaveReading,
                  icon: Icon(
                    _model.bookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                  ),
                ),
              IconButton(
                onPressed: _model.loading || _model.failed
                    ? null
                    : () => showRuqyahReaderPreferences(context, _model),
                tooltip: context.l10n.ruqyahReadingSettings,
                icon: const Icon(Icons.text_fields_rounded),
              ),
            ],
          ),
        ),
        const DuaLanguageButton(),
      ],
    ),
    body: AppPremiumPageBackground(
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: _model,
          builder: (context, _) {
            if (_model.loading || _model.failed) {
              return RuqyahLoadingState(
                failed: _model.failed,
                onRetry: () => _model.load(context.l10n.localeName),
              );
            }
            if (_model.finished) {
              return RuqyahReadingComplete(onRestart: _model.restart);
            }
            return Column(
              children: [
                LinearProgressIndicator(
                  value: _model.completed.length / _model.length,
                  minHeight: 3,
                ),
                if (_model.progressUpdated)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.l10n.ruqyahProgressUpdated,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        IconButton(
                          onPressed: _model.dismissProgressNotice,
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).closeButtonTooltip,
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                      ],
                    ),
                  ),
                if (_model.saveFailed)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      context.l10n.ruqyahSaveFailed,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: _continuous
                      ? RuqyahContinuousReader(model: _model, audio: _audio)
                      : PageView.builder(
                          controller: _pages,
                          itemCount: _model.length,
                          onPageChanged: _model.goTo,
                          itemBuilder: (context, index) =>
                              SingleChildScrollView(
                                key: PageStorageKey('ruqyah-step-$index'),
                                padding: EdgeInsets.fromLTRB(
                                  AppResponsive.of(context).padding,
                                  20,
                                  AppResponsive.of(context).padding,
                                  24,
                                ),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 760,
                                    ),
                                    child: RuqyahReadingContent(
                                      step: _model.stepAt(index),
                                      reading: _model.readingAt(index),
                                      preferences: _model.preferences,
                                      audio: index == _model.index
                                          ? _audio
                                          : null,
                                      routine: _model.routine,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                ),
                if (!_continuous)
                  RuqyahReaderControls(model: _model, onPage: _model.goTo),
              ],
            );
          },
        ),
      ),
    ),
  );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model.removeListener(_syncReader);
    _model.dispose();
    _audio.dispose();
    _pages?.dispose();
    super.dispose();
  }
}
