//make basic route with go router
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/routes/books_routes.dart';
import 'package:greenify/routes/garden_routes.dart';
import 'package:greenify/routes/users_routes.dart';
import 'package:greenify/ui/screen/auth/login_screen.dart';
import 'package:greenify/ui/screen/auth/register_screen.dart';
import 'package:greenify/ui/screen/disease/disease_screen.dart';
import 'package:greenify/ui/screen/home/content/about_screen.dart';
import 'package:greenify/ui/screen/leaderboard/leaderboard_screen.dart';
import 'package:greenify/ui/screen/starter/splash_screen.dart';
import 'package:greenify/ui/screen/wallet/manager_screen.dart';
import 'package:greenify/ui/screen/wallet/success_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _appRoutes =
    GoRouter(initialLocation: "/splash", navigatorKey: navigatorKey, routes: [
  GoRoute(
      path: "/about",
      builder: (context, state) {
        return const AboutScreen();
      }),
  ...usersRoutes,
  ...booksRoutes,
  ...gardenRoutes,
  GoRoute(
      path: SuccessScreen.routePath,
      name: SuccessScreen.routeName,
      builder: (context, state) => const SuccessScreen()),
  GoRoute(
      path: "/disease",
      builder: (context, state) {
        return const DiseaseScreen();
      }),
  GoRoute(
      path: "/leaderboard",
      builder: (context, state) => const LeaderboardScreen()),
  GoRoute(
      path: WalletManagerScreen.routePath,
      builder: (context, state) => WalletManagerScreen()),
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
