import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/model/wallet_model.dart';
import 'package:greenify/services/transaction_notification_service.dart';

class WalletService {
  final TransactionNotificationService _transactionNotificationService =
      TransactionNotificationService();
  WalletService._();

  static final WalletService _instance = WalletService._();

  factory WalletService() {
    return _instance;
  }
  final userRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    final userMap = await userRef.get();
    final wallet = userMap.data()!['wallet'];
    final userWallet = UserModel.fromQuery(userMap);
    userWallet.setWallet(WalletModel.fromMap(wallet));
    if (userWallet.wallet!.value < inputValue) {
      return false;
    }
    userRef.update({"wallet.value": FieldValue.increment(inputValue * -1)});
    return true;
  }

  Future<TransactionModel> getTransactionById({required String id}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userRef.collection("transactions").doc(id).get();

      TransactionModel transaction = TransactionModel.fromMap(
          documentSnapshot.data() as Map<String, dynamic>);
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
      final transaction =
          TransactionModel.fromMap(element.data() as Map<String, dynamic>);
      print("element.data() ${element.data()}");
      transaction.id = element.id;

      transactionsList.add(transaction);
    }
    transactionsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactionsList;
  }

  Future<void> buyPlant({
    required TransactionModel transactionModel,
    required String reference,
  }) async {
    final transactionRef = userRef.collection('transactions');

    print("transactionModel.ownerID ${transactionModel.ownerID}");

    try {
      await _firestore.runTransaction((transaction) async {
        transactionModel.fromID = FirebaseAuth.instance.currentUser!.uid;
        transactionModel.status = 'req';
        final tfId = await transactionRef.add(transactionModel.toMap());
        transactionModel.id = tfId.id;
        final isSuccess = await decreaseWalletValue(
            transactionModel.value, transactionModel.logMessage);
        if (!isSuccess) {
          throw Exception("Saldo tidak cukup");
        }
        _transactionNotificationService.sendNotification(transactionModel);
        _firestore.doc(reference).update({"plant.market_status": "sold"});
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> processTransaction(
      {required String userId,
      required String notifID,
      required String transactionId}) async {
    try {
      final buyerRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      final selfRef = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final selfTranscationRef =
          selfRef.collection("notifications").doc(notifID);
      selfTranscationRef.update({"trxModel.status": "process"});

      final transactionRef =
          buyerRef.collection("transactions").doc(transactionId);
      transactionRef.update({"status": "process"});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> denyTransaction(
      {required String userId,
      required String notifID,
      required String transactionId,
      required int price}) async {
    try {
      final buyerRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      final selfRef = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final selfTranscationRef =
          selfRef.collection("notifications").doc(notifID);
      selfTranscationRef.update({"trxModel.status": "denied"});

      final transactionRef =
          buyerRef.collection("transactions").doc(transactionId);
      buyerRef.update({"wallet.value": FieldValue.increment(price)});
      transactionRef.update({"status": "denied"});
    } catch (e) {
      throw Exception(e);
    }
  }
}
