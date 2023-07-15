import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/garden.dart';
import 'package:greenify/services/pot.dart';

class PotNotifier extends StateNotifier<AsyncValue<List<PotModel>>> {
  final PotServices potServices;
  PotNotifier({required this.potServices}) : super(const AsyncValue.loading());

  Future<void> getPots() async {
    try {
      final pots = await potServices.getPotsFromDB();
      state = AsyncValue.data(pots);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getPotById(String potId) async {
    try {
      state = const AsyncValue.loading();
      final pot = await potServices.getPotById(potId);
      state = AsyncValue.data([pot]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final potProvider = StateNotifierProviderFamily<PotNotifier,
        AsyncValue<List<PotModel>>, String>(
    (ref, arg) => PotNotifier(
        potServices: PotServices(gardenRef: GardensServices.getGardenRef(arg)))
      ..getPots());
