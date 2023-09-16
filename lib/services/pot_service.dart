import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/height_model.dart';
import 'package:greenify/model/plant_model.dart';
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
      final pots = docPots.docs.map((e) => PotModel.fromQuery(e)).toList();
      return pots;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<PotModel>> getBestPotsFromDB() async {
    try {
      final docPots = await gardenRef.collection(collectionPath).limit(4).get();

      final pots = docPots.docs.map((e) => PotModel.fromQuery(e)).toList();
      return pots;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePlantStatus(String id) async {
    try {
      await gardenRef.collection(collectionPath).doc(id).update({
        "plant.status": "dry",
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> waterPlant(String id, HeightModel value) async {
    try {
      await gardenRef.collection(collectionPath).doc(id).update({
        "plant.status": "healthy",
        "plant.height_stat": FieldValue.arrayUnion([value.toQuery()])
      });
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
      final ref =
          await gardenRef.collection(collectionPath).add(potModel.toQuery());
      final res = await ref.get();

      return res.id;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePot(PotModel potModel) async {
    try {
      await gardenRef
          .collection(collectionPath)
          .doc(potModel.id)
          .update(potModel.toQuery());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletePot(String potId) async {
    try {
      await gardenRef.collection(collectionPath).doc(potId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<PlantModel> getPlantFromRef(String ref) async {
    try {
      final res = await FirebaseFirestore.instance.doc(ref).get();
      print("res: ${res.data()}");
      final plant = PlantModel.fromQuery(res.data()!['plant']);
      return plant;
    } catch (e) {
      throw Exception(e);
    }
  }
}
