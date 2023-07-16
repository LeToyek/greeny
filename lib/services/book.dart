import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/auth.dart';

class BookServices {
  static List<String> bookCategoryList = [
    "Media",
    "Jenis",
    "Perawatan",
    "Tips",
    "Pupuk",
    "Lainnya"
  ];

  Future<List<BookModel>> getBooksFromDB(String category) async {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    List<BookModel> books = [];
    final res = await bookRef.get();
    res.docs.where((element) => element['category'] == category).forEach((e) {
      books.add(BookModel.fromQuery(e));
    });
    return books;
  }

  Future<BookModel> insertBookToDB(BookModel book) async {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    try {
      await bookRef.add({
        "user_id": FireAuth.getCurrentUser()!.uid,
        "image_url": book.imageUrl,
        "title": book.title,
        "category": book.category,
        "content": book.content,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
      });
      return book;
    } catch (e) {
      throw Exception(e);
    }
  }
}
