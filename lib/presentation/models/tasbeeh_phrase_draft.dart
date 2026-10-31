class TasbeehPhraseDraft {
  const TasbeehPhraseDraft({
    required this.name,
    required this.arabic,
    required this.meaning,
    required this.target,
    this.builtInPhraseId,
  });

  final String name;
  final String arabic;
  final String meaning;
  final int target;
  final String? builtInPhraseId;
}
