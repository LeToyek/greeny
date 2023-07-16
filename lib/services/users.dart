import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/services/auth.dart';
import 'package:greenify/services/storage.dart';

class UsersServices {
  StorageService storage = StorageService();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;

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

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(id).get();
      UserModel userMod = UserModel.fromQuery(documentSnapshot);

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
      throw Exception('Error occured!');
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

  Future<void> increaseExpUser(int exp) async {
    try {
      await users.doc(user!.uid).update({
        "exp": FieldValue.increment(exp),
        "updated_at": DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error occured!');
    }
  }
}
