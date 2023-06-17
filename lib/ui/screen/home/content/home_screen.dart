import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/icon_card.dart';
import 'package:greenify/ui/widgets/info_card.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const Header(text: 'app_name'),

            Card(
              elevation: 2,
              shadowColor: Theme.of(context).colorScheme.shadow,

              /// Example: Many items have their own colors inside of the ThemData
              /// You can overwrite them in [config/theme.dart].
              color: Theme.of(context).colorScheme.surface,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: SwitchListTile(
                onChanged: (bool newValue) {
                  /// Example: Change locale
                  /// The initial locale is automatically determined by the library.
                  /// Changing the locale like this will persist the selected locale.
                  // context.setLocale(
                  //     newValue ? const Locale('de') : const Locale('en'));
                },
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                value: true,
                title: Row(
                  children: <Widget>[
                    Icon(Ionicons.language_outline,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Text(
                      tr('language_switch_title'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(fontWeightDelta: 2),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.75 / 1,
                padding: EdgeInsets.zero,
                children: const <GrIconCard>[
                  GrIconCard(
                    mode: ThemeMode.system,
                    icon: Ionicons.contrast_outline,
                  ),
                  GrIconCard(
                    mode: ThemeMode.light,
                    icon: Ionicons.sunny_outline,
                  ),
                  GrIconCard(
                    mode: ThemeMode.dark,
                    icon: Ionicons.moon_outline,
                  ),
                ]),

            /// Example: Good way to add space between items without using Paddings
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(.4),
              ),
            ),
            const SizedBox(height: 8),

            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 5.5,
              padding: EdgeInsets.zero,
              children: const <GrInfoCard>[
                /// Example: it is good practice to put widgets in separate files.
                /// This way the screen files won't become too large and
                /// the code becomes more clear.
                GrInfoCard(
                    title: 'localization_title',
                    content: 'localization_content',
                    icon: Ionicons.language_outline,
                    isPrimaryColor: true),
                GrInfoCard(
                    title: 'linting_title',
                    content: 'linting_content',
                    icon: Ionicons.code_slash_outline,
                    isPrimaryColor: false),
                GrInfoCard(
                    title: 'storage_title',
                    content: 'storage_content',
                    icon: Ionicons.folder_open_outline,
                    isPrimaryColor: false),
                GrInfoCard(
                    title: 'dark_mode_title',
                    content: 'dark_mode_content',
                    icon: Ionicons.moon_outline,
                    isPrimaryColor: true),
                GrInfoCard(
                    title: 'state_title',
                    content: 'state_content',
                    icon: Ionicons.leaf_outline,
                    isPrimaryColor: true),
                GrInfoCard(
                    title: 'display_title',
                    content: 'display_content',
                    icon: Ionicons.speedometer_outline,
                    isPrimaryColor: false),
              ],
            ),
            const SizedBox(height: 36),
          ]),
    );
  }
}
