import 'dart:collection';
import 'dart:math';

import '../../data/models/quiz/quiz_config.dart';
import '../../data/models/quiz/quiz_failure.dart';
import '../../data/models/quiz/quiz_question.dart';

class QuizSelection {
  const QuizSelection({
    required this.questionIds,
    required this.optionOrders,
    required this.reusedCount,
    required this.recentCount,
  });
  final List<String> questionIds;
  final Map<String, List<String>> optionOrders;
  final int reusedCount, recentCount;
}

/// A minimum-cost flow assigns concepts to quota slots. Residual paths can
/// revise earlier choices, so a shared concept cannot cause a greedy dead end.
/// Cost bands first maximize the preferred tier, then avoid the last tier;
/// recency ranks and randomized ties are strictly cheaper than either band.
QuizSelection selectQuizQuestions({
  required QuizConfig config,
  required Map<String, QuizQuestionSnapshot> questions,
  required Map<String, DateTime> exposures,
  required Set<String> recentIds,
  Random? random,
}) {
  final rng = random ?? Random();
  final candidates = questions.values.map((q) => q.canonical).toList()
    ..shuffle(rng);
  int tier(QuizQuestion q) {
    final priority = !exposures.containsKey(q.id)
        ? 'unseen'
        : recentIds.contains(q.id)
        ? 'seen_in_recent_attempts'
        : 'seen_outside_recent_attempts';
    return config.priorityOrder.indexOf(priority);
  }

  final tieOrder = {
    for (var i = 0; i < candidates.length; i++) candidates[i].id: i,
  };
  candidates.sort((a, b) {
    final byTier = tier(a).compareTo(tier(b));
    if (byTier != 0) return byTier;
    final bySeen = (exposures[a.id] ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(exposures[b.id] ?? DateTime.fromMillisecondsSinceEpoch(0));
    return bySeen != 0 ? bySeen : tieOrder[a.id]!.compareTo(tieOrder[b.id]!);
  });
  final flow = _Network();
  final source = flow.node(), sink = flow.node();
  final groups = <String, int>{};
  for (final category in config.categories) {
    for (final quota in config.quotas.entries) {
      final group = flow.node();
      groups['$category/${quota.key}'] = group;
      flow.edge(group, sink, quota.value, 0);
    }
  }
  final concepts = <String, int>{};
  final choices = <String, _Edge>{};
  final lowBand = (config.questionCount + 1) * (candidates.length + 1);
  final highBand = (config.questionCount + 1) * lowBand;
  for (var rank = 0; rank < candidates.length; rank++) {
    final question = candidates[rank];
    final group =
        groups['${question.categoryId}/${question.quotaGroup(config)}'];
    if (group == null) continue;
    final concept = concepts.putIfAbsent(question.conceptId, () {
      final node = flow.node();
      flow.edge(source, node, 1, 0);
      return node;
    });
    final preference = tier(question);
    final cost =
        rank +
        (preference == 0 ? 0 : highBand) +
        (preference == 2 ? lowBand : 0);
    choices[question.id] = flow.edge(concept, group, 1, cost);
  }
  if (flow.send(source, sink, config.questionCount) != config.questionCount) {
    throw const QuizFailure(QuizFailureCode.insufficientQuestions);
  }
  final selected = candidates
      .where((q) => choices[q.id]?.capacity == 0)
      .toList();
  if (config.shuffleQuestions) selected.shuffle(rng);
  final optionOrders = <String, List<String>>{};
  for (final question in selected) {
    final ids = question.options.map((o) => o.id).toList();
    if (config.shuffleOptions) ids.shuffle(rng);
    optionOrders[question.id] = List.unmodifiable(ids);
  }
  return QuizSelection(
    questionIds: List.unmodifiable(selected.map((q) => q.id)),
    optionOrders: Map.unmodifiable(optionOrders),
    reusedCount: selected.where((q) => exposures.containsKey(q.id)).length,
    recentCount: selected
        .where((q) => exposures.containsKey(q.id) && recentIds.contains(q.id))
        .length,
  );
}

class _Edge {
  _Edge(this.to, this.reverse, this.capacity, this.cost);
  final int to, reverse, cost;
  int capacity;
}

class _Network {
  final List<List<_Edge>> graph = [];
  int node() {
    graph.add([]);
    return graph.length - 1;
  }

  _Edge edge(int from, int to, int capacity, int cost) {
    final forward = _Edge(to, graph[to].length, capacity, cost);
    final reverse = _Edge(from, graph[from].length, 0, -cost);
    graph[from].add(forward);
    graph[to].add(reverse);
    return forward;
  }

  int send(int source, int sink, int needed) {
    var sent = 0;
    while (sent < needed) {
      final distance = List<int?>.filled(graph.length, null);
      final previous = List<(int, int)?>.filled(graph.length, null);
      final queued = List<bool>.filled(graph.length, false);
      final queue = ListQueue<int>()..add(source);
      distance[source] = 0;
      queued[source] = true;
      while (queue.isNotEmpty) {
        final node = queue.removeFirst();
        queued[node] = false;
        for (var i = 0; i < graph[node].length; i++) {
          final edge = graph[node][i];
          final candidate = distance[node]! + edge.cost;
          if (edge.capacity > 0 &&
              (distance[edge.to] == null || candidate < distance[edge.to]!)) {
            distance[edge.to] = candidate;
            previous[edge.to] = (node, i);
            if (!queued[edge.to]) {
              queued[edge.to] = true;
              queue.add(edge.to);
            }
          }
        }
      }
      if (previous[sink] == null) break;
      var node = sink;
      while (node != source) {
        final (from, index) = previous[node]!;
        final edge = graph[from][index];
        edge.capacity--;
        graph[node][edge.reverse].capacity++;
        node = from;
      }
      sent++;
    }
    return sent;
  }
}
