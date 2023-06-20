//make basic route with go router
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/book/book_screen.dart';
import 'package:greenify/ui/screen/garden/garden_form_screen.dart';
import 'package:greenify/ui/screen/garden/garden_space_screen.dart';
import 'package:greenify/ui/screen/home/sekelaton_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _appRoutes =
    GoRouter(initialLocation: "/", navigatorKey: navigatorKey, routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SekelatonScreen(),
  ),
  GoRoute(path: "/book", builder: (context, state) => const BookScreen()),
  GoRoute(
      path: "/garden", builder: (context, state) => const GardenSpaceScreen()),
  GoRoute(
      path: "/garden/form",
      builder: (context, state) => const GardenFormScreen()),
]);

final appRouteProvider = Provider((ref) => _appRoutes);
