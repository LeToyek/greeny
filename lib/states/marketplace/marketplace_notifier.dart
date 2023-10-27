import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/marketplace_service.dart';

typedef MarketplaceState = AsyncValue<List<PotModel>>;

final marketplaceNotifierProvider =
    StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  final service = ref.watch(marketplaceServiceProvider);

  return MarketplaceNotifier(service)..load();
});

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  final MarketplaceService _service;

  MarketplaceNotifier(this._service) : super(const AsyncLoading());

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
