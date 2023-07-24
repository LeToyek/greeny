import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:ionicons/ionicons.dart';

class ListGardenSpaceScreen extends ConsumerWidget {
  const ListGardenSpaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenRef = ref.watch(gardenProvider);
    final textTheme = Theme.of(context).textTheme;

    final userNotifier = ref.read(userClientProvider.notifier);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: const Text("Gardens"),
          pinned: true,
          floating: true,
          snap: true,
          forceElevated: innerBoxIsScrolled,
        )
      ],
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(gardenProvider),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              gardenRef.when(data: (data) {
                print(data.length);
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      GardenModel? garden;
                      if (index < data.length) {
                        garden = data[index];
                      }
                      return index == data.length
                          ? GestureDetector(
                              onTap: () => context.pushNamed("garden_create"),
                              child: Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  dashPattern: const [8, 8],
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                  child: SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Ionicons.leaf,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "Tambahkan Garden",
                                            style: textTheme.bodySmall!.apply(
                                                fontWeightDelta: 2,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                ref
                                    .read(potProvider(data[index].id).notifier)
                                    .getPotsByGardenId(docId: data[index].id);
                                context.pushNamed("garden_detail",
                                    pathParameters: {"id": data[index].id});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 150,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          garden!.backgroundUrl,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: const Alignment(0.0, 0.5),
                                              end: const Alignment(0.0, 0.0),
                                              colors: <Color>[
                                                Colors.green.withOpacity(0.6),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              garden.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                    childCount: data.length + 1,
                  )),
                );
              }, error: (error, stackTrace) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(error.toString()),
                  ),
                );
              }, loading: () {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
