import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/theme_mode_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/screen/IOT/iot_screen.dart';
import 'package:greenify/ui/screen/additional/emblem_screen.dart';
import 'package:greenify/ui/screen/additional/sold_plant_screen.dart';
import 'package:greenify/ui/screen/payments/history_screen.dart';
import 'package:ionicons/ionicons.dart';

class GrDrawerr extends ConsumerWidget {
  const GrDrawerr({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.watch(singleUserProvider);
    final displayMode = ref.watch(themeProvider);
    final funcDisplayMode = ref.read(themeProvider.notifier);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: profileNotifier.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const Center(child: Text('Error')),
          data: (data) {
            final user = data[0];
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(user.name!),
                  accountEmail: Text(user.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    backgroundImage: user.imageUrl != null
                        ? CachedNetworkImageProvider(
                            user.imageUrl!,
                          )
                        : const CachedNetworkImageProvider(
                            'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                          ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          user.gardens![0].backgroundUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.person_circle_outline),
                    text: 'Akun Saya',
                    ref: ref,
                    route: '/account'),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.storefront_outline),
                    text: 'Tanaman Terjual',
                    ref: ref,
                    route: SoldPlantScreen.routePath),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.time_outline),
                    text: 'Riwayat Transaksi',
                    ref: ref,
                    route: HistoryScreen.routePath),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.trophy_outline),
                    text: 'Medali',
                    ref: ref,
                    route: EmblemScreen.routePath),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.moon_outline),
                    text: 'Dark Mode',
                    ref: ref,
                    grTrailling: Switch(
                      value: displayMode == ThemeMode.dark,
                      onChanged: (value) {
                        funcDisplayMode.setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light);
                      },
                    )),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.information_circle_outline),
                    text: 'Tentang Greeny',
                    ref: ref,
                    route: '/about'),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.radio_outline),
                    text: "IOT",
                    ref: ref,
                    route: IOTScreen.routePath),
                Divider(
                  height: 25,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                grDrawerItem(
                    context: context,
                    icon: const Icon(Ionicons.log_out_outline),
                    text: 'Keluar',
                    ref: ref,
                    route: '/login',
                    colorText: Theme.of(context).colorScheme.error),
              ],
            );
          }),
    );
  }

  ListTile grDrawerItem(
      {required BuildContext context,
      required Icon icon,
      required String text,
      String? route,
      required WidgetRef ref,
      Widget? grTrailling,
      Color? colorText}) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
            color: colorText ?? Theme.of(context).colorScheme.onSurface),
      ),
      leading: Icon(
        icon.icon,
        color: colorText ?? Theme.of(context).colorScheme.onSurface,
      ),
      trailing: grTrailling,
      onTap: () {
        if (route != null) {
          if (route == '/login') {
            ref.read(singleUserProvider.notifier).logOut();
          }
          context.push(route);
        }
      },
    );
  }
}
