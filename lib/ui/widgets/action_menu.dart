import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

PopupMenuItem buildPopupMenuItem(
    {required String text,
    required BuildContext context,
    required IconData icon,
    required String content,
    required int position,
    bool isDelete = false,
    List<Widget>? additionalActions}) {
  final colorScheme = Theme.of(context).colorScheme;
  return PopupMenuItem(
      onTap: () {
        Future.delayed(
            const Duration(seconds: 0),
            () => showDialog(
                  context: context,
                  builder: (context) => _buildAlertMessage(
                      context: context,
                      title: text,
                      content: content,
                      additionalActions: additionalActions),
                ));
      },
      value: position,
      child: Row(
        children: [
          Icon(
            icon,
            color: isDelete ? colorScheme.error : colorScheme.onSurface,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(
                color: isDelete ? colorScheme.error : colorScheme.onSurface),
          ),
        ],
      ));
}

AlertDialog _buildAlertMessage(
    {required String title,
    required String content,
    required BuildContext context,
    List<Widget>? additionalActions}) {
  return AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(onPressed: () => context.pop(), child: const Text("Batal")),
      ...additionalActions ?? [],
    ],
  );
}
