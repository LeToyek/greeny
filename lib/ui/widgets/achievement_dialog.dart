import 'package:flutter/material.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/states/exp_state.dart';

AlertDialog achievementDialog(BuildContext context,
    AchievementModel achievementModel, ExpNotifier expNotifier) {
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
                color: Theme.of(context).colorScheme.primary,
                fontWeightDelta: 2,
                fontSizeDelta: 4)),
        const SizedBox(
          height: 24,
        ),
        Image.network(achievementModel.emblem!.imageUrl, height: 100),
        const SizedBox(
          height: 24,
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
            },
            child: const Text("Tutup"))
      ],
    ),
  );
}
