import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/bottom_nav_bar.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/notification.dart';
import 'package:greenify/ui/layout/bottom_nav_bar.dart';
import 'package:greenify/ui/screen/home/content/index.dart';
import 'package:ionicons/ionicons.dart';

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            heroTag: "fab_main",
            onPressed: () {
              ref.read(homeProvider.notifier).getPots();
              ref.read(bottomNavProvider.notifier).setValueToDB(2);
            },
            child: const Icon(Ionicons.home_outline)),
        bottomNavigationBar: const GrBottomNavBar(),
        backgroundColor: Theme.of(context).colorScheme.background);
  }
}
