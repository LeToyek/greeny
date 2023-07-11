import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/branch/stem.dart';
import 'package:greenify/ui/widgets/card/icon_card.dart';
import 'package:greenify/ui/widgets/card/titled_card.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const Header(text: 'Home'),
            const SizedBox(height: 8),
            GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.75 / 1,
                padding: EdgeInsets.zero,
                children: const <GrIconCard>[
                  GrIconCard(
                    mode: ThemeMode.system,
                    icon: Ionicons.contrast_outline,
                  ),
                  GrIconCard(
                    mode: ThemeMode.light,
                    icon: Ionicons.sunny_outline,
                  ),
                  GrIconCard(
                    mode: ThemeMode.dark,
                    icon: Ionicons.moon_outline,
                  ),
                ]),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(.4),
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
                  onPressed: () => context.push("/garden"),
                ),
                TitledCard(
                  onPressed: () {},
                  title: 'Deteksi Penyakit',
                  icon: Ionicons.heart_outline,
                  position: "bottom_left",
                ),
                TitledCard(
                  title: 'Peringkat',
                  onPressed: () => context.push("/leaderboard"),
                  icon: Ionicons.trophy_outline,
                  position: "bottom_right",
                ),
              ],
            ),
            const SizedBox(height: 4),
            const StemTimeline()
          ]),
    );
  }
}
