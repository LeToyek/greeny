import 'package:flutter/material.dart';

class PlainCard extends StatelessWidget {
  final Widget child;
  Color? color;
  PlainCard({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
