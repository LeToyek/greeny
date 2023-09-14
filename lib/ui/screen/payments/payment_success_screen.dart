import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/theme_mode_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  static const routePath = '/payments/success';
  static const routeName = 'payments-success';
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);

    final boldTextColor = themeMode == ThemeMode.light
        ? Colors.black
        : colorScheme.onSurface.withOpacity(.6);

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlainCard(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Payment Success',
                    style: textTheme.headlineMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Detail Transaksi',
                style: textTheme.labelLarge!.copyWith(
                    color: boldTextColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
