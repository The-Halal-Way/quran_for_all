import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/ruqyah/ruqyah_audio_controller.dart';
import '../../../viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';
import '../shared/ruqyah_style.dart';
import 'ruqyah_collection_contents.dart';
import 'ruqyah_collection_introduction.dart';
import 'ruqyah_long_passage.dart';

/// Two lazy sliver lists meet at the saved passage. Opening a late passage
/// never requires laying out every preceding Arabic/translation panel.
class RuqyahContinuousReader extends StatefulWidget {
  const RuqyahContinuousReader({
    super.key,
    required this.model,
    required this.audio,
  });
  final RuqyahReaderViewModel model;
  final RuqyahAudioController audio;
  @override
  State<RuqyahContinuousReader> createState() => _RuqyahContinuousReaderState();
}

class _RuqyahContinuousReaderState extends State<RuqyahContinuousReader> {
  late int _anchor;
  Key _scrollKey = UniqueKey();
  Key _center = UniqueKey();
  final _viewport = GlobalKey();
  final _passages = <int, GlobalKey>{};
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _anchor = widget.model.index;
  }

  void _jump(int index) {
    if (index < 0 || index >= widget.model.length) return;
    widget.model.goTo(index);
    setState(() {
      _anchor = index;
      _scrollKey = UniqueKey();
      _center = UniqueKey();
      _generation++;
    });
  }

  void _rememberVisible() {
    final generation = _generation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _generation) return;
      final viewport = _viewport.currentContext?.findRenderObject();
      if (viewport is! RenderBox || !viewport.hasSize) return;
      final top = viewport.localToGlobal(Offset.zero).dy;
      final bottom = top + viewport.size.height;
      final visible = <({int index, double top})>[];
      for (final entry in _passages.entries) {
        final box = entry.value.currentContext?.findRenderObject();
        if (box is! RenderBox || !box.attached || !box.hasSize) continue;
        final y = box.localToGlobal(Offset.zero).dy;
        if (y < bottom && y + box.size.height > top + 24) {
          visible.add((index: entry.key, top: y));
        }
      }
      visible.sort((a, b) => a.top.compareTo(b.top));
      if (visible.isNotEmpty) widget.model.goTo(visible.first.index);
    });
  }

  Widget _passage(int index) => Padding(
    key: _passages.putIfAbsent(index, () => GlobalKey()),
    padding: EdgeInsets.fromLTRB(
      AppResponsive.of(context).padding,
      16,
      AppResponsive.of(context).padding,
      12,
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          children: [
            if (index == 0)
              RuqyahCollectionIntroduction(routine: widget.model.routine!),
            RuqyahLongPassage(
              model: widget.model,
              audio: widget.audio,
              index: index,
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.depth == 0) {
                _rememberVisible();
              }
              return false;
            },
            child: SizedBox(
              key: _viewport,
              width: double.infinity,
              child: CustomScrollView(
                key: _scrollKey,
                center: _center,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _passage(_anchor - i - 1),
                      childCount: _anchor,
                    ),
                  ),
                  SliverList(
                    key: _center,
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _passage(_anchor + i),
                      childCount: model.length - _anchor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    tooltip: context.l10n.ruqyahPrevious,
                    onPressed: model.index > 0
                        ? () => _jump(model.index - 1)
                        : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      context.l10n.ruqyahCollectionPosition(
                        RuqyahStyle.number(context, model.index + 1),
                        RuqyahStyle.number(context, model.length),
                      ),
                      textAlign: TextAlign.center,
                      style: AppTheme.text(context).labelLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.ruqyahCollectionContents,
                    onPressed: () async {
                      final index = await showRuqyahCollectionContents(
                        context,
                        model,
                      );
                      if (mounted && index != null) _jump(index);
                    },
                    icon: const Icon(Icons.format_list_numbered_rounded),
                  ),
                  IconButton(
                    tooltip: context.l10n.ruqyahNext,
                    onPressed: model.index < model.length - 1
                        ? () => _jump(model.index + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
