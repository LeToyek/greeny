import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/user_model.dart';

class UsersServices {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<List<UserModel>> getUsers() async {
    List<UserModel> usersList = [
      UserModel(name: 'name', email: 'email', level: 1)
    ];
    QuerySnapshot querySnapshot = await users.get();
    for (var element in querySnapshot.docs) {
      usersList.add(UserModel(
          email: element['email'],
          name: element['name'],
          exp: element['exp'],
          level: element['level'],
          photoFrame: element['photo_frame'],
          imageUrl: element['image_url']));
    }
    return usersList;
  }
}
