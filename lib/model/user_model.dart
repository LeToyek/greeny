import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/services/users_service.dart';

class UserModel {
  String userId;
  String email;
  String? name;
  String? imageUrl;
  int level;
  int exp;
  String? photoFrame;
  List<GardenModel>? gardens;

  UserModel(
      {required this.email,
      required this.userId,
      this.name = "name",
      this.imageUrl,
      this.level = 1,
      this.exp = 0,
      this.photoFrame,
      required this.gardens});

  UserModel.fromQuery(DocumentSnapshot<Object?> element)
      : email = element['email'],
        userId = element['user_id'],
        name = element['name'],
        exp = element['exp'],
        level = element['level'],
        photoFrame = element['photo_frame'],
        imageUrl = element['image_url'];
}
