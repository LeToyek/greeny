import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/IOT/iot_screen.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// Other imports...

class IOTScannerScreen extends ConsumerStatefulWidget {
  static const String routeName = "iot";
  static const String routePath = "/iot";
  const IOTScannerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IOTScannerScreenState();
}

class _IOTScannerScreenState extends ConsumerState<IOTScannerScreen> {
  late MobileScannerController controller;
  late bool _isScanned;
  late bool _isProcessing;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    _isScanned = false;
    _isProcessing = false;
  }

  @override
  void dispose() {
    super.dispose();
    _isScanned = false;
    controller.dispose();
  }

  void getBarcode(Barcode barcode) async {
    try {
      setState(() {
        _isProcessing = true;
      });
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return _isProcessing
                ? const AlertDialog(
                    // title: const Text("Parkir"),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    content: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container();
          },
        ),
      );
      print("barcode: ${barcode.rawValue} ");
      Hive.box("prefs").put("isIOTConnected", true);
      setState(() {
        _isProcessing = false;
      });
      if (context.mounted) {
        context.pushReplacement(IOTScreen.routePath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("QR tidak ditemukan")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: MobileScanner(
                controller: controller,
                key: const Key("scanner"),
                fit: BoxFit.cover,
                onScannerStarted: (arguments) {
                  print("scanner started");
                },
                startDelay: true,
                onDetect: (capture) {
                  if (!_isScanned) {
                    _isScanned = true;
                    Barcode barcode = capture.barcodes.first;
                    getBarcode(barcode);
                    return;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
