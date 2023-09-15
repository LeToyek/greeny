import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionNotificationModel {
  bool isRead = false;
  String? id;
  String title;
  String description;
  String? createdAt;
  String? updatedAt;
  String? refModel;
  String? fromID;
  String? toID;

  TransactionNotificationModel({
    required this.isRead,
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.refModel,
  });

  TransactionNotificationModel copyWith({
    bool? isRead,
    String? id,
    String? title,
    String? description,
    String? createdAt,
    String? updatedAt,
    String? refModel,
  }) {
    return TransactionNotificationModel(
      isRead: isRead ?? this.isRead,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      refModel: refModel ?? this.refModel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isRead': isRead,
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'refModel': refModel,
    };
  }

  factory TransactionNotificationModel.fromMap(DocumentSnapshot<Object?> map) {
    return TransactionNotificationModel(
      isRead: map['isRead'] ?? false,
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      refModel: map['refModel'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionNotificationModel.fromJson(String source) =>
      TransactionNotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionNotificationModel(isRead: $isRead, id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, refModel: $refModel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionNotificationModel &&
        other.isRead == isRead &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.refModel == refModel;
  }

  @override
  int get hashCode {
    return isRead.hashCode ^
        id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        refModel.hashCode;
  }
}
