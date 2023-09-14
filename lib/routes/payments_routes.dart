import 'package:go_router/go_router.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/ui/screen/payments/history_screen.dart';
import 'package:greenify/ui/screen/payments/invoice_screen.dart';
import 'package:greenify/ui/screen/payments/payment_success_screen.dart';
import 'package:greenify/ui/screen/payments/verification_screen.dart';

List<GoRoute> paymentsRoutes = [
  GoRoute(
      path: VerificationScreen.routePath,
      name: VerificationScreen.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return VerificationScreen(
          plant: args['plant'] as PlantModel,
          plantRef: args['plant_reference'] as String,
        );
      }),
  GoRoute(
      path: PaymentSuccessScreen.routePath,
      name: PaymentSuccessScreen.routeName,
      builder: (context, state) {
        final args = state.extra as TransactionModel;
        return PaymentSuccessScreen(
          transactionModel: args,
        );
      }),
  GoRoute(
      path: InvoiceScreen.routePath,
      name: InvoiceScreen.routeName,
      builder: (context, state) => const InvoiceScreen()),
  GoRoute(
      path: HistoryScreen.routePath,
      name: HistoryScreen.routeName,
      builder: (context, state) => const HistoryScreen()),
];
