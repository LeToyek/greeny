import 'package:go_router/go_router.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/ui/screen/payments/history_screen.dart';
import 'package:greenify/ui/screen/payments/invoice_screen.dart';
import 'package:greenify/ui/screen/payments/payment_success_screen.dart';
import 'package:greenify/ui/screen/payments/verification_screen.dart';

List<GoRoute> paymentsRoutes = [
  GoRoute(
      path: VerificationScreen.routePath,
      name: VerificationScreen.routeName,
      builder: (context, state) {
        PlantModel plantModel = state.extra as PlantModel;
        return VerificationScreen(
          plant: plantModel,
        );
      }),
  GoRoute(
      path: PaymentSuccessScreen.routePath,
      name: PaymentSuccessScreen.routeName,
      builder: (context, state) => const PaymentSuccessScreen()),
  GoRoute(
      path: InvoiceScreen.routePath,
      name: InvoiceScreen.routeName,
      builder: (context, state) => const InvoiceScreen()),
  GoRoute(
      path: HistoryScreen.routePath,
      name: HistoryScreen.routeName,
      builder: (context, state) => const HistoryScreen()),
];
