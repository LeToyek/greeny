import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/pot_model.dart';

final marketplaceServiceProvider = Provider<MarketplaceService>((ref) {
  final firestore = FirebaseFirestore
      .instance; // harusnya ref.watch(firebaseFirestoreProvider)

  return MarketplaceServiceImpl(firestore);
});

abstract class MarketplaceService {
  Future<List<PotModel>> getSellingPots();
}

class MarketplaceServiceImpl implements MarketplaceService {
  final FirebaseFirestore _firestore;

  MarketplaceServiceImpl(this._firestore);

  @override
  Future<List<PotModel>> getSellingPots() async {
    // pots are stored in
    // /users/{user}/gardens/{garden}/pots/{pot}
    // get all filtered pots
    try {
      final pots = await _firestore
          .collectionGroup('pots')
          .where(
            'plant.price',
            isNull: false,
          )
          .get();

      // convert to pot model
      final potModels = pots.docs
          .map((e) => PotModel.fromQuery(e))
          .where((element) =>
              element.plant.marketStatus != 'sold' &&
              element.plant.price != null &&
              element.plant.price! > 0)
          .toList();

      // order by created at last is first
      potModels.sort((a, b) {
        final aDate = a.createdAtDate;
        final bDate = b.createdAtDate;

        if (aDate == null || bDate == null) {
          return 0;
        }

        return bDate.compareTo(aDate);
      });

      return potModels;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}
