import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/theme_mode_state.dart';

class NewAppbar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  const NewAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thememode = ref.watch(themeProvider);
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
            color: thememode == ThemeMode.light
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface),
      ),
      backgroundColor: thememode == ThemeMode.light
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
