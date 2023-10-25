import 'package:flutter/material.dart';

TextStyle lightTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.judul,
  });

  final String judul;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            judul,
            style: lightTextStyle.copyWith(
              color: Colors.red,
            ),
          ),
          Text(
            judul,
            style: lightTextStyle.copyWith(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
