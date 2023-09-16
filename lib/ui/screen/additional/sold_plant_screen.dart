import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoldPlantScreen extends ConsumerWidget {
  static const routePath = "/sold_plant";
  static const routeName = "sold_plant";

  const SoldPlantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanaman Terjual'),
      ),
      body: const Center(
        child: Text('Tanaman Terjual'),
      ),
    );
  }
}
