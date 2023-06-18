import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  /// Named parameters are preferred, they make the code easier to understand.
  const TitledCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.position});

  final String title;
  final IconData icon;
  final String position;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: _geometry()),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 54),
          const SizedBox(
            height: 32,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .apply(fontWeightDelta: 2, fontSizeDelta: -2),
          ),
        ],
      ),
    );
  }

  BorderRadiusGeometry _geometry() {
    const double BLUNT = 24;
    if (position == "top_left") {
      return const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(BLUNT),
        bottomLeft: Radius.circular(BLUNT),
        bottomRight: Radius.circular(0),
      );
    } else if (position == "bottom_left") {
      return const BorderRadius.only(
        topLeft: Radius.circular(BLUNT),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(BLUNT),
      );
    } else if (position == "bottom_right") {
      return const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(BLUNT),
        bottomLeft: Radius.circular(BLUNT),
        bottomRight: Radius.circular(0),
      );
    } else if (position == "top_right") {
      return const BorderRadius.only(
        topLeft: Radius.circular(BLUNT),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(BLUNT),
      );
    } else {
      return const BorderRadius.all(Radius.circular(12));
    }
  }
}
