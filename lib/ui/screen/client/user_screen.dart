import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class UserClientScreen extends ConsumerWidget {
  const UserClientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userClientProvider);
    final funcUserRef = ref.read(userClientProvider.notifier);

    return Material(
        color: Theme.of(context).colorScheme.background,
        child: userRef.when(
            data: (data) {
              final user = data.first;
              return Padding(
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
                              await funcUserRef.updateProfilePhoto(photoUrl);
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AlertDialog(content: Text(e.toString())));
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
                              _textAccount(context: context, text: user.name!),
                              const SizedBox(height: 4),
                              _textAccount(
                                  context: context,
                                  text: user.email,
                                  color: Colors.grey[600]),
                              const SizedBox(height: 4),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PlainCard(
                      child: Column(
                    children: [
                      Text(
                        "Emblem",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(fontWeightDelta: 2),
                      ),
                    ],
                  )),
                  const SizedBox(height: 12),
                  PlainCard(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Artikel",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(fontWeightDelta: 2),
                      ),
                    ],
                  )),
                  const SizedBox(height: 12),
                  PlainCard(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Garden",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(fontWeightDelta: 2),
                      ),
                      user.gardens != null || user.gardens!.isNotEmpty
                          ? ListView.builder(
                              itemCount: user.gardens!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                GardenModel? garden;
                                if (user.gardens != null ||
                                    user.gardens!.isNotEmpty) {
                                  garden = user.gardens![index];
                                }
                                return garden != null
                                    ? GestureDetector(
                                        onTap: () {
                                          context.pushNamed("garden_detail",
                                              pathParameters: {
                                                "id": garden!.id
                                              });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: SizedBox(
                                              height: 100,
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
                                                        begin: const Alignment(
                                                            0.0, 0.5),
                                                        end: const Alignment(
                                                            0.0, 0.0),
                                                        colors: <Color>[
                                                          Colors.green
                                                              .withOpacity(0.6),
                                                          Colors.transparent,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Text(
                                                        garden.name,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                              })
                          : Container()
                    ],
                  )),
                  const SizedBox(height: 36),
                  // const SizedBox(height: 12),
                ]),
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
