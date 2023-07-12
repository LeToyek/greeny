import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String? name;
  String? imageUrl;
  int level;
  int exp;
  String? photoFrame;

  UserModel(
      {required this.email,
      this.name = "name",
      this.imageUrl,
      this.level = 1,
      this.exp = 0,
      this.photoFrame});

  UserModel.fromQuery(DocumentSnapshot<Object?> element)
      : email = element['email'],
        name = element['name'],
        exp = element['exp'],
        level = element['level'],
        photoFrame = element['photo_frame'],
        imageUrl = element['image_url'];
}
