import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/garden_service.dart';
import 'package:greenify/services/pot_service.dart';

class HomeNotifier extends StateNotifier<AsyncValue<List<PotModel>>> {
  HomeNotifier() : super(const AsyncValue.data([]));

  Future<void> getPots() async {
    try {
      state = const AsyncValue.loading();
      List<GardenModel> garden = await GardensServices.getGardens();
      final pots = await PotServices(
              gardenRef: GardensServices.getGardenRef(garden[0].id))
          .getPotsFromDB();

      state = AsyncValue.data(pots);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<PotModel>>>((ref) {
  return HomeNotifier()..getPots();
});
