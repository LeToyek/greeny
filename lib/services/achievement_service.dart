import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/services/emblem_service.dart';
import 'package:greenify/services/users_service.dart';

class AchievementService {
  Future<List<AchievementModel>> getAllAchievement(String userId) async {
    try {
      final res = await UsersServices.getUserRef(id: userId)
          .collection(AchievementModel.collectionPath)
          .get();

      List<AchievementModel> achievements = [];
      res.docs.map((e) => achievements.add(AchievementModel.fromQuery(e)));

      return achievements;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> setClose(String achievementId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference achievementRef = UsersServices.getUserRef(id: userId)
        .collection(AchievementModel.collectionPath)
        .doc(achievementId);
    await achievementRef.update({"isClosed": true});
  }

  Future<AchievementModel> increaseEmblemCounter(String achievementId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference achievementRef = UsersServices.getUserRef(id: userId)
          .collection(AchievementModel.collectionPath)
          .doc(achievementId);
      final res = await achievementRef.get();
      final emblem = await EmblemService.getEmblemByID(achievementId);
      AchievementModel achievementModel;
      print("id : $achievementId");
      print("id : ${res.exists}");
      if (!res.exists) {
        achievementModel = AchievementModel(
          id: achievementId,
          counter: 1,
          isExist: false,
          isClaimed: true,
          isClosed: false,
        );
        achievementRef.set(achievementModel.toQuery());
        achievementModel.emblem = emblem;

        return achievementModel;
      }
      achievementModel = AchievementModel.fromQuery(res);
      achievementModel.emblem = emblem;

      await achievementRef.update({'counter': FieldValue.increment(1)});

      achievementModel.counter += 1;

      print(
          "counter : ${emblem.counter} counter : ${achievementModel.counter}");
      if (emblem.counter == achievementModel.counter) {
        await achievementRef.update({'isExist': true});
        achievementModel.isExist = true;
        return achievementModel;
      }

      return achievementModel;
    } catch (e) {
      throw Exception(e);
    }
  }
}
