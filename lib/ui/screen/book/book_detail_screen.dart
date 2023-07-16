import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/book_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(detailBookProvider(bookId));

    final userNotifier = ref.read(usersProvider.notifier);
    final userRef = ref.watch(usersProvider);

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Detail')),
      body: Material(
          color: Theme.of(context).colorScheme.background,
          child: bookRef.when(
              data: (data) {
                final bookData = data.first;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlainCard(
                        child: FutureBuilder(
                            future: bookData.getUserModel(),
                            builder: (snapshot, context) {
                              return Column(
                                children: [
                                  Image.network(bookData.imageUrl),
                                  const SizedBox(height: 10),
                                  Text(bookData.title),
                                  const SizedBox(height: 10),
                                  Chip(
                                      label: Text(
                                    bookData.category,
                                    style: textTheme.bodyMedium,
                                  )),
                                  const SizedBox(height: 10),
                                  Html(data: bookData.content),
                                  const SizedBox(height: 10),
                                  Text(bookData.createdAt.toString()),
                                  const SizedBox(height: 10),
                                  Text(bookData.updatedAt.toString()),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                );
              },
              error: (e, s) => Center(
                    child: Text(e.toString()),
                  ),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ))),
    );
  }
}
