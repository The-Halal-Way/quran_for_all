import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import 'tasbeeh_focus_counter.dart';
import 'tasbeeh_focus_dhikr_navigation.dart';

class TasbeehFocusDhikrPager extends StatefulWidget {
  const TasbeehFocusDhikrPager({
    super.key,
    required this.phrases,
    required this.selectedId,
    required this.counts,
    required this.targets,
    required this.onSelected,
    required this.onCount,
  });

  final List<TasbeehPhrase> phrases;
  final String selectedId;
  final Map<String, int> counts;
  final Map<String, int> targets;
  final ValueChanged<String> onSelected;
  final VoidCallback onCount;

  @override
  State<TasbeehFocusDhikrPager> createState() => _TasbeehFocusDhikrPagerState();
}

class _TasbeehFocusDhikrPagerState extends State<TasbeehFocusDhikrPager> {
  late final PageController _controller;

  int get _selectedIndex => widget.phrases
      .indexWhere((phrase) => phrase.id == widget.selectedId)
      .clamp(0, widget.phrases.length - 1);

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selectedIndex);
  }

  @override
  void didUpdateWidget(TasbeehFocusDhikrPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final idsChanged = !listEquals(
      oldWidget.phrases.map((phrase) => phrase.id).toList(),
      widget.phrases.map((phrase) => phrase.id).toList(),
    );
    if (oldWidget.selectedId != widget.selectedId || idsChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.hasClients) return;
        final index = _selectedIndex;
        if ((_controller.page ?? index.toDouble()).round() != index) {
          _controller.jumpToPage(index);
        }
      });
    }
  }

  void _selectPage(int index) {
    final id = widget.phrases[index].id;
    if (id == widget.selectedId) return;
    HapticFeedback.selectionClick();
    widget.onSelected(id);
  }

  void _move(int offset) {
    if (!_controller.hasClients) return;
    final page = _selectedIndex + offset;
    if (page < 0 || page >= widget.phrases.length) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: PageView.builder(
          key: const ValueKey('tasbeeh_focus_dhikr_pager'),
          controller: _controller,
          itemCount: widget.phrases.length,
          onPageChanged: _selectPage,
          itemBuilder: (context, index) {
            final phrase = widget.phrases[index];
            return Semantics(
              key: ValueKey(phrase.id),
              button: true,
              label: context.l10n.tasbeehCountAction,
              onTap: widget.onCount,
              child: TasbeehFocusCounter(
                phrase: phrase,
                count: widget.counts[phrase.id] ?? 0,
                target: widget.targets[phrase.id] ?? 33,
              ),
            );
          },
        ),
      ),
      if (widget.phrases.length > 1)
        TasbeehFocusDhikrNavigation(
          index: _selectedIndex,
          total: widget.phrases.length,
          onPrevious: () => _move(-1),
          onNext: () => _move(1),
        ),
    ],
  );
}
