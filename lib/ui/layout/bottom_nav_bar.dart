import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/bottom_nav_bar.dart';
import 'package:ionicons/ionicons.dart';

class GrBottomNavBar extends ConsumerWidget {
  const GrBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int bottomNavIndex = ref.watch(bottomNavProvider);

    return Card(
      margin: const EdgeInsets.only(top: 1, right: 4, left: 4),
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: bottomNavIndex,
        onTap: (int index) {
          ref.read(bottomNavProvider.notifier).setValueToDB(index);
        },
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall!.color,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.information_circle_outline),
            activeIcon: Icon(Ionicons.information_circle),
            label: "About",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.settings_outline),
            activeIcon: Icon(Ionicons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.person_outline),
              activeIcon: Icon(Ionicons.person),
              label: "Profile"),
        ],
      ),
    );
  }
}
