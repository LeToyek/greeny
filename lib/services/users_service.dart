import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenify/constants/level_list.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/model/wallet_model.dart';
import 'package:greenify/services/auth_service.dart';
import 'package:greenify/services/emblem_service.dart';
import 'package:greenify/services/storage_service.dart';

class UsersServices {
  StorageService storage = StorageService();
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late User? user = auth.currentUser;

  static DocumentReference getUserRef({String? id}) {
    id ??= FireAuth.getCurrentUser()!.uid;
    final userCollection = FirebaseFirestore.instance.collection("users");
    final docRef = userCollection.doc(id);
    return docRef;
  }

  Future<List<UserModel>> getUsers() async {
    List<UserModel> usersList = [];
    QuerySnapshot querySnapshot = await users.get();
    for (var element in querySnapshot.docs) {
      usersList.add(UserModel.fromQuery(element));
    }
    usersList.sort((a, b) => b.exp.compareTo(a.exp));
    return usersList;
  }

  Future<UserModel> getMainInfoUser({required String id}) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(id).get();
      print("infoSnap ${documentSnapshot.data()}");
      UserModel userMod = UserModel.fromQuery(documentSnapshot);
      return userMod;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<WalletModel> getWalletUser({required String id}) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(id).get();
      WalletModel wallet = WalletModel.fromMap(documentSnapshot['wallet']);
      return wallet;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel> getUserById({String? id}) async {
    try {
      id ??= user!.uid;
      DocumentSnapshot documentSnapshot = await users.doc(id).get();

      UserModel userMod = UserModel.fromQuery(documentSnapshot);

      DocumentReference userDocument =
          UsersServices.getUserRef(id: documentSnapshot.id);

      final resGarden =
          await userDocument.collection(GardenModel.collectionPath).get();
      final resAchievement =
          await userDocument.collection(AchievementModel.collectionPath).get();

      List<AchievementModel> achievementList = [];
      List<AchievementModel> pseudoAchievementList = [];
      if (resGarden.docs.isNotEmpty) {
        userMod.gardens = await userDocument
            .collection(GardenModel.collectionPath)
            .get()
            .then((value) =>
                value.docs.map((e) => GardenModel.fromQuery(e)).toList());
      }
      if (resAchievement.docs.isNotEmpty) {
        await Future.forEach(resAchievement.docs, (element) async {
          AchievementModel achievementModel =
              AchievementModel.fromQuery(element);
          achievementModel.emblem =
              await EmblemService.getEmblemByID(element.id);
          pseudoAchievementList.add(achievementModel);
          if (achievementModel.isExist) {
            achievementList.add(achievementModel);
          }
        });
      }
      userMod.achievements = achievementList;
      userMod.pseudoAchievements = pseudoAchievementList;
      print("data.first.achievements ${userMod.achievements}");

      List<BookModel> books = [];
      final resBook = await FirebaseFirestore.instance
          .collection("books")
          .orderBy('created_at', descending: true)
          .get();

      for (var element in resBook.docs) {
        final book = BookModel.fromQuery(element);
        if (book.userID == userMod.userId) {
          books.add(book);
        }
      }
      userMod.books = books;

      return userMod;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> updateProfilePhoto(String? oldUrl) async {
    try {
      await storage.deleteFile(oldUrl);
      String imageUrl = await storage.uploadFile();
      String? fullPath = await storage.getLinkDownloadFile(imageUrl);
      await users.doc(user!.uid).update({
        "image_url": fullPath!,
        "updated_at": DateTime.now(),
      });
      await FireAuth.getCurrentUser()!.updatePhotoURL(imageUrl);

      return fullPath;
    } catch (e) {
      throw Exception('Error occured! $e');
    }
  }

  Future<void> increaseLevelUser() async {
    try {
      await users.doc(user!.uid).update({
        "level": FieldValue.increment(1),
        "updated_at": DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error occured!');
    }
  }

  Future<String> increaseExpUser(int exp) async {
    try {
      UserModel? userModel = await getUserById();
      await users.doc(userModel.userId).update({
        "exp": FieldValue.increment(exp),
        "updated_at": DateTime.now(),
      });
      final levelUp = isLevelUp(userModel.exp + exp, userModel.level);

      if (levelUp && userModel.level < 10) {
        increaseLevelUser();
        print("test");
        return "level_up";
      }
      return "success";
    } catch (e) {
      throw Exception('Error occured!');
    }
  }

  bool isLevelUp(int exp, int level) {
    for (var e in levelList) {
      print("exp $exp}");
      if (e.level == level) {
        print("exp ${e.level == level}}");
        if (e.exp <= exp) {
          print("level up");
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }
}
