import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/auth.dart';
import 'package:ionicons/ionicons.dart';

class CategoryModel {
  final String name;
  final IconData icon;
  final String description;

  CategoryModel(
      {required this.name, required this.icon, required this.description});
}

class BookServices {
  static List<CategoryModel> bookCategoryList = [
    CategoryModel(
        name: "Media",
        icon: Ionicons.file_tray,
        description:
            "Media berisi artikel yang dapat membantu kamu dalam berkebun"),
    CategoryModel(
        name: "Jenis",
        icon: Ionicons.flower,
        description:
            "Jenis berisi artikel yang dapat membantu kamu dalam mengetahui jenis-jenis tanaman"),
    CategoryModel(
        name: "Perawatan",
        icon: Ionicons.color_fill,
        description:
            "Perawatan berisi artikel yang dapat membantu kamu dalam merawat tanaman"),
    CategoryModel(
        name: "Tips",
        icon: Ionicons.construct,
        description:
            "Tips berisi artikel yang dapat membantu kamu dalam berkebun"),
    CategoryModel(
        name: "Pupuk",
        icon: Ionicons.leaf,
        description:
            "Pupuk berisi artikel yang dapat membantu kamu dalam mengetahui jenis-jenis pupuk"),
    CategoryModel(
        name: "Lainnya",
        icon: Ionicons.ellipsis_horizontal_circle,
        description: "Lainnya artikel yang dapat membantu kamu dalam berkebun"),
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

  Future<BookModel> getBookByIDFromDB(String id) async {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    final res = await bookRef.doc(id).get();
    print("res: $res");
    print("id: $id");
    return BookModel.fromQuery(res);
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
