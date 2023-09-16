import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/model/emblem_model.dart';
import 'package:greenify/states/emblem_state.dart';
import 'package:greenify/states/theme_mode_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class EmblemScreen extends ConsumerWidget {
  static const routePath = "/emblem";
  static const routeName = "Emblem";
  const EmblemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(singleUserProvider);
    final emblemRef = ref.watch(emblemProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);
    final boldTextColor = themeMode == ThemeMode.light
        ? Colors.black
        : colorScheme.onSurface.withOpacity(.6);

    return Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          title: const Text("Medali"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PlainCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Medali',
                    style: textTheme.labelLarge!.copyWith(
                        color: boldTextColor, fontWeight: FontWeight.bold),
                  ),
                  Text('Selesaikan tantangan untuk mendapatkan medali',
                      style: textTheme.labelMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 16,
                  ),
                  emblemRef.when(
                      data: (data) {
                        print(data);
                        return GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 7 / 12,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 12),
                            itemBuilder: (context, index) {
                              final emblem = data[index];
                              return PlainCard(
                                  child: buildEmblemCard(context, ref, emblem));
                            });
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text(error.toString()),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildEmblemCard(
      BuildContext context, WidgetRef ref, EmblemModel emblem) {
    final userRef = ref.watch(singleUserProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
              child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ));
        }, emblem.imageUrl, height: 100),
        const SizedBox(
          height: 16,
        ),
        Text(
          textAlign: TextAlign.center,
          emblem.title,
          style:
              Theme.of(context).textTheme.titleSmall!.apply(fontWeightDelta: 2),
        ),
        const SizedBox(
          height: 8,
        ),
        userRef.when(
            loading: () => const Center(child: Text("Loading ...")),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (data) {
              final achievements = data.first.pseudoAchievements;
              final userEmblem = achievements == null
                  ? AchievementModel(
                      id: emblem.id,
                      counter: 0,
                      isClaimed: false,
                      isClosed: false,
                      isExist: false)
                  : achievements.firstWhere(
                      (element) => element.id == emblem.id,
                      orElse: () => AchievementModel(
                          id: emblem.id,
                          counter: 0,
                          isClaimed: false,
                          isClosed: false,
                          isExist: false));
              return userEmblem.counter / emblem.counter == 1
                  ? const Text("Tercapai")
                  : Text("${userEmblem.counter} / ${emblem.counter}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18));
            }),
        const SizedBox(
          height: 8,
        ),
        Text(
          textAlign: TextAlign.center,
          emblem.must!,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
