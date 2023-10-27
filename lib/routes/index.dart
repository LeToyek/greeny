//make basic route with go router
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/routes/books_routes.dart';
import 'package:greenify/routes/garden_routes.dart';
import 'package:greenify/routes/iot_routes.dart';
import 'package:greenify/routes/payments_routes.dart';
import 'package:greenify/routes/users_routes.dart';
import 'package:greenify/ui/screen/additional/emblem_screen.dart';
import 'package:greenify/ui/screen/additional/sold_plant_screen.dart';
import 'package:greenify/ui/screen/additional/trx_status_screen.dart';
import 'package:greenify/ui/screen/additional/verif_buy_screen.dart';
import 'package:greenify/ui/screen/auth/login_screen.dart';
import 'package:greenify/ui/screen/auth/register_screen.dart';
import 'package:greenify/ui/screen/disease/disease_screen.dart';
import 'package:greenify/ui/screen/home/content/about_screen.dart';
import 'package:greenify/ui/screen/leaderboard/leaderboard_screen.dart';
import 'package:greenify/ui/screen/starter/splash_screen.dart';
import 'package:greenify/ui/screen/wallet/manager_screen.dart';
import 'package:greenify/ui/screen/wallet/success_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _appRoutes = GoRouter(
  initialLocation: "/splash",
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
        path: "/about",
        builder: (context, state) {
          return const AboutScreen();
        }),
    ...usersRoutes,
    ...booksRoutes,
    ...gardenRoutes,
    ...paymentsRoutes,
    ...iotRoutes,
    GoRoute(
        path: TrxStatusScreen.routePath,
        name: TrxStatusScreen.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;

          return TrxStatusScreen(trxIndex: args["index"]);
        }),
    GoRoute(
        path: SoldPlantScreen.routePath,
        name: SoldPlantScreen.routeName,
        builder: (context, state) => const SoldPlantScreen()),
    GoRoute(
        path: EmblemScreen.routePath,
        name: EmblemScreen.routeName,
        builder: (context, state) => const EmblemScreen()),
    GoRoute(
        path: SuccessScreen.routePath,
        name: SuccessScreen.routeName,
        builder: (context, state) => const SuccessScreen()),
    GoRoute(
        path: VerifBuyScreen.routePath,
        name: VerifBuyScreen.routeName,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return VerifBuyScreen(
            indexTrx: args['index'],
          );
        }),
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
    GoRoute(path: "/splash", builder: (context, state) => const SplashScreen()),
  ],
);

final appRouteProvider = Provider((ref) => _appRoutes);
