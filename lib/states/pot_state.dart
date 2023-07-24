import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/garden_service.dart';
import 'package:greenify/services/pot_service.dart';

class PotNotifier extends StateNotifier<AsyncValue<List<PotModel>>> {
  List<PotModel> tempData = [];
  List<PotModel> fullData = [];
  final PotServices potServices;
  PotNotifier({required this.potServices}) : super(const AsyncValue.data([]));

  Future<void> getPots() async {
    try {
      state = const AsyncValue.loading();
      print('potServices = ${potServices.gardenRef.id}');
      final pots = await potServices.getPotsFromDB();
      state = AsyncValue.data(pots);
      tempData = pots;
      fullData = pots;
      print('tempData = $tempData');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getPotsByGardenId(
      {String? userId, required String docId}) async {
    try {
      state = const AsyncValue.loading();
      final pots = await PotServices(
              gardenRef: GardensServices.getGardenRefByUserID(
                  userId: userId, docId: docId))
          .getPotsFromDB();
      print("${potServices.gardenRef.id} and id $docId");
      print('pots = $pots');
      state = AsyncValue.data(pots);
      tempData = pots;
      fullData = pots;
      print("pots = $pots");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> turnBackData() async {
    try {
      state = const AsyncValue.loading();
      state = AsyncValue.data(fullData);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> waterPlant(int index) async {
    try {
      state = const AsyncValue.loading();
      fullData[index].plant.status = PlantStatus.healthy;
      await potServices.waterPlant(fullData[index].id!);
      state = AsyncValue.data(fullData);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getPotById(String potId) async {
    try {
      state = const AsyncValue.loading();
      final pot = tempData.where((element) => element.id == potId).toList();
      state = AsyncValue.data(pot);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<String> createPot(PotModel potModel) async {
    try {
      state = const AsyncValue.loading();

      potModel.id = await potServices.createPot(potModel);
      tempData.add(potModel);
      state = AsyncValue.data(tempData);
      return potModel.id!;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
    return "";
  }
}

final potProvider = StateNotifierProviderFamily<PotNotifier,
        AsyncValue<List<PotModel>>, String>(
    (ref, arg) => PotNotifier(
        potServices: PotServices(gardenRef: GardensServices.getGardenRef(arg)))
      ..getPots());

// final detailPotProvider = StateNotifierProviderFamily<PotNotifier,
//         AsyncValue<List<PotModel>>, List<String>>(
//     (ref, arg) => PotNotifier(
//         potServices: PotServices.getInstance(
//             gardenRef: GardensServices.getGardenRef(arg.first)))
//       ..getPotById(arg.last));

final singlePotProvider = StateNotifierProviderFamily<PotNotifier,
        AsyncValue<List<PotModel>>, String>(
    (ref, arg) => PotNotifier(
        potServices:
            PotServices(gardenRef: GardensServices.getGardenRef(arg))));
