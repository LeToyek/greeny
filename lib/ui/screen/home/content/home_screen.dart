import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/constants/user_constants.dart';
import 'package:greenify/states/book_state.dart';
import 'package:greenify/states/bottom_nav_bar_state.dart';
import 'package:greenify/states/marketplace/marketplace_notifier.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/screen/wallet/manager_screen.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/utils/formatter.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(singleUserProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _subTitleSection(context, "Tanaman Terbaru"),
            userRef.when(
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                data: (data) {
                  final user = data.first;
                  final totalArtikel =
                      user.books == null ? 0 : user.books!.length;
                  final totalGardens =
                      user.gardens == null ? 0 : user.gardens!.length;
                  return IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3, child: _buildWalletCard(context, ref)),
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: _buildMainCard(
                                  color: Colors.tealAccent.shade700,
                                  icon: Ionicons.leaf_outline,
                                  context: context,
                                  ref: ref,
                                  title: "Kebun",
                                  total: totalGardens),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: _buildMainCard(
                                  color: Colors.deepOrange.shade700,
                                  icon: Ionicons.book_outline,
                                  context: context,
                                  ref: ref,
                                  title: "Artikel",
                                  total: totalArtikel),
                            )),
                      ],
                    ),
                  );
                }),
            _buildNewestPlant(context, ref),
            _buildNewestArticle(context, ref),
            _buildTopPlayers(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildGetEmblem(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return PlainCard(
        color: colorScheme.primary,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ));
  }

  Widget _buildNewestArticle(BuildContext context, WidgetRef ref) {
    final bookRef = ref.watch(bestBookProvider);

    return PlainCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _subTitleSection(
                context, "Artikel Terbaru", Ionicons.newspaper),
          ),
          SizedBox(
              height: 300,
              child: bookRef.when(loading: () {
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
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final book = data[index];
                    return InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              // title: const Text("Parkir"),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              content: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                        await ref
                            .read(detailBookProvider(book.id!).notifier)
                            .getBookByID(book.id!);

                        if (context.mounted) {
                          context.pop();
                          context.push("/book/detail/${book.id}");
                        }
                      },
                      child: Container(
                        margin: index != 2
                            ? const EdgeInsets.only(right: 8)
                            : EdgeInsets.zero,
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                child: CachedNetworkImage(
                                  imageUrl: book.imageUrl,
                                  width: 150,
                                  height: 180,
                                  fit: BoxFit.cover,
                                )),
                            Container(
                              width: 150,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title ?? "Title",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(
                                            fontWeightDelta: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  Text(
                                    book.category ?? "Category",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(
                                            fontWeightDelta: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }))
        ],
      ),
    );
  }

  Widget _buildTopPlayers(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(usersProvider);
    final userClientController = ref.read(userClientProvider.notifier);
    final bottomNavRef = ref.read(bottomNavProvider.notifier);
    return PlainCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _subTitleSection(context, "Top Players", Ionicons.trophy),
          ),
          SizedBox(
              height: 200,
              child: userRef.when(loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, error: (error, stackTrace) {
                return Center(
                  child: Text(error.toString()),
                );
              }, data: (data) {
                print("data.length: ${data.length}");
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return index == 3
                        ? Center(
                            child: TextButton(
                                child: const Text("Tampilkan semua pemain"),
                                onPressed: () {
                                  bottomNavRef.setValueToDB(4);
                                }),
                          )
                        : Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await userClientController.setVisitedUser(
                                      id: data[index].userId);
                                  await userClientController
                                      .getUserById(data[index].userId);
                                  if (context.mounted) {
                                    context.push("/user/detail");
                                  }
                                },
                                child: Container(
                                    child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Text("${index + 1}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .apply(fontWeightDelta: 2)),
                                        const SizedBox(width: 16),
                                        CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  data[index].imageUrl == null
                                                      ? unknownImage
                                                      : data[index].imageUrl!),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(data[index].name ?? "User"),
                                        const Spacer(),
                                        Text(data[index].exp.toString()),
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                              )
                            ],
                          );
                  },
                );
              }))
        ],
      ),
    );
  }

  Widget _subTitleSection(BuildContext context, String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium!.apply(
              fontWeightDelta: 2,
              color: Theme.of(context).colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildNewestPlant(BuildContext context, WidgetRef ref) {
    const String bestPlant = "115aa02a-d72e-47bc-b83b-d4ba5bfe06c4";
    // final potRef = ref.watch(bestPotProvider(bestPlant));

    final potRef = ref.watch(marketplaceNotifierProvider);

    final potNotifier = ref.read(potProvider(bestPlant).notifier);
    final userClientController = ref.read(userClientProvider.notifier);
    // final potNotifier = ref.watch(bestPotProvider(bestPlant).notifier);
    return PlainCard(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child:
                  _subTitleSection(context, "Tanaman Terbaru", Ionicons.planet),
            ),
            SizedBox(
              height: 240,
              child: potRef.when(loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, error: (error, stackTrace) {
                return Center(
                  child: Text(error.toString()),
                );
              }, data: (data) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final pot = data[index];
                    final heroKey = "pot_${pot.id}_$index";

                    return InkWell(
                      onTap: () {
                        print(pot.ref);
                        final parts = pot.ref!.path.split("/");
                        final userId = parts[1];
                        final garden = parts[3];
                        final potId = parts[5];
                        // const userId = "jCrKt22Hp6eX7unsc0jHvodUmFu1";
                        userClientController.setVisitedUser(id: userId);
                        userClientController.setVisitedUserModel();

                        context.push(
                          "/garden/$garden/detail/$potId",
                          extra: {
                            "pot": pot,
                            "photoHero": heroKey,
                          },
                        );
                      },
                      child: Hero(
                        tag: heroKey,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(pot.plant.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pot.plant.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                              fontWeightDelta: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                    ),
                                    Text(
                                      "Rp ${formatMoney(pot.plant.price ?? 0)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                              fontWeightDelta: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ));
  }

  Widget _buildWalletCard(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final wallet = ref.watch(singleUserProvider);

    return PlainCard(
      onTap: () => context.push(WalletManagerScreen.routePath),
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Ionicons.wallet,
                color: colorScheme.primary,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: FittedBox(
                  child: Text(
                    "Greeny Wallet",
                    style: textTheme.labelMedium!.apply(
                        fontWeightDelta: 2, color: colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          wallet.when(
            data: (data) {
              return Text(
                data.first.wallet == null
                    ? "loading.."
                    : "Rp ${formatMoney(data.first.wallet!.value)}",
                style: textTheme.labelLarge!.apply(
                    fontWeightDelta: 2,
                    fontSizeDelta: 4,
                    color: colorScheme.onSurface),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text("error $error"),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "Tekan untuk topup",
            style: textTheme.labelSmall!
                .apply(fontWeightDelta: 3, color: Colors.orange.shade700),
          )
              .animate(
                delay: 500.ms,
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .fadeIn(duration: 500.ms)
              .then(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildMainCard(
      {required BuildContext context,
      Color? color,
      required WidgetRef ref,
      required String title,
      required IconData icon,
      required int total}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PlainCard(
      color: color ?? colorScheme.surface,
      child: Container(
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium!
                      .apply(fontWeightDelta: 2, color: Colors.white),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "$total",
                  style: textTheme.labelLarge!.apply(
                      fontWeightDelta: 2,
                      fontSizeDelta: 6,
                      color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
