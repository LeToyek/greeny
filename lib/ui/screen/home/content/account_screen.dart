import 'package:flutter/material.dart';
import 'package:greenify/ui/layout/header.dart';
import 'package:greenify/ui/widgets/card/info_card.dart';
import 'package:ionicons/ionicons.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const Header(text: 'bottom_nav_second'),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 5.5,
              padding: EdgeInsets.zero,
              children: const <GrInfoCard>[
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
