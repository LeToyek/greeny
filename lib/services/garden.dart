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
    final gardens = gardenCollection.get().then(
        (value) => value.docs.map((e) => GardenModel.fromQuery(e)).toList());

    return gardens;
  }

  Future<GardenModel> getGardenById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('gardens').doc(id).get();
      GardenModel garden = GardenModel.fromQuery(documentSnapshot);

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
