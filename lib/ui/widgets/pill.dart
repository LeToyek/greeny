import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  final IconData icon;
  final String title;
  const Pill({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall!.apply(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeightDelta: 2),
          ),
        ],
      ),
    );
  }
}
