import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenify/model/transaction_model.dart';
import 'package:greenify/model/transaction_notification_model.dart';

class TransactionNotificationService {
  TransactionNotificationService._();

  static final TransactionNotificationService _instance =
      TransactionNotificationService._();

  factory TransactionNotificationService() {
    return _instance;
  }
  final userCollection = FirebaseFirestore.instance.collection("users");
  final userRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  Future<void> sendNotification(TransactionModel transactionModel) async {
    final timeNow = DateTime.now().toString();
    final tfNotification = TransactionNotificationModel(
        isRead: false,
        title: "Pembelian Tanaman",
        description: transactionModel.logMessage,
        trxModel: transactionModel,
        fromID: transactionModel.fromID,
        toID: transactionModel.ownerID,
        createdAt: timeNow,
        updatedAt: timeNow);
    await userCollection
        .doc(transactionModel.ownerID)
        .collection("notifications")
        .add(tfNotification.toMap());
  }

  Future<List<TransactionNotificationModel>>
      getTransactionNotification() async {
    final snapshot = await userRef.collection("notifications").get();
    final data = snapshot.docs.map((e) {
      final tfData = TransactionNotificationModel.fromMap(e.data());
      tfData.id = e.id;
      return tfData;
    }).toList();
    return data;
  }

  final StreamController<TransactionNotificationModel> _streamController =
      StreamController<TransactionNotificationModel>.broadcast();

  Stream<TransactionNotificationModel> get stream => _streamController.stream;

  void addTransactionNotification(
      TransactionNotificationModel transactionNotification) {
    _streamController.add(transactionNotification);
  }

  void dispose() {
    _streamController.close();
  }
}
