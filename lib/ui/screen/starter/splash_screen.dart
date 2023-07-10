import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/services/auth.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(seconds: 2), () async {
      User? user = await FireAuth.getCurrentUser();
      if (context.mounted) {
        if (user != null) {
          context.pushReplacement("/");
        } else {
          context.pushReplacement("/login");
        }
      }
    });
    return Center(
      child: Text(
        "Splash Screen",
        style: Theme.of(context).textTheme.headlineLarge!.apply(
              fontWeightDelta: 2,
            ),
      ),
    );
  }
}
