import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/pill.dart';
import 'package:ionicons/ionicons.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(singleUserProvider);
    final funcUserRef = ref.read(singleUserProvider.notifier);

    return Material(
        color: Theme.of(context).colorScheme.background,
        child: userRef.when(
            data: (data) {
              final user = data.first;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: <Widget>[
                      const Header(text: "Account Page"),
                      PlainCard(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  String photoUrl = "";
                                  if (user.imageUrl != null) {
                                    photoUrl = user.imageUrl!;
                                  }
                                  await funcUserRef
                                      .updateProfilePhoto(photoUrl);
                                } catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          content: Text(e.toString())));
                                }
                              },
                              child: ClipOval(
                                child: user.imageUrl != null
                                    ? Image.network(
                                        user.imageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _textAccount(
                                      context: context, text: user.name!),
                                  const SizedBox(height: 4),
                                  _textAccount(
                                      context: context,
                                      text: user.email,
                                      color: Colors.grey[600]),
                                  const SizedBox(height: 4),
                                  Pill(
                                    icon: Ionicons.leaf,
                                    title: "Pro",
                                    color: Colors.red[200],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      PlainCard(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Garden",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(fontWeightDelta: 2),
                          ),
                          Row(
                            children: const [Text("data")],
                          )
                        ],
                      )),
                      const SizedBox(height: 36),

                      GestureDetector(
                        onTap: () {
                          funcUserRef.logOut();
                          context.go("/login");
                        },
                        child: PlainCard(
                            color: Theme.of(context).colorScheme.error,
                            child: Row(
                              children: [
                                const Icon(
                                  Ionicons.log_out_outline,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                _textAccount(
                                    context: context,
                                    text: 'Logout',
                                    color: Colors.white),
                              ],
                            )),
                      )
                      // const SizedBox(height: 12),
                    ]),
                  ),
                ],
              );
            },
            error: (e, s) => Center(
                    child: Container(
                  child: Text(e.toString()),
                )),
            loading: () => const Center(child: CircularProgressIndicator())));
  }

  Widget _textAccount({required context, required String text, Color? color}) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .apply(fontWeightDelta: 2, color: color),
    );
  }
}
