import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
    (ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  late ThemeMode themeMode;
  ThemeModeNotifier() : super(ThemeMode.light) {
    final String mode = Hive.box('prefs')
        .get("themeMode", defaultValue: ThemeMode.system.toString()) as String;
    switch (mode) {
      case "ThemeMode.system":
        themeMode = ThemeMode.system;
        break;
      case "ThemeMode.light":
        themeMode = ThemeMode.light;
        break;
      case "ThemeMode.dark":
        themeMode = ThemeMode.dark;
        break;
    }
  }

  void setThemeMode(ThemeMode mode) {
    print(mode);
    themeMode = mode;
    state = themeMode;
  }
}
