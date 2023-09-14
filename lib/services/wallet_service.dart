import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/model/user_model.dart';

class WalletService {
  WalletService._();

  static final WalletService _instance = WalletService._();

  factory WalletService() {
    return _instance;
  }
  final userRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  Future<void> increaseWalletValue(int inputValue) async {
    final timeNow = DateTime.now().toString();
    userRef.collection("transactions").add(TransactionModel(
            value: inputValue,
            createdAt: timeNow,
            updatedAt: timeNow,
            logType: '[ADD]',
            logMessage: 'Menambah saldo')
        .toMap());
    userRef.update({"wallet.value": FieldValue.increment(inputValue)});
  }

  Future<bool> decreaseWalletValue(int inputValue, String message) async {
    final timeNow = DateTime.now().toString();
    final userMap = await userRef.get();
    final userWallet = UserModel.fromQuery(userMap);
    if (userWallet.wallet!.value < inputValue) {
      return false;
    }
    userRef.collection("transactions").add(TransactionModel(
            value: inputValue,
            createdAt: timeNow,
            updatedAt: timeNow,
            logType: '[SUBSTRACT]',
            logMessage: message)
        .toMap());
    userRef.update({"wallet.value": FieldValue.increment(inputValue * -1)});
    return true;
  }

  Future<TransactionModel> getTransactionById({required String id}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userRef.collection("transactions").doc(id).get();
      print("infoSnap ${documentSnapshot.data()}");
      TransactionModel transaction = TransactionModel.fromMap(documentSnapshot);
      return transaction;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    List<TransactionModel> transactionsList = [];
    QuerySnapshot querySnapshot =
        await userRef.collection("transactions").get();
    for (var element in querySnapshot.docs) {
      transactionsList.add(TransactionModel.fromMap(element));
    }
    transactionsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactionsList;
  }
}
