import 'package:flutter/material.dart';
import 'package:greenify/ui/widgets/card/info_card.dart';
import 'package:ionicons/ionicons.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        centerTitle: true,
        title: const Text(
          "Book",
        ),
      ),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            physics: const BouncingScrollPhysics(),
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 4 / 5.5,
                padding: EdgeInsets.zero,
                children: const <GrInfoCard>[
                  GrInfoCard(
                      title: 'Media Tanam',
                      content: 'localization_content',
                      icon: Ionicons.leaf_outline,
                      isPrimaryColor: false),
                  GrInfoCard(
                      title: 'Jenis Tanaman',
                      content: 'linting_content',
                      icon: Ionicons.flower_outline,
                      isPrimaryColor: false),
                  GrInfoCard(
                      title: 'Perawatan',
                      content: 'storage_content',
                      icon: Ionicons.heart_outline,
                      isPrimaryColor: false),
                ],
              ),
            ]),
      ),
    );
  }
}
