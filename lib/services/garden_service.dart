import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/services/users_service.dart';

class GardensServices {
  // Get all gardens
  static DocumentReference getGardenRef(String docId) {
    return UsersServices.getUserRef()
        .collection(GardenModel.collectionPath)
        .doc(docId);
  }

  static DocumentReference getGardenRefByUserID(
      {String? userId, required String docId}) {
    return UsersServices.getUserRef(id: userId)
        .collection(GardenModel.collectionPath)
        .doc(docId);
  }

  static Future<void> createGarden(String name, String backgroundUrl) async {
    try {
      await UsersServices.getUserRef()
          .collection(GardenModel.collectionPath)
          .add({
        "name": name,
        "background_url": backgroundUrl,
        "created_at": DateTime.now(),
        'updated_at': DateTime.now(),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<GardenModel>> getGardens() async {
    final gardenCollection =
        UsersServices.getUserRef().collection(GardenModel.collectionPath);

    final rawGardens = await gardenCollection.get();
    final gardens =
        rawGardens.docs.map((e) => GardenModel.fromQuery(e)).toList();
    print(gardens[0].backgroundUrl);

    return gardens;
  }

  static Future<List<GardenModel>> getGardenByUserId(String? id) async {
    final gardenCollection =
        UsersServices.getUserRef(id: id).collection(GardenModel.collectionPath);

    final rawGardens = await gardenCollection.get();
    final gardens =
        rawGardens.docs.map((e) => GardenModel.fromQuery(e)).toList();

    return gardens;
  }

  static Future<GardenModel> getGardenById(String id) async {
    try {
      final gardenDoc = await UsersServices.getUserRef()
          .collection(GardenModel.collectionPath)
          .doc(id)
          .get();
      GardenModel garden = GardenModel.fromQuery(gardenDoc);

      return garden;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateGarden(
      String id, String name, String backgroundUrl) async {
    try {
      await FirebaseFirestore.instance.collection('gardens').doc(id).update({
        "name": name,
        "background_url": backgroundUrl,
        "updated_at": DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error occured!');
    }
  }
}
