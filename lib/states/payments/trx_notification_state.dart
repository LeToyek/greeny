import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/transaction_notification_model.dart';
import 'package:greenify/services/transaction_notification_service.dart';

class TrxNotitifactionNotifier
    extends StateNotifier<AsyncValue<List<TransactionNotificationModel>>> {
  final TransactionNotificationService _trxNotifService =
      TransactionNotificationService();
  TrxNotitifactionNotifier()
      : super(
          const AsyncValue.loading(),
        );

  Future<void> getTrxNotif() async {
    try {
      final data = await _trxNotifService.getTransactionNotification();
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final trxNotificationProvider = StateNotifierProvider<TrxNotitifactionNotifier,
    AsyncValue<List<TransactionNotificationModel>>>((ref) {
  return TrxNotitifactionNotifier()..getTrxNotif();
});
