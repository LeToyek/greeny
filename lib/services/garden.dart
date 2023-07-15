import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/services/users.dart';

class GardensServices {
  // Get all gardens
  static DocumentReference getGardenRef(String docId) {
    return UsersServices.getUserRef()
        .collection(GardenModel.collectionPath)
        .doc(docId);
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
