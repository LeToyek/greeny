import 'package:flutter/material.dart';

Widget platFormField(
    {required String label,
    required String hint,
    context,
    required TextEditingController nameController,
    required String? Function(String?) validator,
    int? maxLines}) {
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
        validator: validator,
        maxLines: maxLines ?? 1,
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
