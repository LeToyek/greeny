import 'package:flutter/material.dart';
import 'package:greenify/model/plant_model.dart';

Widget plantStatusPill(PlantStatus status) {
  switch (status) {
    case PlantStatus.healthy:
      return Chip(
        label: const Text("Healthy"),
        backgroundColor: Colors.green.shade200,
        labelStyle: const TextStyle(color: Colors.white),
      );
    case PlantStatus.dry:
      return Chip(
        label: const Text("Dry"),
        backgroundColor: Colors.orange.shade300,
        labelStyle: const TextStyle(color: Colors.white),
      );
    case PlantStatus.dead:
      return Chip(
        label: const Text("Dead"),
        backgroundColor: Colors.red.shade200,
        labelStyle: const TextStyle(color: Colors.white),
      );
    default:
      return const Chip(
        label: Text("Unknown"),
        backgroundColor: Colors.grey,
        labelStyle: TextStyle(color: Colors.white),
      );
  }
}

Widget plantHeightPill(int height) {
  if (height > 100) {
    return Chip(
      label: Text("$height cm"),
      backgroundColor: Colors.blue.shade200,
      labelStyle: const TextStyle(color: Colors.white),
    );
  } else if (height > 50) {
    return Chip(
      label: Text("$height cm"),
      backgroundColor: Colors.purple.shade200,
      labelStyle: const TextStyle(color: Colors.white),
    );
  } else {
    return Chip(
      label: Text("$height cm"),
      backgroundColor: Colors.green.shade200,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
