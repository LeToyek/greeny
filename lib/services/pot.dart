import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/pot_model.dart';

class PotServices {
  static const String collectionPath = 'pots';
  final DocumentReference gardenRef;

  PotServices({required this.gardenRef});

  Future<List<PotModel>> getPotsFromDB() async {
    try {
      final docPots = await gardenRef.collection(collectionPath).get();
      print(docPots);
      final pots = docPots.docs.map((e) => PotModel.fromQuery(e)).toList();
      return pots;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PotModel> getPotById(String potId) async {
    try {
      final potDoc =
          await gardenRef.collection(collectionPath).doc(potId).get();
      PotModel pot = PotModel.fromQuery(potDoc);
      return pot;
    } catch (e) {
      throw Exception(e);
    }
  }
}
