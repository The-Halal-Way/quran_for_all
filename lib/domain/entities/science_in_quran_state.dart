import '../../core/constants/science_in_quran_document.dart';

class ScienceInQuranReadingState {
  ScienceInQuranReadingState({
    this.pageCount = 0,
    this.lastPage = 1,
    Iterable<int> bookmarks = const <int>[],
  }) : bookmarks = bookmarks.toSet().toList()..sort();

  final int pageCount;
  final int lastPage;
  final List<int> bookmarks;

  ScienceInQuranReadingState copyWith({
    int? pageCount,
    int? lastPage,
    Iterable<int>? bookmarks,
  }) => ScienceInQuranReadingState(
    pageCount: pageCount ?? this.pageCount,
    lastPage: lastPage ?? this.lastPage,
    bookmarks: bookmarks ?? this.bookmarks,
  );

  Map<String, dynamic> toJson() => {
    'pageCount': pageCount,
    'lastPage': lastPage,
    'bookmarks': bookmarks,
  };

  factory ScienceInQuranReadingState.fromJson(Map<String, dynamic> json) {
    final rawBookmarks = json['bookmarks'];
    return ScienceInQuranReadingState(
      pageCount: (json['pageCount'] as num?)?.toInt() ?? 0,
      lastPage: (json['lastPage'] as num?)?.toInt() ?? 1,
      bookmarks: rawBookmarks is List
          ? rawBookmarks.whereType<num>().map((value) => value.toInt())
          : const <int>[],
    );
  }
}

class ScienceInQuranLibrary {
  const ScienceInQuranLibrary({
    required this.reading,
    required this.filePath,
    required this.document,
  });

  final ScienceInQuranReadingState reading;
  final String? filePath;
  final ScienceInQuranDocument? document;
}

enum ScienceInQuranIssue { network, invalidPdf, storage, cancelled }

class ScienceInQuranException implements Exception {
  const ScienceInQuranException(this.issue);

  final ScienceInQuranIssue issue;
}
