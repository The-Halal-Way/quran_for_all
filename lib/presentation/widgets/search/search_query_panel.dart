import 'package:flutter/material.dart';

class SearchQueryPanel extends StatelessWidget {
  const SearchQueryPanel({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.query,
    required this.resultCount,
    required this.isLoading,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String query;
  final int resultCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: const InputDecoration(
              hintText: 'Try: Al-Baqarah, 2:255, para 1, mercy',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          if (query.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  isLoading
                      ? Icons.hourglass_bottom_rounded
                      : Icons.tune_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isLoading
                        ? 'Searching...'
                        : '$resultCount ${resultCount == 1 ? 'result' : 'results'} for "$query"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
