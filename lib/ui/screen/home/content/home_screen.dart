import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/card/titled_card.dart';
import 'package:ionicons/ionicons.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refPots = ref.watch(homeProvider);
    final userRef = ref.read(usersProvider.notifier);
    final gardenRef = ref.watch(gardenProvider.notifier);

    final userClientController = ref.read(userClientProvider.notifier);
    return refPots.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
      data: (data) {
        print(
            'data[0].plant.heightStat!.length ${data[1].plant.heightStat![0].height}');
        return Material(
          color: Theme.of(context).colorScheme.background,
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const Header(text: 'Home'),
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
                const SizedBox(height: 4),
                const Header(text: 'Grafik Pertumbuhan'),
                const SizedBox(height: 8),
                PlainCard(
                    child: SfSparkLineChart.custom(
                  dataCount: data[1].plant.heightStat!.length,
                  xValueMapper: (index) =>
                      data[1].plant.heightStat![index].date,
                  yValueMapper: (index) =>
                      data[1].plant.heightStat![index].height,
                  color: Theme.of(context).colorScheme.primary,
                  axisLineColor: Theme.of(context).colorScheme.onPrimary,
                  axisLineWidth: 2,
                  axisLineDashArray: const [5, 5],
                )),
                PlainCard(
                    child: SfSparkLineChart(
                  data:
                      data.map((e) => e.plant.heightStat!.last.height).toList(),
                  color: Theme.of(context).colorScheme.primary,
                  axisLineColor: Theme.of(context).colorScheme.onPrimary,
                  axisLineWidth: 2,
                  axisLineDashArray: const [5, 5],
                ))
                // StemTimeline(
                //   potModels: data,
                // )
              ]),
        );
      },
    );
  }
}
