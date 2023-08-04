import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/bottom_nav_bar.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:ionicons/ionicons.dart';

class GrBottomNavBar extends ConsumerWidget {
  const GrBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int bottomNavIndex = ref.watch(bottomNavProvider);
    final potRef = ref.read(homeProvider.notifier);
    final userClientController = ref.read(userClientProvider.notifier);
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
          if (index == 0) {
            potRef.getPots();
          }
          if (index == 1) {
            userClientController.setVisitedUser();
          }
          ref.read(bottomNavProvider.notifier).setValueToDB(index);
        },
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall!.color,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.book_outline),
            activeIcon: Icon(Ionicons.book),
            label: "Artikel",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.leaf_outline),
            activeIcon: Icon(Ionicons.leaf),
            label: "Garden",
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.wind, color: Colors.transparent),
              label: ""),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.heart_outline),
            activeIcon: Icon(Ionicons.heart),
            label: "Detektor",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.stats_chart_outline),
            activeIcon: Icon(Ionicons.stats_chart),
            label: "Peringkat",
          ),
        ],
      ),
    );
  }
}
