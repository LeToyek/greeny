import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/book.dart';

class BookNotifier extends StateNotifier<AsyncValue<List<BookModel>>> {
  final BookServices bookServices;
  final List<BookModel> tempBooks = [];
  BookNotifier({required this.bookServices}) : super(const AsyncValue.data([]));

  Future<void> getAllBooks(String category) async {
    try {
      state = const AsyncValue.loading();
      final books = await bookServices.getBooksFromDB(category);
      tempBooks.addAll(books);
      state = AsyncValue.data(books);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getBookByID(String id) async {
    try {
      state = const AsyncValue.loading();
      final book = await bookServices.getBookByIDFromDB(id);
      state = AsyncValue.data([book]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createBook(BookModel book) async {
    try {
      state = const AsyncValue.loading();
      final createdBook = await bookServices.insertBookToDB(book);
      print(createdBook);
      state = AsyncValue.data(tempBooks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception(e);
    }
  }
}

final detailBookProvider = StateNotifierProviderFamily<BookNotifier,
        AsyncValue<List<BookModel>>, String>(
    (ref, arg) => BookNotifier(bookServices: BookServices())..getBookByID(arg));

final bookProvider =
    StateNotifierProvider<BookNotifier, AsyncValue<List<BookModel>>>((ref) {
  return BookNotifier(bookServices: BookServices());
});

final bookFamilyProvider = StateNotifierProviderFamily<BookNotifier,
    AsyncValue<List<BookModel>>, String>((ref, arg) {
  return BookNotifier(bookServices: BookServices())..getAllBooks(arg);
});
