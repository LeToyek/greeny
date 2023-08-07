import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/services/garden_service.dart';

class GardenNotifier extends StateNotifier<AsyncValue<List<GardenModel>>> {
  List<GardenModel> fullData = [];
  GardenNotifier() : super(const AsyncValue.loading());

  Future<void> getGardens() async {
    try {
      state = const AsyncValue.loading();
      final gardens = await GardensServices.getGardens();
      state = AsyncValue.data(gardens);
    } catch (e) {
      print('error = $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getGardenByID(String id) async {
    try {
      final gardens = await GardensServices.getGardenById(id);
      fullData = [gardens];
      state = AsyncValue.data([gardens]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  GardenModel? getThisGarden() {
    print(fullData);
    if (fullData.isEmpty) {
      return null;
    }
    return fullData.first;
  }

  Future<void> getGardensByUserId({String? id}) async {
    try {
      final gardens = await GardensServices.getGardenByUserId(id);
      fullData = gardens;
      state = AsyncValue.data(gardens);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createGarden(String name, String backgroundUrl) async {
    try {
      await GardensServices.createGarden(name, backgroundUrl);
      getGardens();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateGarden(
      String id, String name, String backgroundUrl) async {
    try {
      state = const AsyncValue.loading();
      await GardensServices.updateGarden(id, name, backgroundUrl);
      getGardens();
    } catch (e) {
      print('update error');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteGarden(String id) async {
    try {
      state = const AsyncValue.loading();
      await GardensServices.deleteGarden(id);
      getGardens();
    } catch (e) {
      print('delete error');
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
