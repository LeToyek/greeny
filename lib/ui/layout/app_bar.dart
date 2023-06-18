import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GrAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        systemStatusBarContrastEnforced: false,
        statusBarColor: Theme.of(context).colorScheme.background,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(8);
}
