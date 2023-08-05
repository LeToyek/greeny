import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/garden_service.dart';
import 'package:greenify/services/pot_service.dart';

class HomeNotifier extends StateNotifier<AsyncValue<List<PotModel>>> {
  List<GardenModel> gardens = [];
  int lastIndex = 0;
  HomeNotifier() : super(const AsyncValue.data([]));

  Future<void> getPots() async {
    try {
      state = const AsyncValue.loading();
      List<GardenModel> resGarden = await GardensServices.getGardens();
      gardens = resGarden;
      final pots = await PotServices(
              gardenRef: GardensServices.getGardenRef(resGarden[0].id))
          .getPotsFromDB();

      state = AsyncValue.data(pots);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getNewPots({GardenModel? garden, String? date}) async {
    try {
      state = const AsyncValue.loading();
      final newPots = await PotServices(
              gardenRef: GardensServices.getGardenRef(
                  garden != null ? garden.id : gardens[lastIndex].id))
          .getPotsFromDB();
      state = AsyncValue.data(newPots);
      if (garden != null) {
        lastIndex = gardens.indexOf(garden);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  GardenModel? getGarden() {
    if (gardens.isEmpty) {
      return null;
    }
    return gardens[lastIndex];
  }

  List<GardenModel> getAllGarden() {
    print('gardens: $gardens');
    return gardens;
  }
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<PotModel>>>((ref) {
  return HomeNotifier()..getPots();
});
