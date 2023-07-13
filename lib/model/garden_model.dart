import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/pot_model.dart';

class GardenModel {
  final String name, backgroundUrl, gardenId;
  final List<PotModel> pots;
  GardenModel(
      {required this.name,
      required this.backgroundUrl,
      required this.gardenId,
      required this.pots});

  GardenModel.fromQuery(DocumentSnapshot<Object?> element)
      : name = element['name'],
        backgroundUrl = element['background_url'],
        gardenId = element['garden_id'],
        pots = (element['pots'] as List)
            .map((e) => PotModel.fromQuery(e))
            .toList();
}
