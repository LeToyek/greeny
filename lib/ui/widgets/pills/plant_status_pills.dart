import 'package:flutter/material.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/utils/formatter.dart';

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
      backgroundColor: Colors.blue.shade300,
      labelStyle: const TextStyle(color: Colors.white),
    );
  } else if (height > 50) {
    return Chip(
      label: Text("$height cm"),
      backgroundColor: Colors.purple.shade300,
      labelStyle: const TextStyle(color: Colors.white),
    );
  } else {
    return Chip(
      label: Text("$height cm"),
      backgroundColor: Colors.green.shade300,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}

Widget plantPricePill({int? price}) {
  if (price != null && price > 0) {
    return Chip(
      label: Text("Rp ${formatMoney(price)}"),
      backgroundColor: Colors.green.shade700,
      labelStyle: const TextStyle(color: Colors.white),
    );
  } else {
    return Chip(
      label: const Text("Tidak untuk dijual"),
      backgroundColor: Colors.red.shade300,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}
