import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/states/bottom_nav_bar_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/layout/bottom_nav_bar.dart';
import 'package:greenify/ui/layout/drawer.dart';
import 'package:greenify/ui/screen/home/content/index.dart';
import 'package:ionicons/ionicons.dart';

class SekelatonScreen extends ConsumerWidget {
  const SekelatonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(bottomNavProvider);
    final profileNotifier = ref.watch(singleUserProvider);
    final colorScheme = Theme.of(context).colorScheme;
    // final initializer = ref.watch(notificationProvider);
    return profileNotifier.when(
      data: (data) {
        final user = data[0];
        return Scaffold(
            appBar: index == 0
                ? CustomAppBar(user)
                : AppBar(
                    centerTitle: true,
                    title: _getAppBarTitle(ref),
                  ),
            endDrawer: const GrDrawerr(),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: contents.elementAt(index),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: index == 3
                ? null
                : FloatingActionButton(
                    heroTag: "fab_main",
                    onPressed: () {
                      // ref.read(homeProvider.notifier).getPots();
                      ref.read(bottomNavProvider.notifier).setValueToDB(2);
                    },
                    child: const Icon(Ionicons.leaf_outline)),
            bottomNavigationBar: const GrBottomNavBar(),
            backgroundColor: Theme.of(context).colorScheme.background);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
          body: Center(
              child: Column(
        children: [
          Text(
            error.toString(),
            style: TextStyle(color: colorScheme.error),
          ),
          Text(stackTrace.toString(),
              style: TextStyle(color: colorScheme.error))
        ],
      ))),
    );
  }

  Text _getAppBarTitle(WidgetRef ref) {
    final int index = ref.watch(bottomNavProvider);
    switch (index) {
      case 0:
        return const Text("Home");
      case 1:
        return const Text("Artikel");
      case 2:
        return const Text("Garden");
      case 3:
        return const Text("Penyakit");
      case 4:
        return const Text("Peringkat");
      default:
        return const Text("Home");
    }
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  UserModel user;
  CustomAppBar(this.user, {super.key});
  @override
  Size get preferredSize => const Size.fromHeight(200);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Avatar
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.imageUrl!),
                  ),
                ),

                // User's name and money
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    // User's name
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // User's detailed name (e.g., job title)
                    Text(
                      'Photographer | Traveler',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),

                    // SizedBox(height: 10),

                    // Money balance
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () => print("object"),
                    icon: const Icon(Ionicons.notifications_outline),
                    color: Colors.white),
                IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Ionicons.menu),
                    color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
