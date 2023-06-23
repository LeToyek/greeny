import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

enum PlantBoxStatus { empty, filled, locked }

class PlantCard extends StatelessWidget {
  PlantCard(
      {super.key,
      required this.title,
      required this.imageURI,
      this.status = PlantBoxStatus.locked});

  final String title;
  final String imageURI;
  late PlantBoxStatus status;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.shadow,
        color: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: _buildPlantBox(status, textTheme, title, imageURI));
  }

  Widget _buildPlantBox(
      PlantBoxStatus status, TextTheme textTheme, String title, String imgUrl) {
    switch (status) {
      case PlantBoxStatus.empty:
        return PlantBox(textTheme, "Tambah", Ionicons.add_circle_outline, null);
      case PlantBoxStatus.filled:
        return PlantBox(textTheme, title, null, imgUrl);
      case PlantBoxStatus.locked:
        return PlantBox(
            textTheme, "Locked", Ionicons.lock_closed_outline, null);
    }
  }

  Widget PlantBox(
      TextTheme textTheme, String title, IconData? icon, String? imageURI) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        imageURI != null ? Image.asset(imageURI) : Icon(icon),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.titleSmall!.apply(fontWeightDelta: 2),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
