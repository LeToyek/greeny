import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/book_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/capitalizer.dart';
import 'package:greenify/utils/date_helper.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(detailBookProvider(bookId));

    final userClientController = ref.read(userClientProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text('Book Detail')),
      body: SingleChildScrollView(
        child: Material(
            color: Theme.of(context).colorScheme.background,
            child: bookRef.when(
                data: (data) {
                  final bookData = data.first;
                  return Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlainCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalize(bookData.title),
                                style: textTheme.titleLarge!.apply(
                                    fontWeightDelta: 2, fontSizeDelta: 8),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  userClientController
                                      .getUserById(bookData.userID!);
                                  context.push("/user/detail");
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          bookData.user!.imageUrl!),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          capitalize(bookData.user!.name!),
                                          style: textTheme.bodyMedium,
                                        ),
                                        Text(
                                          DateHelper.timestampToReadable(
                                                  bookData.createdAt!)
                                              .toString(),
                                          style: textTheme.bodySmall,
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network(bookData.imageUrl),
                              const SizedBox(height: 10),
                              const SizedBox(height: 10),
                              Html(data: bookData.content),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ))
                  ]);
                },
                error: (e, s) => Center(
                      child: Text(e.toString()),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))),
      ),
    );
  }
}
