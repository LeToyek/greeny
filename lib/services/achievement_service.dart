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

  Future<AchievementModel> increaseEmblemCounter(String achievementId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference achievementRef = UsersServices.getUserRef(id: userId)
          .collection(AchievementModel.collectionPath)
          .doc(achievementId);
      final res = await achievementRef.get();
      final emblem = await EmblemService.getEmblemByID(achievementId);
      AchievementModel achievementModel;
      if (!res.exists) {
        achievementModel = AchievementModel(
          id: achievementId,
          counter: 1,
          isExist: false,
          isClaimed: false,
        );
        achievementRef.set(achievementModel.toQuery());
        achievementModel.emblem = emblem;

        return achievementModel;
      }
      achievementModel = AchievementModel.fromQuery(res);
      achievementModel.emblem = emblem;

      if (emblem.counter == achievementModel.counter) {
        await achievementRef.update({'isExist': true, 'isClaimed': true});
        achievementModel.isExist = true;
        return achievementModel;
      }

      if (!achievementModel.isClaimed) {
        await achievementRef.update({'isClaimed': true});
        achievementModel.isClaimed = true;
      }
      await achievementRef.update({'counter': FieldValue.increment(1)});
      achievementModel.counter += 1;

      return achievementModel;
    } catch (e) {
      throw Exception(e);
    }
  }
}
