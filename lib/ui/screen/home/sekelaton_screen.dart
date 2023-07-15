import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/bottom_nav_bar.dart';
import 'package:greenify/states/notification.dart';
import 'package:greenify/ui/layout/bottom_nav_bar.dart';
import 'package:greenify/ui/screen/home/content/index.dart';

class SekelatonScreen extends ConsumerWidget {
  const SekelatonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(bottomNavProvider);
    final initializer = ref.watch(notificationProvider);
    return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: contents.elementAt(index),
        ),
        bottomNavigationBar: const GrBottomNavBar(),
        backgroundColor: Theme.of(context).colorScheme.background);
  }
}
