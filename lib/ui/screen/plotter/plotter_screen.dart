import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:greenify/constants/plant_category_list.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/ui/screen/plotter/list_item.dart';
import 'package:ionicons/ionicons.dart';

class PlotterScreen extends ConsumerStatefulWidget {
  const PlotterScreen({super.key});

  @override
  ConsumerState<PlotterScreen> createState() => _PlotterScreenState();
}

class _PlotterScreenState extends ConsumerState<PlotterScreen> {
  UnityWidgetController? _unityWidgetController;

  void onUnityCreated(controller) {
    setState(() {
      _unityWidgetController = controller;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _unityWidgetController?.dispose();
  }

  void spawnPlant([String plant = 'DefaultPlant']) {
    _unityWidgetController?.postMessage(
      'SpawnerManager',
      'SpawnFromFlutter',
      plant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterImages = plantCategory;

    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 230,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              useAndroidViewSurface: false,
              fullscreen: false,
              hideStatus: false,
            ),
            // child: Container(
            //   color: Colors.blue,
            // ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            height: 240,
            child: PlotterPlantSelector(
              onPlantSelected: (pot) => spawnPlant(
                pot.plant.category == 'Sayur' ? 'DefaultPlant' : 'FlowerPlant',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlotterPlantSelector extends ConsumerStatefulWidget {
  const PlotterPlantSelector({
    super.key,
    this.onPlantSelected,
  });

  final Function(PotModel pot)? onPlantSelected;

  @override
  ConsumerState<PlotterPlantSelector> createState() =>
      _PlotterPlantSelectorState();
}

class _PlotterPlantSelectorState extends ConsumerState<PlotterPlantSelector> {
  GardenModel? garden;

  @override
  Widget build(BuildContext context) {
    final gardenRef = ref.watch(gardenProvider);

    garden ??= gardenRef.maybeWhen(
      data: (data) => data[0],
      orElse: () => null,
    );

    final potsRef = garden == null
        ? const AsyncValue<List<PotModel>>.data([])
        : ref.watch(potProvider(garden?.id ?? ''));

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 16,
            ),
            child: gardenRef.when(
              data: (data) {
                return Row(
                  children: [
                    Icon(
                      Ionicons.leaf_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<GardenModel>(
                        value: garden,
                        onChanged: (value) {
                          setState(() {
                            garden = value;
                          });
                        },
                        items: data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Text("Loading"),
              error: (e, s) => Text(e.toString()),
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            height: 8,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: potsRef.when(
              error: (e, s) => Text(e.toString()),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (pots) => pots.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24) +
                          const EdgeInsets.only(bottom: 18 + 24),
                      child: const Center(
                        child: Text("Belum ada tanaman pada garden ini :("),
                      ),
                    )
                  : ListView.builder(
                      itemCount: pots.length,
                      padding: const EdgeInsets.symmetric(horizontal: 24) +
                          const EdgeInsets.only(top: 8, bottom: 18 + 24),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => widget.onPlantSelected?.call(
                                  pots[index],
                                ),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          plantCategory
                                              .where((element) =>
                                                  element['name'] ==
                                                  pots[index].plant.category)
                                              .toList()[0]['image'],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        pots[index].plant.name,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        children: const [
          ListItem(
            judul: "abc",
          ),
          ListItem(
            judul: "def",
          ),
          ListItem(
            judul: "lskdfm",
          ),
          ListItem(
            judul: "asdf",
          ),
        ],
      ),
    );
  }
}
