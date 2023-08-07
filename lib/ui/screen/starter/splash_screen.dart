import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/bootstrap_service.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Bootstrap.checkUserExist(context);
      }
    });
    return Scaffold(
      body: Center(
        child: Text(
          "Greeny",
          style: Theme.of(context).textTheme.displaySmall!.apply(
                fontWeightDelta: 2,
                color: Colors.white,
              ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
