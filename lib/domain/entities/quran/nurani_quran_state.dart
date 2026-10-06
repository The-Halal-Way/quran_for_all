/// PDF page numbers are one-based, including the cover and introductory pages.
class NuraniQuranReadingState {
  NuraniQuranReadingState({
    this.lastPage = 1,
    this.pageCount = 0,
    Iterable<int> bookmarks = const [],
  }) : bookmarks = List.unmodifiable(bookmarks.toSet().toList()..sort());

  final int lastPage;
  final int pageCount;
  final List<int> bookmarks;

  NuraniQuranReadingState copyWith({
    int? lastPage,
    int? pageCount,
    Iterable<int>? bookmarks,
  }) => NuraniQuranReadingState(
    lastPage: lastPage ?? this.lastPage,
    pageCount: pageCount ?? this.pageCount,
    bookmarks: bookmarks ?? this.bookmarks,
  );

  Map<String, Object> toJson() => {
    'lastPage': lastPage,
    'pageCount': pageCount,
    'bookmarks': bookmarks,
  };

  factory NuraniQuranReadingState.fromJson(Map<String, dynamic> json) {
    final count = (json['pageCount'] as num?)?.toInt() ?? 0;
    final safeCount = count > 0 ? count : 0;
    final page = (json['lastPage'] as num?)?.toInt() ?? 1;
    bool validPage(int value) =>
        value > 0 && (safeCount == 0 || value <= safeCount);
    return NuraniQuranReadingState(
      lastPage: validPage(page) ? page : 1,
      pageCount: safeCount,
      bookmarks: ((json['bookmarks'] as List?) ?? const [])
          .whereType<num>()
          .map((value) => value.toInt())
          .where(validPage),
    );
  }
}

class NuraniQuranLibrary {
  const NuraniQuranLibrary({required this.reading, this.filePath});

  final NuraniQuranReadingState reading;
  final String? filePath;
}

enum NuraniQuranIssue { network, invalidPdf, storage, cancelled }

class NuraniQuranException implements Exception {
  const NuraniQuranException(this.issue);

  final NuraniQuranIssue issue;
}
