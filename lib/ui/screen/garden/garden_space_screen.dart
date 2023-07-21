import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/ui/widgets/achievement_dialog.dart';
import 'package:greenify/ui/widgets/card/plant_card.dart';

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
              child: gardenRef.when(
                  data: (garden) {
                    return potsRef.when(data: (data) {
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
                                if (index == data.length) {
                                  return GestureDetector(
                                    onTap: () =>
                                        context.push("/garden/form/$id"),
                                    child: PlantCard(
                                      status: PlantBoxStatus.empty,
                                      title: 'Add Plant',
                                      imageURI:
                                          "lib/assets/images/dumPlant.png",
                                    ),
                                  );
                                }
                                if (index > data.length) {
                                  return PlantCard(
                                    title: 'Empty',
                                    imageURI: "lib/assets/images/dumPlant.png",
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                        "/garden/$id/detail/${data[index].id}");
                                    potsNotifier.getPotById(data[index].id!);
                                    return;
                                  },
                                  child: PlantCard(
                                    status: PlantBoxStatus.filled,
                                    title: data[index].plant.name,
                                    imageURI: "lib/assets/images/dumPlant.png",
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
                      print("loading");
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text(e.toString())))),
          expRef.when(
            data: (data) {
              if (data.isNotEmpty &&
                  data.last.isExist &&
                  data.last.isClaimed &&
                  data.last.isClosed) {
                return achievementDialog(context, data.last, expNotifier);
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
