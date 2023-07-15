import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/garden_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

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
                      return GestureDetector(
                        onTap: () => context.pushNamed("garden_detail",
                            pathParameters: {"id": data[index].id}),
                        child: Column(children: [
                          PlainCard(
                              child: Row(
                            children: [
                              Text(data[index].name),
                              const SizedBox(width: 16),
                            ],
                          )),
                          const SizedBox(height: 16)
                        ]),
                      );
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
