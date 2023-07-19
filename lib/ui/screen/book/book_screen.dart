import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/services/book_service.dart';
import 'package:greenify/ui/widgets/card/info_card.dart';
import 'package:ionicons/ionicons.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listItem = BookServices.bookCategoryList;
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
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 4 / 5.5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listItem.length,
                  itemBuilder: (context, index) {
                    final item = listItem[index];
                    return GestureDetector(
                      onTap: () => context.push("/book/${item.name}"),
                      child: GrInfoCard(
                          title: item.name,
                          content: item.description,
                          icon: item.icon,
                          isPrimaryColor: false),
                    );
                  },
                  padding: EdgeInsets.zero,
                  // children: const <GrInfoCard>[
                  //   GrInfoCard(
                  //       title: 'Media Tanam',
                  //       content: 'localization_content',
                  //       icon: Ionicons.leaf_outline,
                  //       isPrimaryColor: false),
                  //   GrInfoCard(
                  //       title: 'Jenis Tanaman',
                  //       content: 'linting_content',
                  //       icon: Ionicons.flower_outline,
                  //       isPrimaryColor: false),
                  //   GrInfoCard(
                  //       title: 'Perawatan',
                  //       content: 'storage_content',
                  //       icon: Ionicons.heart_outline,
                  //       isPrimaryColor: false),
                  // ],
                ),
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.pushReplacement("/book/create"),
          child: const Icon(Ionicons.add_outline),
        ));
  }
}
