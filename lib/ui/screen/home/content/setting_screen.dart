import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/ui/layout/header.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: const <Widget>[
            Header(text: 'Setting Screen'),
            SizedBox(height: 36),
          ]),
    );
  }
}
