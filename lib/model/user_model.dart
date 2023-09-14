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
  WalletModel? wallet;

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

  void setWallet(WalletModel walletModel) {
    wallet = walletModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image_url': imageUrl,
      'user_id': userId,
      "exp": exp,
      "level": level,
      "photo_frame": photoFrame ?? "default",
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
      "wallet": wallet!.toMap(),
    };
  }
}
