import 'package:flutter/material.dart';

Widget platFormField(
    String label, String hint, context, TextEditingController nameController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: Theme.of(context).textTheme.titleMedium!.apply(
                fontWeightDelta: 2,
              )),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
                color: Colors.grey,
              ),
          border: const OutlineInputBorder(),
        ),
      ),
    ],
  );
}
