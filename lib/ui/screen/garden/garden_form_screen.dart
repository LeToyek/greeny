import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GardenFormScreen extends ConsumerWidget {
  const GardenFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: const [],
          title: const Text("Add Plant"),
          centerTitle: true,
        ),
        body: Material(
            color: Theme.of(context).colorScheme.background,
            child: Form(
                autovalidateMode: AutovalidateMode.always,
                child:
                    ListView(physics: const BouncingScrollPhysics(), children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Name",
                      hintText: "Enter Plant Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Type",
                      hintText: "Enter Plant Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Description",
                      hintText: "Enter Plant Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Image",
                      hintText: "Enter Plant Image",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Watering",
                      hintText: "Enter Plant Watering",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Fertilizer",
                      hintText: "Enter Plant Fertilizer",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Sunlight",
                      hintText: "Enter Plant Sunlight",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Temperature",
                      hintText: "Enter Plant Temperature",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Humidity",
                      hintText: "Enter Plant Humidity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Soil",
                      hintText: "Enter Plant Soil",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Plant Pot",
                      hintText: "Enter Plant Pot",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]))));
  }
}
