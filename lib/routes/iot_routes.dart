import 'package:go_router/go_router.dart';
import 'package:greenify/ui/screen/IOT/iot_screen.dart';

List<GoRoute> iotRoutes = [
  GoRoute(
      path: IOTScreen.routePath,
      builder: (context, state) => const IOTScreen()),
];
