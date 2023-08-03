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
import 'package:greenify/ui/widgets/card/plant_card.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

class GardenSpaceScreen extends ConsumerWidget {
  final String id;
  const GardenSpaceScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenRef = ref.watch(gardenProvider);
    final potsRef = ref.watch(potProvider(id));
    final potsNotifier = ref.watch(potProvider(id).notifier);

    final expRef = ref.watch(expProvider);
    final expNotifier = ref.watch(expProvider.notifier);
    final userClientController = ref.read(userClientProvider.notifier);

    final singleNotifier = ref.read(singleUserProvider.notifier);

    final textTheme = Theme.of(context).textTheme;

    bool isWatering = false;

    int waterExp = 20;
    List<String> achievementIDs = [
      "cWmOltw7SolOmbm1akM5",
      "RL7wKvRiysNsPhUEjG2z"
    ];

    const int maxPlantCount = 16;
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        centerTitle: true,
        title: const Text(
          "Garden Space",
        ),
      ),
      body: Stack(
        children: [
          Material(
              color: Theme.of(context).colorScheme.background,
              child: potsRef.when(data: (data) {
                print('data: $data');
                return ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                          double counterHeight =
                              data[index].plant.heightStat != null
                                  ? data[index].plant.heightStat!.last.height
                                  : 0;
                          return GestureDetector(
                            onTap:
                                data[index].plant.status == PlantStatus.dry &&
                                        userClientController.isSelf()
                                    ? () {
                                        print(counterHeight);
                                        print(
                                            'data[index].plant.heightStat: ${data[index].plant.heightStat}');
                                        showDialog(
                                            context: context,
                                            builder:
                                                (context) => StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                "Ukur ketinggian tanamanmu",
                                                                style: textTheme.titleLarge!.apply(
                                                                    fontWeightDelta:
                                                                        2,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onSurface),
                                                              ),
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                              Lottie.network(
                                                                  "https://lottie.host/35acbdf6-a272-4ca5-b5bc-a3d6aae25c04/mI4jAwJBdz.json",
                                                                  height: 72),
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary),
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          setState(
                                                                              () {
                                                                            if (counterHeight >
                                                                                0) {
                                                                              counterHeight--;
                                                                            }
                                                                          });
                                                                        },
                                                                        icon: Icon(
                                                                          Ionicons
                                                                              .remove,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onPrimary,
                                                                        )),
                                                                  ),
                                                                  Text(
                                                                    "$counterHeight cm",
                                                                    style: textTheme.titleLarge!.apply(
                                                                        fontWeightDelta:
                                                                            2,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onSurface),
                                                                  ),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary),
                                                                      child: IconButton(
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              if (counterHeight < 10000) {
                                                                                counterHeight++;
                                                                              }
                                                                            });
                                                                          },
                                                                          icon: Icon(
                                                                            Ionicons.add,
                                                                            color:
                                                                                Theme.of(context).colorScheme.onPrimary,
                                                                          ))),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                              Text(
                                                                "Jangan lupa untuk mengukur ketinggian tanamanmu ya setiap menyiramnya!",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textTheme
                                                                    .bodyMedium!
                                                                    .apply(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onSurface),
                                                              ),
                                                              const SizedBox(
                                                                height: 16,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Batal")),
                                                                  StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                    return ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                            () {
                                                                              isWatering = true;
                                                                            },
                                                                          );
                                                                          expNotifier.increaseExp(
                                                                              waterExp,
                                                                              achievementIDs);
                                                                          potsNotifier.waterPlant(
                                                                              index,
                                                                              counterHeight);
                                                                          context
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            "Siram"));
                                                                  }),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ));
                                      }
                                    : () {
                                        context.push(
                                            "/garden/$id/detail/${data[index].id}");
                                        potsNotifier
                                            .getPotById(data[index].id!);
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
                print(error);
                return Center(
                  child: Text(error.toString()),
                );
              }), loading: () {
                return isWatering
                    ? Center(
                        child: LottieBuilder.network(
                            "https://lottie.host/4bf3a194-fe78-4c88-a433-0d025161afd8/nr0ZJBhjEI.json"))
                    : const Center(
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
    );
  }
}
