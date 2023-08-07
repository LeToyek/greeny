import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/constants/plant_category_list.dart';
import 'package:greenify/states/plant_avatar_state.dart';
import 'package:greenify/states/theme_mode_state.dart';
import 'package:ionicons/ionicons.dart';

Widget plantChoose(PageController pageController,
    PlantAvatarNotifier pageNotifier, BuildContext context, WidgetRef ref) {
  final characterImages = plantCategory;
  final theme = ref.watch(themeProvider);
  return Row(
    children: [
      InkWell(
          onTap: () {
            if (pageController.page! > 0) {
              pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            } else {
              pageController.animateToPage(characterImages.length - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            }
          },
          child: Icon(
            Ionicons.chevron_back_outline,
            color: theme != ThemeMode.light
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground,
          )),
      Expanded(
        child: SizedBox(
          height: 210,
          child: PageView.builder(
            controller: pageController,
            itemCount: characterImages.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 1;
                  if (pageController.position.haveDimensions) {
                    value = pageController.page! - index;
                    value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 210,
                      width: Curves.easeOut.transform(value) * 210,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 130,
                      child: Image.asset(
                        characterImages[index]["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      characterImages[index]["name"],
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(fontWeightDelta: 2),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
      InkWell(
          onTap: () {
            if (pageController.page! < characterImages.length - 1) {
              pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            } else {
              pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            }
          },
          child: Icon(
            Ionicons.chevron_forward_outline,
            color: theme != ThemeMode.light
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground,
          )),
    ],
  );
}
