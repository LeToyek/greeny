import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(usersProvider);

    final userClientController = ref.read(userClientProvider.notifier);
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: userRef.when(loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      }, data: (data) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    userClientController.getUserById(data[index].userId);
                    context.push("/user/detail");
                  },
                  child: PlainCard(
                      child: Row(
                    children: [
                      Text("${index + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(fontWeightDelta: 2)),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        backgroundImage: NetworkImage(data[index].imageUrl ==
                                null
                            ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                            : data[index].imageUrl!),
                      ),
                      const SizedBox(width: 16),
                      Text(data[index].name ?? "User"),
                      const Spacer(),
                      Text(data[index].exp.toString()),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
