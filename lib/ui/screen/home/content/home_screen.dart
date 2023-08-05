import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/layout/app_bar.dart';
import 'package:greenify/ui/layout/drawer.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/card/titled_card.dart';
import 'package:greenify/ui/widgets/charts/plant_progress_chart.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refPots = ref.watch(homeProvider);
    final userRef = ref.read(usersProvider.notifier);
    final gardenRef = ref.watch(gardenProvider.notifier);

    final userClientController = ref.read(userClientProvider.notifier);
    return Scaffold(
      appBar: const NewAppbar(title: "Home"),
      endDrawer: const GrDrawerr(),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(.4),
                ),
              ),
              const SizedBox(height: 8),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <TitledCard>[
                  TitledCard(
                    title: 'Tentang Tanaman',
                    icon: Ionicons.book_outline,
                    position: "top_left",
                    onPressed: () => context.push("/book"),
                  ),
                  TitledCard(
                    title: 'Garden Space',
                    icon: Ionicons.leaf_outline,
                    position: "top_right",
                    onPressed: () {
                      userClientController.setVisitedUser();
                      gardenRef.getGardens();
                      context.push("/garden");
                    },
                  ),
                  TitledCard(
                    onPressed: () async {
                      if (context.mounted) {
                        context.push("/disease");
                      }
                    },
                    title: 'Deteksi Penyakit',
                    icon: Ionicons.heart_outline,
                    position: "bottom_left",
                  ),
                  TitledCard(
                    title: 'Peringkat',
                    onPressed: () {
                      userRef.getUsers();
                      context.push("/leaderboard");
                    },
                    icon: Ionicons.trophy_outline,
                    position: "bottom_right",
                  ),
                ],
              ),
              // const SizedBox(height: 4),
              // const Header(text: 'Grafik Pertumbuhan Tanaman'),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(.4),
                ),
              ),
              const SizedBox(height: 8),
              PlainCard(child: const PlantProgressChart()),
              const SizedBox(height: 60),
              // StemTimeline(
              //   potModels: data,
              // )
            ]),
      ),
    );
  }
}
