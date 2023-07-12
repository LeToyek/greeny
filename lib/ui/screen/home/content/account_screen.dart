import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/services/auth.dart';
import 'package:greenify/states/user_action_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:ionicons/ionicons.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAction = ref.watch(userActionProvider);
    final funcUserAction = ref.read(userActionProvider.notifier);

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
                      const Header(text: 'Account Screen'),
                      const SizedBox(height: 36),
                      Stack(
                        children: [
                          ClipOval(
                            child: user.imageUrl != null
                                ? Image.network(
                                    user.imageUrl!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
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
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  color: Colors.white,
                                  child: const Icon(
                                    Ionicons.camera_outline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      PlainCard(
                          child:
                              _textAccount(context: context, text: user.name!)),
                      const SizedBox(height: 12),
                      PlainCard(
                          child:
                              _textAccount(context: context, text: user.email)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          FireAuth.signOut();
                          context.pushReplacement("/login");
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
                  userAction.when(
                      data: (act) => Container(),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Container()),
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
