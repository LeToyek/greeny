import 'package:greenify/model/plant_model.dart';

class PotModel {
  final String id;
  final PotStatus status;
  final PlantModel plant;
  final int positionIndex;

  PotModel(
      {required this.id,
      required this.status,
      required this.plant,
      required this.positionIndex});

  PotModel.fromQuery(Map<String, dynamic> element)
      : id = element['id'],
        status = element['status'],
        plant = PlantModel.fromQuery(element['plant']),
        positionIndex = element['position_index'];

  Map<String, dynamic> toQuery(PotModel potModel) {
    return {
      "id": potModel.id,
      "status": potModel.status,
      "position_index": potModel.positionIndex,
    };
  }
}

enum PotStatus { empty, locked, filled }
