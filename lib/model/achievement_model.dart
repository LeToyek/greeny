import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/emblem_model.dart';

class AchievementModel {
  final String id;
  int counter;
  EmblemModel? emblem;
  bool isClaimed;
  bool isClosed;
  bool isExist;
  static const String collectionPath = 'achievements';

  AchievementModel({
    required this.id,
    required this.counter,
    required this.isClaimed,
    required this.isExist,
    required this.isClosed,
  });

  AchievementModel.fromQuery(DocumentSnapshot<Object?> query)
      : id = query['id'],
        counter = query['counter'],
        isClaimed = query['isClaimed'],
        isExist = query['isExist'],
        isClosed = query['isClosed'];

  Map<String, dynamic> toQuery() => {
        'id': id,
        'counter': counter,
        'isClaimed': isClaimed,
        'isExist': isExist,
      };
}
