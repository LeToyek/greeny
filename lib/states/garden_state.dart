import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/services/garden.dart';

class GardenNotifier extends StateNotifier<AsyncValue<List<GardenModel>>> {
  GardenNotifier() : super(const AsyncValue.loading());

  Future<void> getGardens() async {
    try {
      final gardens = await GardensServices.getGardens();
      state = AsyncValue.data(gardens);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getGardenByID(String id) async {
    try {
      final gardens = await GardensServices.getGardenById(id);
      state = AsyncValue.data([gardens]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getGardensByUserId({String? id}) async {
    try {
      final gardens = await GardensServices.getGardenByUserId(id);
      state = AsyncValue.data(gardens);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final gardenProvider =
    StateNotifierProvider<GardenNotifier, AsyncValue<List<GardenModel>>>((ref) {
  return GardenNotifier()..getGardens();
});

final userGardenProvider =
    StateNotifierProvider<GardenNotifier, AsyncValue<List<GardenModel>>>((ref) {
  return GardenNotifier()..getGardensByUserId();
});
