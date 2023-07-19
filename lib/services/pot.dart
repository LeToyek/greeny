import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/pot_model.dart';

class PotServices {
  static const String collectionPath = 'pots';
  final DocumentReference gardenRef;

  // static PotServices? _instance;

  PotServices({required this.gardenRef});
  // PotServices._internal({required this.gardenRef});

  // factory PotServices.getInstance({required DocumentReference gardenRef}) {
  //   _instance ??= PotServices._internal(gardenRef: gardenRef);
  //   return _instance!;
  // }

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

  Future<PotModel?> getPotByIdFromDb(String potId) async {
    try {
      final potDoc =
          await gardenRef.collection(collectionPath).doc(potId).get();
      PotModel pot = PotModel.fromQuery(potDoc);
      return pot;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> createPot(PotModel potModel) async {
    try {
      await gardenRef.collection(collectionPath).add(potModel.toQuery());

      return "success";
    } catch (e) {
      throw Exception(e);
    }
  }
}
