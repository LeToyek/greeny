import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/book_state.dart';
import 'package:greenify/states/users_state.dart';

class BookListScreen extends ConsumerWidget {
  final String category;
  const BookListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(bookFamilyProvider(category));
    final userClientController = ref.read(userClientProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(title: Text(category), centerTitle: true),
        body: SingleChildScrollView(
          child: Material(
              color: colorScheme.background,
              child: bookRef.when(
                  data: (data) => ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: colorScheme.surface,
                              title: Text(data[index].title),
                              subtitle:
                                  Text("Penulis: ${data[index].user!.name}"),
                              leading: SizedBox(
                                height: 75,
                                width: 75,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      data[index].imageUrl,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              onTap: () {
                                userClientController.setVisitedUser(
                                    id: data[index].userID);
                                context.push("/book/detail/${data[index].id}");
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                  error: (error, stack) => Center(
                        child: Text(error.toString()),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ))),
        ));
  }
}
