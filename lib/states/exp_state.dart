import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/services/achievement_service.dart';
import 'package:greenify/services/users_service.dart';

class ExpNotifier extends StateNotifier<AsyncValue<List<AchievementModel>>> {
  UsersServices usersServices;
  ExpNotifier({required this.usersServices}) : super(const AsyncValue.data([]));

  Future<void> increaseExp(int value, List<String> achievementIDs) async {
    try {
      state = const AsyncValue.loading();
      print(await usersServices.increaseExpUser(value));
      final List<AchievementModel> achievements = [];
      await Future.forEach(
          achievementIDs,
          (element) async => achievements
              .add(await AchievementService().increaseEmblemCounter(element)));

      state = AsyncValue.data(achievements);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void turnStateToNull() {
    state = const AsyncValue.data([]);
  }
}

final expProvider =
    StateNotifierProvider<ExpNotifier, AsyncValue<List<AchievementModel>>>(
        (ref) {
  return ExpNotifier(usersServices: UsersServices());
});
