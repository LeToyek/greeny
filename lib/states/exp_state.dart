import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/users_service.dart';

class ExpNotifier extends StateNotifier<AsyncValue<String>> {
  UsersServices usersServices;
  ExpNotifier({required this.usersServices}) : super(const AsyncValue.data(""));

  Future<void> increaseExp(int value) async {
    try {
      state = const AsyncValue.loading();
      await usersServices.increaseExpUser(value);
      state = const AsyncValue.data("Success");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> levelUp() async {
    try {
      state = const AsyncValue.loading();
      await usersServices.increaseLevelUser();
      state = const AsyncValue.data("Success");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final expProvider =
    StateNotifierProvider<ExpNotifier, AsyncValue<String>>((ref) {
  return ExpNotifier(usersServices: UsersServices());
});
