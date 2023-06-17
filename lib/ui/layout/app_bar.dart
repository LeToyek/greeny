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
      backgroundColor: Colors.transparent,
      excludeHeaderSemantics: true,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      bottomOpacity: 0,
      toolbarOpacity: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(8);
}
