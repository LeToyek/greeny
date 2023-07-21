import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:greenify/services/disease_service.dart';
import 'package:image/image.dart' as imglib;

class DiseaseScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const DiseaseScreen({super.key, required this.cameras});

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  final TFLiteDiseaseDetectionService _diseaseDetectionService =
      TFLiteDiseaseDetectionService();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String imagePath;

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) {
      return;
    }
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
    _controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _diseaseDetectionService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TfLite Flutter Helper',
            style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(
              _controller,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) => onViewFinderTap(details, constraints),
                );
              }),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
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
            String res = await _diseaseDetectionService.detectDisease(imageRes);
            print("res: $res");
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Theme.of(context).colorScheme.surface,
                context: context,
                builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Hasil Deteksi Greeny",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeightDelta: 2,
                                    fontSizeDelta: 4)),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(res,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeightDelta: 1,
                                fontSizeDelta: 8)),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
