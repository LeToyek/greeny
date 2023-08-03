import 'package:flutter/material.dart';
import 'package:greenify/ui/screen/book/book_screen.dart';
import 'package:greenify/ui/screen/disease/disease_screen.dart';
import 'package:greenify/ui/screen/garden/list_garden_space_screen.dart';
import 'package:greenify/ui/screen/home/content/home_screen.dart';
import 'package:greenify/ui/screen/leaderboard/leaderboard_screen.dart';

final List<Widget> contents = [
  const BookScreen(),
  const ListGardenSpaceScreen(),
  const HomeScreen(),
  const DiseaseScreen(),
  const LeaderboardScreen(),
  // const AccountScreen()
];
