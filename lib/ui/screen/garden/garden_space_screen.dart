import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/constants/plant_category_list.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/achievement_dialog.dart';
import 'package:greenify/ui/widgets/action_menu.dart';
import 'package:greenify/ui/widgets/card/plant_card.dart';
import 'package:greenify/ui/widgets/watering_dialog.dart';
import 'package:ionicons/ionicons.dart';

class GardenSpaceScreen extends ConsumerWidget {
  final String id;
  const GardenSpaceScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenRef = ref.watch(gardenProvider.notifier);
    final potsRef = ref.watch(potProvider(id));
    final potsNotifier = ref.watch(potProvider(id).notifier);

    final expRef = ref.watch(expProvider);
    final expNotifier = ref.watch(expProvider.notifier);
    final userClientController = ref.read(userClientProvider.notifier);

    final singleNotifier = ref.read(singleUserProvider.notifier);

    final textTheme = Theme.of(context).textTheme;
    var appBarHeight = AppBar().preferredSize.height;

    bool isWatering = false;

    int waterExp = 20;
    List<String> achievementIDs = [
      "cWmOltw7SolOmbm1akM5",
      "RL7wKvRiysNsPhUEjG2z"
    ];

    const int maxPlantCount = 16;
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        gardenRef.getGardens();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            !userClientController.isSelf()
                ? Container()
                : PopupMenuButton(
                    offset: Offset(0.0, appBarHeight),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    itemBuilder: (context) => [
                          buildPopupMenuItem(
                              text: "Edit Garden",
                              context: context,
                              icon: Ionicons.pencil_outline,
                              content: "Ubah detail informasi tanaman ini",
                              position: 0,
                              additionalActions: [
                                TextButton(
                                    onPressed: () {
                                      final garden = gardenRef.getThisGarden();
                                      context.pop();
                                      context.push("/garden/edit/$id",
                                          extra: garden);
                                    },
                                    child: const Text("Ubah")),
                              ]),
                          buildPopupMenuItem(
                              text: "Hapus Garden",
                              context: context,
                              icon: Ionicons.trash_bin_outline,
                              content:
                                  "Garden anda akan dihapus secara permanen",
                              position: 1,
                              isDelete: true,
                              additionalActions: [
                                TextButton(
                                    onPressed: () {
                                      gardenRef.deleteGarden(id);
                                      context.pop();
                                      context.pop();
                                    },
                                    child: const Text("Hapus")),
                              ]),
                        ])
          ],
          leading: IconButton(
            onPressed: () {
              gardenRef.getGardens();
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: Text(
            gardenRef.getThisGarden() == null
                ? "Garden Space"
                : gardenRef.getThisGarden()!.name,
          ),
        ),
        body: Stack(
          children: [
            Material(
                color: Theme.of(context).colorScheme.background,
                child: potsRef.when(data: (data) {
                  print('data: $data');
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: maxPlantCount,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 7 / 13,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 12),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            print('index: $index');
                            if (index == data.length &&
                                userClientController.isSelf()) {
                              print('index: $index');
                              return GestureDetector(
                                onTap: () => context.push("/garden/form/$id"),
                                child: PlantCard(
                                  status: PlantBoxStatus.empty,
                                  title: 'Add Plant',
                                  imageURI: "lib/assets/images/dumPlant.png",
                                ),
                              );
                            }
                            if (index >= data.length) {
                              print('index2: $index');
                              return PlantCard(
                                title: 'Empty',
                                imageURI: "lib/assets/images/dumPlant.png",
                              );
                            }

                            int counterHeight =
                                data[index].plant.heightStat != null
                                    ? data[index].plant.heightStat!.last.height
                                    : 0;
                            return GestureDetector(
                              onTap: data[index].plant.status ==
                                          PlantStatus.dry &&
                                      userClientController.isSelf()
                                  ? () {
                                      showWateringDialog(
                                          context: context,
                                          textTheme: textTheme,
                                          counterHeight: counterHeight,
                                          isDetail: false,
                                          potsNotifier: potsNotifier,
                                          index: index,
                                          expNotifier: expNotifier,
                                          waterExp: waterExp,
                                          achievementIDs: achievementIDs);
                                    }
                                  : () {
                                      userClientController
                                          .setVisitedUserModel();
                                      context.push(
                                          "/garden/$id/detail/${data[index].id}");
                                      potsNotifier.getPotById(data[index].id!);
                                      return;
                                    },
                              child: Stack(
                                children: [
                                  PlantCard(
                                    status: PlantBoxStatus.filled,
                                    title: data[index].plant.name,
                                    imageURI: plantCategory
                                        .where((element) =>
                                            element['name'] ==
                                            data[index].plant.category)
                                        .toList()[0]['image'],
                                  ),
                                  data[index].plant.status == PlantStatus.dry
                                      ? Positioned(
                                          // top: 0,
                                          // right: 0,
                                          // bottom: 0,
                                          // left: 0,
                                          child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          width: 32,
                                          height: 32,
                                          child: const Icon(
                                            Ionicons.water,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ))
                                      : Container()
                                ],
                              ),
                            );
                          },
                        ),
                      ]);
                }, error: ((error, stackTrace) {
                  return Center(
                    child: Text(error.toString()),
                  );
                }), loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })),
            expRef.when(
              data: (data) {
                if (data.isNotEmpty) {
                  for (var e in data) {
                    if (e.isExist && !e.isClosed) {
                      return AchievementDialog(
                          achievementModel: e, expNotifier: expNotifier);
                    }
                  }
                }
                return Container();
              },
              loading: () => Container(),
              error: (e, s) => Container(),
            ),
          ],
        ),
      ),
    );
  }
}
