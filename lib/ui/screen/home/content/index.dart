import 'package:flutter/material.dart';
import 'package:greenify/ui/screen/home/content/about_screen.dart';
import 'package:greenify/ui/screen/home/content/account_screen.dart';
import 'package:greenify/ui/screen/home/content/home_screen.dart';
import 'package:greenify/ui/screen/home/content/setting_screen.dart';

final List<Widget> contents = [
  const HomeScreen(),
  const AboutScreen(),
  const SettingScreen(),
  const AccountScreen()
];
