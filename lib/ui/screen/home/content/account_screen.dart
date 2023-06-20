import 'package:flutter/material.dart';
import 'package:greenify/ui/layout/header.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: const <Widget>[
            Header(text: 'bottom_nav_second'),
            SizedBox(height: 36),
          ]),
    );
  }
}
