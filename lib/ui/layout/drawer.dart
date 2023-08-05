import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:greenify/states/users_state.dart';
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
                        ? NetworkImage(
                            user.imageUrl!,
                          )
                        : const NetworkImage(
                            'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                          ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    image: DecorationImage(
                      image: NetworkImage(user.gardens![0].backgroundUrl),
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
                    icon: const Icon(Ionicons.information_circle),
                    text: 'Tentang Greenify',
                    ref: ref,
                    route: '/about'),
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
          context.push(route);
        }
      },
    );
  }
}
