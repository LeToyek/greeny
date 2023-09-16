import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/book_model.dart';
import 'package:greenify/services/book_service.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/info_card.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/capitalizer.dart';
import 'package:greenify/utils/date_helper.dart';
import 'package:greenify/utils/formatter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  String _selectedValue = "Semua";

  @override
  Widget build(BuildContext context) {
    final listItem = BookServices.bookCategoryList;
    final userRef = ref.watch(singleUserProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const emptyGifLink =
        "https://lottie.host/2074ca4c-e3b9-468f-92d0-c276fc401c23/bMZExAL1R7.json";

    return Scaffold(
        backgroundColor: colorScheme.background,
        body: Material(
          color: colorScheme.background,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              PlainCard(
                color: colorScheme.surface,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      borderRadius: BorderRadius.circular(12),
                      isDense: true,
                      value: _selectedValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorScheme.primary,
                      ),
                      dropdownColor: colorScheme.surface,
                      style: TextStyle(color: colorScheme.onSurface),
                      items: [
                        _buildDropdownItem("Semua"),
                        _buildDropdownItem("Artikel Saya"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value.toString();
                        });
                      }),
                ),
              ),
              const SizedBox(height: 16),
              _selectedValue != "Semua"
                  ? userRef.when(
                      error: (e, s) => Center(
                            child: Text(e.toString()),
                          ),
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      data: (data) {
                        final user = data.first;
                        return user.books != null && user.books!.isNotEmpty
                            ? GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: user.books!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 7 / 12,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 12),
                                itemBuilder: (context, index) {
                                  BookModel? book;
                                  book = user.books![index];
                                  return _buildBookContainer(book);
                                })
                            : Center(
                                child: PlainCard(
                                    child: Column(
                                children: [
                                  Text(
                                    "Tidak Ada Artikel",
                                    style: textTheme.headlineMedium!
                                        .apply(fontWeightDelta: 2),
                                  ),
                                  LottieBuilder.network(emptyGifLink),
                                  Text(
                                    "Yuk, mulai menulis dan berbagi pengetahuan melalui artikelmu !",
                                    style: textTheme.bodyMedium!
                                        .apply(fontWeightDelta: 2),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )));
                      })
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                    ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_book',
          onPressed: () => context.push("/book/create"),
          child: const Icon(Ionicons.add_outline),
        ));
  }

  Widget _buildBookContainer(BookModel book) {
    return PlainCard(
        onTap: () => context.push("/book/detail/${book.id}"),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    book.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalize(trimmer(book.title)),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(fontWeightDelta: 2),
                  ),
                  Text(
                    DateHelper.timestampToReadable(book.createdAt!),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(fontWeightDelta: 2, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  DropdownMenuItem _buildDropdownItem(String text) {
    return DropdownMenuItem(
      value: text,
      child: Text(text),
    );
  }
}
