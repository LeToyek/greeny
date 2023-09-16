import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/services/wallet_service.dart';

class TransactionHistoryNotifier
    extends StateNotifier<AsyncValue<List<TransactionModel>>> {
  final WalletService _walletService = WalletService();

  late List<TransactionModel> tempTrxes;
  TransactionHistoryNotifier() : super(const AsyncValue.loading());

  Future<void> getTransactionHistory() async {
    try {
      state = const AsyncValue.loading();
      final transactionHistory = await _walletService.getTransactions();
      state = AsyncValue.data(transactionHistory);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getDetailTransaction(int index) async {
    try {
      state = const AsyncValue.loading();

      state = AsyncValue.data(tempTrxes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  TransactionModel getTransactionById(String id) {
    return tempTrxes.firstWhere((element) => element.id == id);
  }
}

final transactionHistory = StateNotifierProvider<TransactionHistoryNotifier,
    AsyncValue<List<TransactionModel>>>((ref) {
  return TransactionHistoryNotifier()..getTransactionHistory();
});
