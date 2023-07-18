import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/services/users.dart';

class BookModel {
  String? id;
  final String imageUrl;
  final String title;
  final String category;
  final String content;
  String? userID;
  String? createdAt;
  String? updatedAt;

  BookModel({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.content,
  });

  BookModel.fromQuery(DocumentSnapshot<Object?> data)
      : id = data.id,
        imageUrl = data['image_url'],
        title = data['title'],
        category = data['category'],
        content = data['content'],
        userID = data['user_id'],
        createdAt = data['created_at'].toString(),
        updatedAt = data['updated_at'].toString();

  Future<UserModel> getUserModel() async {
    return await UsersServices().getUserById(id: userID!);
  }
}
