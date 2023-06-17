import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/ui/layout/app_bar.dart';
import 'package:greenify/ui/layout/bottom_nav_bar.dart';
import 'package:greenify/ui/screen/home/content/home_screen.dart';

class SekelatonScreen extends ConsumerWidget {
  const SekelatonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const GrAppBar(),
        body: const HomeScreen(),
        bottomNavigationBar: const GrBottomNavBar(),
        backgroundColor: Theme.of(context).colorScheme.background);
  }
}
