import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class PlotterScreen extends StatefulWidget {
  const PlotterScreen({super.key});

  @override
  State<PlotterScreen> createState() => _PlotterScreenState();
}

class _PlotterScreenState extends State<PlotterScreen> {
  UnityWidgetController? _unityWidgetController;

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  @override
  void dispose() {
    super.dispose();

    _unityWidgetController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            // child: UnityWidget(
            //   onUnityCreated: onUnityCreated,
            // ),
            child: Container(
              color: Colors.blue,
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            right: 24,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 100,
                  height: 100,
                  color: Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
