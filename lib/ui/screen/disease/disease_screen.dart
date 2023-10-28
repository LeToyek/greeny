import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/disease_model.dart';
import 'package:greenify/model/soill_model.dart';
import 'package:greenify/services/disease_service.dart';
import 'package:greenify/services/soil_service.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/ui/screen/disease/disease_detection_bottom_sheet.dart';
import 'package:greenify/ui/widgets/achievement_dialog.dart';
import 'package:image/image.dart' as imglib;

import 'soil_detection_bottom_sheet.dart';

enum DetectionMode {
  disease,
  soil,
}

class DiseaseScreen extends ConsumerStatefulWidget {
  const DiseaseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends ConsumerState<DiseaseScreen> {
  DetectionMode? _detectionMode = DetectionMode.disease;

  final TFLiteDiseaseDetectionService _diseaseDetectionService =
      TFLiteDiseaseDetectionService();
  final TFLiteSoilDetectionService _soilDetectionService =
      TFLiteSoilDetectionService();
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  late String imagePath;
  bool isLoading = true;
  String? processMessage;

  List<CameraDescription> cameras = [];

  FlashMode flashMode = FlashMode.off;

  // for debugging
  imglib.Image? debugImagePreview;

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
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_initCamera);
  }

  void _initCamera(_) async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(flashMode);
    setState(() {
      isLoading = false;
    });
  }

  void changeCamera(CameraDescription cameraDescription) async {
    await _controller.dispose();
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(flashMode);
    await _initializeControllerFuture;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _diseaseDetectionService.dispose();
  }

  Future<void> _captureAndDetect() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      setState(() {
        processMessage = "Capturing...";
      });

      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();
      await _controller.pausePreview();

      if (!mounted) return;

      // If the picture was taken, display it on a new screen.
      setState(() {
        processMessage = "Processing...";
        imagePath = image.path;
      });

      await Future.delayed(500.milliseconds);

      final bytes = await File(image.path).readAsBytes();
      final imglib.Image imageRes = imglib.decodeImage(bytes)!;

      // if (kDebugMode) {
      debugImagePreview = imglib.copyResize(
        imageRes,
        width: 220,
        height: 220,
      );
      // }

      setState(() {
        processMessage = "Analyzing...";
      });

      if (_detectionMode == DetectionMode.disease) {
        Disease res = await _diseaseDetectionService.detectDisease(imageRes);

        await _increaseAIExp();

        if (context.mounted) {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            context: context,
            builder: (context) => DiseaseDetectionBottomSheet(res: res),
          );
        }
      } else {
        Soil res = await _soilDetectionService.detectSoil(imageRes);

        await _increaseAIExp();

        if (context.mounted) {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            context: context,
            builder: (context) => SoilDetectionBottomSheet(res: res),
          );
        }
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    } finally {
      setState(() {
        processMessage = null;
      });

      await _controller.resumePreview();
    }
  }

  Future<void> _increaseAIExp() async {
    final expNotifier = ref.read(expProvider.notifier);
    int aiExp = 20;
    List<String> achievementIDs = [
      "00zvXoQO7ScRbcSpiiay",
      "E7Y6oP3lzSBHzXRLcN9S"
    ];

    await expNotifier.increaseExp(aiExp, achievementIDs);
  }

  @override
  Widget build(BuildContext context) {
    final expRef = ref.watch(expProvider);
    final expNotifier = ref.watch(expProvider.notifier);
    // final singleNotifier = ref.read(singleUserProvider.notifier);
    // final userClientController = ref.read(userClientProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            height: 68,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                child: TabBar(
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                  onTap: (index) {
                    if (index == 0) {
                      setState(() {
                        _detectionMode = DetectionMode.disease;
                      });
                    } else {
                      setState(() {
                        _detectionMode = DetectionMode.soil;
                      });
                    }
                  },
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.sick),
                      text: "Penyakit",
                    ),
                    Tab(
                      icon: Icon(Icons.grass),
                      text: "Tanah",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
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
                            builder: (context, constraints) => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) => onViewFinderTap(
                                details,
                                constraints,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (processMessage != null)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  processMessage!,
                                  style: const TextStyle(color: Colors.white),
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
                                    achievementModel: e,
                                    expNotifier: expNotifier,
                                  );
                                }
                              }
                            }
                            return Container();
                          },
                          loading: () => Container(),
                          error: (e, s) => Container(),
                        ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: AnimatedSwitcher(
                          duration: 250.milliseconds,
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                          child: debugImagePreview != null
                              ? Container(
                                  key: const ValueKey("debug_image_preview"),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned.fill(
                                        child: Image.memory(
                                          imglib.encodeJpg(debugImagePreview!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: -8,
                                        right: -8,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              debugImagePreview = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Row(
                          children: [
                            // flash mode
                            FloatingActionButton(
                              heroTag: 'fab_flash_mode',
                              backgroundColor: flashMode == FlashMode.off
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.primary,
                              foregroundColor: flashMode == FlashMode.off
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onPrimary,
                              mini: true,
                              onPressed: processMessage != null
                                  ? null
                                  : () async {
                                      if (flashMode == FlashMode.off) {
                                        flashMode = FlashMode.torch;
                                      } else {
                                        flashMode = FlashMode.off;
                                      }
                                      await _controller.setFlashMode(flashMode);
                                      setState(() {});
                                    },
                              child: const Icon(Icons.flash_on),
                            ),
                            if (cameras.length > 1)
                              FloatingActionButton(
                                heroTag: 'fab_change_camera',
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSurface,
                                mini: true,
                                onPressed: processMessage != null
                                    ? null
                                    : () {
                                        if (_controller.description ==
                                            cameras[0]) {
                                          changeCamera(cameras[1]);
                                        } else {
                                          changeCamera(cameras[0]);
                                        }
                                      },
                                child: const Icon(Icons.flip_camera_android),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          // Provide an onPressed callback.
          heroTag: 'fab_disease',
          enableFeedback: true,
          onPressed: processMessage != null ? null : _captureAndDetect,
          child: const Icon(Icons.camera_alt),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
