import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/height_model.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/services/background_service.dart';
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
      tempData = pots;
      fullData = pots;
      print('tempData = $tempData');
      state = AsyncValue.data(pots);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getTopPots(String gardenID) async {
    try {
      state = const AsyncValue.loading();
      const userId = "jCrKt22Hp6eX7unsc0jHvodUmFu1";
      final garden =
          GardensServices.getGardenRefByUserID(docId: gardenID, userId: userId);
      final pots = await PotServices(gardenRef: garden).getPotsFromDB();
      print('gardenb = $gardenID');

      state = AsyncValue.data(pots);
      tempData = pots;
      fullData = pots;
      print('tempData = $tempData');
    } catch (e) {
      print("aerror $e");
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getPotsByGardenId(
      {String? userId, required String docId}) async {
    try {
      final isSelf = userId == null;
      state = const AsyncValue.loading();
      final pots = await PotServices(
              gardenRef: GardensServices.getGardenRefByUserID(
                  userId: userId, docId: docId))
          .getPotsFromDB();
      List<PotModel> cleanedPots = pots.map<PotModel>((e) {
        final lastWatering = DateTime.parse(e.plant.heightStat!.last.date);
        final tempTime = DateTime(
            lastWatering.year,
            lastWatering.month,
            lastWatering.day + int.parse(e.plant.wateringSchedule),
            lastWatering.hour);
        print("is Self = $isSelf");
        if (isSelf && tempTime.isBefore(DateTime.now())) {
          print("get");
          if (e.plant.status != PlantStatus.dry) {
            potServices.updatePlantStatus(e.id!);
          }
          e.plant.status = PlantStatus.dry;
        }
        return e;
      }).toList();
      state = AsyncValue.data(cleanedPots);
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

  Future<void> selfWaterPlant(int height, String id) async {
    try {
      state = const AsyncValue.loading();
      final selectedPot = fullData.firstWhere((element) => element.id == id);
      final plant = selectedPot.plant;
      final potHeight = plant.heightStat!;
      final lastDate = DateTime.parse(potHeight.last.date);
      final lastHeight =
          HeightModel(height: height, date: DateTime.now().toString());
      await potServices.waterPlant(id, lastHeight);
      potHeight.last = lastHeight;
      state = AsyncValue.data([selectedPot]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> waterPlant(int index, int height) async {
    try {
      state = const AsyncValue.loading();
      final selectedPlant = fullData[index].plant;
      selectedPlant.status = PlantStatus.healthy;
      await AndroidAlarmManager.cancel(selectedPlant.timeID!);

      final lastHeight =
          HeightModel(height: height, date: DateTime.now().toString());
      selectedPlant.heightStat!.last = lastHeight;
      await potServices.waterPlant(fullData[index].id!, lastHeight);

      List<String> timeParts = selectedPlant.wateringTime.split(':');
      int hours = int.parse(
          timeParts[0].startsWith('0') ? timeParts[0][1] : timeParts[0]);
      int minutes = int.parse(
          timeParts[1].startsWith('0') ? timeParts[1][1] : timeParts[1]);

      DateTime now = DateTime.now();
      DateTime tomorrow = DateTime(
        now.year,
        now.month,
        now.day + int.parse(selectedPlant.wateringSchedule),
        hours,
        minutes,
      );
      final alarm = await AndroidAlarmManager.oneShotAt(
          tomorrow, selectedPlant.timeID!, BackgroundServices.callback);
      print('alarm on state $alarm');

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

  Future<void> getbestPotById(String potId) async {
    try {
      state = const AsyncValue.loading();
      List<PotModel> finalArray = [];
      late final int selectedIndex;
      for (var i = 0; i < tempData.length; i++) {
        if (tempData[i].id == potId) {
          selectedIndex = i;
          finalArray.add(tempData[i]);
        }
      }
      tempData.map((e) {
        if (e.id != potId) {
          finalArray.add(e);
        }
      });

      state = AsyncValue.data(finalArray);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<String> createPot(PotModel potModel) async {
    try {
      state = const AsyncValue.loading();
      potModel.createdAt = DateTime.now().toString();
      potModel.updatedAt = DateTime.now().toString();
      potModel.id = await potServices.createPot(potModel);
      tempData.add(potModel);

      state = AsyncValue.data(tempData);
      return potModel.id!;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
    return "";
  }

  Future<String> editPot(PotModel potModel) async {
    try {
      state = const AsyncValue.loading();
      potModel.updatedAt = DateTime.now().toString();
      await potServices.updatePot(potModel);
      tempData.add(potModel);

      state = AsyncValue.data(tempData);
      return potModel.id!;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
    return "";
  }

  Future<void> deletePot(String potId) async {
    try {
      state = const AsyncValue.loading();
      await potServices.deletePot(potId);
      tempData.removeWhere((element) => element.id == potId);
      state = AsyncValue.data(tempData);
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
final bestPotProvider = StateNotifierProviderFamily<PotNotifier,
        AsyncValue<List<PotModel>>, String>(
    (ref, arg) => PotNotifier(
        potServices:
            PotServices(gardenRef: GardensServices.getBestUserGardenRef(arg)))
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
