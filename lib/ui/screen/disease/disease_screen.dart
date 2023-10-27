import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/disease_service.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/achievement_dialog.dart';
import 'package:image/image.dart' as imglib;

class DiseaseScreen extends ConsumerStatefulWidget {
  const DiseaseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends ConsumerState<DiseaseScreen> {
  final TFLiteDiseaseDetectionService _diseaseDetectionService =
      TFLiteDiseaseDetectionService();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String imagePath;
  bool isLoading = true;
  bool isProcessing = false;

  List<CameraDescription> cameras = [];

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    _controller.setExposurePoint(offset);
    _controller.setFocusPoint(offset);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    }).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _diseaseDetectionService.dispose();
  }

  void changeCamera(CameraDescription cameraDescription) async {
    await _controller.dispose();
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final expRef = ref.watch(expProvider);
    final expNotifier = ref.watch(expProvider.notifier);
    final singleNotifier = ref.read(singleUserProvider.notifier);
    // final userClientController = ref.read(userClientProvider.notifier);

    int aiExp = 20;
    List<String> achievementIDs = [
      "00zvXoQO7ScRbcSpiiay",
      "E7Y6oP3lzSBHzXRLcN9S"
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(
                    _controller,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) =>
                              onViewFinderTap(details, constraints),
                        );
                      },
                    ),
                  ),
                ),
                if (isProcessing)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Processing...",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                else
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
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            // Provide an onPressed callback.
            heroTag: 'fab_disease',
            enableFeedback: true,

            onPressed: isProcessing
                ? null
                : () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      setState(() {
                        isProcessing = true;
                      });
                      await _initializeControllerFuture;

                      // Attempt to take a picture and get the file `image`
                      // where it was saved.
                      final image = await _controller.takePicture();

                      if (!mounted) return;

                      // If the picture was taken, display it on a new screen.
                      setState(() {
                        imagePath = image.path;
                      });

                      final bytes = await File(image.path).readAsBytes();
                      final imglib.Image imageRes = imglib.decodeImage(bytes)!;
                      print("imageRes: $imageRes");
                      Map<String, dynamic> res = await _diseaseDetectionService
                          .detectDisease(imageRes);

                      await expNotifier.increaseExp(aiExp, achievementIDs);
                      setState(() {
                        isProcessing = false;
                      });

                      if (context.mounted) {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Hasil Deteksi Greeny",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  fontWeightDelta: 2,
                                                  fontSizeDelta: 4)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(res["nama"],
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeightDelta: 2,
                                              fontSizeDelta: 8)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text("Penanganan",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeightDelta: 2,
                                              fontSizeDelta: 4)),
                                  Text(res["penanganan"],
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeightDelta: 1,
                                              fontSizeDelta: 2)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text("Obat",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeightDelta: 2,
                                              fontSizeDelta: 4)),
                                  Text(res["obat"],
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeightDelta: 1,
                                              fontSizeDelta: 2)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text("Gambar Tanaman",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeightDelta: 2,
                                              fontSizeDelta: 4)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          height: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  res['images'][0]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  res['images'][1]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          height: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  res['images'][2]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(
            width: 16,
          ),
          // change camera
          FloatingActionButton(
            heroTag: 'fab_change_camera',
            onPressed: isProcessing
                ? null
                : () {
                    if (cameras.length > 1) {
                      if (_controller.description == cameras[0]) {
                        changeCamera(cameras[1]);
                      } else {
                        changeCamera(cameras[0]);
                      }
                    }
                  },
            child: const Icon(Icons.flip_camera_android),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
