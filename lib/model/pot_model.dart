import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/plant_model.dart';

class PotModel {
  final String id;
  final PotStatus status;
  final int positionIndex;
  final PlantModel plant;
  static const String collectionPath = 'pots';

  PotModel(
      {required this.id,
      required this.status,
      required this.positionIndex,
      required this.plant});

  PotModel.fromQuery(DocumentSnapshot<Object?> element)
      : id = element.id,
        status = element['status'],
        positionIndex = element['position_index'],
        plant = PlantModel.fromQuery(element['plant']);

  //       plant = Potserv

  // Map<String, dynamic> toQuery(PotModel potModel) {
  //   return {
  //     "id": potModel.id,
  //     "status": potModel.status,
  //     "position_index": potModel.positionIndex,
  //   };
  // }
}

enum PotStatus { empty, locked, filled }
