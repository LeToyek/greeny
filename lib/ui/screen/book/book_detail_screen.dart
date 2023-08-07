import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/book_state.dart';
import 'package:greenify/states/file_notifier_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/action_menu.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/capitalizer.dart';
import 'package:greenify/utils/date_helper.dart';
import 'package:ionicons/ionicons.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(detailBookProvider(bookId));
    final bookNotifier = ref.watch(detailBookProvider(bookId).notifier);
    final funcFileRef = ref.read(fileEditBookProvider.notifier);
    final userNotifier = ref.watch(singleUserProvider.notifier);

    final userClientController = ref.read(userClientProvider.notifier);

    var appBarHeight = AppBar().preferredSize.height;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    const avatarUrl =
        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

    PopupMenuButton actionMenu() {
      return PopupMenuButton(
          offset: Offset(0.0, appBarHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          itemBuilder: (context) => [
                buildPopupMenuItem(
                    text: "Edit Artikel",
                    context: context,
                    icon: Ionicons.pencil_outline,
                    content: "Ubah Artikel ini",
                    position: 0,
                    additionalActions: [
                      TextButton(
                          onPressed: () {
                            funcFileRef.imageUrl =
                                bookNotifier.getThisBook().imageUrl;
                            context.pop();
                            context.push("/book/edit/$bookId");
                          },
                          child: const Text("Ubah")),
                    ]),
                buildPopupMenuItem(
                    text: "Hapus Artikel",
                    context: context,
                    icon: Ionicons.trash_bin_outline,
                    content: "Artikel anda akan dihapus secara permanen",
                    position: 1,
                    isDelete: true,
                    additionalActions: [
                      TextButton(
                          onPressed: () async {
                            await bookNotifier.deleteBook(bookId);
                            userNotifier.getUser();
                            if (context.mounted) {
                              context.pop();
                              context.pop();
                            }
                          },
                          child: const Text("Hapus")),
                    ]),
              ]);
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Artikel'),
        actions: [
          !userClientController.isSelf() ? Container() : actionMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Material(
            color: colorScheme.background,
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
                                          bookData.user!.imageUrl == null
                                              ? avatarUrl
                                              : bookData.user!.imageUrl!),
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
