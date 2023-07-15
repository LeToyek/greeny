import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/garden.dart';

class GardenModel {
  static const String collectionPath = "gardens";
  final String id, name, backgroundUrl;
  final Future<List<PotModel>> pots;
  GardenModel(
      {required this.id,
      required this.name,
      required this.backgroundUrl,
      required this.pots});

  GardenModel.fromQuery(DocumentSnapshot<Object?> element)
      : id = element.id,
        name = element['name'],
        backgroundUrl = element['background_url'],
        pots = GardensServices.getGardenRef(element.id)
            .collection(PotModel.collectionPath)
            .get()
            .then((value) =>
                value.docs.map((e) => PotModel.fromQuery(e)).toList());
}

Map<Object, Object?> toQuery(GardenModel gardenModel) {
  return {
    "name": gardenModel.name,
    "background_url": gardenModel.backgroundUrl,
  };
}
