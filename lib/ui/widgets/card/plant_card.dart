import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({super.key, required this.title, required this.imageURI});

  final String title;
  final String imageURI;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(imageURI),
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleSmall!.apply(fontWeightDelta: 2),
            ),
          ],
        ),
      ),
    );
  }
}
