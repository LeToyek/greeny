import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/pot_model.dart';

class GardenModel {
  static const String collectionPath = "gardens";
  final String name, backgroundUrl;
  final List<PotModel> pots;
  GardenModel(
      {required this.name, required this.backgroundUrl, required this.pots});

  GardenModel.fromQuery(DocumentSnapshot<Object?> element)
      : name = element['name'],
        backgroundUrl = element['background_url'],
        pots = [];

  Map<Object, Object?> toQuery(GardenModel gardenModel) {
    return {
      "name": gardenModel.name,
      "background_url": gardenModel.backgroundUrl,
    };
  }
}
