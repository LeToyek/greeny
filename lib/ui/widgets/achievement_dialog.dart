import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/users_state.dart';

class AchievementDialog extends ConsumerWidget {
  final AchievementModel achievementModel;
  final ExpNotifier expNotifier;
  const AchievementDialog(
      {super.key, required this.achievementModel, required this.expNotifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final singleNotifier = ref.read(singleUserProvider.notifier);

    return AlertDialog(
      elevation: 4,
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Selamat! Anda mendapatkan pencapaian baru!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeightDelta: 2,
                  fontSizeDelta: 4)),
          const SizedBox(
            height: 24,
          ),
          CachedNetworkImage(
              imageUrl: achievementModel.emblem!.imageUrl, height: 100),
          const SizedBox(
            height: 8,
          ),
          Text(achievementModel.emblem!.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.apply(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeightDelta: 2,
                  fontSizeDelta: 8)),
          const SizedBox(
            height: 12,
          ),
          Text(achievementModel.emblem!.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeightDelta: 1,
                  fontSizeDelta: 4)),
          ElevatedButton(
              onPressed: () {
                expNotifier.turnStateToNull();
                expNotifier.turnToClosed(achievementModel.id);
                singleNotifier.getUser();
              },
              child: const Text("Tutup"))
        ],
      ),
    );
  }
}
