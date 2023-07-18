//make basic route with go router
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/auth/login_screen.dart';
import 'package:greenify/ui/screen/auth/register_screen.dart';
import 'package:greenify/ui/screen/book/book_create_screen.dart';
import 'package:greenify/ui/screen/book/book_detail_screen.dart';
import 'package:greenify/ui/screen/book/book_list_screen.dart';
import 'package:greenify/ui/screen/book/book_screen.dart';
import 'package:greenify/ui/screen/garden/garden_form_screen.dart';
import 'package:greenify/ui/screen/garden/garden_pot_detail_screen.dart';
import 'package:greenify/ui/screen/garden/garden_space_screen.dart';
import 'package:greenify/ui/screen/garden/list_garden_space_screen.dart';
import 'package:greenify/ui/screen/home/content/account_screen.dart';
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
  GoRoute(
      path: "/user/detail",
      builder: (context, state) {
        return const AccountScreen();
      }),
  GoRoute(path: "/book", builder: (context, state) => const BookScreen()),
  GoRoute(
      path: "/book/create",
      builder: (context, state) => const BookCreateScreen()),
  GoRoute(
      path: "/book/:category",
      builder: (context, state) {
        final category = state.pathParameters["category"]!;
        return BookListScreen(category: category);
      }),
  GoRoute(
      name: "book_detail",
      path: "/book/detail/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return BookDetailScreen(bookId: id);
      }),
  GoRoute(
      path: "/garden",
      builder: (context, state) => const ListGardenSpaceScreen()),
  GoRoute(
      path: "/garden/form/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return GardenFormScreen(id: id);
      }),
  GoRoute(
      path: "/garden/:gardenID/detail/:potID",
      builder: (context, state) {
        final gardenID = state.pathParameters["gardenID"]!;
        final potID = state.pathParameters["potID"]!;
        return GardenPotDetailScreen(gardenID: gardenID, potID: potID);
      }),
  GoRoute(
      name: "garden_detail",
      path: "/garden/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return GardenSpaceScreen(id: id);
      }),
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
