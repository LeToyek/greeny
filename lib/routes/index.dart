//make basic route with go router
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/home/sekelaton_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _appRoutes =
    GoRouter(initialLocation: "/", navigatorKey: navigatorKey, routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SekelatonScreen(),
  )
]);

final appRouteProvider = Provider((ref) => _appRoutes);
