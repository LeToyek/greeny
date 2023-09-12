import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/client/user_screen.dart';
import 'package:greenify/ui/screen/home/content/account_screen.dart';
import 'package:greenify/ui/screen/home/sekelaton_screen.dart';

List<GoRoute> usersRoutes = [
  GoRoute(
    path: "/",
    builder: (context, state) => const SekelatonScreen(),
  ),
  GoRoute(
      path: "/account",
      builder: (context, state) {
        return const AccountScreen();
      }),
  GoRoute(
      path: "/user/detail",
      builder: (context, state) {
        return const UserClientScreen();
      }),
];
