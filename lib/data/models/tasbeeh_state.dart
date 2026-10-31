import 'tasbeeh_session.dart';

class TasbeehSavedState extends TasbeehProgress {
  const TasbeehSavedState({
    required super.counts,
    required super.targets,
    super.selectedPhrase,
    super.customPhrases,
    super.builtInPhraseIds,
    super.phraseOrder,
    super.autoNext,
    this.sessions = const [],
    this.selectedSessionId = TasbeehSession.defaultId,
  });

  final List<TasbeehSession> sessions;
  final String selectedSessionId;

  @override
  Map<String, dynamic> toMap() => {
    ...super.toMap(),
    'version': 3,
    'selectedSessionId': selectedSessionId,
    'sessions': sessions.map((session) => session.toMap()).toList(),
  };

  factory TasbeehSavedState.fromMap(Map<String, dynamic> map) {
    final legacy = TasbeehProgress.fromMap(map);
    final rawSessions = map['sessions'];
    return TasbeehSavedState(
      counts: legacy.counts,
      targets: legacy.targets,
      selectedPhrase: legacy.selectedPhrase,
      customPhrases: legacy.customPhrases,
      builtInPhraseIds: legacy.builtInPhraseIds,
      phraseOrder: legacy.phraseOrder,
      autoNext: legacy.autoNext,
      selectedSessionId: map['selectedSessionId'] is String
          ? map['selectedSessionId'] as String
          : TasbeehSession.defaultId,
      sessions: rawSessions is List
          ? List.unmodifiable([
              for (final entry in rawSessions)
                if (entry is Map<String, dynamic>)
                  ?TasbeehSession.fromMap(entry),
            ])
          : const [],
    );
  }
}
