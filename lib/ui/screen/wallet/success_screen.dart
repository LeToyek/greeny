import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends ConsumerWidget {
  static const routePath = "/wallet/success";
  static const routeName = "wallet_success";
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userNotifier = ref.watch(singleUserProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        Lottie.asset("lib/assets/lottie/success_gif.json",
            width: 200, height: 200),
        const SizedBox(height: 20),
        Text(
          "Top Up Berhasil!",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(fontWeightDelta: 2),
        ),
        const SizedBox(height: 20),
        Text(
          "Terima kasih telah melakukan top up saldo, saldo anda akan bertambah dalam 1x24 jam",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(16),
          child: PlainCard(
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                context.go("/");
              },
              child: Center(
                  child: Text(
                "Kembali ke Beranda",
                style: textTheme.labelLarge!
                    .apply(fontWeightDelta: 2, color: Colors.white),
              ))),
        )
      ])),
    );
  }
}
