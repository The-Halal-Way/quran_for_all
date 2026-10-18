import 'package:http/http.dart' as http;

import '../../core/constants/pdf_book_document.dart';
import '../../data/repositories/pdf_book_repository_impl.dart';
import 'pdf_book_viewmodel.dart';

/// Creates local reading state only when a book's library card is opened.
class PdfBooksLibrary {
  PdfBooksLibrary(this._client);

  final http.Client _client;
  final Map<String, PdfBookViewModel> _books = {};

  PdfBookViewModel forBook(PdfBookDefinition book) => _books.putIfAbsent(
    book.id,
    () => PdfBookViewModel(
      PdfBookRepositoryImpl(_client, book: book),
      book: book,
    ),
  );

  void dispose() {
    for (final book in _books.values) {
      book.dispose();
    }
  }
}
