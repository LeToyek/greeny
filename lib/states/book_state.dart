import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/book_service.dart';

class BookNotifier extends StateNotifier<AsyncValue<List<BookModel>>> {
  final BookServices bookServices;
  List<BookModel> tempBooks = [];
  BookNotifier({required this.bookServices}) : super(const AsyncValue.data([]));

  Future<void> getAllBooks(String category) async {
    try {
      state = const AsyncValue.loading();
      final books = await bookServices.getBooksFromDB(category);
      tempBooks = books;
      state = AsyncValue.data(books);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getWholeBooks() async {
    try {
      state = const AsyncValue.loading();
      final books = await bookServices.getWholeBooks();
      state = AsyncValue.data(books);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getBookByID(String id) async {
    try {
      state = const AsyncValue.loading();
      final book = await bookServices.getBookByIDFromDB(id);
      tempBooks = [book];
      state = AsyncValue.data([book]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  BookModel getThisBook() {
    return state.value!.first;
  }

  Future<void> createBook(BookModel book) async {
    try {
      state = const AsyncValue.loading();
      final createdBook = await bookServices.insertBookToDB(book);

      state = AsyncValue.data([...tempBooks, createdBook]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception(e);
    }
  }

  Future<void> updateBook(BookModel book) async {
    try {
      state = const AsyncValue.loading();
      final updatedBook = await bookServices.updateBookToDB(book);
      final bookState = tempBooks.first;
      bookState.title = book.title;
      bookState.content = book.content;
      bookState.category = book.category;
      bookState.imageUrl = book.imageUrl;

      state = AsyncValue.data([bookState]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception(e);
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      state = const AsyncValue.loading();
      await bookServices.deleteBookFromDB(id);

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
  return BookNotifier(bookServices: BookServices())..getWholeBooks();
});

final bookFamilyProvider = StateNotifierProviderFamily<BookNotifier,
    AsyncValue<List<BookModel>>, String>((ref, arg) {
  return BookNotifier(bookServices: BookServices())..getAllBooks(arg);
});
