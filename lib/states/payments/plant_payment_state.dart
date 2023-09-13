import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/plant_model.dart';

class PlantPaymentNotifier extends StateNotifier<AsyncValue<PlantModel>> {
  PlantPaymentNotifier() : super(const AsyncValue.loading());

  Future<void> getPot(PlantModel plant) async {
    try {
      state = AsyncValue.data(plant);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final plantPaymentProvider =
    StateNotifierProvider<PlantPaymentNotifier, AsyncValue<PlantModel>>(
        (ref) => PlantPaymentNotifier());
