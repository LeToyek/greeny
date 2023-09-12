import 'package:flutter/material.dart';

class PlainCard extends StatelessWidget {
  final Widget child;
  Color? color;
  EdgeInsets? padding;
  EdgeInsets? margin;
  void Function()? onTap;
  Border? border;
  BoxShadow? boxShadow;
  PlainCard(
      {super.key,
      required this.child,
      this.color,
      this.padding,
      this.margin,
      this.onTap,
      this.border,
      this.boxShadow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: margin ?? const EdgeInsets.all(0),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: border ?? Border.all(color: Colors.transparent),
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            boxShadow ??
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
          ],
        ),
        child: child,
      ),
    );
  }
}
