import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenify/model/emblem_model.dart';

class AchievementModel {
  final String id;
  int counter;
  EmblemModel? emblem;
  bool isClaimed;
  bool isExist;
  static const String collectionPath = 'achievements';

  AchievementModel({
    required this.id,
    required this.counter,
    required this.isClaimed,
    required this.isExist,
  });

  AchievementModel.fromQuery(DocumentSnapshot<Object?> query)
      : id = query['id'],
        counter = query['counter'],
        isClaimed = query['isClaimed'],
        isExist = query['isExist'];

  Map<String, dynamic> toQuery() => {
        'id': id,
        'counter': counter,
        'isClaimed': isClaimed,
        'isExist': isExist,
      };
}
