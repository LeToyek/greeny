import 'package:flutter/material.dart';

AlertDialog loaderDialog(context) {
  return AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconPadding: EdgeInsets.zero,
    insetPadding: EdgeInsets.zero,
    titlePadding: EdgeInsets.zero,
    buttonPadding: EdgeInsets.zero,
    actionsPadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    content: SizedBox(
      height: 72,
      width: 72,
      child: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      ),
    ),
  );
}
