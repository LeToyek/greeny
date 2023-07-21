import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/book_state.dart';

class BookListScreen extends ConsumerWidget {
  final String category;
  const BookListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(bookFamilyProvider(category));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(title: Text(category), centerTitle: true),
        body: SingleChildScrollView(
          child: Material(
              color: Theme.of(context).colorScheme.background,
              child: bookRef.when(
                  data: (data) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  tileColor:
                                      Theme.of(context).colorScheme.surface,
                                  title: Text(data[index].title),
                                  subtitle: Text(
                                      "Penulis: ${data[index].user!.name}"),
                                  leading: Image.network(data[index].imageUrl),
                                  onTap: () {
                                    context
                                        .push("/book/detail/${data[index].id}");
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          })),
                  error: (error, stack) => Center(
                        child: Text(error.toString()),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ))),
        ));
  }
}
