import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

void showWateringDialog({
  required BuildContext context,
  required TextTheme textTheme,
  required double counterHeight,
  required PotNotifier potsNotifier,
  required bool isDetail,
  int? index,
  String? id,
  required ExpNotifier expNotifier,
  required int waterExp,
  required List<String> achievementIDs,
}) {
  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ukur ketinggian tanamanmu",
                      style: textTheme.titleLarge!.apply(
                          fontWeightDelta: 2,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Lottie.network(
                        "https://lottie.host/35acbdf6-a272-4ca5-b5bc-a3d6aae25c04/mI4jAwJBdz.json",
                        height: 72),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (counterHeight > 0) {
                                    counterHeight--;
                                  }
                                });
                              },
                              icon: Icon(
                                Ionicons.remove,
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                        ),
                        Text(
                          "$counterHeight cm",
                          style: textTheme.titleLarge!.apply(
                              fontWeightDelta: 2,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (counterHeight < 10000) {
                                      counterHeight++;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Ionicons.add,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Jangan lupa untuk mengukur ketinggian tanamanmu ya setiap menyiramnya!",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium!.apply(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("Batal")),
                        StatefulBuilder(builder: (context, setState) {
                          return ElevatedButton(
                              onPressed: () async {
                                expNotifier.increaseExp(
                                    waterExp, achievementIDs);
                                isDetail
                                    ? potsNotifier.selfWaterPlant(
                                        counterHeight, id!)
                                    : potsNotifier.waterPlant(
                                        index!, counterHeight);

                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                              child: const Text("Siram"));
                        }),
                      ],
                    )
                  ],
                ),
              );
            },
          ));
}
