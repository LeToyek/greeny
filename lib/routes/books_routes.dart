import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/book/book_create_screen.dart';
import 'package:greenify/ui/screen/book/book_detail_screen.dart';
import 'package:greenify/ui/screen/book/book_edit_screen.dart';
import 'package:greenify/ui/screen/book/book_list_screen.dart';
import 'package:greenify/ui/screen/book/book_screen.dart';

List<GoRoute> booksRoutes = [
  GoRoute(path: "/book", builder: (context, state) => const BookScreen()),
  GoRoute(
      path: "/book/edit/:id",
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return BookEditScreen(id: id!);
      }),
  GoRoute(
      path: "/book/create",
      builder: (context, state) => const BookCreateScreen()),
  GoRoute(
      path: "/book/:category",
      builder: (context, state) {
        final category = state.pathParameters["category"]!;
        return BookListScreen(category: category);
      }),
  GoRoute(
      name: "book_detail",
      path: "/book/detail/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return BookDetailScreen(bookId: id);
      }),
];
