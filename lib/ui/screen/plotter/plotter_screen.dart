import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:greenify/constants/plant_category_list.dart';
import 'package:greenify/ui/screen/plotter/list_item.dart';

class PlotterScreen extends StatefulWidget {
  const PlotterScreen({super.key});

  @override
  State<PlotterScreen> createState() => _PlotterScreenState();
}

class _PlotterScreenState extends State<PlotterScreen> {
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
            // child: UnityWidget(
            //   onUnityCreated: onUnityCreated,
            //   useAndroidViewSurface: false,
            //   fullscreen: false,
            //   hideStatus: false,
            // ),
            child: Container(
              color: Colors.blue,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            height: 220,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8,
                    ),
                    child: Consumer(builder: (context, ref, _) {
                      // final
                      return DropdownButton<String>(
                        value: 'DefaultPlant',
                        onChanged: (value) => {},
                        items: const [
                          DropdownMenuItem(
                            value: 'DefaultPlant',
                            child: Text('Default Plant'),
                          ),
                          DropdownMenuItem(
                            value: 'FlowerPlant',
                            child: Text('Flower Plant'),
                          ),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: characterImages.length,
                      padding: const EdgeInsets.symmetric(horizontal: 24) +
                          const EdgeInsets.only(bottom: 18 + 24),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => spawnPlant(
                                index == 0 ? 'DefaultPlant' : 'FlowerPlant',
                              ),
                              child: Container(
                                width: 100,
                                height: 100,
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                    characterImages[index]["image"]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
