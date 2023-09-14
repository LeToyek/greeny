import 'package:flutter/material.dart';

Widget platFormField(
    {String? label,
    required String hint,
    context,
    TextInputType? keyboardType,
    required TextEditingController nameController,
    required String? Function(String?) validator,
    int? maxLines}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      label != null
          ? Text(label,
              style: Theme.of(context).textTheme.titleMedium!.apply(
                    fontWeightDelta: 2,
                  ))
          : Container(),
      SizedBox(height: label != null ? 8.0 : 0),
      TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
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
