import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/user_model.dart';

class TransactionModel {
  final int value;
  final String createdAt;
  final String updatedAt;
  final String logType;
  final String logMessage;
  String? id;

  PlantModel? plant;
  String? ownerID;
  String? fromID;
  String? refModel;
  String? status;
  TransactionModel(
      {this.id,
      required this.value,
      required this.createdAt,
      required this.updatedAt,
      required this.logType,
      required this.logMessage,
      this.status});

  TransactionModel copyWith({
    int? value,
    String? createdAt,
    String? updatedAt,
    String? logType,
    String? logMessage,
  }) {
    return TransactionModel(
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      logType: logType ?? this.logType,
      logMessage: logMessage ?? this.logMessage,
    );
  }

  void setPlant(PlantModel plant) {
    this.plant = plant;
  }

  void setRef(String refModel) {
    this.refModel = refModel;
  }

  Future<UserModel> toUserModel() async {
    final user =
        await FirebaseFirestore.instance.collection('users').doc(ownerID).get();
    return UserModel.fromQuery(user);
  }

  Map<String, dynamic> toMap() {
    return plant == null
        ? {
            'value': value,
            'createdAt': createdAt,
            'updatedAt': updatedAt,
            'logType': logType,
            'logMessage': logMessage,
          }
        : {
            'value': value,
            'createdAt': createdAt,
            'updatedAt': updatedAt,
            'logType': logType,
            'logMessage': logMessage,
            'plant': plant!.toQuery(),
            'ownerID': ownerID,
            'refModel': refModel ?? "",
            'fromID': fromID ?? "",
            'status': status ?? "",
          };
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionModel(value: $value, createdAt: $createdAt, updatedAt: $updatedAt, logType: $logType, logMessage: $logMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.value == value &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.logType == logType &&
        other.logMessage == logMessage;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        logType.hashCode ^
        logMessage.hashCode;
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    final transactionModel = TransactionModel(
        value: map['value']?.toInt() ?? 0,
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        logType: map['logType'],
        logMessage: map['logMessage'],
        status: map['status']);
    if (map.containsKey('plant') && map.containsKey('ownerID')) {
      transactionModel.setPlant(PlantModel.fromQuery(map['plant']));
      transactionModel.ownerID = map['ownerID'];
    }
    return transactionModel;
  }
}
