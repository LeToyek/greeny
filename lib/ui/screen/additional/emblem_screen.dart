import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmblemScreen extends ConsumerWidget {
  static const routePath = "/emblem";
  static const routeName = "Emblem";
  const EmblemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emblem"),
      ),
      body: const Center(
        child: Text("Emblem"),
      ),
    );
  }
}
