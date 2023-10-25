import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/marketplace_service.dart';

typedef PlantsState = AsyncValue<List<PotModel>>;

final plantsNotifierProvider =
    StateNotifierProvider<PlantsNotifier, PlantsState>((ref) {
  final service = ref.watch(marketplaceServiceProvider);

  return PlantsNotifier(service)..load();
});

class PlantsNotifier extends StateNotifier<PlantsState> {
  final MarketplaceService _service;

  PlantsNotifier(this._service) : super(const AsyncLoading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final pots = await _service.getSellingPots();
      state = AsyncValue.data(pots);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
