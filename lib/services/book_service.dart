import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/auth_service.dart';
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
    final res = await bookRef.orderBy('created_at').get();

    for (final doc in res.docs) {
      if (doc['category'] == category) {
        final book = BookModel.fromQuery(doc);
        await book.getUserModel();
        books.add(book);
      }
    }

    return books;
  }

  Future<List<BookModel>> getWholeBooks() async {
    try {
      CollectionReference bookRef =
          FirebaseFirestore.instance.collection('books');
      List<BookModel> books = [];
      final res = await bookRef.orderBy('created_at').limit(3).get();

      for (final doc in res.docs) {
        final book = BookModel.fromQuery(doc);
        await book.getUserModel();
        books.add(book);
      }

      return books;
    } catch (e) {
      rethrow;
    }
  }

  Future<BookModel> getBookByIDFromDB(String id) async {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    final res = await bookRef.doc(id).get();
    final book = BookModel.fromQuery(res);
    await book.getUserModel();
    print(book);
    return book;
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

  Future<BookModel> updateBookToDB(BookModel book) async {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    try {
      await bookRef.doc(book.id).update({
        "image_url": book.imageUrl,
        "title": book.title,
        "category": book.category,
        "content": book.content,
        "updated_at": DateTime.now(),
      });
      return book;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteBookFromDB(String id) async {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');
    try {
      await bookRef.doc(id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
