import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(themeProvider);
    final funcDisplayMode = ref.read(themeProvider.notifier);
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const Header(text: 'Setting'),
            const SizedBox(height: 36),
            PlainCard(
                child: Row(
              children: [
                const Expanded(child: Text('Dark Mode')),
                Switch(
                  value: displayMode == ThemeMode.dark,
                  onChanged: (value) {
                    funcDisplayMode
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                )
              ],
            )),
            // GestureDetector(
            //   onTap: () async => AndroidAlarmManager.cancel(1),
            //   child: PlainCard(
            //       child: Row(
            //     children: const [
            //       Expanded(child: Text('Disable Notification')),
            //     ],
            //   )),
            // )
          ]),
    );
  }
}
