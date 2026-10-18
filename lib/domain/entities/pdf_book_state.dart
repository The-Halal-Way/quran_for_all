import '../../core/constants/pdf_book_document.dart';

class PdfBookReadingState {
  PdfBookReadingState({
    this.pageCount = 0,
    this.lastPage = 1,
    Iterable<int> bookmarks = const <int>[],
  }) : bookmarks = bookmarks.toSet().toList()..sort();

  final int pageCount;
  final int lastPage;
  final List<int> bookmarks;

  PdfBookReadingState copyWith({
    int? pageCount,
    int? lastPage,
    Iterable<int>? bookmarks,
  }) => PdfBookReadingState(
    pageCount: pageCount ?? this.pageCount,
    lastPage: lastPage ?? this.lastPage,
    bookmarks: bookmarks ?? this.bookmarks,
  );

  Map<String, dynamic> toJson() => {
    'pageCount': pageCount,
    'lastPage': lastPage,
    'bookmarks': bookmarks,
  };

  factory PdfBookReadingState.fromJson(Map<String, dynamic> json) {
    final rawBookmarks = json['bookmarks'];
    return PdfBookReadingState(
      pageCount: (json['pageCount'] as num?)?.toInt() ?? 0,
      lastPage: (json['lastPage'] as num?)?.toInt() ?? 1,
      bookmarks: rawBookmarks is List
          ? rawBookmarks.whereType<num>().map((value) => value.toInt())
          : const <int>[],
    );
  }
}

class PdfBookLibrary {
  const PdfBookLibrary({
    required this.reading,
    required this.filePath,
    required this.document,
  });

  final PdfBookReadingState reading;
  final String? filePath;
  final PdfBookDocument? document;
}

enum PdfBookIssue { network, invalidPdf, storage, cancelled }

class PdfBookException implements Exception {
  const PdfBookException(this.issue);

  final PdfBookIssue issue;
}
