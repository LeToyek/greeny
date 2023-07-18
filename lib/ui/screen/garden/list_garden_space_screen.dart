import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/garden_state.dart';

class ListGardenSpaceScreen extends ConsumerWidget {
  const ListGardenSpaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenRef = ref.watch(gardenProvider);

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
                      final garden = data[index];
                      return GestureDetector(
                          onTap: () => context.pushNamed("garden_detail",
                              pathParameters: {"id": data[index].id}),
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
                                      garden.backgroundUrl,
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
                    childCount: data.length,
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
