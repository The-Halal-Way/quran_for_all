import 'package:flutter/material.dart';

import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import 'tasbeeh_phrase_actions.dart';
import 'tasbeeh_phrase_card.dart';
import 'tasbeeh_section_header.dart';

class TasbeehPhraseSelector extends StatefulWidget {
  const TasbeehPhraseSelector({
    super.key,
    required this.phrases,
    required this.selectedId,
    required this.counts,
    required this.targets,
    required this.onSelected,
    required this.onAdd,
    required this.onAction,
  });
  final List<TasbeehPhrase> phrases;
  final String selectedId;
  final Map<String, int> counts;
  final Map<String, int> targets;
  final ValueChanged<String> onSelected;
  final VoidCallback onAdd;
  final void Function(TasbeehPhrase, TasbeehPhraseAction) onAction;

  @override
  State<TasbeehPhraseSelector> createState() => _TasbeehPhraseSelectorState();
}

class _TasbeehPhraseSelectorState extends State<TasbeehPhraseSelector> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _revealSelected();
  }

  @override
  void didUpdateWidget(TasbeehPhraseSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) _revealSelected();
  }

  void _revealSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final index = widget.phrases.indexWhere(
        (phrase) => phrase.id == widget.selectedId,
      );
      if (index < 0) return;
      final position = _controller.position;
      final offset =
          (index * (TasbeehPhraseCard.width + 10) -
                  (position.viewportDimension - TasbeehPhraseCard.width) / 2)
              .clamp(0.0, position.maxScrollExtent);
      _controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TasbeehSectionHeader(onAdd: widget.onAdd),
      const SizedBox(height: 8),
      SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (final phrase in widget.phrases) ...[
              TasbeehPhraseCard(
                key: ValueKey(phrase.id),
                phrase: phrase,
                isSelected: widget.selectedId == phrase.id,
                count: widget.counts[phrase.id] ?? 0,
                target: widget.targets[phrase.id] ?? 33,
                onTap: () => widget.onSelected(phrase.id),
                onAction: (action) => widget.onAction(phrase, action),
              ),
              if (phrase != widget.phrases.last) const SizedBox(width: 10),
            ],
          ],
        ),
      ),
    ],
  );
}
