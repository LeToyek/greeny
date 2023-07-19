import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/achievement_model.dart';
import 'package:greenify/services/achievement_service.dart';
import 'package:greenify/services/users_service.dart';

class ExpNotifier extends StateNotifier<AsyncValue<AchievementModel?>> {
  UsersServices usersServices;
  ExpNotifier({required this.usersServices})
      : super(const AsyncValue.data(null));

  Future<void> increaseExp(int value, String achievementId) async {
    try {
      state = const AsyncValue.loading();
      await usersServices.increaseExpUser(value);
      final achievement =
          await AchievementService().increaseEmblemCounter(achievementId);
      state = AsyncValue.data(achievement);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void turnStateToNull() {
    state = const AsyncValue.data(null);
  }
}

final expProvider =
    StateNotifierProvider<ExpNotifier, AsyncValue<AchievementModel?>>((ref) {
  return ExpNotifier(usersServices: UsersServices());
});
