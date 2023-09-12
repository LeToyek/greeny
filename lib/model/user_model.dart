import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/model/wallet_model.dart';

class UserModel {
  String userId;
  String email;
  String? name;
  String? imageUrl;
  int level;
  int exp;
  String? photoFrame;
  List<GardenModel>? gardens;
  List<AchievementModel>? achievements;
  List<BookModel>? books;
  late WalletModel wallet;

  UserModel(
      {required this.email,
      required this.userId,
      this.name = "name",
      this.imageUrl,
      this.level = 1,
      this.exp = 0,
      this.photoFrame,
      this.gardens});

  UserModel.fromQuery(DocumentSnapshot<Object?> element)
      : email = element['email'],
        userId = element['user_id'],
        name = element['name'],
        exp = element['exp'],
        level = element['level'],
        photoFrame = element['photo_frame'],
        imageUrl = element['image_url'];

  void setWallet(DocumentSnapshot<Object?> element) {
    wallet = WalletModel.fromMap(element['wallet']);
  }
}
