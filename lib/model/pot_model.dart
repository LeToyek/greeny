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
}

enum PotStatus { empty, locked, filled }
