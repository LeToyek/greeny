import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:ionicons/ionicons.dart';

enum PlantBoxStatus { empty, filled, locked }

class PlantCard extends ConsumerWidget {
  PlantCard(
      {super.key,
      required this.title,
      required this.imageURI,
      this.status = PlantBoxStatus.locked});

  final String title;
  final String imageURI;
  late PlantBoxStatus status;

  @override
  Widget build(BuildContext context, ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.shadow,
        color: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child:
            _buildPlantBox(status, textTheme, title, imageURI, ref, context));
  }

  Widget _buildPlantBox(PlantBoxStatus status, TextTheme textTheme,
      String title, String imgUrl, WidgetRef ref, context) {
    switch (status) {
      case PlantBoxStatus.empty:
        return PlantBox(textTheme, "Tambah", Ionicons.add_circle_outline, null,
            ref, context);
      case PlantBoxStatus.filled:
        return PlantBox(textTheme, title, null, imgUrl, ref, context);
      case PlantBoxStatus.locked:
        return PlantBox(textTheme, "Terkunci", Ionicons.lock_closed_outline,
            null, ref, context);
    }
  }

  Widget PlantBox(TextTheme textTheme, String title, IconData? icon,
      String? imageURI, WidgetRef ref, context) {
    final state = ref.watch(themeProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        imageURI != null
            ? Image.asset(
                imageURI,
                height: 80,
                width: double.infinity,
              )
            : Icon(
                icon,
                color: state != ThemeMode.light
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground,
              ),
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
