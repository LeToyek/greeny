//make basic route with go router
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/auth/login_screen.dart';
import 'package:greenify/ui/screen/auth/register_screen.dart';
import 'package:greenify/ui/screen/book/book_screen.dart';
import 'package:greenify/ui/screen/garden/garden_form_screen.dart';
import 'package:greenify/ui/screen/garden/garden_space_screen.dart';
import 'package:greenify/ui/screen/home/sekelaton_screen.dart';
import 'package:greenify/ui/screen/leaderboard/leaderboard_screen.dart';
import 'package:greenify/ui/screen/starter/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _appRoutes =
    GoRouter(initialLocation: "/splash", navigatorKey: navigatorKey, routes: [
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
  GoRoute(
      path: "/leaderboard",
      builder: (context, state) => const LeaderboardScreen()),
  GoRoute(
    path: "/register",
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: "/login",
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(path: "/splash", builder: (context, state) => const SplashScreen())
]);

final appRouteProvider = Provider((ref) => _appRoutes);
